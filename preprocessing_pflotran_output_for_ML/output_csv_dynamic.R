rm(list=ls())
library(rhdf5)
library(field)

source("codes/xuehang_R_functions.R")
source("codes/1600m_3d_model.R")

H5close()


gridx = 4
gridy = 4
Northb = 117772
Southb = 114442
Westb = 593334
Eastb = 594654
domain.grid = expand.grid(seq(Westb,Eastb,gridx),seq(Southb,Northb,gridy))

model.grid = proj_to_model(model_origin,angle,domain.grid)

min.spc = 0.11
max.spc = 0.425
max.tracer = 0.001

t0 = as.POSIXct("2010-01-01 00:00:00",tz="GMT")
time.stamp = as.POSIXct("2008-01-01 00:00:00",tz="GMT")


data.dir = "/files1/song884/bpt/new_simulation_13_25/"
data.files = system(paste("ls ", data.dir,"pflotran_bigplume*h5",sep=""),
                    intern=TRUE)

output.dir = "csv/dynamic/"
system(paste("find ", output.dir,"-type f -exec rm {} \\;"))

for (ifile in data.files)
{
    x = h5read(ifile,"/Coordinates")[["X [m]"]]
    y = h5read(ifile,"/Coordinates")[["Y [m]"]]
    z = h5read(ifile,"/Coordinates")[["Z [m]"]]

    dx = diff(x)
    dy = diff(y)
    dz = diff(z)
    
    x = x[-1]-0.5*dx
    y = y[-1]-0.5*dy
    z = z[-1]-0.5*dz


    
    nx = length(x)
    ny = length(y)
    nz = length(z)

    ifile.h5ls = h5ls(ifile)

    times = unique(ifile.h5ls[[1]][grep("Time",ifile.h5ls[[1]])])
    materials = h5read(ifile,paste(times[1],"/Material_ID",sep=""))

    river.tracer = unique(ifile.h5ls[[2]])
    river.tracer = river.tracer[grep("Total_Tracer_river",river.tracer)]

    non.hanford = which(materials!=1,arr.ind=TRUE)

    for (itime in times)
    {
        print(itime)
        
        real.time = 3600*as.numeric(unlist(strsplit(itime," "))[3])+t0
        time.index = 1+as.numeric(difftime(real.time,t0,units="h"))
        
        satu = h5read(ifile,paste(itime,"/Liquid_Saturation",sep=""))
        satu[which(materials==0)]=1
        satu[which(satu!=1)]=NA
        water.table = apply(satu,c(2,3),function(x) max(x*z,na.rm=TRUE))
        lowest.wl = min(water.table)
        highest.index = which(z==lowest.wl)

        pressure = h5read(ifile,
                          paste(itime,"/Liquid_Pressure [Pa]",sep=""))
        wl = pressure[highest.index-1,,]
        wl[which(materials[highest.index-1,,]==0)] = NA
        wl = pressure[highest.index-1,,]/101325+z[highest.index-1]
        wl = t(wl)
        output.wl = cbind(domain.grid,
            interp.surface(list(x=x,y=y,z=wl),model.grid))
        colnames(output.wl) = c("Easting","Northing","WL")

        fname = paste(output.dir,"wl/simu",
                      '_',
                      "spc",
                      '_',
                      time.index,
                      '_',
                      format(real.time,'%Y_%m_%d_%H_%M_%S'),
                      '.dat',sep='')
        write.csv(output.wl,fname,row.names=F)


        
        vx = h5read(ifile,
                    paste(itime,"/Liquid X-Velocity [m_per_h]",sep=""))
        vy = h5read(ifile,
                    paste(itime,"/Liquid Y-Velocity [m_per_h]",sep=""))  

        vxy = (vx**2+ny**2)**0.5
        vxy[(highest.index+1):nz,,] = NA    
        vxy[non.hanford] = NA

        total.tracer = array(0,c(nz,ny,nx))
        for (itracer in river.tracer)
        {
            total.tracer = total.tracer+
                h5read(ifile,paste(itime,"/",itracer,sep=""))
        }
        total.tracer[(highest.index+1):nz,,] = NA    
        total.tracer[non.hanford] = NA

        average.tracer = apply(total.tracer*vxy,c(2,3),sum,na.rm=TRUE)/
            apply(vxy,c(2,3),sum,na.rm=TRUE)
        average.tracer = (average.tracer/max.tracer)*(
            max.spc-min.spc)+min.spc

        average.tracer = t(average.tracer)
        output.tracer = cbind(domain.grid,
                              interp.surface(list(x=x,y=y,z=average.tracer),
                                             model.grid))

        colnames(output.tracer) = c("Easting","Northing","SpC")

        fname = paste(output.dir,"spc/simu",
                      '_',
                      "spc",
                      '_',
                      time.index,
                      '_',
                      format(real.time,'%Y_%m_%d_%H_%M_%S'),
                      '.dat',sep='')
        write.csv(output.tracer,fname,row.names=F)
    }
}
