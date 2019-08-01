rm(list=ls())
library(akima)
library(scales)

compare.time = seq(1,1081)

load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*1*24)
obs.value = spc.value[["S10"]][compare.time]

case.name = "2d"
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))



simu.ensemble = tracer.ensemble[,1:2,compare.time]
simu.ensemble = apply(simu.ensemble,c(1,3),mean)

simu.ensemble[2,]=1-simu.ensemble[2,]
simu.ensemble[2,] = rescale(simu.ensemble[2,],c(0.135,0.45))
simu.ensemble[3,]=1-simu.ensemble[3,]
simu.ensemble[3,] = rescale(simu.ensemble[3,],c(0.135,0.45))
simu.ensemble[4,]=1-simu.ensemble[4,]
simu.ensemble[4,] = rescale(simu.ensemble[4,],c(0.135,0.45))
simu.ensemble[5,]=1-simu.ensemble[5,]
simu.ensemble[5,] = rescale(simu.ensemble[5,],c(0.135,0.45))



simu.ensemble[1,] = rescale(simu.ensemble[1,],c(0.135,0.45))

time.ticks = seq(start.time,end.time,3600*1*24)
##end.time = start.time+3600*265
##start.time = start.time+3600*97
end.time = as.POSIXct("2016-02-02 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.range = range(start.time,end.time)

jpeg(paste("figures/87.level.s10.forward.jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
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
lines(interp.time,level.value[["SWS-1"]],col='grey',lty=1,lwd=2)
lines(interp.time,level.value[["NRG"]],col='grey',lty=2,lwd=2)


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


lines(interp.time[compare.time],simu.ensemble[1,],col='grey',lwd=2)


#lines(interp.time[compare.time],simu.ensemble[2,],col='red',lwd=2)
#lines(interp.time[compare.time],simu.ensemble[3,],col='orange',lwd=2)
#lines(interp.time[compare.time],simu.ensemble[4,],col='green',lwd=2)
lines(interp.time[compare.time],simu.ensemble[5,],col='blue',lwd=2)




points(interp.time,spc.value[["S10"]],col="black",pch=16)



##rect(interp.time[1+24*7],0,interp.time[24*17],0.6)
##rect(interp.time[24*17+1],0,interp.time[1081],0.6)
##rect(interp.time[1+24*7],0,interp.time[1081],0.6)


axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 2,col.axis='black',col='black',line=0,las=2)
mtext(side = 2,text='SpC (mS/cm)',col='black',line=2.5)




legend("top",c("2-3 WL","4-9 WL","SWS-1 WL","NRG WL",
               "S10 SpC",
               "Old boundary","20","40","60","80"),
       cex=0.8,
       lty=c(2,1,1,2,
             NA,
             1,1,1,1,1),
       pch=c(NA,NA,NA,NA,
             16,
             NA,NA,NA,NA,NA),
       col=c("black","black","grey","grey",
             "black",
             "grey","blue","green","orange","red"),
       lwd=c(2,2,2,2,
             2,
             2,2,2,2,2),
       bty="n",horiz=TRUE)

dev.off()
lt
