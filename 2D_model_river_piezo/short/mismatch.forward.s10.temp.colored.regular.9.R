rm(list=ls())
library(akima)
library(scales)

compare.time = seq(1,409)
##nreaz=100
#nreaz=9
nreaz=55

case.name = "regular.5"
#case.name = "new.block"
case.name = "th_richards_compare.6"
case.name = "new.block.long"

case.name = "regular.9"

load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*5*24)
time.ticks = seq(min(interp.time[compare.time]),max(interp.time),3600*5*24)
time.ticks.minor = seq(start.time,end.time,3600*1*24)

for (itime in seq(1,length(interp.time)))
{
    obs.value = (spc.temp.value[["S10"]]-spc.temp.value[["SWS-1"]])/(spc.temp.value[["2-3"]]-spc.temp.value[["SWS-1"]])
}



load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))
simu.ensemble = tracer.ensemble[,7:8,]
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
simu.ensemble = (1-simu.ensemble)
time.range = range(interp.time[compare.time])

level.inland = read.table(paste("regular.3","/1","/DatumH_Inland_Heat.txt",sep=''))[,4]
level.river = read.table(paste("regular.3","/1","/DatumH_River_Heat.txt",sep=''))[,4]
#level.inland = read.table(paste("regular.3","/1","/DatumH_Inland_Heat.txt",sep=''))[,4]
#level.river = read.table(paste("regular.3","/1","/DatumH_River_Heat.txt",sep=''))[,4]


jpeg(paste("figures/s10.1.temp.forward.jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,8,4,8),mgp=c(4,1.5,0))
plot(interp.time,level.value[["2-2"]],
     col='white',
     ylim=c(102,106.3),
     xlim=time.range,
     type='l',
     lty=2,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )



## lines(interp.time[compare.time],level.value[["2-2"]][compare.time],col='black',lty=2,lwd=2)
## lines(interp.time[compare.time],level.value[["4-9"]][compare.time],col='black',lty=3,lwd=2)
lines(interp.time[compare.time],level.inland[compare.time],col='black',lty=1,lwd=2)


## lines(interp.time[compare.time],level.value[["NRG"]][compare.time],col='blue',lty=2,lwd=2)
## lines(interp.time[compare.time],level.value[["SWS-1"]][compare.time],col='blue',lty=3,lwd=2)
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
     ylim=c(0.,1.8),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


##for (i in c(2,3,4)){

## simulations = c(seq(1:7),seq(9,17),seq(19,27),seq(29,37),seq(39,47),
##                 seq(49,57),seq(59,67),seq(69,77),seq(79,86),seq(89,96),c(99,100))
#simulations = seq(1,100)
simulations = seq(1,55)    
## for (i in simulations){

##     lines(interp.time[compare.time],simu.ensemble[i,compare.time],col='green',lwd=5)
## }


##for (i in which(simu.ensemble[,150]<0.7 & simu.ensemble[,150]>0.25) ) {
##for (i in which(simu.ensemble[,150]<0.3 & simu.ensemble[,150]>0.2) ) {
for (i in c(51) ) {        
    lines(interp.time[compare.time],simu.ensemble[i,compare.time],col='red',lwd=5)

}
#lines(interp.time[compare.time],simu.ensemble[96,compare.time],col='red',lwd=5)

#lines(interp.time[compare.time],simu.ensemble[4,compare.time],col='red',lwd=5)
## for (i in 4:6){

## lines(interp.time[compare.time],simu.ensemble[i,compare.time],col='red',lwd=5)
## }


#lines(interp.time[compare.time],simu.ensemble[96,compare.time],col='orangered',lwd=5)



points(interp.time[compare.time],obs.value[compare.time],col="black",pch=16,cex=0.5)

axis(side = 2,at=seq(0,1,0.25),col.axis='black',col='black',line=0.5,las=2,cex.axis=1.8)
mtext(side = 2,at=0.5,text='Groundwater contribution (%)',col='black',line=6,cex=1.8)


legend(x=start.time,y= 1.9,c("Inland WL","River WL","S10 GC","Simulated GC"),
       cex=1.65,
       lty=c(1,1,NA,1),
       pch=c(NA,NA,16,NA),       
       col=c("black","blue","black","orangered"),
       lwd=c(3,3,3,3),
       bty="n",horiz=TRUE)

dev.off()
## legend(x=start.time,y=1.8,c("2-2 WL","4-9 WL","NRG WL","SWS-1 WL"),
##        cex=1.65,
##        lty=c(2,3,2,3),
##        col=c("black","black","blue","blue"),
##        lwd=c(3,3,3,3),
##        bty="n",horiz=TRUE)
## dev.off()




## legend("top",c("2-2 WL","4-9 WL","SWS-1 WL","NRG WL",
##                "S10 GC"),
##        cex=1.65,
##        lty=c(2,1,1,2,
##              NA,1),
##        pch=c(NA,NA,NA,NA,
##              16,NA),
##        col=c("black","black","blue","blue",
##              "black","orangered"),
##        lwd=c(3,3,3,
##              3,3),
##        bty="n",horiz=TRUE)
