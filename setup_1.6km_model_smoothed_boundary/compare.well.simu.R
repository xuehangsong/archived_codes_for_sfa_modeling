rm(list=ls())


start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.tick = seq(from=start.time,to=end.time,by="1 year")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600


well.name = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","3-18","4-9","4-7","SWS-1","NRG")
nwell = length(well.name)

load("results/mass.well.level.2010_2016.r")
load("results/well.data.xts.r")
well.level = array(ntime*nwell,c(nwell,ntime))
rownames(well.level) = well.name
for (iwell in well.name) {
    well.level[iwell,] = well.data.xts[[iwell]][,"level"]
}
save(well.level,file="results/well.level.2010_2016.r")

for (iwell in well.name[1:12])

{
    jpeg(paste("figures/",iwell,"_level.compare.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
    plot(time.index,mass.well.level[iwell,],type="p",col="black",pch=16,cex=0.3,
         xlim=range(start.time,end.time),
         xlab=NA,
         ylab=NA,
         axes=FALSE,
         ylim=c(104,109),
         main=iwell,
         )
    points(time.index,well.level[iwell,],col="red",pch=16,cex=0.3)
    mtext("Time (Year)",side=1,line=2)
    mtext("Well level (m)",side=2,line=2)
    axis(side=1,label=time.tick,at=time.tick)
    axis(side=2,at=seq(104,109))    
    legend("topright",c("MASS1 level","Well level"),
           pch=c(16,16),col=c("black","red"),
           bty="n",horiz=TRUE)

    dev.off()
    
}

for (iwell in well.name[13:14])

{
    jpeg(paste("figures/",iwell,"_level.compare.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
    plot(time.index,mass.well.level[iwell,],type="p",col="black",pch=16,cex=0.3,
         xlim=range(start.time,end.time),
         xlab=NA,
         ylab=NA,         ylim=c(104,109),
         main=iwell,
         axes=FALSE,
         )
    points(time.index,well.level[iwell,],col="blue",pch=16,cex=0.3)
    mtext("Time (Year)",side=1,line=2)
    mtext("Well level (m)",side=2,line=2)
    axis(side=1,label=time.tick,at=time.tick)
    axis(side=2,at=seq(104,109))        
    legend("topright",c("MASS1 level","Well level"),
           pch=c(16,16),col=c("black","blue"),
           bty="n",horiz=TRUE)

    dev.off()
    
}




for (iwell in well.name)

{
    jpeg(paste("figures/",iwell,"_level.diff.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
    plot(time.index,mass.well.level[iwell,]-well.level[iwell,],type="p",col="black",pch=16,cex=0.3,
         xlim=range(start.time,end.time),
         xlab=NA,
         ylab=NA,
         ylim=c(-1,1.5),
         main=iwell,
         axes=FALSE         
         )
    axis(side=1,label=time.tick,at=time.tick)
    axis(side=2,at=seq(-1,1.5,0.5))        
    mtext("Time (Year)",side=1,line=2)
    mtext("Well level (m)",side=2,line=2)

    lines(time.index,rep(0,ntime),lty=2,col="orange",lwd=2)
    legend("topright",c("MASS1 level - Well-level"),
           pch=c(16),col=c("black"),
           bty="n",horiz=TRUE)

    dev.off()
    
}

