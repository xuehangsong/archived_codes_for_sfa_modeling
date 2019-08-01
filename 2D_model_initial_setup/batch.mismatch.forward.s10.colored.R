rm(list=ls())
library(akima)
library(scales)

compare.time = seq(25,960)

load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*5*24)
time.ticks.minor = seq(start.time,end.time,3600*1*24)
for (itime in seq(1,length(interp.time)))
{
    obs.value = (spc.temp.value[["S10"]]-spc.temp.value[["SWS-1"]])/(spc.temp.value[["2-2"]]-spc.temp.value[["SWS-1"]])
}


case.name = "regular.2"
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))
simu.ensemble = tracer.ensemble[,1:2,]
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
simu.ensemble = (simu.ensemble-0.09)/(0.52-0.09)
###simu.ensemble = (1-simu.ensemble)

time.range = range(interp.time[compare.time])
load(paste(case.name,"/statistics/state.vector.r",sep=''))

for (ibatch in 0:9)
{    
    jpeg(paste("figures/",case.name,".",ibatch,".temp.forward.jpg",sep=''),width=20,height=20,units='in',res=200,quality=100)
    par(mar=c(0,10,0,0),mgp=c(4,1.5,0),oma=c(5,0,0,0),mfrow=c(6,2))
    plot(interp.time[compare.time],level.value[["2-2"]][compare.time],
         col='black',
         ylim=c(104.5,106.3),
         xlim=time.range,
         type='l',
         lty=2,
         lwd=2,
         axes= FALSE,
         xlab=NA,
         ylab=NA,     
         )
    lines(interp.time[compare.time],level.value[["4-9"]][compare.time],col='black',lty=1,lwd=2)
    lines(interp.time[compare.time],level.value[["SWS-1"]][compare.time],col='blue',lty=1,lwd=2)
    lines(interp.time[compare.time],level.value[["NRG"]][compare.time],col='blue',lty=2,lwd=2)
    
    axis(side = 2,at = c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=1.8)
    mtext(side = 2,at=105.3,text='Water level (m)',line=6.5,col='black',cex=1.3)
    mtext(side = 1,text='Time (day)',line=4,cex=1.3)
    axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8,tck=-0.015)
    axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02,cex.axis=1.8)


    plot(interp.time[compare.time],level.value[["2-2"]][compare.time],
         col='black',
         ylim=c(104.5,106.3),
         xlim=time.range,
         type='l',
         lty=2,
         lwd=2,
         axes= FALSE,
         xlab=NA,
         ylab=NA,     
         )
    lines(interp.time[compare.time],level.value[["4-9"]][compare.time],col='black',lty=1,lwd=2)
    lines(interp.time[compare.time],level.value[["SWS-1"]][compare.time],col='blue',lty=1,lwd=2)
    lines(interp.time[compare.time],level.value[["NRG"]][compare.time],col='blue',lty=2,lwd=2)
    
    axis(side = 2,at = c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=1.8)
    mtext(side = 2,at=105.3,text='Water level (m)',line=6.5,col='black',cex=1.3)
    mtext(side = 1,text='Time (day)',line=4,cex=1.3)
    axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8,tck=-0.015)
    axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02,cex.axis=1.8)



    
    ## legend("top",c("2-2 WL","4-9 WL","SWS-1 WL","NRG WL",
    ##                 "S10 GC"),
    ##         cex=1,
    ##         lty=c(2,1,1,2,
    ##               NA,1),
    ##         pch=c(NA,NA,NA,NA,
    ##               16,NA),
    ##        col=c("black","black","blue","blue",
    ##               "black","orangered"),
    ##         lwd=c(3,3,3,
    ##               3,3),
    ##         bty="n",horiz=TRUE)

    
    
    for (i in 1:10+ibatch*10)
    {
###    par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T)
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
        
        lines(interp.time[compare.time],simu.ensemble[i,compare.time],col='green',lwd=5)
        lines(interp.time[compare.time],simu.ensemble[96,compare.time],col='orangered',lwd=5)        
        points(interp.time[compare.time],obs.value[compare.time],col="black",pch=16,cex=1)

        axis(side = 2,at=seq(0,1,0.25),col.axis='black',col='black',line=0.5,las=2,cex.axis=1.8)


        axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8,tck=-0.015)
        axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02,cex.axis=1.8)

        mtext(side = 2,at=0.5,text='Groundwater contribution (%)',col='black',line=6,cex=1.3)
        mtext(side = 1,text='Time (day)',line=4,cex=1.3)
        mtext(side = 3,line =-9,paste("H =",format(10**state.vector[i,1],digits=2),",A =",format(10**state.vector[i,3],digits=2)),cex=3)

        
    }












    dev.off()
}
