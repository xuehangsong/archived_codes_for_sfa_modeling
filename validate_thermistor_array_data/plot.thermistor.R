rm(list=ls())
library("openxlsx")


start.time = as.POSIXct("03/02/2016 00:00:00",format="%m/%d/%Y %H:%M:%S",tz="GMT")
end.time = as.POSIXct("03/09/2016 00:00:00",format="%m/%d/%Y %H:%M:%S",tz="GMT")
time.ticks = seq(start.time-3600*24,end.time,3600*24)


thermistor.data = read.csv("thermarray.csv")
names(thermistor.data) = c("Time",
                           "-64cm",
                           "-24cm",
                           "-4cm",
                           "+16cm",
                           "+26cm",
                           "+46cm"
                           )


thermistor.data[[1]] = strptime(thermistor.data[[1]],format="%m/%d/%Y %H:%M",tz="GMT")



sws1.data = read.csv("River_300A.csv")
names(sws1.data) = c("Time","DegC","SpC","River level")
sws1.data[[1]] = strptime(sws1.data[[1]],format="%Y-%m-%d %H:%M:%S",tz="GMT")


line.col = c("red","orange","yellow","grey","green","cyan")
line.lwd = rep(1,6)
line.lty = c(2,2,2,1,1,1)
    
jpeg(filename="thermistor.jpeg",width=10,height=8,units='in',res=200,quality=100)
plot(thermistor.data[[1]],thermistor.data[[3]],type='l',col='white',
     xlim=range(start.time,end.time),
     ylim=c(4,9),
     axes = FALSE,
     xlab = NA,
     ylab = NA,

     )

for (i.line in 2:7)
{
lines(thermistor.data[[1]],thermistor.data[[i.line]],
      col = line.col[i.line-1],
      lty = line.lty[i.line-1],
      lwd = line.lwd[i.line-1])

}

axis(side=1,at=time.ticks,label=format(time.ticks,format="%m/%d/%y"))
mtext(side=1,text="Time (day)",line=3)
axis(side=2,las=2,line=0.5)
mtext(side=2,text="Temperature(DegC)",line=3)


par(new=T)
plot(sws1.data[[1]],sws1.data[[2]],
     ylim=c(4,9),
     xlim=range(start.time,end.time),
     type='l',col='black',
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     )



par(new=T)
plot(sws1.data[[1]],sws1.data[[4]],
     xlim=range(start.time,end.time),
     ylim=c(103,106.5),
     type='l',col='blue',
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     
     )

axis(side=4,las=2,line=-3)
mtext(side=4,text="River level(m)",line=0.5)


legend("topleft",c(names(thermistor.data)[2:7],"SWS-1 T","SWS-1 WL"),
       lty=c(line.lty,1,1),
       lwd=c(line.lwd,1,1),
       col=c(line.col,"black","blue"),
       bty='n'
)

dev.off()
