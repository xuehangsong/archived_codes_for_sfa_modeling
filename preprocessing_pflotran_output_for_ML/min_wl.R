rm(list=ls())
library(rhdf5)
H5close()

data.dir = "/global/cscratch1/sd/pshuai/John_case_material_2/"
data.file = "pflotran_bigplume-004.h5"

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

lowest.wl = 1000

for (itime in times)
{
    print(itime)
    satu = h5read(data,paste(itime,"/Liquid_Saturation",sep=""))
    satu[which(materials==0)]=1
    satu[which(satu!=1)]=NA

    water.table = apply(satu,c(2,3),function(x) max(x*z,na.rm=TRUE))
    lowest.wl = min(water.table,lowest.wl)
}


## vx = h5read(data,paste(itime,"/Liquid X-Velocity [m_per_h]",sep=""))
## vy = h5read(data,paste(itime,"/Liquid Y-Velocity [m_per_h]",sep=""))    
