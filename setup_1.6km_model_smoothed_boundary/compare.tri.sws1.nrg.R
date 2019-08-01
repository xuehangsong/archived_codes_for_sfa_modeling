rm(list=ls())


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

for (iwell in c("NRG","SWS-1"))

{
    jpeg(paste("figures/",iwell,"_tri.compare.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
    plot(time.index,mass.well.level[iwell,],type="l",col="black",
         xlim=range(start.time,end.time),
         xlab=NA,
         ylab=NA,
         axes=FALSE,
         ylim=c(104,109),
         main=iwell,
         )
    lines(time.index,well.level[iwell,],col="blue")
    lines(time.index,well.gauge.level[iwell,],col="red")
    
    mtext("Time (Year)",side=1,line=2)
    mtext("Well level (m)",side=2,line=2)
    axis(side=1,label=time.tick,at=time.tick)
    axis(side=2,at=seq(104,109))    
    legend("topright",c("MASS1 level","Gauge level","Well level"),
           pch=c(NA,NA,NA),lty=c(1,1,1),col=c("black","blue","red"),
           bty="n",horiz=TRUE)

    dev.off()
    
}


time.tick = seq(from=start.time,to=end.time,by="5 days")
river.avaiable = which(!is.na(river.gradient))
for (iwell in c("NRG","SWS-1"))

{
    jpeg(paste("figures/",iwell,"_tri.compare.1.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
    plot(time.index[river.avaiable],mass.well.level[iwell,river.avaiable],type="l",col="black",
         xlim=range(time.index[river.avaiable]),
         xlab=NA,
         ylab=NA,
         axes=FALSE,
         ylim=c(104.5,106),
         main=iwell,
         )
    lines(time.index[river.avaiable],well.level[iwell,river.avaiable],col="blue")
    lines(time.index[river.avaiable],well.gauge.level[iwell,river.avaiable],col="red")
    
    mtext("Time (Year)",side=1,line=2)
    mtext("Well level (m)",side=2,line=2)
    axis(side=1,label=time.tick,at=time.tick)
    axis(side=2,at=seq(104.5,106,0.5))    
    legend("topright",c("MASS1 level","Gauge level","Well level"),
           pch=c(NA,NA,NA),lty=c(1,1,1),col=c("black","blue","red"),
           bty="n",horiz=TRUE)

    dev.off()
    
}



time.tick = seq(from=start.time,to=end.time,by="1 days")
river.avaiable = which(!is.na(river.gradient))[300:500]
for (iwell in c("NRG","SWS-1"))

{
    jpeg(paste("figures/",iwell,"_tri.compare.2.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
    plot(time.index[river.avaiable],mass.well.level[iwell,river.avaiable],type="l",col="black",
         xlim=range(time.index[river.avaiable]),
         xlab=NA,
         ylab=NA,
         axes=FALSE,
         ylim=c(104.5,106),
         main=iwell,
         )
    lines(time.index[river.avaiable],well.level[iwell,river.avaiable],col="blue")
    lines(time.index[river.avaiable],well.gauge.level[iwell,river.avaiable],col="red")
    
    mtext("Time (Year)",side=1,line=2)
    mtext("Well level (m)",side=2,line=2)
    axis(side=1,label=time.tick,at=time.tick)
    axis(side=2,at=seq(104.5,106,0.5))    
    legend("topleft",c("MASS1 level","Gauge level","Well level"),
           pch=c(NA,NA,NA),lty=c(1,1,1),col=c("black","blue","red"),
           bty="n",horiz=TRUE)

    dev.off()
    
}
