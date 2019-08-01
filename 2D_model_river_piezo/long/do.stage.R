rm(list=ls())
load("results/interp.data.r")

gc.value = list()


jpeg(paste("figures/","s10_stage.jpg",sep=''),width=5,height=6.5,units='in',res=200,quality=100)
plot(c(0.13,0.13),c(0,20),
     type='l',
     col='white',
     lwd=2,
     xlim=c(104.5,106),     
     ylim=c(2,15),
     main="S10",
     xlab=NA,
     ylab=NA)
mtext(expression("River stage(m)"),side=1,line=2.2,col="black",cex=1)
mtext(expression("DO concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
points(level.value[["SWS-1"]],do.value[["S10"]],cex=0.5,pch=16)
dev.off()



jpeg(paste("figures/","s40_stage.jpg",sep=''),width=5,height=6.5,units='in',res=200,quality=100)
plot(c(0.13,0.13),c(0,20),
     type='l',
     col='white',
     lwd=2,
     xlim=c(104.5,106),     
     ylim=c(4,15),
     main="S40",
     xlab=NA,
     ylab=NA)
mtext(expression("River stage(m)"),side=1,line=2.2,col="black",cex=1)
mtext(expression("DO concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
points(level.value[["SWS-1"]],do.value[["S40"]],cex=0.5,pch=16)
dev.off()



jpeg(paste("figures/","s10_s40_stage.jpg",sep=''),width=5,height=6.5,units='in',res=200,quality=100)
plot(c(0.13,0.13),c(0,20),
     type='l',
     col='white',
     lwd=2,
     xlim=c(104.5,106),     
     ylim=c(-10,10),
     main="S10-S40",
     xlab=NA,
     ylab=NA)
mtext(expression("River stage(m)"),side=1,line=2.2,col="black",cex=1)
mtext(expression("DO concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
points(level.value[["SWS-1"]],(do.value[["S10"]]-do.value[["S40"]]),cex=0.5,pch=16)
dev.off()




jpeg(paste("figures/","s10_s40.jpg",sep=''),width=5,height=5.5,units='in',res=200,quality=100)
plot(c(0.13,0.13),c(0,20),
     type='l',
     col='white',
     lwd=2,
     xlim=c(2,15),     
     ylim=c(2,15),
     main="S10 vs. S40",
     xlab=NA,
     ylab=NA,
     asp=1)
mtext(expression("S10 DO concentration (mg/L)"),side=1,line=2.2,col="black",cex=1)
mtext(expression("S40 DO concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
points(do.value[["S10"]],do.value[["S40"]],cex=0.5,pch=16)

lines(c(0,0),c(20,20),col="red")
dev.off()









jpeg(paste("figures/","s10_stage_diff.jpg",sep=''),width=5,height=6.5,units='in',res=200,quality=100)
plot(c(0.13,0.13),c(0,20),
     type='l',
     col='white',
     lwd=2,
     xlim=c(-0.6,0.6),     
     ylim=c(2,15),
     main="S10",
     xlab=NA,
     ylab=NA)
mtext(expression("SWS-1 - 2-3(m)"),side=1,line=2.2,col="black",cex=1)
mtext(expression("DO concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
points(level.value[["SWS-1"]]-level.value[["2-3"]],do.value[["S10"]],cex=0.5,pch=16)
dev.off()



jpeg(paste("figures/","s40_stage_diff.jpg",sep=''),width=5,height=6.5,units='in',res=200,quality=100)
plot(c(0.13,0.13),c(0,20),
     type='l',
     col='white',
     lwd=2,
     xlim=c(-0.6,0.6),     
     ylim=c(4,15),
     main="S40",
     xlab=NA,
     ylab=NA)
mtext(expression("SWS-1 - 2-3(m)"),side=1,line=2.2,col="black",cex=1)
mtext(expression("concentration (mg/L)"),side=2,line=2.2,col="black",cex=1)
points(level.value[["SWS-1"]]-level.value[["2-3"]],do.value[["S40"]],cex=0.5,pch=16)
dev.off()

