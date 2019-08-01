rm(list=ls())
library(xts)
source("codes/xuehang_R_functions.R")
load("results/thermal_data.r")



simu.start = as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
ntherm = ncol(thermistor.xts)

shallow.threshold = -1.5

case.name = "homo_2"
porosity = 1
col.index = 6


temp.data = as.matrix(read.csv(paste("results/",case.name,"_c",col.index-1,
                                     "_Temperature [C].txt",sep=""),header=F))
vx.data  = as.matrix(read.csv(paste("results/",case.name,"_c",col.index-1,
                                    "_Liquid X-Velocity [m_per_h].txt",sep=""),header=F))/porosity*24
vy.data  = as.matrix(read.csv(paste("results/",case.name,"_c",col.index-1,
                                    "_Liquid Y-Velocity [m_per_h].txt",sep=""),header=F))/porosity*24
vz.data  = as.matrix(read.csv(paste("results/",case.name,"_c",col.index-1,
                                    "_Liquid Z-Velocity [m_per_h].txt",sep=""),header=F))/porosity*24

simu.time = as.numeric(unlist(read.csv(
    paste("results/",case.name,"_time.txt",sep=""),header=F)))
simu.time = simu.start+simu.time*3600
temp.depth = as.numeric(unlist(read.csv(
    paste("results/",case.name,"_c",col.index-1,"_depth.txt",sep=""),header=F)))
ndepth = length(temp.depth)

temp.data.shallow = temp.data[,which(temp.depth>=shallow.threshold)]
vx.data.shallow = vx.data[,which(temp.depth>=shallow.threshold)]
vy.data.shallow = vy.data[,which(temp.depth>=shallow.threshold)]
vz.data.shallow = vz.data[,which(temp.depth>=shallow.threshold)]

temp.depth.shallow = temp.depth[which(temp.depth>=shallow.threshold)]
ndepth.shallow = length(temp.depth.shallow)




