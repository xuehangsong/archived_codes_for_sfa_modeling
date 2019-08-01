rm(list=ls())
library("fields")
library("akima")

air_pressure = 101325
gravity = 9.8068
water_density = 998.2 #997

ntime = 720
source("~/repos/sbr-river-corridor-sfa/1600m_3d_model.R")
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
load(file="real_river/cfd.1600m.river.r")
load(file="real_river/face.1600m.r")
load(file="real_river/pressure.dataset.r")

model.cells = expand.grid(1:nx,1:ny,1:nz)

face.z = z[model.cells[face.cell.ids.final,3]]
## type.index = which(face.ids.final==5)
## face.z[type.index] = face.z[type.index]+0.5*dz[model.cells[face.cell.ids.final[type.index],3]]
## type.index = which(face.ids.final==6)
## face.z[type.index] = face.z[type.index]-0.5*dz[model.cells[face.cell.ids.final[type.index],3]]


river.head = (pressure.dataset-air_pressure)/gravity/water_density+replicate(ntime,face.z)#face.z

for (itime in 1:ntime)
{
    itime = 720

    

    
}



## load("real_river/pressure1.r")
## plot(pressure[,5],pressure[,1])
## load(file=paste("real_river/pressure_surface",itime,".r",sep=""))
## points(cfd.1600m.riverbed[,3],pressure.surface,col="green")
## points(face.z,pressure.dataset[,1]-air_pressure,col="red")


## plot(face.z,(pressure.dataset[,1]-air_pressure)/gravity/water_density+face.z,col="red")

load(file=paste("real_river/pressure_surface",itime,".r",sep=""))
plot(cfd.1600m.riverbed[,3],pressure.surface/gravity/water_density,col="green",cex=0.1)



zzz = pressure.surface/gravity/water_density##
zzz[which(zzz<0.1)] = NA
zzz = zzz+cfd.1600m.riverbed[,3]
load(file=paste("real_river/pressure_surface",itime,".r",sep=""))
plot(cfd.1600m.riverbed[,3],zzz,col="green",cex=0.1)



load("real_river/pressure1.r")
temp = proj_to_model(model_origin,angle,cbind(pressure[,"x"],pressure[,"y"]))
pressure[,"x"] = temp[,1]
pressure[,"y"] = temp[,2]
####truncated in east-west direction
original.data = pressure
pressure = NULL
data.range = original.data[,"x"]
pressure = original.data[which(data.range>west-100 & data.range<east+100),]


####truncated in north-south direction
original.data = pressure
pressure = NULL
data.range = original.data[,"y"]
pressure = original.data[which(data.range>south-100 & data.range<north+100),]

plot(pressure[,3],pressure[,5])
points(cfd.1600m.riverbed[,1],cfd.1600m.riverbed[,3],col="green")

load(file=paste("real_river/pressure_surface",itime,".r",sep=""))
plot(pressure[,5],pressure[,1]/water_density/gravity+pressure[,5],xlim=c(90,107),ylim=c(102,107))
points(cfd.1600m.riverbed[,3],(pressure.surface+air_pressure)/gravity/water_density+cfd.1600m.riverbed[,3],col="green")
