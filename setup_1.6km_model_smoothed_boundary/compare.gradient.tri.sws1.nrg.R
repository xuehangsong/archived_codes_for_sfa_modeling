rm(list=ls())


well.name = c("SWS-1","NRG")
coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% well.name,]


start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.tick = seq(from=start.time,to=end.time,by="1 year")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600


load("results/well.gauge.level.2010_2016.r") 
load("results/well.level.2010_2016.r")
load("results/mass.well.level.2010_2016.r")
load("results/river.gradient.2010_2016.r")

jpeg(paste("figures/tri.gradient.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,(mass.well.level["SWS-1",]-mass.well.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]),type="l",col="black",
     xlim=range(start.time,end.time),
     xlab=NA,
     ylab=NA,
     axes=FALSE,
     ylim=c(-0.0008,0.0006),     
     )
lines(time.index,(well.level["SWS-1",]-well.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]),col="blue")
lines(time.index,(well.gauge.level["SWS-1",]-well.gauge.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]),col="red")

mtext("Time (Year)",side=1,line=2)
mtext("Gradient across SWS-1/NRG",side=2,line=2)
axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(-8e-4,6e-4,2e-4))    
legend("topright",c("MASS1 gradient","Gauge gradient","Well gradient"),
       pch=c(NA,NA,NA),lty=c(1,1,1),col=c("black","blue","red"),
       bty="n",horiz=TRUE)

dev.off()






time.tick = seq(from=start.time,to=end.time,by="5 days")
river.avaiable = which(!is.na(river.gradient))
jpeg(paste("figures/tri.gradient.1.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index[river.avaiable],((mass.well.level["SWS-1",]-mass.well.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]))[river.avaiable],type="l",col="black",
     xlim=range(time.index[river.avaiable]),
     xlab=NA,
     ylab=NA,
     axes=FALSE,
     ylim=c(-0.000,0.0004),     
     )
lines(time.index[river.avaiable],((well.level["SWS-1",]-well.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]))[river.avaiable],col="blue")
lines(time.index[river.avaiable],((well.gauge.level["SWS-1",]-well.gauge.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]))[river.avaiable],col="red")

mtext("Time (Year)",side=1,line=2)
mtext("Gradient across SWS-1/NRG",side=2,line=2)
axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(0,4e-4,1e-4))    
legend("topright",c("MASS1 gradient","Gauge gradient","Well gradient"),
       pch=c(NA,NA,NA),lty=c(1,1,1),col=c("black","blue","red"),
       bty="n",horiz=TRUE)

dev.off()



time.tick = seq(from=start.time,to=end.time,by="1 days")
river.avaiable = which(!is.na(river.gradient))[300:500]
jpeg(paste("figures/tri.gradient.2.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index[river.avaiable],((mass.well.level["SWS-1",]-mass.well.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]))[river.avaiable],type="l",col="black",
     xlim=range(time.index[river.avaiable]),
     xlab=NA,
     ylab=NA,
     axes=FALSE,
     ylim=c(-0.000,0.0004),     
     )
lines(time.index[river.avaiable],((well.level["SWS-1",]-well.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]))[river.avaiable],col="blue")
lines(time.index[river.avaiable],((well.gauge.level["SWS-1",]-well.gauge.level["NRG",])/(coord.data["SWS-1",2]-coord.data["NRG",2]))[river.avaiable],col="red")

mtext("Time (Year)",side=1,line=2)
mtext("Gradient across SWS-1/NRG",side=2,line=2)
axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(0,4e-4,1e-4))    
legend("topright",c("MASS1 gradient","Gauge gradient","Well gradient"),
       pch=c(NA,NA,NA),lty=c(1,1,1),col=c("black","blue","red"),
       bty="n",horiz=TRUE)

dev.off()


