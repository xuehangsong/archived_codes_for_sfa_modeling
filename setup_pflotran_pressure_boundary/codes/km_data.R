rm(list=ls())
library("akima")

data.dir = "7km/pressure.csv/"
file.pre = "BCs"

model.range = array(NA,c(2,3))
colnames(model.range) = c("x","y","z")
model.range[,"x"] = c(20,2340)
model.range[,"y"] = c(-7180,100)
model.range[,"z"] = c(93.869,130)

site.range = array(NA,c(2,3))
colnames(site.range) = c("x","y","z")
site.range[,"x"] = c(593575,595935)
site.range[,"y"] = c(113590,120670)
site.range[,"z"] = c(93.869,130)

#corrected as Jie changed the model domain
site.range[,"x"] = c(593575+20,595935-20)
site.range[,"y"] = c(113590-100,120670+100)
site.range[,"z"] = c(93.869,130)

drift.site.model = c(site.range[1,"x"]-model.range[1,"x"],
                     site.range[1,"y"]-model.range[1,"y"])                     
                     

start.time = as.POSIXct("2014-01-01 00:00:00",tz="GMT")
time.step = 3600
ntime = 720
for (itime in 1:ntime)
{
    print(itime)
    pressure = read.csv(paste("real_river/riverCFD/PressureBoundaryOutput_PressureBC_",
                              sprintf("%1.6e",itime*time.step+20.2),".csv",sep=""))
    colnames(pressure) = c("pa","saturation","x","y","z")
    pressure[,"x"] = drift.site.model["x"] + pressure[,"x"]
    pressure[,"y"] = drift.site.model["y"] + pressure[,"y"]   
    save(list=ls(),file=paste("real_river/pressure",itime,".r",sep=""))
}



## istate = 1
## data = read.csv(paste(data.dir,file.pre,sprintf("%03d",istate),".csv",sep=""))
## colnames(data) = c("Saturation","Pressure","x","y")

## a = interp(data[,3],data[,4],data[,5])
