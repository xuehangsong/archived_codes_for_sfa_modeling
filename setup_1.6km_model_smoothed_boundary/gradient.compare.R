rm(list=ls())

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600
mass.gradient = rep(NA,ntime)

load("results/river.gradient.2010_2016.r")
load("results/inland.gradient.2010_2016.r")
load("results/mass.gradient.2010_2016.r")

time.tick = seq(from=start.time,to=end.time,by="1 year")
jpeg(paste("figures/compare.gradient.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,mass.gradient,type="p",col="black",pch=16,cex=0.3,
     xlim=range(start.time,end.time),
     xlab=NA,
     ylab=NA,
     ylim=c(-0.0004,0.0004),
     axes=FALSE
     )
axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(-4e-4,4e-4,2e-4))

points(time.index,inland.gradient,col="red",pch=16,cex=0.3)
points(time.index,river.gradient,col="blue",pch=16,cex=0.3)
lines(time.index,rep(0,ntime),lty=2,col="orange",lwd=2)

mtext("Time (Year)",side=1,line=2)
mtext("Gradient",side=2,line=2)

legend("topright",c("River gradient","Inland gradient","MASS1 gradient"),
       pch=c(16,16,16),col=c("blue","red","black"),
       bty="n",horiz=TRUE)

dev.off()

time.tick = seq(from=start.time,to=end.time,by="5 day")
river.avaiable = which(!is.na(river.gradient))
jpeg(paste("figures/compare.gradient.1.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index[river.avaiable],mass.gradient[river.avaiable],type="l",col="black",
     xlim=range(time.index[river.avaiable]),
     xlab=NA,
     ylab=NA,
     ylim=c(-0.000,0.0003),
     axes=FALSE
     )
lines(time.index[river.avaiable],inland.gradient[river.avaiable],col="red")
lines(time.index[river.avaiable],river.gradient[river.avaiable],col="blue")

axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(0,4e-4,1e-4))

mtext("Time (Year)",side=1,line=2)
mtext("Gradient",side=2,line=2)

legend("topright",c("River gradient","Inland gradient","MASS1 gradient"),
       lty=c(1,1,1),col=c("blue","red","black"),
       bty="n",horiz=TRUE)

dev.off()


time.tick = seq(from=start.time,to=end.time,by="1 day")
river.avaiable = which(!is.na(river.gradient))[300:500]
jpeg(paste("figures/compare.gradient.2.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index[river.avaiable],mass.gradient[river.avaiable],type="l",col="black",
     xlim=range(time.index[river.avaiable]),
     xlab=NA,
     ylab=NA,
     ylim=c(-0.000,0.0003),
     axes=FALSE
     )
lines(time.index[river.avaiable],inland.gradient[river.avaiable],col="red")
lines(time.index[river.avaiable],river.gradient[river.avaiable],col="blue")

axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(0,4e-4,1e-4))

mtext("Time (Year)",side=1,line=2)
mtext("Gradient",side=2,line=2)

legend("topright",c("River gradient","Inland gradient","MASS1 gradient"),
       lty=c(1,1,1),col=c("blue","red","black"),
       bty="n",horiz=TRUE)

dev.off()
