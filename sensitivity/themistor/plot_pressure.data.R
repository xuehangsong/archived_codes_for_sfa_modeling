rm(list=ls())

##colnames(north_05) = c("Time","Pressure (mH2O)")
data = readLines("data/T3_thermistor_array.csv")
data = data[c(-1)]
data = read.csv(textConnection(data),stringsAsFactors=FALSE,header=FALSE)
data[[1]] = strptime(data[[1]],format="%m/%d/%Y %H:%M",tz="GMT")
thermistor = data.frame(data)
colnames(thermistor) = c("Time","TM1","TM2","TM3","TM4","TM5","TM6")


data = readLines("data/T3_Therm.csv")
data = data[c(-1)]
data = read.csv(textConnection(data),stringsAsFactors=FALSE,header=FALSE)
data[[1]] = strptime(data[[1]],format="%Y-%m-%d %H:%M:%S",tz="GMT")
data = data.frame(data)
colnames(data)=colnames(thermistor)
thermistor = rbind(thermistor,data)


data = readLines("data/RG3_T3_T3_Temps.dat")
data = data[-(1:4)]
data = read.csv(textConnection(data),stringsAsFactors=FALSE,header=FALSE)
data[[1]] = strptime(data[[1]],format="%Y-%m-%d %H:%M:%S",tz="GMT")
data = data.frame(data[[1]],data[[3]],data[[4]],data[[5]],data[[6]],data[[7]],data[[8]])
colnames(data)=colnames(thermistor)
thermistor = rbind(thermistor,data)
                   


stop()
RG3 = read.csv("RG3.csv",stringsAsFactors=FALSE)
RG3[[1]] = strptime(RG3[[1]],format="%Y-%m-%d %H:%M:%S",tz="GMT")

start.time = range(north_river[,1])[1]
start.time = as.POSIXct(start.time,format="%Y-%m-%d %H:%M:%S",tz="GMT")
end.time = range(north_river[,1])[2]
end.time = as.POSIXct(end.time,format="%Y-%m-%d %H:%M:%S",tz="GMT")

time.ticks = seq(start.time-3600*24,end.time,3600*24*5)

jpeg(filename="ERT_north.jpeg",width=10,height=8,units='in',res=200,quality=100)
plot(north_river[,1],north_river[,2],type="l",ylim=c(0,3),col="blue",lwd=2,
     xlim=range(start.time,end.time),     
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     main="ERT_north"
     )
lines(north_05[,1],north_05[,2],col="green",lwd=2)
lines(north_2[,1],north_2[,2],col="red",lwd=2)

axis(side=1,at=time.ticks,label=format(time.ticks,format="%m/%d/%y"))
mtext(side=1,text="Time (day)",line=3)
axis(side=2,las=2,line=0.5)
mtext(side=2,text="Pressure (m)",line=3)

legend("bottom",c("river","shallow pressure","deep pressure"),lty=1,lwd=2,
       col=c("blue","green","red"),
       bty='n'
)

par(new=T)
plot(RG3[[1]],RG3[[2]],
     ylim=c(103,106),
     xlim=range(start.time,end.time),
     type='l',col='black',lwd=2,
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     )

axis(side=4,las=2,line=-2,col="blue")
mtext(side=4,text="River level(m)",line=1,col="blue")

legend("top",c("RG3 river level"),lty=1,lwd=2,
       col=c("black"),bty="n")


dev.off()





jpeg(filename="ERT_south.jpeg",width=10,height=8,units='in',res=200,quality=100)
plot(south_river[,1],south_river[,2],type="l",ylim=c(0,3),col="blue",lwd=2,
     xlim=range(start.time,end.time),     
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     )
lines(south_05[,1],south_05[,2],col="green",lwd=2)
lines(south_2[,1],south_2[,2],col="red",lwd=2)

axis(side=1,at=time.ticks,label=format(time.ticks,format="%m/%d/%y"))
mtext(side=1,text="Time (day)",line=3)
axis(side=2,las=2,line=0.5)
mtext(side=2,text="Pressure (m)",line=3)

legend("bottom",c("river","shallow pressure","deep pressure"),lty=1,lwd=2,
       col=c("blue","green","red"),
       bty='n'
)

par(new=T)
plot(RG3[[1]],RG3[[2]],
     ylim=c(103,106),
     xlim=range(start.time,end.time),
     type='l',col='black',lwd=2,
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     main="ERT_south"     
     )

axis(side=4,las=2,line=-2,col="blue")
mtext(side=4,text="River level(m)",line=1,col="blue")

legend("top",c("RG3 river level"),lty=1,lwd=2,
       col=c("black"),bty="n")


dev.off()

