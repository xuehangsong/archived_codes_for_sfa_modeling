rm(list=ls())
library(akima)
library(scales)


case.name = "regular.2"
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))
load(paste(case.name,"/statistics/state.vector.r",sep=''))
load("results/s10.conversion.12_22_to_12_24.r")

compare.time = seq(1,960)

load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*1*24)
time.ticks.minor = seq(start.time,end.time,3600*1*24)
obs.value = spc.value[["S10"]][compare.time]





simu.ensemble = tracer.ensemble[,1:2,compare.time]
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
simu.ensemble = rescale(simu.ensemble,c(0.135,0.45))

time.ticks = seq(start.time,end.time,3600*1*24)
time.range = range(start.time,end.time)
time.range = range(interp.time[c(1+24*4,24*11)])



jpeg(paste("figures/s10.1.forward.jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,5,4,5))
plot(interp.time,level.value[["2-3"]],
     col='black',
     ylim=c(102,106),
     xlim=time.range,
     type='l',
     lty=2,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )
lines(interp.time,level.value[["4-9"]],col='black',lty=1,lwd=2)
lines(interp.time,level.value[["SWS-1"]],col='blue',lty=1,lwd=2)
lines(interp.time,level.value[["NRG"]],col='blue',lty=2,lwd=2)
lines(rep(interp.time[188],2),c(0,200))

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,text='Time (day)',line=2)
axis(side = 4,col.axis='grey',col='grey',las=2,line=0)
mtext(side = 4,text='Water level (m)',line=3,col='grey')


par(mar=c(5,5,4,5),new=T)
plot(interp.time,spc.value[["S10"]],
     col='black',
     xlim=time.range,
     ylim=c(0.,0.9),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )



for (ireaz in which(state.vector[,3]>-11 ) ){
    lines(interp.time[compare.time],simu.ensemble[ireaz,],col='green',lwd=2)
}
    lines(interp.time[compare.time],simu.ensemble[100,],col='orange',lwd=5)


## for  (ireaz in which(state.vector[,3]< -11)) {
##     lines(interp.time[compare.time],simu.ensemble[ireaz,],col='grey',lwd=2)
## }

## lines(interp.time[compare.time],simu.ensemble[87,],col='orangered',lwd=5)
## lines(interp.time[compare.time],simu.ensemble[10,],col='darkred',lwd=5)

## lines(interp.time[compare.time],simu.ensemble[50,],col='orangered',lwd=5)
## lines(interp.time[compare.time],simu.ensemble[19,],col='darkred',lwd=5)

lines(interp.time[compare.time],simu.ensemble[87,],col='orangered',lwd=5)
lines(interp.time[compare.time],simu.ensemble[13,],col='darkred',lwd=5)



## lines(interp.time[compare.time],simu.ensemble[10,],col='orangered',lwd=3)
## lines(interp.time[compare.time],simu.ensemble[13,],col='darkred',lwd=3)

points(interp.time,spc.value[["S10"]],col="black",pch=16)

## rect(interp.time[97],0,interp.time[172],0.6,lty=2)
## rect(interp.time[178],0,interp.time[189],0.6,lty=2)
## rect(interp.time[202],0,interp.time[240],0.6,lty=2)



## rect(interp.time[173],0,interp.time[177],0.6,lty=2)
## rect(interp.time[190],0,interp.time[201],0.6,lty=2)
## rect(interp.time[241],0,interp.time[265],0.6,lty=2)
rect(interp.time[97],0,interp.time[265],0.6,lty=2)


axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 2,col.axis='black',col='black',line=0,las=2)
mtext(side = 2,text='SpC (mS/cm)',col='black',line=2.5)




legend("top",c("2-3 WL","4-9 WL","SWS-1 WL","NRG WL",
               "S10 SpC",
               "Simu.(upper)",
               "Best.(upper)",
               "Simu.(bottom)",               
               "Best(bottom)"),
       cex=0.8,
       lty=c(2,1,1,2,
             NA,
             1,1,1,1),
       pch=c(NA,NA,NA,NA,
             16,
             NA,NA,NA,NA),
       col=c("black","black","blue","blue",
             "black",
             "green","red","grey","blue"),
       lwd=c(2,2,2,
             2,
             2,2,2),
       bty="n",horiz=TRUE)

dev.off()

    
