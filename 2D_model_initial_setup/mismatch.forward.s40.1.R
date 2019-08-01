rm(list=ls())
library(akima)

compare.time = seq(1,960)

load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*1*24)
obs.value = spc.value[["S40"]][compare.time]

case.name = "regular.2"
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))

simu.ensemble = tracer.ensemble[,4,compare.time]

time.ticks = seq(start.time,end.time,3600*1*24)
time.range = range(start.time,end.time)


jpeg(paste("figures/s40.1.forward.jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,5,4,5))
plot(interp.time,level.value[["2-2"]],
     col='grey',
     ylim=c(102,106),
     xlim=time.range,
     type='l',
     lty=1,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )
lines(interp.time,level.value[["SWS-1"]],col='grey',lty=2,lwd=2)

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,text='Time (day)',line=2)
axis(side = 4,col.axis='grey',col='grey',las=2,line=0)
mtext(side = 4,text='Water level (m)',line=3,col='grey')


par(mar=c(5,5,4,5),new=T)
plot(interp.time,spc.value[["S40"]],
     col='black',
     xlim=time.range,
     ylim=c(0.,0.9),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

for (ireaz in 1:dim(simu.ensemble)[1]) {
    lines(interp.time[compare.time],simu.ensemble[ireaz,],col='green')
}
lines(interp.time[compare.time],simu.ensemble[12,],col='red')

points(interp.time,spc.value[["S40"]],col="black",pch=16)



rect(interp.time[1+24*7],0,interp.time[24*17],0.6)
#rect(interp.time[24*17+1],0,interp.time[1081],0.6)
#rect(interp.time[1+24*7],0,interp.time[1081],0.6)


axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 2,col.axis='black',col='black',line=0,las=2)
mtext(side = 2,text='SpC (mS/cm)',col='black',line=2.5)




legend("top",c("Inland WL","River WL",
               "S40 SpC",
               "Realizations",
               "Best match"),
       cex=0.8,
       lty=c(1,2,
             NA,
             1,1),
       pch=c(NA,NA,
             16,
             NA,NA),
       col=c("grey","grey",
             "black",
             "green","red"),
       lwd=c(2,2,
             2,
             2,2),
       bty="n",horiz=TRUE)

dev.off()

    







stop()











jpeg(paste("figures/","contour.jpg",sep=''),width=8,height=4,units='in',res=200,quality=100)
par(mgp=c(1.8,0.6,0),mar=c(4.1,4.1,2.1,2.1))
plot(interp.time[compare.time],obs.value,
     col='blue',
     pch=16,
     cex=0.3,
     ylim=c(0,0.8),
     xlab=NA,
     axes=FALSE,
     ylab=NA     
     )

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,text='Time (day)',line=2)



for (ireaz in 1:dim(simu.ensemble)[1])
{
    lines(interp.time[compare.time],simu.ensemble[ireaz,],col="green")
}

####lines(interp.time[compare.time],simu.ensemble[which.min(data.mismatch),],col="red")
points(interp.time[compare.time],obs.value,col="black",cex=0.3,pch=16)

##legend(x='topright',c('T4',"Mean","Realizations"),
legend(x='topright',c('T4',"Realizations"),
       lty=c(NA,1,1),
       pch=c(16,NA,NA),
##       col=c("black","Red","Green"),
       col=c("black","Green"),
       bty='n',
       horiz=TRUE
       )
dev.off()

jpeg(filename=paste("figures/1.hist.jpg"),units='in',width=4,height=4,res=200,quality=100)
par(mgp=c(1.8,0.8,0))
h = hist(simu.ensemble,breaks=20,plot=FALSE)
h$counts = h$counts/sum(h$counts)
plot(h,
     ylab = "Probability",
     xlab = "Simulated SpC(mS/cm)",
     main = NA,
     xlim = c(0,1.0),
     )
title("Histogram of S40 Simulation",line = 0)
dev.off()


jpeg(filename=paste("figures/22.hist.jpg"),units='in',width=4,height=4,res=200,quality=100)
par(mgp=c(1.8,0.8,0))
h = hist(obs.value,breaks=20,plot=FALSE)
h$counts = h$counts/sum(h$counts)
plot(h,
     ylab = "Probability",
     xlab = "Simulated SpC(mS/cm)",
     main = NA,
     xlim = c(0,1.0),     
     )
title("Histogram of S40",line = 0)
dev.off()

stop()
jpeg(filename=paste("figures/33.hist.jpg"),units='in',width=4.5,height=5,res=200,quality=100)
par(mgp=c(1.8,0.8,0))
plot(simu.ensemble,obs.value,
     xlab = "SpC simulation",
     ylab = "SpC observation",
     main = NA,
     xlim = c(0,0.6),
     ylim = c(0,0.6)     ,
     pch=1,
     cex=0.5,
     asp=1.0
     )
dev.off()
