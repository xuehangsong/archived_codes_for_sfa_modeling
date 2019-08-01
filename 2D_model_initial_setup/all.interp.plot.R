rm(list=ls())
load("results/interp.data.r")

i=0

time.range = range(start.time+24*3600,start.time+45*24*3600)
time.ticks.minor = seq(time.range[1],time.range[2],3600*1*24)
time.ticks = seq(time.range[1],time.range[2],3600*5*24)


jpeg(paste("figures/all.slice.",i,".jpg",sep=''),width=14,height=16,units='in',res=200,quality=100)
#jpeg(paste("figures/spc.slice.",i,".jpg",sep=''),width=10,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,8,4,8),mgp=c(4,1.5,0))
plot(interp.time,level.value[["2-2"]],
     col='black',
     ylim=c(99,106),
     xlim=time.range,
     type='l',
     lty=2,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )
lines(interp.time,level.value[["SWS-1"]],col='blue',lty=1,lwd=2)
lines(interp.time,level.value[["NRG"]],col='blue',lty=2,lwd=2)
#lines(interp.time,level.value[["2-3"]],col='orange',lty=1,lwd=2)
lines(interp.time,level.value[["4-9"]],col='black',lty=1,lwd=2)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8)
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.018,cex.axis=1.8)
mtext(side = 1,text='Time (day)',line=3,cex=1.8)
axis(side = 2,at=c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=1.7)
mtext(side = 2,at=105.3,text='Water level (m)',line=6,col='black',cex=1.8)


par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T)
plot(interp.time,spc.value[["2-2"]],
     col='black',
     xlim=time.range,
     ylim=c(-1.3,1.3),
     type='l',
     lwd=2,
     lty=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(interp.time[1:265],spc.value[["S10"]][1:265],col='darkgreen',lwd=2)
#lines(interp.time,spc.value[["S40"]],col='red',lwd=2)
lines(interp.time,spc.value[["SWS-1"]],col='blue',lwd=2)
lines(interp.time,spc.value[["NRG"]],col='blue',lty=2,lwd=2)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8)
axis(side = 4,at = c(0.1,0.3,0.5,0.7),col.axis='black',col='black',line=0,las=2,cex.axis=1.8)
mtext(side = 4,at=0.4,text='SpC (mS/cm)',col='black',line=5,cex=1.8)






par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T)
plot(interp.time,spc.temp.value[["2-2"]],
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

lines(interp.time,spc.temp.value[["S10"]],col='darkgreen',lwd=2)
#lines(interp.time,spc.temp.value[["S40"]],col='red',lwd=2)
lines(interp.time,spc.temp.value[["SWS-1"]],col='blue',lwd=2)
lines(interp.time,spc.temp.value[["NRG"]],col='blue',lty=2,lwd=2)
#lines(interp.time,spc.temp.value[["2-3"]],col='black',lty=2,lwd=2)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8)
axis(side = 2,at=c(0,6,12,18),col.axis='black',col='black',line=0,las=2,cex.axis=1.8)
mtext(side = 2,at = 10 ,text=bquote("Temperature ("^o*"C)"),col='black',line=4,cex=1.8)





par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T,xpd=TRUE)
plot(interp.time,do.value[["2-2"]],
     col='black',
     xlim=time.range,
     ylim=c(0,55),
     type='l',
     lwd=2,
     lty=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(interp.time[1:241],do.value[["S10"]][1:241],col='darkgreen',lwd=2)
#lines(interp.time,do.value[["S40"]],col='red',lwd=2)
lines(interp.time,do.value[["SWS-1"]],col='blue',lwd=2)
lines(interp.time[1:423],do.value[["NRG"]][1:423],col='blue',lty=2,lwd=2)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8)
axis(side = 4,at = c(0,4,8,12),col.axis='black',col='black',line=0,las=2,cex.axis=1.8)
mtext(side = 4,at=6,text='DO (mg/L)',col='black',line=4,cex=1.8)



legend(mean(interp.time-3600*24*22),59,c("2-2","4-9",
               "SWS-1","NRG",
               "S10"),#"S40"),
##               "S10"),               
       cex=1.8,
       lty=c(2,1,
             1,2,
             1,1),
       col=c("black","black",
             "blue","blue",
             "darkgreen","red"),
       lwd=c(3,3,3,
             3,3,
             3,3),
       bty="n",horiz=TRUE)

dev.off()



