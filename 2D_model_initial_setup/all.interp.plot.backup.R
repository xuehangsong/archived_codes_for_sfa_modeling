rm(list=ls())
load("results/interp.data.r")

i=0
## start.time = start.time+3600*24*7*(i-1)
## end.time = start.time+3600*24*7


time.ticks.minor = seq(start.time,end.time,3600*1*24)
time.ticks = seq(start.time,end.time,3600*4*24)
time.range = range(start.time,end.time)


jpeg(paste("figures/all.slice.",i,".jpg",sep=''),width=12,height=12,units='in',res=200,quality=100)
#jpeg(paste("figures/spc.slice.",i,".jpg",sep=''),width=10,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,5,4,5))
plot(interp.time,level.value[["2-2"]],
     col='black',
     ylim=c(100,106),
     xlim=time.range,
     type='l',
     lty=1,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )
lines(interp.time,level.value[["SWS-1"]],col='blue',lty=1,lwd=2)
lines(interp.time,level.value[["NRG"]],col='pink',lty=1,lwd=3)
lines(interp.time,level.value[["2-3"]],col='orange',lty=1,lwd=3)
lines(interp.time,level.value[["4-9"]],col='grey',lty=1,lwd=3)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02)
mtext(side = 1,text='Time (day)',line=2)
axis(side = 2,at=c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0)
mtext(side = 2,at=105.3,text='Water level (m)',line=3.5,col='black')




par(mar=c(5,5,4,5),new=T)
plot(interp.time,spc.temp.value[["2-2"]],
     col='black',
     xlim=time.range,
     ylim=c(0.,60),
     type='l',
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(interp.time,spc.temp.value[["S10"]],col='green',lwd=2)
##lines(interp.time,spc.temp.value[["T3"]],col='red',lwd=2)
lines(interp.time,spc.temp.value[["SWS-1"]],col='blue',lwd=2)
lines(interp.time,spc.temp.value[["NRG"]],col='pink',lty=1,lwd=3)
lines(interp.time,spc.temp.value[["2-3"]],col='orange',lty=1,lwd=3)

axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 2,at=c(0,5,10,15,20),col.axis='black',col='black',line=0,las=2)
mtext(side = 2,at = 10 ,text='Temp (DegC)',col='black',line=2.5)


par(mar=c(5,5,4,5),new=T)
plot(interp.time,spc.value[["2-2"]],
     col='black',
     xlim=time.range,
     ylim=c(-0.5,1.2),
     type='l',
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(interp.time,spc.value[["S10"]],col='green',lwd=2)
##lines(interp.time,spc.value[["T3"]],col='red',lwd=2)
lines(interp.time,spc.value[["SWS-1"]],col='blue',lwd=2)
lines(interp.time,spc.value[["NRG"]],col='pink',lty=1,lwd=3)
lines(interp.time,spc.value[["2-3"]],col='orange',lty=1,lwd=3)




## head.diff = level.value[["NRG"]]-level.value[["2-2"]]
## line.mark = which(head.diff>=0)
## line.mark = line.mark[which(head.diff[line.mark+1]<0)]
## for (i.line in line.mark)
## {
##     lines(rep(interp.time[i.line]+900,2),c(-0.8,1.2),lty=2, col="orange")
## }

## line.mark = which(head.diff<=0)
## line.mark = line.mark[which(head.diff[line.mark+1]>0)]
## for (i.line in line.mark)
## {
##     lines(rep(interp.time[i.line]+900,2),c(-0.8,1.2),lty=2,col="cyan")
## }






axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)))
axis(side = 4,at = c(0.1,0.2,0.3,0.4,0.5,0.6,0.8),col.axis='black',col='black',line=0,las=2)
mtext(side = 4,at=0.4,text='SpC (mS/cm)',col='black',line=2.5)


