rm(list=ls())
library(akima)
library(scales)


##compare.time = seq(1+24*4,24*11)
compare.time = seq(25,24*11)
compare.time = seq(25,337)
compare.time = seq(1+24*2,24*10)


load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]+3600*24),3600*2*24)
#time.ticks = seq(min(interp.time[compare.time]),max(interp.time[citation]-3600*2*14),3600*2*24)
time.ticks.minor = seq(min(interp.time[compare.time]),max(interp.time[compare.time]+3600*24),3600*1*24)
##time.ticks.minor=time.ticks1A#

obs.value = do.value[["S10"]]##[compare.time]

case.name="rate.doc"
load(paste(case.name,"/statistics/do.ensemble.r",sep=''))
simu.ensemble = do.ensemble[,1:2,]*1000*32.0
simu.ensemble = apply(simu.ensemble,c(1,3),mean)

time.range = range(interp.time[compare.time])

level.inland = read.table(paste(case.name,"/1","/DatumH_Inland_Heat.txt",sep=''))[,4]
level.river = read.table(paste(case.name,"/1","/DatumH_River_Heat.txt",sep=''))[,4]




jpeg(paste("figures/",case.name,"s10.do.forward.jpg",sep=''),width=16.8,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,8,4,8),mgp=c(4,1.5,0))
plot(interp.time,level.value[["2-2"]],
     col='white',
     ylim=c(102,106),
     xlim=time.range,
     type='l',
     lty=2,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
    )

lines(interp.time[compare.time],level.value[["2-2"]][compare.time],col='black',lty=2,lwd=2)
lines(interp.time[compare.time],level.value[["4-9"]][compare.time],col='black',lty=3,lwd=2)
lines(interp.time[compare.time],level.inland[compare.time],col='black',lty=1,lwd=2)


lines(interp.time[compare.time],level.value[["NRG"]][compare.time],col='blue',lty=2,lwd=2)
lines(interp.time[compare.time],level.value[["SWS-1"]][compare.time],col='blue',lty=3,lwd=2)
lines(interp.time[compare.time],level.river[compare.time],col='blue',lty=1,lwd=2)


axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8,tck=-0.015)
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02,cex.axis=1.8)
mtext(side = 1,text='Time (day)',line=3,cex=1.8)
axis(side = 4,at = c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=1.8)
mtext(side = 4,at=105.3,text='Water level (m)',line=6.5,col='black',cex=1.8)



par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T,xpd=TRUE)
plot(interp.time,spc.value[["S10"]],
     col='white',
     xlim=time.range,
     ylim=c(0.,20),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )






for (ireaz in 1:100) {

    lines(interp.time[compare.time],simu.ensemble[ireaz,compare.time],col='green',lwd=3)

}
lines(interp.time[compare.time],simu.ensemble[20,compare.time],col='red',lwd=3)
lines(interp.time[compare.time],simu.ensemble[102,compare.time],col='orange',lwd=3)
lines(interp.time[compare.time],simu.ensemble[23,compare.time],col='purple',lwd=3)
points(interp.time[compare.time],obs.value[compare.time],col="black",pch=16)



axis(side = 2,at=seq(0,12,4),col.axis='black',col='black',line=0.5,las=2,cex.axis=1.8)
mtext(side = 2,at=6,text='DO (mg/L)',col='black',line=4,cex=1.8)


legend(x=start.time+1.7*3600*24,y= 23,c("Inland WL","River WL","S10 DO","Simulated DO","Best Realization"),
       cex=1.5,
       lty=c(1,1,NA,1,1),
       pch=c(NA,NA,16,NA,NA),       
       col=c("black","blue","black","green","red"),
       lwd=c(3,3,3,3,3),
       bty="n",horiz=TRUE)

legend(x=start.time+3*3600*24,y= 21.5,c("2-2 WL","4-9 WL","NRG WL","SWS-1 WL"),
       cex=1.5,
       lty=c(2,3,2,3),
       col=c("black","black","blue","blue"),
       lwd=c(3,3,3,3),
       bty="n",horiz=TRUE)

legend(x=start.time+3*3600*24,y= 20,c("150mg/d/L 2mg/L","25mg/d/L 4mg/L","25mg/d/L 3mg/L"),
       cex=1.5,
       lty=c(1,1,1),
       col=c("red","purple","orange"),
       lwd=c(3,3,3,3),
       bty="n",horiz=TRUE)

dev.off()

    
