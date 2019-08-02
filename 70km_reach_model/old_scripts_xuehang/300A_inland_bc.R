## #This file is used for calculating transient boundary conditions
## #using universal kriging 

###cov_model_sets = c('gaussian','wave','exponential','spherical')
###drift_sets = c(0,1)


rm(list=ls())
library(geoR)
library(rhdf5)

##------------INPUT----------------##
source("codes/300A_parameters.R")
H5close()
options(geoR.messages=FALSE)
input_folder = 'data/headdata4krige_Plume_2008-2017/'

##--------------OUTPUT---------------------##
output_folder = "300A_model/"
initial.h5 = "300A_H_Initial.h5"
BC.h5 = "300A_H_BC.h5"
fname_300A.bc.r= "results/300A.bc.r"

## for grids
grid.x = 4.0
grid.y = 4.0
grid.nx = diff(range_x)/grid.x
grid.ny = diff(range_y)/grid.y
pred.grid.south = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),range_y[1]+grid.y/2) # for South boundary
pred.grid.north = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),range_y[2]-grid.y/2) # for North boundary
pred.grid.east = expand.grid(range_x[1]+grid.x/2,seq(range_y[1]+grid.y/2,range_y[2],grid.y)) # for East boundary
pred.grid.west = expand.grid(range_x[2]-grid.x/2,seq(range_y[1]+grid.y/2,range_y[2],grid.y)) # for West boundary
pred.grid.domain = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),
                               seq(range_y[1]+grid.y/2,range_y[2],grid.y))
colnames(pred.grid.south)=c('x','y')
colnames(pred.grid.north)=c('x','y')
colnames(pred.grid.east)=c('x','y')
colnames(pred.grid.west)=c('x','y')
colnames(pred.grid.domain)=c('x','y')


## time information
start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

dt = 3600  ##secs
times = seq(start.time,end.time,dt)
ntime = length(times)
time.id = seq(0,ntime-1,dt/3600)  ##hourly boundary, why start from 0h?

origin.time = as.POSIXct("2007-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S") # starting time should be 1 h early than "2008-1-1 0:0:0" to set the right index in folder/headdata4krige_Plume_2008_2017

## BC.south = array(NA,c(ntime,grid.nx))
## BC.north = array(NA,c(ntime,grid.nx))
## BC.east = array(NA,c(ntime,grid.ny))
## BC.west = array(NA,c(ntime,grid.ny))


BC.south = c()
BC.north = c()
BC.east = c()
BC.west = c()
avail.time.id = c()

