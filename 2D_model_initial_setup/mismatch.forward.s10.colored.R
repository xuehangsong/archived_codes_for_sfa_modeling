rm(list=ls())
library(akima)
library(scales)


case.name = "diffusion"
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))
compare.time = seq(1,1081)

load("results/interp.data.r") 
for (itime in seq(1,length(interp.time)))
{
    obs.value = (spc.temp.value[["S10"]]-spc.temp.value[["SWS-1"]])/(spc.temp.value[["2-2"]]-spc.temp.value[["SWS-1"]])
}


time.range = range(start.time,end.time)
#time.range = range(start.time,start.time+31*24*3600)
#time.range = range(start.time+30*6*24*3600,start.time+7*30*24*3600)
#time.range = range(end.time-31*24*3600,end.time)

time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*5*24)
time.ticks.minor = seq(start.time,end.time,3600*1*24)


simu.ensemble = tracer.ensemble[,1:2,]
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
simu.ensemble = 1-simu.ensemble

jpeg(paste("figures/s10.1.forward.jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,5,4,5))
plot(interp.time,level.value[["2-3"]],
     col='black',
     ylim=c(102,106.5),
     xlim=time.range,
     type='l',
     lty=2,
     lwd=3,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(interp.time,level.value[["SWS-1"]],col='blue',lty=1,lwd=3)
lines(interp.time,level.value[["NRG"]],col='blue',lty=2,lwd=3)
lines(interp.time,level.value[["4-9"]],col='black',lty=1,lwd=3)
lines(interp.time,level.value[["2-3"]],col='black',lty=2,lwd=3)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,text='Time (day)',line=2)
axis(side = 4,col.axis='grey',col='grey',las=2,line=0)
mtext(side = 4,text='Water level (m)',line=3,col='grey')


par(mar=c(5,5,4,5),new=T)
plot(interp.time[compare.time],simu.ensemble[1,compare.time],
     col='white',
     xlim=time.range,
     ylim=c(0.,2.0),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


points(interp.time[compare.time],obs.value[compare.time],col='black',pch=16,cex=0.5)

for (i in seq(1,10))
{
lines(interp.time[compare.time],simu.ensemble[i,compare.time],col='green',lwd=3)
}
lines(interp.time[compare.time],simu.ensemble[7,compare.time],col='orangered',lwd=3)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.025)
axis(side = 2,col.axis='black',col='black',line=0,las=2)
mtext(side = 2,text='GC (%)',col='black',line=2.5)




legend("top",c("2-3 WL","4-9 WL","SWS-1 WL","NRG WL",
               "S10 SpC",
               "Simulation"),
#               "Best.(upper)",
#               "Simu.(bottom)",               
#               "Best(bottom)"),
       cex=1.2,
       lty=c(2,1,1,2,
             NA,
             1,1,1,1),
       pch=c(NA,NA,NA,NA,
             16,
             NA,NA,NA,NA),
       col=c("black","black","blue","blue",
             "black",
             "red","red","grey","blue"),
       lwd=c(2,2,2,
             2,
             2,2,2),
       bty="n",horiz=TRUE)

dev.off()

    
