rm(list=ls())
library("fields")
library("akima")

source("~/repos/sbr-river-corridor-sfa/1600m_3d_model.R")
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
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

cfd.1600m.riverbed = expand.grid(x,y)
colnames(cfd.1600m.riverbed) = c("x","y")

colnames(cfd.1600m.riverbed)[1] = "x"
colnames(cfd.1600m.riverbed)[2] = "y"
temp.surface = interpp(pressure[,"x"],pressure[,"y"],pressure[,"z"],
                       cfd.1600m.riverbed[,"x"],cfd.1600m.riverbed[,"y"])[[3]]

cfd.1600m.riverbed = cbind(cfd.1600m.riverbed,temp.surface)
colnames(cfd.1600m.riverbed) = c("x","y","z")
#filled.contour(x,y,array(cfd.1600m.riverbed[,"z"],c(nx,ny)))

save(cfd.1600m.riverbed,file="real_river/cfd.1600m.river.r")

stop()
ntime = 720
for (itime in 1:ntime)
{

    print(itime)
    load(paste("real_river/pressure",itime,".r",sep=""))

    temp = proj_to_model(model_origin,angle,cbind(pressure[,"x"],pressure[,"y"]))
    pressure[,"x"] = temp[,1]
    pressure[,"y"] = temp[,2]
    pressure[,"pa"] = pressure[,"pa"]-(197-pressure[,"z"])*9.81*1.18415
    print(min(pressure[,"pa"]))
    
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
    
    pressure.surface = interpp(pressure[,"x"],pressure[,"y"],pressure[,"pa"],
            cfd.1600m.riverbed[,"x"],cfd.1600m.riverbed[,"y"])[[3]]
    
    save(pressure.surface,file=paste("real_river/pressure_surface",itime,".r",sep=""))    
##  filled.contour(x,y,array(pressure.surface,c(nx,ny)))
    
}
