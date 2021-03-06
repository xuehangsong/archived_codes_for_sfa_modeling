rm(list=ls())
library(akima)
library(scales)

compare.time = seq(25,300)
iobs=4

load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*2*24)
time.ticks.minor = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*1*24)
time.range = range(interp.time[compare.time])


case.name="th_richards_compare.7"
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))
load(paste(case.name,"/statistics/level.ensemble.r",sep=''))

jpeg(paste("figures/",case.name,"th_richards.jpg",sep=''),width=16.8,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,8,4,8),mgp=c(4,1.5,0))
plot(interp.time,level.value[["2-2"]],
     col='white',
     ylim=c(102,106),
     xlim=time.range,
     type='l',
     lty=3,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


lines(interp.time[compare.time],level.ensemble[4,iobs,compare.time],col='black',lty=1,lwd=5)
lines(interp.time[compare.time],level.ensemble[3,iobs,compare.time],col='red',lty=3,lwd=5)

lines(interp.time[compare.time],rep(104.425,length(compare.time)),col='green',lty=3,lwd=5)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8,tck=-0.015)
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02,cex.axis=1.8)
mtext(side = 1,text='Time (day)',line=3,cex=1.8)
axis(side = 4,at = c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=1.8)
mtext(side = 4,at=105.3,text='Water level (m)',line=6.5,col='black',cex=1.8)



par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T,xpd=TRUE)
plot(interp.time,spc.value[["S10"]],
     col='white',
     xlim=time.range,
     ylim=c(0,2),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


lines(interp.time[compare.time],tracer.ensemble[4,iobs,compare.time],col='black',lty=1,lwd=5)
lines(interp.time[compare.time],tracer.ensemble[3,iobs,compare.time],col='red',lty=3,lwd=5)



axis(side = 2,at=seq(0,1.2,0.4),col.axis='black',col='black',line=0.5,las=2,cex.axis=1.8)
mtext(side = 2,at=0.6,text='Tracer (mg/L)',col='black',line=5,cex=1.8)


legend(x=start.time+10*3600*24,y= 2.1,c("Richards mode","TH mode"),
       cex=2,
       lty=c(1,2),
       pch=c(NA,NA),
       col=c("black","red"),
       lwd=c(5,5),
       bty="n",horiz=TRUE)

dev.off()





load(paste(case.name,"/statistics/qlx.ensemble.r",sep=''))
load(paste(case.name,"/statistics/qlz.ensemble.r",sep=''))

jpeg(paste("figures/",case.name,"th_richards_qlx.jpg",sep=''),width=16.8,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,8,4,8),mgp=c(4,1.5,0))
plot(interp.time,level.value[["2-2"]],
     col='white',
     ylim=c(-4.5,3.5),
     xlim=time.range,
     type='l',
     lty=3,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


lines(interp.time[compare.time],qlx.ensemble[4,iobs,compare.time],col='black',lty=1,lwd=5)
lines(interp.time[compare.time],qlx.ensemble[3,iobs,compare.time],col='red',lty=3,lwd=5)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8,tck=-0.015)
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02,cex.axis=1.8)
mtext(side = 1,text='Time (day)',line=3,cex=1.8)
axis(side = 2,at=c(-1,0,1,2,3),col.axis='black',col='black',line=0.5,las=2,cex.axis=1.8)
mtext(side = 2,at=1,text='qlx (m/h)',col='black',line=4,cex=1.8)



par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T,xpd=TRUE)
plot(interp.time,spc.value[["S10"]],
     col='white',
     xlim=time.range,
     ylim=c(-1,7),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


lines(interp.time[compare.time],qlz.ensemble[4,iobs,compare.time],col='black',lty=1,lwd=5)
lines(interp.time[compare.time],qlz.ensemble[3,iobs,compare.time],col='red',lty=3,lwd=5)



axis(side = 4,at=c(-1,0,1,2,3),col.axis='black',col='black',line=0.5,las=2,cex.axis=1.8)
mtext(side = 4,at=1,text='qlz (m/h)',col='black',line=4,cex=1.8)

legend(x=start.time+10*3600*24,y= 8,c("Richards mode","TH mode"),
       cex=2,
       lty=c(1,2),
       pch=c(NA,NA),
       col=c("black","red"),
       lwd=c(5,5),
       bty="n",horiz=TRUE)

dev.off()

    