legend("top",c("2-2","2-3","4-9",
               "SWS-1","NRG",
               "S10"),
##               "S10"),               
       cex=1.0,
       lty=c(1,1,1,
             1,1,
             1,1),
       col=c("black","orange","grey",
             "blue","pink",
             "green","red"),
       lwd=c(3,3,3,
             3,3,
             3,3),
       bty="n",horiz=TRUE)

dev.off()



spc.value[["S40"]] = spc.value[["S40"]][97:265]
spc.value[["S10"]] = spc.value[["S10"]][97:265]
spc.value[["T3"]] = spc.value[["T3"]][97:265]
spc.temp.value[["S40"]] = spc.temp.value[["S40"]][97:265]
spc.temp.value[["S10"]] = spc.temp.value[["S10"]][97:265]
spc.temp.value[["T3"]] = spc.temp.value[["T3"]][97:265]




jpeg(paste("figures/s10_s40_temp.jpg",sep=''),width=6.4,height=7,units='in',res=200,quality=100)
par(mgp=c(1,0.7,0))
plot(spc.temp.value[["S10"]],spc.temp.value[["S40"]],
     asp=1,
     xlim=c(3,16),
     ylim=c(3,16),     
     axes= FALSE,
    xlab=NA,
    ylab=NA,     
     )
box()
axis(side = 1)
mtext(side = 1,text=expression(paste('S10 SpC (uS/cm)')),line=1.8)
axis(side = 2)
mtext(side = 2,text=expression(paste('S40 SpC (uS/cm)')),line=2)


lines(1:30,1:30,col="blue",lwd=3)


reg.fit = lm(spc.temp.value[["S40"]]~spc.temp.value[["S10"]])
abline(reg.fit,col="red",lwd=3)
reg.cf = round(reg.fit[[1]],2)
reg.eq =  paste("S40 = ",reg.cf[2],"* S10",ifelse(sign(reg.cf[1])==1,"+","-"),abs(reg.cf[1]))
mtext(reg.eq,1,line=-4,at=13)
mtext(bquote("R"^"2" == .(round(summary(reg.fit)$r.squared,2))),1,line=-2,at=11.5)


legend("topleft",c("Data","1:1 line","Regression line"),
       cex=1.0,
       pch=c(1,NA,NA),
       lty=c(NA,1,1),
       col=c("black","blue","red"),
       lwd=c(NA,3,3),
       bty="n")#,horiz=TRUE)


dev.off()


jpeg(paste("figures/s10_T3_temp.jpg",sep=''),width=6.4,height=7,units='in',res=200,quality=100)
par(mgp=c(1,0.7,0))
plot(spc.temp.value[["S10"]],spc.temp.value[["T3"]],
     asp=1,
     xlim=c(3,16),
     ylim=c(3,16),     
     axes= FALSE,
    xlab=NA,
    ylab=NA,     
     )
box()
axis(side = 1)
mtext(side = 1,text=expression(paste('S10 temperature ('^"o","C)")),line=1.8)
axis(side = 2)
mtext(side = 2,text=expression(paste('T3 temperature ('^"o","C)")),line=2,)

lines(1:30,1:30,col="blue",lwd=3)


reg.fit = lm(spc.temp.value[["T3"]]~spc.temp.value[["S10"]])
abline(reg.fit,col="red",lwd=3)
reg.cf = round(reg.fit[[1]],2)
reg.eq =  paste("T3 = ",reg.cf[2],"* S10",ifelse(sign(reg.cf[1])==1,"+","-"),abs(reg.cf[1]))
mtext(reg.eq,1,line=-4,at=12.85)
mtext(bquote("R"^"2" == .(round(summary(reg.fit)$r.squared,2))),1,line=-2,at=11.5)



legend("topleft",c("Data","1:1 line","Regression line"),
       cex=1.0,
       pch=c(1,NA,NA),
       lty=c(NA,1,1),
       col=c("black","blue","red"),
       lwd=c(NA,3,3),
       bty="n")#,horiz=TRUE)


