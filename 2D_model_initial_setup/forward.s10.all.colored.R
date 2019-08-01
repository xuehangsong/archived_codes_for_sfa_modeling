rm(list=ls())
library(akima)
library(scales)


compare.time = seq(1+24*4,24*11)
compare.time = seq(1,360)

load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]+3600*0.5*24),3600*1*24)
time.ticks.minor = seq(start.time,end.time,3600*1*24)

obs.value = do.value[["S10"]]##[compare.time]

case.name="reaction.2"
load(paste(case.name,"/statistics/do.ensemble.r",sep=''))
simu.ensemble = do.ensemble[,1:2,]#*1000*32.0
simu.ensemble = apply(simu.ensemble,c(1,3),mean)

time.range = range(interp.time[compare.time])

jpeg(paste("figures/s10.all.forward.jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,5,4,5))
plot(interp.time,level.value[["2-2"]],
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
##lines(rep(interp.time[188],2),c(0,200))

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.025)
mtext(side = 1,text='Time (day)',line=2)
axis(side = 4,col.axis='grey',col='grey',las=2,line=0)
mtext(side = 4,text='Water level (m)',line=3,col='grey')


par(mar=c(5,5,4,5),new=T)
plot(interp.time,spc.value[["S10"]],
     col='white',
     xlim=time.range,
     ylim=c(0.,0.0008),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


##points(interp.time[compare.time],obs.value[compare.time],col="black",pch=16)
lines(interp.time[compare.time],simu.ensemble[5,compare.time],col='red',lwd=3)

load(paste(case.name,"/statistics/n2.ensemble.r",sep=''))
simu.ensemble = n2.ensemble[,1:2,]*10000#*1000*28.0134
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
lines(interp.time[compare.time],simu.ensemble[5,compare.time],col='pink',lwd=3,lty=2)


load(paste(case.name,"/statistics/hco3.ensemble.r",sep=''))
simu.ensemble = hco3.ensemble[,1:2,]/10#*1000*12.0107
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
lines(interp.time[compare.time],simu.ensemble[5,compare.time],col='green',lwd=3)


load(paste(case.name,"/statistics/ch2o.ensemble.r",sep=''))
simu.ensemble = ch2o.ensemble[,1:2,]#*1000*12.0107
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
lines(interp.time[compare.time],simu.ensemble[5,compare.time],col='orange',lwd=3)


load(paste(case.name,"/statistics/no3.ensemble.r",sep=''))
simu.ensemble = no3.ensemble[,1:2,]#*1000*62.005
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
lines(interp.time[compare.time],simu.ensemble[5,compare.time],col='grey',lwd=3,lty=2)






axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 2,col.axis='black',col='black',line=0,las=2)
mtext(side = 2,text='Concentration (mol/L)',col='black',line=3.5)




legend("top",c("2-2 WL","4-9 WL","SWS-1 WL","NRG WL",
               "S10 DO"),#,"Simulation"),
       cex=1.2,
       lty=c(2,1,1,2,
             NA,1),
       pch=c(NA,NA,NA,NA,
             16,NA),
       col=c("black","black","blue","blue",
             "black","orangered"),
       lwd=c(3,3,3,
             3,3),
       bty="n",horiz=TRUE)


legend(mean(interp.time[compare.time]-3600*24*2.7),5e-04,c("DO","CH2O","0.1*HCO3-","10000*N2","NO3-"),
       cex=1.2,
       lty=c(1,1,1,2,2),
       col=c("red","black","green","pink","grey"),
       lwd=c(3,3,3,
             3,3),
       bty="n",horiz=TRUE)


dev.off()

    
