rm(list=ls())
library(rhdf5)
H5close()

min.spc = 0.11
max.spc = 0.425
max.tracer = 0.001

lowest.wl = 104.25

data.dir = "/global/cscratch1/sd/pshuai/John_case_material_2/"
data.file = "pflotran_bigplume-003.h5"
output.file = "results/2013_104_25.h5"
if(file.exists(output.file))
{
    file.remove(output.file)
}
h5createFile(output.file)

data = paste(data.dir,data.file,sep="")

x = h5read(data,"/Coordinates")[["X [m]"]]
y = h5read(data,"/Coordinates")[["Y [m]"]]
z = h5read(data,"/Coordinates")[["Z [m]"]]

dx = diff(x)
dy = diff(y)
dz = diff(z)

x = x[-1]-0.5*dx
y = y[-1]-0.5*dy
z = z[-1]-0.5*dz

nx = length(x)
ny = length(y)
nz = length(z)

data.h5ls = h5ls(data)

times = unique(data.h5ls[[1]][grep("Time",data.h5ls[[1]])])
materials = h5read(data,paste(times[1],"/Material_ID",sep=""))


highest.index = which(z==lowest.wl)

river.tracer = unique(data.h5ls[[2]])
river.tracer = river.tracer[grep("Total_Tracer_river",river.tracer)]


non.hanford = which(materials!=1,arr.ind=TRUE)


h5createGroup(output.file,"Coordinates [M]")
h5write(x,output.file,"Coordinates [M]/X [m]",level=0)
h5write(y,output.file,"Coordinates [M]/Y [m]",level=0)

for (itime in times)
{
    print(itime)

    h5createGroup(output.file,itime)
    
    pressure = h5read(data,paste(itime,"/Liquid_Pressure [Pa]",sep=""))
    wl = pressure[highest.index-1,,]
    wl[which(materials[highest.index-1,,]==0)] = NA
    wl = pressure[highest.index-1,,]/101325+z[highest.index-1]
    h5write(wl,output.file,paste(itime,"/","Water_Level [m]",sep=""),level=0)

    
    vx = h5read(data,paste(itime,"/Liquid X-Velocity [m_per_h]",sep=""))
    vy = h5read(data,paste(itime,"/Liquid Y-Velocity [m_per_h]",sep=""))    

    vxy = (vx**2+ny**2)**0.5
    vxy[(highest.index+1):nz,,] = NA    
    vxy[non.hanford] = NA

    total.tracer = array(0,c(nz,ny,nx))
    for (itracer in river.tracer)
    {
        total.tracer = total.tracer+ h5read(data,paste(itime,"/",itracer,sep=""))
    }
    total.tracer[(highest.index+1):nz,,] = NA    
    total.tracer[non.hanford] = NA

    average.tracer=apply(total.tracer*vxy,c(2,3),sum,na.rm=TRUE)/apply(vxy,c(2,3),sum,na.rm=TRUE)
    average.tracer = (average.tracer/max.tracer)*(max.spc-min.spc)+min.spc
    
    h5write(average.tracer,output.file,paste(itime,"/","Tracer [M]",sep=""),level=0)
}


