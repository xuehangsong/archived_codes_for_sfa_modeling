rm(list=ls())
library(xts)
load("results/thermal.data.r")
start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-08-25 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")



all.block = list.files("splited_data/matched_data/")
all.block = paste("splited_data/matched_data/",all.block,"/CalculatedSpecificDischarge.csv",sep="")
nblock = length(all.block)
match.data = list()
for (iblock in 1:length(all.block))
{
    match.data[[iblock]] = read.table(all.block[[iblock]],skip=1,sep=",")
    match.data[[iblock]][,1] =  as.POSIXct(match.data[[iblock]][,1],format="%m/%d/%Y %H:%M:%S",tz='GMT')
}

pure.data = list()
for (iblock in 1:length(all.block))
{
    pure.data[[iblock]] = match.data[[iblock]][,2]
    
}





time.ticks = seq(from=start.time,to=end.time,by="months")
jpegfile="./figures/matching.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(index(river.data),river.data[,4],type="l",col='blue',
     xlim=range(start.time,end.time+3600*24*7),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+60*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(index(inland.data),inland.data[,4],col="black")


par(new=T)
plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time+3600*24*7),     
     ylim=c(-5,30),
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

legend(start.time+2*24*3600,25,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m","+0.16m","Inland"),
       c("red","orange","green","blue","black")
       )



par(new=T)
plot(match.data[[1]][,1],match.data[[1]][,2],type="p",col='black',pch=16,cex=0.5,
     xlim=range(start.time,end.time+3600*24*7),     
     ylim=c(0,2e-3),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 4,at=seq(0,6e-4,2e-4),col.axis='black',las=2,line=-4)
mtext(side = 4,at=3e-4,text='Flux (m/s)',line=0,col='black')

for (iblock in 1:nblock)
{
    if(match.data[[iblock]][1,2]>0) {color="blue"} else {color="white"}
    points(match.data[[iblock]][,1],match.data[[iblock]][,2],cex=0.5,pch=16,col=color)
}

dev.off()


















time.ticks = seq(from=start.time,to=end.time,by="months")
jpegfile="./figures/matching2.jpg"
jpeg(jpegfile,width=15,height=8,units='in',res=500,quality=100)
plot(index(river.data),river.data[,4],type="l",col='blue',
     xlim=range(start.time,end.time+3600*24*7),
     ylim=c(90,107),     
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
mtext(side = 1,at=start.time+60*3600*24,text='Time (day)',line=2)
axis(side = 4,at=seq(104,107),col.axis='black',las=2,line=-2)
mtext(side = 4,at=105.5,text='Water level (m)',line=0.5,col='black')
lines(index(inland.data),inland.data[,4],col="black")


par(new=T)
plot(index(thermal.data),thermal.data[,2],type="l",col='blue',
     xlim=range(start.time,end.time+3600*24*7),     
     ylim=c(-5,30),
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

legend(start.time+2*24*3600,25,lty=1,pch=NA,c("-0.64m","-0.24m","-0.04m","+0.16m","Inland"),
       c("red","orange","green","blue","black")
       )



par(new=T)
plot(match.data[[1]][,1],match.data[[1]][,2],type="p",col='black',pch=16,cex=0.5,
     xlim=range(start.time,end.time+3600*24*7),     
     ylim=c(-1.2e-5,2.5e-5),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
axis(side = 4,at=seq(0,-1.2e-5,-4e-6),col.axis='black',las=2,line=-4)
mtext(side = 4,at=-6e-6,text='Flux (m/s)',line=0,col='black')

for (iblock in 1:nblock)
{
    if(match.data[[iblock]][1,2]>0) {color="white"} else {color="black"}
    points(match.data[[iblock]][,1],match.data[[iblock]][,2],cex=0.5,pch=16,col=color)
}

dev.off()

