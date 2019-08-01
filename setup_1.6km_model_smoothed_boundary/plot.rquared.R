rm=ls()


load("results/inland.gradient.2010_2016.r")
load("results/mass.gradient.2010_2016.r")



start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.tick = seq(from=start.time,to=end.time,by="1 year")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600


jpeg(paste("figures/inland.squared.compare.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,inland.rsquared,type="p",col="black",pch=16,cex=0.3,
     xlim=range(start.time,end.time),
     xlab=NA,
     ylab=NA,
     axes=FALSE,
     ylim=c(0,1),
     main="Inland R^2"     
     )
mtext("Time (Year)",side=1,line=2)
mtext("R^2",side=2,line=2)
axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(0,1,0.2))    
## legend("bottomright",c("MASS1 level","Inland"),
##        pch=c(16,16),col=c("black","red"),
##        bty="n",horiz=TRUE)

dev.off()


jpeg(paste("figures/mass.squared.compare.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,mass.rsquared,type="p",col="black",pch=16,cex=0.3,
     xlim=range(start.time,end.time),
     xlab=NA,
     ylab=NA,
     axes=FALSE,
     ylim=c(0.85,1),
     main="Mass R^2"
     )
mtext("Time (Year)",side=1,line=2)
mtext("R^2",side=2,line=2)
axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(0.85,1,0.05))    
## legend("bottomright",c("MASS1 level","Inland"),
##        pch=c(16,16),col=c("black","red"),
##        bty="n",horiz=TRUE)

dev.off()


for (itime in c(12015,15000,22001,25000,51000,51500,52000,52500)) {
    jpeg(paste("figures/",itime,"mass.squared.jpg",sep=''),width=8,height=5,units='in',res=200,quality=100)
    plot(inland.lm[[itime]]$model[,2],inland.lm[[itime]]$model[,1],type="p",col="black",pch=1,cex=1,
         xlab=NA,
         ylab=NA,
         axes=FALSE,
         xlim=c(-800,800),
         ylim=c(min(inland.lm[[itime]]$model[,1])-0.05,max(inland.lm[[itime]]$model[,1])+0.05),
         main=time.index[itime]
         )
    text(inland.lm[[itime]]$model[,2],inland.lm[[itime]]$model[,1]-0.01,labels=rownames(inland.lm[[itime]]$model))
    abline(inland.lm[[itime]],lty=2)
    mtext("y (m)",side=1,line=2)
    mtext("Water elevation (m)",side=2,line=2)
    axis(side=2)
    axis(side=1,at=seq(-800,800,400))    

    dev.off()
}