dev.off()











jpeg(paste("figures/s10_s40_spc.jpg",sep=''),width=6.4,height=7,units='in',res=200,quality=100)
par(mgp=c(1,0.7,0))
plot(spc.value[["S10"]],spc.value[["S40"]],
     asp=1,
     xlim=c(0.05,0.7),
     ylim=c(0.05,0.7),     
     axes= FALSE,
    xlab=NA,
    ylab=NA,     
     )
box()
axis(side = 1)
mtext(side = 1,text=expression(paste('S10 temperature ('^"o","C)")),line=1.8)
axis(side = 2)
mtext(side = 2,text=expression(paste('S40 temperature ('^"o","C)")),line=2)


lines(0:30,0:30,col="blue",lwd=3)


reg.fit = lm(spc.value[["S40"]]~spc.value[["S10"]])
abline(reg.fit,col="red",lwd=3)
reg.cf = round(reg.fit[[1]],2)
reg.eq =  paste("S40 = ",reg.cf[2],"* S10",ifelse(sign(reg.cf[1])==1,"+","-"),abs(reg.cf[1]))
mtext(reg.eq,1,line=-4,at=0.5)
mtext(bquote("R"^"2" == .(round(summary(reg.fit)$r.squared,2))),1,line=-2,at=0.425)


legend("topleft",c("Data","1:1 line","Regression line"),
       cex=1.0,
       pch=c(1,NA,NA),
       lty=c(NA,1,1),
       col=c("black","blue","red"),
       lwd=c(NA,3,3),
       bty="n")#,horiz=TRUE)


dev.off()









jpeg(paste("figures/s10_t3_spc.jpg",sep=''),width=6.4,height=7,units='in',res=200,quality=100)
par(mgp=c(1,0.7,0))
plot(spc.value[["S10"]],spc.value[["T3"]],
     asp=1,
     xlim=c(0.05,0.7),
     ylim=c(0.05,0.7),     
     axes= FALSE,
    xlab=NA,
    ylab=NA,     
     )
box()
axis(side = 1)
mtext(side = 1,text=expression(paste('S10 SpC (uS/cm)')),line=1.8)
axis(side = 2)
mtext(side = 2,text=expression(paste('T3 SpC (uS/cm)')),line=2)


lines(0:30,0:30,col="blue",lwd=3)


reg.fit = lm(spc.value[["T3"]]~spc.value[["S10"]])
abline(reg.fit,col="red",lwd=3)
reg.cf = round(reg.fit[[1]],2)
reg.eq =  paste("T3 = ",reg.cf[2],"* S10",ifelse(sign(reg.cf[1])==1,"+","-"),abs(reg.cf[1]))
mtext(reg.eq,1,line=-4,at=0.5)
mtext(bquote("R"^"2" == .(round(summary(reg.fit)$r.squared,2))),1,line=-2,at=0.45)


legend("topleft",c("Data","1:1 line","Regression line"),
       cex=1.0,
       pch=c(1,NA,NA),
       lty=c(NA,1,1),
       col=c("black","blue","red"),
       lwd=c(NA,3,3),
       bty="n")#,horiz=TRUE)


dev.off()





jpeg(paste("figures/s10_spc_temp.regresion.jpg",sep=''),width=6.4,height=7,units='in',res=200,quality=100)
par(mgp=c(1,0.7,0))
plot(spc.value[["S10"]],spc.temp.value[["S10"]],
##     asp=1,
     xlim=c(0.05,0.7),
     ylim=c(3,16),     
     axes= FALSE,
    xlab=NA,
    ylab=NA,     
     )
box()
axis(side = 1)
mtext(side = 1,text=expression(paste('S10 SpC (uS/cm)')),line=1.8)
axis(side = 2)
mtext(side = 2,text=expression(paste('S10 temperature ('^"o","C)")),line=2,)

lines(0:30,0:30,col="blue",lwd=3)


