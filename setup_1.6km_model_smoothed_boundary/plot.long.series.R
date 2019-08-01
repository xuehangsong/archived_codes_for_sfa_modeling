rm(list=ls())

start.time = as.POSIXct("2004-1-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
##end.time = as.POSIXct("2017-1-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

end.time = as.POSIXct("2016-10-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

time.ticks = seq(start.time,end.time,366*24*3600)
##time.ticks = seq(start.time,end.time,31*24*3600)

load("results/river.data.r")

jpeg(paste("figures/river.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
##jpeg(paste("figures/2016.jpg",sep=''),width=8,height=5,units='in',res=200,quality=100)

plot(obs.time,obs.value,type="l",col="darkblue",
     xlim=range(start.time,end.time),
     xlab=NA,
     ylab=NA,
     axes= FALSE,
     )
load("results/level.data.r")

lines(obs.time[["SWS-1"]],obs.value[["SWS-1"]],col='blue')
lines(obs.time[["2-3"]],obs.value[["2-3"]],col='red')
##mtext(side = 3,text='2016 Year',line=-2,cex=2.2)

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%Y"),tck=-0.018,cex.axis=1.2)
mtext(side = 1,text='Time (Year)',line=3,cex=1.2)
axis(side = 2,at=seq(104,107.5,1),col.axis='black',col='black',las=2,line=-1,cex.axis=1.2)
mtext(side = 2,at=105.5,text='Water level (m)',line=2,col='black',cex=1.2)
axis(side=3,at=c(0))
axis(side=4,at=c(0))


legend(start.time,107.5,c("river","2-3"),
       cex=1.3,
       col=c("blue","red"),
       lwd=c(3,3),
       bty="n",horiz=TRUE)
dev.off()
