rm(list=ls())
library(xts)
load("results/thermal.data.r")
load("results/ibutton.data.r")
start.time = as.POSIXct("2016-04-15 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

end.time = as.POSIXct("2016-07-25 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
start.time = as.POSIXct("2016-05-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")


diff.head = as.numeric(river.data[,4]-inland.data[,4])

head.sign.na = which(is.na(diff.head))
head.sign.na = head.sign.na[2:(length(head.sign.na)-1)]
diff.head[head.sign.na]=diff.head[head.sign.na-1]

low.gw =  which(diff.head<=0)
na.gw =  which(is.na(diff.head))


###screen the raise out 
thermal.data[which(river.data[,4]<104.9,),] = NA


time.ticks = seq(from=start.time,to=end.time,by="weeks")

river.data.new = read.csv("data/SWS-1_20170405.csv")
river.data.new[,1] = as.POSIXct(river.data.new[,1],format="%m/%d/%Y %H:%M",tz="GMT")



jpegfile="./figures/temperature.pdf"
##pdf(jpegfile,width=6,height=4)##,units='in',res=500,quality=100)
pdf(jpegfile,width=8,height=4)##,units='in',res=500,quality=100)
par(mar=c(3.1,3.1,1,4))

plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time),     
##     ylim=c(8.5,20.5),
     ylim=c(9.5,27),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 2,at=seq(6,21,3),col.axis='black',las=1,mgp=c(1.5,0.7,0))
mtext(side = 2,at=15,text=expression(paste("Temperature ("^o,"C)")),line=1.5,col='black')
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d"),mgp=c(1,0.7,0))
mtext(side = 1,text='Time',1.5)
lines(index(inland.data),inland.data[,4],col="black")


lines(index(thermal.data),thermal.data[,2],col='red')
lines(index(thermal.data),thermal.data[,3],col='orange')
lines(index(thermal.data),thermal.data[,4],col='green')
lines(index(thermal.data),thermal.data[,5],col='blue')
lines(index(inland.data),inland.data[,2],col='black')
box()
legend(start.time+3600*24*25,12.5,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m"),
       col=c("red","orange","green"),horiz=TRUE,bty="n")

legend(start.time++3600*24*25,11,lty=1,pch=NA,c("River","Inland"),
       col=c("blue","black"),horiz=TRUE,bty="n")
legend(start.time,27.5,lty=1,pch=NA,c("River stage"),
       col=c("darkgrey"),horiz=TRUE,bty="n")


par(new=T)
plot(river.data.new[,1],river.data.new[,8],type="l",col="darkgrey",
     xlim=range(start.time,end.time),ylim=c(100,107),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 4,at=seq(105,110,1),col.axis='black',las=1,mgp=c(1.5,0.7,0))
mtext(side = 4,at=106,text=expression(paste("Water level (m)")),line=2.5,col='black')
dev.off()