reg.fit = lm(spc.temp.value[["S10"]]~spc.value[["S10"]])
abline(reg.fit,col="red",lwd=3)
reg.cf = round(reg.fit[[1]],2)
reg.eq =  paste("Temp = ",reg.cf[2],"* SpC",ifelse(sign(reg.cf[1])==1,"+","-"),abs(reg.cf[1]))
mtext(reg.eq,1,line=-4,at=0.54)
mtext(bquote("R"^"2" == .(round(summary(reg.fit)$r.squared,2))),1,line=-2,at=0.45)


legend("topleft",c("Data","Regression line"),
       cex=1.0,
       pch=c(1,NA),
       lty=c(NA,1),
       col=c("black","red"),
       lwd=c(NA,3),
       bty="n")#,horiz=TRUE)


dev.off()



jpeg(paste("figures/s40_spc_temp.regresion.jpg",sep=''),width=6.4,height=7,units='in',res=200,quality=100)
par(mgp=c(1,0.7,0))
plot(spc.value[["S40"]],spc.temp.value[["S40"]],
##     asp=1,
     xlim=c(0.05,0.7),
     ylim=c(3,16),     
     axes= FALSE,
    xlab=NA,
    ylab=NA,     
     )
box()
axis(side = 1)
mtext(side = 1,text=expression(paste('S40 SpC (uS/cm)')),line=1.8)
axis(side = 2)
mtext(side = 2,text=expression(paste('S40 temperature ('^"o","C)")),line=2,)

lines(0:30,0:30,col="blue",lwd=3)


reg.fit = lm(spc.temp.value[["S40"]]~spc.value[["S40"]])
abline(reg.fit,col="red",lwd=3)
reg.cf = round(reg.fit[[1]],2)
reg.eq =  paste("Temp = ",reg.cf[2],"* SpC",ifelse(sign(reg.cf[1])==1,"+","-"),abs(reg.cf[1]))
mtext(reg.eq,1,line=-4,at=0.235)
mtext(bquote("R"^"2" == .(round(summary(reg.fit)$r.squared,2))),1,line=-2,at=0.15)


legend("topleft",c("Data","Regression line"),
       cex=1.0,
       pch=c(1,NA),
       lty=c(NA,1),
       col=c("black","red"),
       lwd=c(NA,3),
       bty="n")#,horiz=TRUE)


dev.off()











jpeg(paste("figures/T3_spc_temp.regresion.jpg",sep=''),width=6.4,height=7,units='in',res=200,quality=100)
par(mgp=c(1,0.7,0))
plot(spc.value[["T3"]],spc.temp.value[["T3"]],
##     asp=1,
     xlim=c(0.05,0.7),
     ylim=c(3,16),     
     axes= FALSE,
    xlab=NA,
    ylab=NA,     
     )
box()
axis(side = 1)
mtext(side = 1,text=expression(paste('T3 SpC (uS/cm)')),line=1.8)
axis(side = 2)
mtext(side = 2,text=expression(paste('T3 temperature ('^"o","C)")),line=2,)

lines(0:30,0:30,col="blue",lwd=3)


reg.fit = lm(spc.temp.value[["T3"]]~spc.value[["T3"]])
abline(reg.fit,col="red",lwd=3)
reg.cf = round(reg.fit[[1]],2)
reg.eq =  paste("Temp = ",reg.cf[2],"* SpC",ifelse(sign(reg.cf[1])==1,"+","-"),abs(reg.cf[1]))
mtext(reg.eq,1,line=-4,at=0.54)
mtext(bquote("R"^"2" == .(round(summary(reg.fit)$r.squared,2))),1,line=-2,at=0.45)


legend("topleft",c("Data","Regression line"),
       cex=1.0,
       pch=c(1,NA),
       lty=c(NA,1),
       col=c("black","red"),
       lwd=c(NA,3),
       bty="n")#,horiz=TRUE)


dev.off()


