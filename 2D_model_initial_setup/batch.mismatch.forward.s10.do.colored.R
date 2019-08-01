rm(list=ls())
library(akima)
library(scales)

compare.time = seq(25,227)
#compare.time = seq(25,337)

load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*1*24)
time.ticks.minor = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*1*24)
obs.value = do.value[["S10"]]


case.name="rate.doc"
load(paste(case.name,"/statistics/state.vector.r",sep=''))
load(paste(case.name,"/statistics/do.ensemble.r",sep=''))
simu.ensemble = do.ensemble[,1:2,]*1000*32.0
simu.ensemble = apply(simu.ensemble,c(1,3),mean)





level.inland = read.table(paste(case.name,"/1","/DatumH_Inland_Heat.txt",sep=''))[,4]
level.river = read.table(paste(case.name,"/1","/DatumH_River_Heat.txt",sep=''))[,4]




time.range = range(interp.time[compare.time])
for (ibatch in 0:9)
{    
    jpeg(paste("figures/",case.name,".",ibatch,".do.forward.jpg",sep=''),width=20,height=20,units='in',res=200,quality=100)
    par(mar=c(2,12,2,0),mgp=c(12,2,0),oma=c(5,0,10,0),mfrow=c(6,2))
    plot(interp.time[compare.time],level.value[["2-2"]][compare.time],
         col='white',
         ylim=c(104.5,106.3),
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



    
    axis(side = 2,at = c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=3.0)
    mtext(side = 2,at=105.3,text='WL (m)',line=9,col='black',cex=2.0)
    mtext(side = 1,text='Time (day)',line=5.3,cex=2.0)
    axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex=2,cex.axis=2.0,tck=-0.015)
    axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),cex=3,tck=-0.02,cex.axis=3.0)



    plot(interp.time[compare.time],level.value[["2-2"]][compare.time],
         col='white',
         ylim=c(104.5,106.3),
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



    
    axis(side = 2,at = c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=3.0)
    mtext(side = 2,at=105.3,text='WL (m)',line=9,col='black',cex=2.0)
    mtext(side = 1,text='Time (day)',line=5.3,cex=2.0)
    axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex=2,cex.axis=2.0,tck=-0.015)
    axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),cex=3,tck=-0.02,cex.axis=3.0)


    
    
    
    for (i in 1:10+ibatch*10)
    {
###    par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T)
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
        
        lines(interp.time[compare.time],simu.ensemble[i,compare.time],col='darkdarkgreen',lwd=5)
        lines(interp.time[compare.time],simu.ensemble[20,compare.time],col='orangered',lwd=5)        
        points(interp.time[compare.time],obs.value[compare.time],col="black",pch=16,cex=1)

        axis(side = 2,at=seq(0,12,4),col.axis='black',col='black',line=0.5,las=2,cex.axis=3.0)


        axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=2.0,tck=-0.015)
        axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02,cex.axis=3)

        mtext(side = 2,at=6,text='GC(%)',col='black',line=5.5,cex=2.0)
        mtext(side = 1,text='Time (day)',line=5.3,cex=2.0)
        mtext(side = 3,line =-7,paste("Rate =",format(state.vector[i,1]*16*1000*3600*24,digits=2),
                                      "mg/L/d, DOC =",format(state.vector[i,2]*12*1000,digits=2),"mg/L"),cex=2)

        
    }



    par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE,xpd=TRUE)
    plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")

legend(x=-0.6,y=1.0,c("2-2 WL","4-9 WL","NRG WL","SWS-1 WL"),
       cex=3,
       xpd=TRUE,
       lty=c(2,3,2,3),
       col=c("black","black","blue","blue"),
       lwd=c(3,3,3,3),
       bty="n",horiz=TRUE)
    
legend(x=-0.9,0.94,c("Inland WL","River WL","S10 DO","Simulated DO","Best DO match"),
       cex=3,
       xpd=TRUE,
       lty=c(1,1,NA,1,1),
       pch=c(NA,NA,16,NA,NA),
       col=c("black","blue","black","darkdarkgreen","orangered"),
       lwd=c(3,3,3,3,3),
       bty="n",horiz=TRUE)

    

    dev.off()
}
