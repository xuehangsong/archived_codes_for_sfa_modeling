rm(list=ls())
library(xts)
load("results/thermal.data.r")
load("results/ibutton.data.r")
start.time = as.POSIXct("2016-04-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-07-25 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")



diff.head = as.numeric(river.data[,4]-inland.data[,4])

head.sign.na = which(is.na(diff.head))
head.sign.na = head.sign.na[2:(length(head.sign.na)-1)]
diff.head[head.sign.na]=diff.head[head.sign.na-1]

low.gw =  which(diff.head<=0)
na.gw =  which(is.na(diff.head))


time.ticks = seq(from=start.time,to=end.time,by="months")
jpegfile="./figures/temperature.jpg"
jpeg(jpegfile,width=5.4,height=2.1,units='in',res=500,quality=100)
par(mar=c(2,3,1,1))

plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(5,25),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,25,5),col.axis='black',las=1,mgp=c(1.5,0.7,0))
mtext(side = 2,text=expression(paste("Temperature ("^o,"C)")),line=1.5,col='black')
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%Y-%m"),mgp=c(1.5,0.7,0))
##mtext(side = 1,at=start.time+60*3600*24,text='Time (day)',line=1.5)
lines(index(inland.data),inland.data[,4],col="black")


lines(index(thermal.data),thermal.data[,2],col='red')
lines(index(thermal.data),thermal.data[,3],col='orange')
lines(index(thermal.data),thermal.data[,4],col='green')
lines(index(thermal.data),thermal.data[,5],col='blue')
lines(index(inland.data),inland.data[,2],col='black')
box()
legend(start.time,24.5,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m"),
       col=c("red","orange","green"),horiz=TRUE,bty="n")

legend(start.time,27,lty=1,pch=NA,c("River","Inland"),
       col=c("blue","black"),horiz=TRUE,bty="n")

dev.off()


stop()

