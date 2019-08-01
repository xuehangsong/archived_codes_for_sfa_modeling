rm(list=ls())
load("results/interp.data.r")

i=0
#start.time = start.time+3600*24*7*(i-1)
#end.time = start.time+3600*24*7


time.ticks = seq(start.time,end.time,3600*1*24)
time.range = range(start.time,end.time)




jpeg(paste("figures/spc.slice.",i,".jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
#jpeg(paste("figures/spc.slice.",i,".jpg",sep=''),width=10,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,5,4,5))
plot(interp.time,level.value[["2-2"]],
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
lines(interp.time,level.value[["SWS-1"]],col='grey',lty=2,lwd=2)
lines(interp.time,level.value[["NRG"]],col='blue',lty=2,lwd=2)

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,text='Time (day)',line=2)
axis(side = 4,col.axis='grey',col='grey',las=2,line=0)
mtext(side = 4,text='Water level (m)',line=3,col='grey')


par(mar=c(5,5,4,5),new=T)
plot(interp.time,spc.value[["2-2"]],
     col='black',
     xlim=time.range,
     ylim=c(0.,0.8),
     type='l',
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(interp.time,spc.value[["S10"]],col='green',lwd=2)
lines(interp.time,spc.value[["S40"]],col='red',lwd=2)
lines(interp.time,spc.value[["SWS-1"]],col='blue',lwd=2)
lines(interp.time,spc.value[["NRG"]],col='blue',lwd=2,lty=2)

## line.mark = which(diff(sign(diff(spc.value[["S40"]])))==2)+1
## for (i.line in line.mark)
## {
##     lines(rep(interp.time[i.line],2),c(0,0.7),col="orange")
## }

## line.mark = which(diff(sign(diff(spc.value[["S40"]])))==-2)+1
## for (i.line in line.mark)
## {
##     lines(rep(interp.time[i.line],2),c(0,0.7),col="cyan")
## }






head.diff = level.value[["SWS-1"]]-level.value[["2-2"]]
line.mark = which(head.diff>0)
line.mark = line.mark[which(head.diff[line.mark+1]<0)]
for (i.line in line.mark)
{
    lines(rep(interp.time[i.line]+900,2),c(0,0.7),col="orange")
}

line.mark = which(head.diff<0)
line.mark = line.mark[which(head.diff[line.mark+1]>0)]
for (i.line in line.mark)
{
    lines(rep(interp.time[i.line]+900,2),c(0,0.7),col="cyan")
}




axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 2,col.axis='black',col='black',line=0,las=2)
mtext(side = 2,text='SpC (mS/cm)',col='black',line=2.5)


legend("top",c("2-2 WL","SWS-1 WL",
               "S10 SpC","S40 SpC",
               "2-2 SpC","SWS-1 SpC","NRG SpC"),
       cex=0.8,
       lty=c(1,2,
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

    

#max.S40 = which(diff(sign(diff(spc.value[["S40"]])))==-2)+1


