rm(list=ls())
load("results/thermistor.interp.data.r")


i=8
start.time = as.POSIXct("2016-03-02 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-03-09 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

time.ticks = seq(start.time,end.time,3600*1*24)
time.range = range(start.time,end.time)

jpeg(paste("figures/thermistor.temp.slice.",i,".jpg",sep=''),width=14,height=8.4,units='in',res=200,quality=100)
#jpeg(paste("figures/spc.temp.slice.",i,".jpg",sep=''),width=10,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,5,4,5))
plot(interp.time,level.value[["2-3"]],
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

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,text='Time (day)',line=2)
axis(side = 4,col.axis='grey',col='grey',las=2,line=0)
mtext(side = 4,text='Water level (m)',line=3,col='grey')


par(mar=c(5,5,4,5),new=T)
plot(interp.time,temp.value[["2-3"]],
     col='black',
     xlim=time.range,
     ylim=c(4.,10),
##     ylim=c(0.,25),     
     type='l',
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(interp.time,temp.value[["-64cm"]],col='red',lwd=2,lty=2)
lines(interp.time,temp.value[["-24cm"]],col='pink',lwd=2,lty=2)
lines(interp.time,temp.value[["-4cm"]],col='yellow',lwd=2,lty=2)
lines(interp.time,temp.value[["+16cm"]],col='darkgreen',lwd=2,lty=1)
lines(interp.time,temp.value[["+26cm"]],col='green',lwd=2,lty=1)
lines(interp.time,temp.value[["+46cm"]],col='skyblue',lwd=2,lty=1)
lines(interp.time,temp.value[["SWS-1"]],col='blue',lwd=2,lty=1)

## line.mark = which(diff(sign(diff(spc.temp.value[["S40"]])))==2)+1
## for (i.line in line.mark)
## {
##     lines(rep(interp.time[i.line],2),c(0,0.7),col="orange")
## }

## line.mark = which(diff(sign(diff(spc.temp.value[["S40"]])))==-2)+1
## for (i.line in line.mark)
## {
##     lines(rep(interp.time[i.line],2),c(0,0.7),col="cyan")
## }

head.diff = level.value[["SWS-1"]]-level.value[["2-3"]]
line.mark = which(head.diff>0)
line.mark = line.mark[which(head.diff[line.mark+1]<0)]
for (i.line in line.mark)
{
##    lines(rep(interp.time[i.line]+900,2),c(0,22),col="orange")
    lines(rep(interp.time[i.line]+900,2),c(0,9.5),col="orange")    
}

line.mark = which(head.diff<0)
line.mark = line.mark[which(head.diff[line.mark+1]>0)]
for (i.line in line.mark)
{
###    lines(rep(interp.time[i.line]+900,2),c(0,22),col="cyan")
    lines(rep(interp.time[i.line]+900,2),c(0,9.5),col="cyan")    
}




axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 2,col.axis='black',col='black',line=0,las=2)
mtext(side = 2,text='Temp (DegC)',col='black',line=2.5)


legend("top",c("2-3 WL","SWS-1 WL",
               "-64cm","-24cm","-4cm",
               "+16cm","+26cm","+46cm",               
               "2-3 T","SWS-1 T"),
       cex=0.8,
       lty=c(1,1,
             2,2,2,
             1,1,1,
             1,1),
       col=c("grey","grey",
             "red","pink","yellow",
             "darkgreen","green","skyblue",
             "black","blue"),
       lwd=c(2,2,
             2,2,
             2,2,2),
       bty="n",horiz=TRUE)

dev.off()

