rm(list=ls())
load("results/interp.data.r")

i=0
#start.time = start.time+3600*24*7*(i-1)
#end.time = start.time+3600*24*7


time.ticks = seq(start.time,end.time,3600*1*24)
time.range = range(start.time,end.time)




jpeg(paste("figures/level.slice.",i,".jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
#jpeg(paste("figures/spc.slice.",i,".jpg",sep=''),width=10,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,5,4,5))
plot(interp.time,level.value[["2-2"]],
     col='red',
     ylim=c(104,107),
     xlim=time.range,
     type='l',
     lty=1,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )
lines(interp.time,level.value[["SWS-1"]],col='black',lty=2,lwd=2)
lines(interp.time,level.value[["NRG"]],col='blue',lty=2,lwd=2)

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,text='Time (day)',line=2)
axis(side = 2,col.axis='black',col='black',las=2,line=0)
mtext(side = 2,text='Water level (m)',line=3,col='black')

legend("top",c("2-2 WL","SWS-1 WL","NRG"),
       cex=0.8,
       lty=c(1,1,1),
       col=c("red","black","blue"),
       lwd=c(2,2,2),
       bty="n",horiz=TRUE)

dev.off()

    

#max.S40 = which(diff(sign(diff(spc.value[["S40"]])))==-2)+1