start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-03-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/temperature1.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(index(river.data),river.data[,4],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(index(inland.data)[-1:0+low.gw[iblock]]),90,
         mean(index(inland.data)[0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
    rect(mean(index(inland.data)[-1:0+na.gw[iblock]]),90,
         mean(index(inland.data)[0:1+na.gw[iblock]]),107,
         col="white",
         density=-3,
         border=NA
         )
}
lines(index(inland.data),inland.data[,4],col="black")
lines(index(river.data),river.data[,4],col="blue")


mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')


par(new=T)
plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(5,25),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(index(thermal.data),thermal.data[,2],col='red')
lines(index(thermal.data),thermal.data[,3],col='orange')
lines(index(thermal.data),thermal.data[,4],col='green')
lines(index(thermal.data),thermal.data[,5],col='blue')
lines(index(inland.data),inland.data[,2],col='black')

legend(start.time,22,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m","+0.16m","Inland"),
       col=c("red","orange","green","blue","black"))


dev.off()





start.time = as.POSIXct("2016-04-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-04-30 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/temperature2.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(index(river.data),river.data[,4],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )

for (iblock in 1:length(low.gw))
{
    rect(mean(index(inland.data)[-1:0+low.gw[iblock]]),90,
         mean(index(inland.data)[0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
        rect(mean(index(inland.data)[-1:0+na.gw[iblock]]),90,
         mean(index(inland.data)[0:1+na.gw[iblock]]),107,
         col="white",
         density=-3,
         border=NA
         )

}
lines(index(inland.data),inland.data[,4],col="black")
lines(index(river.data),river.data[,4],col="blue")

axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')




par(new=T)
plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(5,25),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(index(thermal.data),thermal.data[,2],col='red')
lines(index(thermal.data),thermal.data[,3],col='orange')
lines(index(thermal.data),thermal.data[,4],col='green')
lines(index(thermal.data),thermal.data[,5],col='blue')
lines(index(inland.data),inland.data[,2],col='black')

legend(start.time,22,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m","+0.16m","Inland"),
       c("red","orange","green","blue","black"))


dev.off()



start.time = as.POSIXct("2016-05-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-05-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/temperature3.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(index(river.data),river.data[,4],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(index(inland.data)[-1:0+low.gw[iblock]]),90,
         mean(index(inland.data)[0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
    rect(mean(index(inland.data)[-1:0+na.gw[iblock]]),90,
         mean(index(inland.data)[0:1+na.gw[iblock]]),107,
         col="white",
         density=-3,
         border=NA
         )

}
lines(index(inland.data),inland.data[,4],col="black")
lines(index(river.data),river.data[,4],col="blue")

axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')


par(new=T)
plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(5,25),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(index(thermal.data),thermal.data[,2],col='red')
lines(index(thermal.data),thermal.data[,3],col='orange')
lines(index(thermal.data),thermal.data[,4],col='green')
lines(index(thermal.data),thermal.data[,5],col='blue')
lines(index(inland.data),inland.data[,2],col='black')


legend(start.time,22,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m","+0.16m","Inland"),
       c("red","orange","green","blue","black"))



dev.off()



start.time = as.POSIXct("2016-06-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-07-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/temperature4.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(index(river.data),river.data[,4],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(index(inland.data)[-1:0+low.gw[iblock]]),90,
         mean(index(inland.data)[0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )
        rect(mean(index(inland.data)[-1:0+na.gw[iblock]]),90,
         mean(index(inland.data)[0:1+na.gw[iblock]]),107,
         col="white",
         density=-3,
         border=NA
         )
}
lines(index(inland.data),inland.data[,4],col="black")
lines(index(river.data),river.data[,4],col="blue")

axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')


par(new=T)
plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(5,25),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(index(thermal.data),thermal.data[,2],col='red')
lines(index(thermal.data),thermal.data[,3],col='orange')
lines(index(thermal.data),thermal.data[,4],col='green')
lines(index(thermal.data),thermal.data[,5],col='blue')
lines(index(inland.data),inland.data[,2],col='black')


legend(start.time,22,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m","+0.16m","Inland"),
       c("red","orange","green","blue","black"))

dev.off()




start.time = as.POSIXct("2016-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-07-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/temperature5.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(index(river.data),river.data[,4],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(index(inland.data)[-1:0+low.gw[iblock]]),90,
         mean(index(inland.data)[0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )

    rect(mean(index(inland.data)[-1:0+na.gw[iblock]]),90,
         mean(index(inland.data)[0:1+na.gw[iblock]]),107,
         col="white",
         density=-3,
         border=NA
         )
    
}
lines(index(inland.data),inland.data[,4],col="black")
lines(index(river.data),river.data[,4],col="blue")

axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')


par(new=T)
plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(5,25),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(index(thermal.data),thermal.data[,2],col='red')
lines(index(thermal.data),thermal.data[,3],col='orange')
lines(index(thermal.data),thermal.data[,4],col='green')
lines(index(thermal.data),thermal.data[,5],col='blue')
lines(index(inland.data),inland.data[,2],col='black')


legend(start.time,22,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m","+0.16m","Inland"),
       c("red","orange","green","blue","black"))

dev.off()


start.time = as.POSIXct("2016-08-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-08-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")
jpegfile="./figures/temperature6.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(index(river.data),river.data[,4],type="l",col='blue',
     xlim=range(start.time,end.time),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
for (iblock in 1:length(low.gw))
{
    rect(mean(index(inland.data)[-1:0+low.gw[iblock]]),90,
         mean(index(inland.data)[0:1+low.gw[iblock]]),107,
         col="lightgrey",
         density=-3,
         border=NA
         )

    rect(mean(index(inland.data)[-1:0+na.gw[iblock]]),90,
         mean(index(inland.data)[0:1+na.gw[iblock]]),107,
         col="white",
         density=-3,
         border=NA
         )
    
}
lines(index(inland.data),inland.data[,4],col="black")
lines(index(river.data),river.data[,4],col="blue")

axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')


par(new=T)
plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time),     
     ylim=c(5,25),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

lines(index(thermal.data),thermal.data[,2],col='red')
lines(index(thermal.data),thermal.data[,3],col='orange')
lines(index(thermal.data),thermal.data[,4],col='green')
lines(index(thermal.data),thermal.data[,5],col='blue')
lines(index(inland.data),inland.data[,2],col='black')


legend(start.time,22,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m","+0.16m","Inland"),
       c("red","orange","green","blue","black"))

dev.off()






start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-03-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="5 days")


color = c("blue","green","gold","orange","deeppink","red")
names(color) = as.character(seq(1,6))
for (isection in c("A","B","C","D","E"))
    {

        jpegfile=paste("figures/ibutton_",isection,".jpg",sep='')        
        jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
        plot(index(river.data),river.data[,4],type="l",col='blue',
             xlim=range(start.time,end.time),
             ylim=c(90,107),     
             axes=FALSE,
             xlab=NA,
             ylab=NA,
             )
        for (iblock in 1:length(low.gw))
        {
            rect(mean(index(inland.data)[-1:0+low.gw[iblock]]),90,
                 mean(index(inland.data)[0:1+low.gw[iblock]]),107,
                 col="lightgrey",
                 density=-3,
                 border=NA
                 )
            rect(mean(index(inland.data)[-1:0+na.gw[iblock]]),90,
                 mean(index(inland.data)[0:1+na.gw[iblock]]),107,
                 col="cyan",
                 density=-3,
                 border=NA
         )
            
        }
        lines(index(inland.data),inland.data[,4],col="black")
        lines(index(river.data),river.data[,4],col="blue")

        axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
        mtext(side = 1,at=start.time+15*3600*24,text='Time (day)',line=2)
        axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
        mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
        lines(index(inland.data),inland.data[,4],col="red")

        par(new=T)
        plot(index(ibutton.data[[isection]][["1"]]),ibutton.data[[isection]][["1"]][,3],type="l",
             xlim=range(start.time,end.time),             
             ylim=c(5,25),
             axes=FALSE,
             xlab=NA,
             ylab=NA,
             )
        axis(side = 2,at=seq(5,20,5),col.axis='black',las=0,line=0)
        mtext(side = 2,at=12.5,text='Temperature (DegC)',line=2,col='black')

        for (idepth in ibutton.list[[isection]])
        {
            lines(index(ibutton.data[[isection]][[idepth]]),ibutton.data[[isection]][[idepth]][,3],col=color[idepth],type='l')
        }


        legend(start.time,22,as.character(ibutton.depth[isection,ibutton.list[[isection]]]),col=color[ibutton.list[[isection]]],lty=1,pch=NA)
        lines(index(inland.data),inland.data[,2],col='black')

        dev.off()

    }

