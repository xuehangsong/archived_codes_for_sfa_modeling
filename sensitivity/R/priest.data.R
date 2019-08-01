##This file is used to collect all data from priest discharge

rm(list=ls())
library(xts)
data = read.table("data/priest.dam/priest.discharge.txt",header=TRUE,skip=28,fill=TRUE)

data[,4] = data[,4]*0.3048^3
data[,6] = data[,6]*0.3048

data[,3] = as.POSIXct(data[,3],tz="GMT",format="%Y-%m-%d")
start.time = range(data[,3])[1]
end.time = range(data[,3])[2]

start.time = as.POSIXct("1917-01-01",tz="GMT",format="%Y-%m-%d")
end.time = as.POSIXct("2016-01-01",tz="GMT",format="%Y-%m-%d")

time.ticks = seq(start.time,end.time,by="5 year")

jpeg(paste("figures/river.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(data[,3],data[,4]/1000,type="l",
     xlab=NA,
     ylab=NA,
     axes= FALSE,     
     )

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%Y"),tck=-0.018,cex.axis=1.2)
mtext(side = 1,text='Time (Year)',line=3,cex=1.2)

axis(side = 2,at=seq(0,20,5),col.axis='black',col='black',las=2,line=0,cex.axis=1.2)
mtext(side = 2,at=10,text='Discharge (10^3 m^3/s)',line=2,col='black',cex=1.2)

par(new=T)
plot(data[,3],data[,6],type="l",
     xlab=NA,
     ylab=NA,
     axes= FALSE,
     col="blue"
     )

dev.off()



jpeg(paste("figures/operation.curve.jpg",sep=''),width=8,height=8,units='in',res=200,quality=100)

data.1 = xts(data,order.by=data[,3],unique=T,tz="GMT")
data.1 = data.1[.indexyear(data.1) %in% c(17:93),]
plot(as.numeric(data.1[,6]),as.numeric(data.1[,4])/1000,type="p",col="red",
     ylim=c(0,12),
     xlim=c(0,10),
     xlab=NA,
     ylab=NA,
     axes= FALSE,
     )


data.2 = xts(data,order.by=data[,3],unique=T,tz="GMT")
data.2 = data.2[.indexyear(data.2) %in% c(94:116),]
points(as.numeric(data.2[,6]),as.numeric(data.2[,4])/1000,type="p",col="blue")

axis(side = 1,seq(0,10,2),tck=-0.018,cex.axis=1.2)
mtext(side = 1,text='Gage height (m)',line=2,cex=1.2)

axis(side = 2,at=seq(0,12,3),col.axis='black',col='black',las=2,line=0,cex.axis=1.2)
mtext(side = 2,at=6,text='Discharge (10^3 m^3/s)',line=2,col='black',cex=1.2)


legend(0,11,c("Before 1994","Since 1994"),
       cex=1.3,
       col=c("red","blue"),
       lwd=c(3,3),
       bty="n",horiz=TRUE)
dev.off()


dev.off()

