rm(list=ls())

i=0

start.time = as.POSIXct("2016-03-19 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-04-06 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")


time.range = range(start.time,end.time)
time.ticks.minor = seq(time.range[1],time.range[2],3600*1*24)
time.ticks = seq(time.range[1],time.range[2],3600*5*24)


jpeg(paste("figures/all.slice.",i,".jpg",sep=''),width=14,height=16,units='in',res=200,quality=100)
par(mar=c(5,8,4,8),mgp=c(4,1.5,0))

load("results/level.data.r")
plot(obs.time[["2-3"]],obs.value[["2-3"]],
     col='white',
     ylim=c(99,106),
     xlim=time.range,
     type='l',
     lty=2,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )
lines(obs.time[["2-3"]],obs.value[["2-3"]],col='black',lty=1,lwd=2)
lines(obs.time[["SWS-1"]],obs.value[["SWS-1"]],col='blue',lty=1,lwd=2)



axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8)
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.018,cex.axis=1.8)
mtext(side = 1,text='Time (day)',line=3,cex=1.8)
axis(side = 2,at=c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=1.7)
mtext(side = 2,at=105.3,text='Water level (m)',line=6,col='black',cex=1.8)




load("results/spc.data.r")
par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T)
plot(obs.time[["2-3"]],obs.value[["2-3"]],
     col='white',
     xlim=time.range,
     ylim=c(-1.3,1.3),
     type='l',
     lwd=2,
     lty=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


lines(obs.time[["2-3"]],obs.value[["2-3"]],col='black',lty=1,lwd=2)
lines(obs.time[["SWS-1"]],obs.value[["SWS-1"]],col='blue',lty=1,lwd=2)
lines(obs.time[["S10"]],obs.value[["S10"]]/1000,col='darkgreen',lty=1,lwd=2)
lines(obs.time[["S40"]],obs.value[["S40"]]/1000,col='red',lty=1,lwd=2)
lines(obs.time[["NRG"]],obs.value[["NRG"]]/1000,col='orange',lty=1,lwd=2)


axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8)
axis(side = 4,at = c(0.1,0.3,0.5,0.7),col.axis='black',col='black',line=0,las=2,cex.axis=1.8)
mtext(side = 4,at=0.4,text='SpC (mS/cm)',col='black',line=5,cex=1.8)





load("results/spc.temp.data.r")
par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T)
plot(obs.time[["2-3"]],obs.value[["2-3"]],
     col='black',
     xlim=time.range,
     ylim=c(-22.,58),
     type='l',
     lty=2,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(obs.time[["2-3"]],obs.value[["2-3"]],col='black',lty=1,lwd=2)
lines(obs.time[["SWS-1"]],obs.value[["SWS-1"]],col='blue',lty=1,lwd=2)
lines(obs.time[["S10"]],obs.value[["S10"]],col='darkgreen',lty=1,lwd=2)
lines(obs.time[["S40"]],obs.value[["S40"]],col='red',lty=1,lwd=2)
lines(obs.time[["NRG"]],obs.value[["NRG"]],col='orange',lty=1,lwd=2)



load("results/do.temp.data.r")
lines(obs.time[["2-3"]],obs.value[["2-3"]],col='black',lty=1,lwd=2)
lines(obs.time[["S10"]],obs.value[["S10"]],col='darkgreen',lty=1,lwd=2)
lines(obs.time[["S40"]],obs.value[["S40"]],col='red',lty=1,lwd=2)




axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8)
axis(side = 2,at=c(0,6,12,18),col.axis='black',col='black',line=0,las=2,cex.axis=1.8)
mtext(side = 2,at = 10 ,text=bquote("Temperature ("^o*"C)"),col='black',line=4,cex=1.8)

load("results/do.data.r")
par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T,xpd=TRUE)
plot(obs.time[["NRG"]],obs.value[["NRG"]],
     col='white',
     xlim=time.range,
     ylim=c(0,55),
     type='l',
     lwd=2,
     lty=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(obs.time[["S10"]],obs.value[["S10"]],col='darkgreen',lty=1,lwd=2)
lines(obs.time[["S40"]],obs.value[["S40"]],col='red',lty=1,lwd=2)
lines(obs.time[["NRG"]],obs.value[["NRG"]],col='orange',lty=1,lwd=2)


axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8)
axis(side = 4,at = c(0,4,8,12),col.axis='black',col='black',line=0,las=2,cex.axis=1.8)
mtext(side = 4,at=6,text='DO (mg/L)',col='black',line=4,cex=1.8)


head.diff = level.value[["SWS-1"]]-level.value[["2-3"]]
line.mark = which(head.diff>=0)
line.mark = line.mark[which(head.diff[line.mark+1]<0)]
for (i.line in line.mark)
{
    lines(rep(interp.time[i.line]+900,2),c(0,50),lty=2, lwd=2,col="orange")
}

line.mark = which(head.diff<=0)
line.mark = line.mark[which(head.diff[line.mark+1]>0)]
for (i.line in line.mark)
{
    lines(rep(interp.time[i.line]+900,2),c(0,50),lty=2,lwd=2,col="cyan")
}









legend(mean(c(start.time,end.time))-24*10*3600,59,
       c("2-3","SWS-1","NRG","S10","S40"),
       cex=1.8,
       lty=c(1,1,1,1,1),
       col=c("black","blue","orange","darkgreen","red"),
       lwd=c(3,3,3,3,3),
       bty="n",horiz=TRUE)

dev.off()



