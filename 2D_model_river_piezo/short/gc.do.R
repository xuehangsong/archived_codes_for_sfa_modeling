rm(list=ls())
load("results/interp.data.r")

gc.value = list()
gc.value[["S10"]] = (spc.temp.value[["S10"]] - spc.temp.value[["NRG"]])/(spc.temp.value[["2-3"]] - spc.temp.value[["NRG"]])
gc.value[["S40"]] = (spc.temp.value[["S40"]] - spc.temp.value[["NRG"]])/(spc.temp.value[["2-3"]] - spc.temp.value[["NRG"]])

gc.value[["S10"]] = gc.value[["S10"]][110:371]
gc.value[["S40"]] = gc.value[["S40"]][110:371]
do.value[["S10"]] = do.value[["S10"]][110:371]
do.value[["S40"]] = do.value[["S40"]][110:371]



jpeg(paste("figures/","s10_gc.jpg",sep=''),width=5,height=6.5,units='in',res=200,quality=100)
#par(mfrow=c(2,2),mar=c(3.1,3.5,2,1),oma=c(1,1,1,1),mgp=c(1.8,0.8,0),pty='m')
{
    plot(c(0.13,0.13),c(0,20),
         type='l',
         col='white',
         lwd=2,
         xlim=c(-0.2,0.3),
         ylim=c(2,15),
         main="S10",
         xlab=NA,
         ylab=NA)
    mtext(expression("Groundwater contribution"),side=1,line=2.2,col="black",cex=1)
    mtext(expression("DO concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
    points(gc.value[["S10"]],do.value[["S10"]],cex=0.5,pch=16)
    
    
}    
dev.off()

jpeg(paste("figures/","s40_gc.jpg",sep=''),width=5,height=6.5,units='in',res=200,quality=100)
{
    plot(c(0.13,0.13),c(0,20),
         type='l',
         col='white',
         lwd=2,
         xlim=c(-0.2,0.3),
         ylim=c(2,15),
         main="S40",
         xlab=NA,
         ylab=NA)
    mtext(expression("Groundwater contribution"),side=1,line=2.2,col="black",cex=1)
    mtext(expression("DO concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
    points(gc.value[["S40"]],do.value[["S40"]],cex=0.5,pch=16)
    
    
}    
dev.off()



jpeg(paste("figures/","s40_gc.jpg",sep=''),width=5,height=6.5,units='in',res=200,quality=100)
{
    plot(c(0.13,0.13),c(0,20),
         type='l',
         col='white',
         lwd=2,
         xlim=c(-0.2,0.3),
         ylim=c(2,15),
         main="S40",
         xlab=NA,
         ylab=NA)
    mtext(expression("Groundwater contribution"),side=1,line=2.2,col="black",cex=1)
    mtext(expression("DO concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
    points(gc.value[["S40"]],do.value[["S40"]],cex=0.5,pch=16)
    
    
}    
dev.off()