start.time = as.POSIXct("2016-04-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2017-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
every_min = 5
start_min = 0
time.index = seq(from=start.time,to=end.time,by=paste(every_min,"min"))
temp.data.shallow.xts = regulate_data(cbind(data.frame(simu.time),data.frame(temp.data.shallow)),
                                      start.time,end.time,every_min,start_min)
vx.data.shallow.xts = regulate_data(cbind(data.frame(simu.time),data.frame(vx.data.shallow)),
                                      start.time,end.time,every_min,start_min)
vy.data.shallow.xts = regulate_data(cbind(data.frame(simu.time),data.frame(vy.data.shallow)),
                                      start.time,end.time,every_min,start_min)
vz.data.shallow.xts = regulate_data(cbind(data.frame(simu.time),data.frame(vz.data.shallow)),
                                      start.time,end.time,every_min,start_min)


colnames(temp.data.shallow.xts) = temp.depth.shallow
time.ticks = seq(from=as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
                ,to=as.POSIXct("2017-12-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),by="1 month")                        
colors = heat.colors(ndepth.shallow)

jpeg(paste("figures/",case.name,"_temperature.jpg",sep=''),width=10,height=6,units='in',res=300,quality=100)
plot(simu.time,temp.data.shallow[,1],
     type="l",
     col="white",
     ylim=c(0,25),
     ylab="DegC",
     xlab=NA,
     axes=FALSE)
box()
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%Y"))
axis(side = 2,at=seq(0,25,5))

for (idepth in 1:ndepth.shallow)
{
    lines(simu.time,temp.data.shallow[,idepth],col=colors[idepth])
}
therm.col = c("black","orange","green","blue")
for (itherm in c(1,4))
{
    lines(index(thermistor.xts),thermistor.xts[,itherm],col=therm.col[itherm],lwd=1)
}

legend("topright",
       c("Simulation(-1.5m)","Simulation(-0.1m)","-0.64 m","River"),
       col=c("red","yellow","black","blue"),
       lwd=1,
       bty="n")
dev.off()



jpeg(paste("figures/",case.name,"_vx.jpg",sep=''),width=10,height=6,units='in',res=300,quality=100)
plot(simu.time,vx.data.shallow[,1],
     type="l",
     col="white",
     ylim=range(vx.data.shallow),
     xlab=NA,
     ylab="X flux (m/d)",     
     axes=FALSE)
box()
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%Y"))
#axis(side = 2,at=seq(-20,20,2))
axis(side = 2,at=seq(-20,20,0.5))

for (idepth in ndepth.shallow:1)
{
    lines(simu.time,vx.data.shallow[,idepth],col=colors[idepth])
}


legend("topright",
       c("Simulation(-1.5m)","Simulation(-0.1m)"),
       col=c("red","yellow","black","blue"),
       lwd=1,
       bty="n")
dev.off()




jpeg(paste("figures/",case.name,"_vy.jpg",sep=''),width=10,height=6,units='in',res=300,quality=100)
plot(simu.time,vy.data.shallow[,1],
     type="l",
     col="white",
     ylim=range(vy.data.shallow),
     xlab=NA,
     ylab="Y flux (m/d)",     
     axes=FALSE)
box()
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%Y"))
#axis(side = 2,at=seq(-20,20,0.02))
axis(side = 2,at=seq(-20,20,0.2))

for (idepth in ndepth.shallow:1)
{
    lines(simu.time,vy.data.shallow[,idepth],col=colors[idepth])
}


legend("topright",
       c("Simulation(-1.5m)","Simulation(-0.1m)"),
       col=c("red","yellow","black","blue"),
       lwd=1,
       bty="n")
dev.off()




jpeg(paste("figures/",case.name,"_vz.jpg",sep=''),width=10,height=6,units='in',res=300,quality=100)
plot(simu.time,vz.data.shallow[,1],
     type="l",
     col="white",
     ylim=range(vz.data.shallow),
     xlab=NA,
     ylab="z flux (m/d)",     
     axes=FALSE)
box()
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%Y"))
#axis(side = 2,at=seq(-20,20,2))
axis(side = 2,at=seq(-20,20,0.5))

for (idepth in ndepth.shallow:1)
{
    lines(simu.time,vz.data.shallow[,idepth],col=colors[idepth])
}


legend("topright",
       c("Simulation(-1.5m)","Simulation(-0.1m)"),
       col=c("red","yellow","black","blue"),
       lwd=1,
       bty="n")
dev.off()





lpml_data = temp.data.shallow
rownames(lpml_data) = as.character(simu.time)
colnames(lpml_data) = temp.depth.shallow
write.csv(lpml_data,file=paste("results/",case.name,"_simulation.csv",sep=""))


lpml_data = vx.data.shallow
rownames(lpml_data) = as.character(simu.time)
colnames(lpml_data) = temp.depth.shallow
write.csv(lpml_data,file=paste("results/",case.name,"_simulation_vx.csv",sep=""))

lpml_data = vy.data.shallow
rownames(lpml_data) = as.character(simu.time)
colnames(lpml_data) = temp.depth.shallow
write.csv(lpml_data,file=paste("results/",case.name,"_simulation_vy.csv",sep=""))


lpml_data = vz.data.shallow
rownames(lpml_data) = as.character(simu.time)
colnames(lpml_data) = temp.depth.shallow
write.csv(lpml_data,file=paste("results/",case.name,"_simulation_vz.csv",sep=""))





## lines(simu.time,temp.data.shallow[,1],col="red")
## lines(simu.time,temp.data.shallow[,ndepth.shallow],col="green")




## plot(as.numeric(temp.data.shallow.xts[,"-1.5"]),as.numeric(thermistor.xts[,"-0.64"]))
## plot(as.numeric(temp.data.shallow.xts[,"-0.1"]),as.numeric(thermistor.xts[,"-0.64"]))
