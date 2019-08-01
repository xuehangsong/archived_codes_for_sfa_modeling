rm(list=ls())
library(xts)
load("results/evan.data.r")

start.time = as.POSIXct("2004-08-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2005-06-30 14:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

diff.head = as.numeric(river.level[,2]-inland.level[,2])
low.gw =  which(diff.head<=0)

time.ticks = seq(from=start.time,to=end.time,by="months")
jpegfile="./figures/evan.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+150*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")


par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')




lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-30*24*3600,24,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()


start.time = as.POSIXct("2004-08-10 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2004-08-31 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan1.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+10*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,15,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()








start.time = as.POSIXct("2004-09-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2004-09-30 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan2.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()










start.time = as.POSIXct("2004-10-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2004-10-31 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan3.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()

















start.time = as.POSIXct("2004-11-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2004-11-30 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan4.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()














start.time = as.POSIXct("2004-12-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2004-12-31 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan5.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()



start.time = as.POSIXct("2005-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2005-1-31 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan6.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()








start.time = as.POSIXct("2005-02-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2005-02-28 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan7.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()







start.time = as.POSIXct("2005-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2005-03-31 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan8.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()




start.time = as.POSIXct("2005-04-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2005-04-30 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan9.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()


start.time = as.POSIXct("2005-05-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2005-05-31 23:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/evan10.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(river.level[,1],river.level[,2],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(inland.level[,1][-1:0+low.gw[iblock]]),90,
         mean(inland.level[,1][0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
}


axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(inland.level[,1],inland.level[,2],col="black")
lines(river.level[,1],river.level[,2],col="blue")

par(new=T)
plot(river.data[,3],river.data[,6],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(0,30),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(sp9a142.data[,1],sp9a142.data[,3],col='red')
lines(sp9a86.data[,1],sp9a86.data[,3],col='orange')
lines(sp9a19.data[,1],sp9a19.data[,3],col='green')


legend(end.time-5*24*3600,25,lty=1,pch=NA,c("-1.42-0.23m","-0.86-0.23m","-0.19-0.23m","River"),
       c("red","orange","green","blue")
       )


dev.off()