for (itime in 1:ntime)
{
    # print(times[itime])
    index = paste(as.character(difftime(times[itime],origin.time,tz="GMT",units="hours")),
                  "_",format(times[itime],"%d_%b_%Y_%H_%M_%S"),sep="")
    data = read.table(paste(input_folder,'time',index,'.dat',sep=''),header=F,na.strings = "NaN")


    if (!all(is.na(data[,3])))
    {
        avail.time.id = c(avail.time.id,time.id[itime])
### The x/y column is swaped.
### The reason is the data file from Huiying is also reversed (need to change the code from Huiying)
        data[,c(1,2,3)] = data[,c(2,1,3)]

        colnames(data) = c('x','y','z')
        data = as.geodata(data)

        ##This bins and esimator.type is defined by Xingyuan
        if (nrow(data$coords)>27) {
            bin1 = variog(data,uvec=c(0,50,100,seq(150,210,30),250,300),trend='cte',bin.cloud=T,estimator.type='modulus')
        } else {
            bin1 = variog(data,uvec=c(0,100,seq(150,210,30),250,300),trend='cte',bin.cloud=T,estimator.type='modulus')
        }
        initial.values <- expand.grid(max(bin1$v),seq(300))
        wls = variofit(bin1,ini = initial.values,fix.nugget=T,nugget = 0.00001,fix.kappa=F,cov.model='exponential')


        #check the varigram
        if (itime %% 1000 == 1) {
            # jpeg(filename=paste('figures/Semivariance Time = ',format(times[itime],"%Y-%m-%d %H:%M:%S"),".jpg",sep=''),
            #      width=5,height=5,units="in",quality=100,res=300)
            # plot(bin1,main = paste('Time = ',format(times[itime],"%Y-%m-%d %H:%M:%S"),sep=''),col='red', pch = 19, cex = 1, lty = "solid", lwd = 2)
            # text(bin1$u,bin1$v,labels=bin1$n, cex= 0.7,pos = 2)
            # lines(wls)
            # dev.off()
          print(times[itime])
        }


        ## Generate boundary and initial condition
        kc.south = krige.conv(data, loc = pred.grid.south, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))    
        kc.north = krige.conv(data, loc = pred.grid.north, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
        kc.east = krige.conv(data, loc = pred.grid.east, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
        kc.west = krige.conv(data, loc = pred.grid.west, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))            

        BC.south = rbind(BC.south,kc.south$predict)
        BC.north = rbind(BC.north,kc.north$predict)
        BC.east = rbind(BC.east,kc.east$predict)
        BC.west = rbind(BC.west,kc.west$predict)                        
        

        if (itime==1)
        {
            kc.domain = krige.conv(data, loc = pred.grid.domain, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
            h.initial = as.vector(kc.domain$predict)
            dim(h.initial) = c(grid.nx,grid.ny)
        }




    }
}

time.id = avail.time.id


##Generate the initial condition hdf5 file for the domain.
if (file.exists(paste(output_folder,initial.h5,sep=''))) {
    file.remove(paste(output_folder,initial.h5,sep=''))
}
h5createFile(paste(output_folder,initial.h5,sep=''))
h5createGroup(paste(output_folder,initial.h5,sep=''),'Initial_Head')
h5write(t(h.initial),paste(output_folder,initial.h5,sep=''),
        'Initial_Head/Data',level=0)
fid = H5Fopen(paste(output_folder,initial.h5,sep=''))
h5g = H5Gopen(fid,'/Initial_Head')
h5writeAttribute(attr = 1.0, h5obj = h5g, name = 'Cell Centered')
h5writeAttribute.character(attr = "XY", h5obj = h5g, name = 'Dimension')
h5writeAttribute(attr = c(grid.x,grid.y), h5obj = h5g, name = 'Discretization')
h5writeAttribute(attr = 500.0, h5obj = h5g, name = 'Max Buffer Size')
h5writeAttribute(attr = c(range_x[1],range_y[1]), h5obj = h5g, name = 'Origin') 
H5Gclose(h5g)
H5Fclose(fid)



##Generate the BC hdf5 file.
if (file.exists(paste(output_folder,BC.h5,sep=''))) {
    file.remove(paste(output_folder,BC.h5,sep=''))
} 

h5createFile(paste(output_folder,BC.h5,sep=''))

### write data
h5createGroup(paste(output_folder,BC.h5,sep=''),'BC_South')
h5write(time.id,paste(output_folder,BC.h5,sep=''),'BC_South/Times',level=0)
h5write(BC.south,paste(output_folder,BC.h5,sep=''),'BC_South/Data',level=0)

h5createGroup(paste(output_folder,BC.h5,sep=''),'BC_North')
h5write(time.id,paste(output_folder,BC.h5,sep=''),'BC_North/Times',level=0)
h5write(BC.north,paste(output_folder,BC.h5,sep=''),'BC_North/Data',level=0)

h5createGroup(paste(output_folder,BC.h5,sep=''),'BC_East')
h5write(time.id,paste(output_folder,BC.h5,sep=''),'BC_East/Times',level=0)
h5write(BC.east,paste(output_folder,BC.h5,sep=''),'BC_East/Data',level=0)

h5createGroup(paste(output_folder,BC.h5,sep=''),'BC_West')
h5write(time.id,paste(output_folder,BC.h5,sep=''),'BC_West/Times',level=0)
h5write(BC.west,paste(output_folder,BC.h5,sep=''),'BC_West/Data',level=0)

### write attribute
fid = H5Fopen(paste(output_folder,BC.h5,sep=''))
h5g.south = H5Gopen(fid,'/BC_South')
h5g.north = H5Gopen(fid,'/BC_North')
h5g.east = H5Gopen(fid,'/BC_East')
h5g.west = H5Gopen(fid,'/BC_West')


h5writeAttribute(attr = 1.0, h5obj = h5g.south, name = 'Cell Centered')
h5writeAttribute(attr = 'X', h5obj = h5g.south, name = 'Dimension')
h5writeAttribute(attr = grid.x, h5obj = h5g.south, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g.south, name = 'Max Buffer Size')
h5writeAttribute(attr = range_x[1], h5obj = h5g.south, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g.south, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g.south, name = 'Transient')


h5writeAttribute(attr = 1.0, h5obj = h5g.north, name = 'Cell Centered')
h5writeAttribute(attr = 'X', h5obj = h5g.north, name = 'Dimension')
h5writeAttribute(attr = grid.x, h5obj = h5g.north, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g.north, name = 'Max Buffer Size')
h5writeAttribute(attr = range_x[1], h5obj = h5g.north, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g.north, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g.north, name = 'Transient')


h5writeAttribute(attr = 1.0, h5obj = h5g.east, name = 'Cell Centered')
h5writeAttribute(attr = 'Y', h5obj = h5g.east, name = 'Dimension')
h5writeAttribute(attr = grid.y, h5obj = h5g.east, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g.east, name = 'Max Buffer Size')
h5writeAttribute(attr = range_y[1], h5obj = h5g.east, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g.east, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g.east, name = 'Transient')


h5writeAttribute(attr = 1.0, h5obj = h5g.west, name = 'Cell Centered')
h5writeAttribute(attr = 'Y', h5obj = h5g.west, name = 'Dimension')
h5writeAttribute(attr = grid.y, h5obj = h5g.west, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g.west, name = 'Max Buffer Size')
h5writeAttribute(attr = range_y[1], h5obj = h5g.west, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g.west, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g.west, name = 'Transient')


H5Gclose(h5g.south)
H5Gclose(h5g.north)
H5Gclose(h5g.east)
H5Gclose(h5g.west)
H5Fclose(fid)

save(list=ls(),file=fname_300A.bc.r)
