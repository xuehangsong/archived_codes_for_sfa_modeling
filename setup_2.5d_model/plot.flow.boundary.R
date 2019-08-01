rm(list=ls())
load("results/interp.data.r")


compare.time = seq(1,1345)
##compare.time = seq(1,1063)
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]),3600*5*24)
time.ticks.minor = seq(start.time,end.time,3600*1*24)

for (itime in seq(length(interp.time)))
###for (itime in seq(1,2))
{
##    jpeg(paste("figures/","flow.boundary",itime,".jpg",sep=''),width=27,height=5,units='in',res=200,quality=100)
    jpeg(paste("figures/","flow.boundary2.",itime,".jpg",sep=''),width=18,height=5,units='in',res=200,quality=100)    
    par(mar=c(4,6,4,4))
    plot(interp.time,level.value[["2-2"]],
         type = "l",
         col = 'black',
         lwd=2,
         ylim = c(104.5,106),
         axes= FALSE,
         xlab=NA,
         ylab=NA,     
         )

    box()
    lines(interp.time,level.value[["SWS-1"]],col="blue",lwd=2)
    lines(rep(interp.time[itime],2),c(104.6,105.8),col="red",lwd=2)
    
    axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
    axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02)
    mtext(side = 1,text='Time (day)',line=2)
    mtext(side = 3,format(interp.time[itime],format="%Y-%m-%d   %H:%M",tz="GMT"),line=1,cex=2)
    axis(side = 2,col.axis='black',col='black',las=2,line=0)
    mtext(side = 2,text='Water level (m)',line=3.5,col='black')

    
    legend("topright",c("SWS-1","Well 2-2"),
           lty=c(1,1),
           col=c("blue","black"),
           bty='n',
           horiz=TRUE,
           )
    
    
    dev.off()

    
}

