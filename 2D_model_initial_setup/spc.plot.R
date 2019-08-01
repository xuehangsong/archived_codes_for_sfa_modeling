rm(list=ls())
load("results/trimed.data.r")

time.ticks = seq(start.time,end.time,3600*24)
time.range = c(start.time,end.time)


jpeg(paste("figures/spc.slice.jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
plot(level.time[["2-2"]],level.value[["2-2"]],
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
lines(level.time[["SWS-1"]],level.value[["SWS-1"]],col='grey',lty=2,lwd=2)

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,text='Time (day)',line=2)
axis(side = 2,col.axis='grey',col='grey',las=2,line=-2)
mtext(side = 2,text='Water level (m)',line=1,col='grey')


par(new=T)

plot(spc.time[["2-2"]],spc.value[["2-2"]],
     col='black',
     xlim=time.range,
     ylim=c(0.,0.7),
     type='l',
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(spc.time[["S10"]],spc.value[["S10"]],col='green',lwd=2)
lines(spc.time[["S40"]],spc.value[["S40"]],col='red',lwd=2)
lines(spc.time[["SWS-1"]],spc.value[["SWS-1"]],col='blue',lwd=2)
lines(spc.time[["NRG"]],spc.value[["NRG"]],col='blue',lwd=2,lty=2)


axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 4,col.axis='black',col='black',line=-3,las=2)
mtext(side = 4,text='SpC (mS/cm)',col='black',line=0)


legend("top",c("2-2 WL","SWS-1 WL",
               "S10 SpC","S40 SpC",
               "2-2 SpC","SWS-1 SpC","NRG SpC"),
       lty=c(1,1,
             1,1,
             1,1,2),
       col=c("grey","grey",
             "green","red",
             "black","blue","blue"),
       lwd=c(2,2,
             2,2,
             2,2,2),
       bty="n",horiz=TRUE)
dev.off()




