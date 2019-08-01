rm(list=ls())


north_05 = readLines("NorthArray_INW/Shallow05m_ERTarray_21106005_14Sept2016.csv")
north_05 = north_05[c(-1:-33)]
north_05 = read.csv(textConnection(north_05),stringsAsFactors=FALSE,header=FALSE)
north_05[[2]] = strptime(north_05[[2]],format="%d-%b-%y %H:%M:%S",tz="GMT")
north_05 =data.frame(north_05[[2]],north_05[[5]])
colnames(north_05) = c("Time","Pressure (mH2O)")


north_2 = readLines("NorthArray_INW/Deep2m_ERT ARRAY_2939009_14Sept2016.csv")
north_2 = north_2[c(-1:-33)]
north_2 = read.csv(textConnection(north_2),stringsAsFactors=FALSE,header=FALSE)
north_2[[2]] = strptime(north_2[[2]],format="%d-%b-%y %H:%M:%S",tz="GMT")
north_2 =data.frame(north_2[[2]],north_2[[5]])
colnames(north_2) = c("Time","Pressure (mH2O)")


north_river = readLines("NorthArray_INW/River_ERT ARRAY_2642046_14Sept2016.csv")
north_river = north_river[c(-1:-22)]
north_river = read.csv(textConnection(north_river),stringsAsFactors=FALSE,header=FALSE)
north_river[[2]] = strptime(north_river[[2]],format="%d-%b-%y %H:%M:%S",tz="GMT")
north_river =data.frame(north_river[[2]],north_river[[3]])
colnames(north_river) = c("Time","Pressure (mH2O)")

south = readLines("ERT_S_Press_Table1.dat")
south = south[-c(1,2,3,4)]
south = read.csv(textConnection(south),stringsAsFactors=FALSE)
south[[1]] = strptime(south[[1]],format="%Y-%m-%d %H:%M:%S",tz="GMT")

south_05 = data.frame(south[[1]],south[[6]])##*1.42197020632)
colnames(south_05) = c("Time","Pressure (mH2O)")

south_2 = data.frame(south[[1]],south[[7]])##*1.42197020632)
colnames(south_2) = c("Time","Pressure (mH2O)")

south_river= data.frame(south[[1]],south[[5]])##*1.42197020632)
colnames(south_river) = c("Time","Pressure (mH2O)")


RG3 = read.csv("RG3.csv",stringsAsFactors=FALSE)
RG3[[1]] = strptime(RG3[[1]],format="%Y-%m-%d %H:%M:%S",tz="GMT")

start.time = range(north_river[,1])[1]
start.time = as.POSIXct(start.time,format="%Y-%m-%d %H:%M:%S",tz="GMT")
end.time = range(north_river[,1])[2]
end.time = as.POSIXct(end.time,format="%Y-%m-%d %H:%M:%S",tz="GMT")

time.ticks = seq(start.time-3600*24,end.time,3600*24*5)

jpeg(filename="ERT_north.jpeg",width=10,height=8,units='in',res=200,quality=100)
plot(north_river[,1],north_river[,2],type="l",ylim=c(0,4),col="blue",lwd=2,
     xlim=range(start.time,end.time),     
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     main="ERT_north",
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
plot(south_river[,1],south_river[,2],type="l",ylim=c(0,4),col="blue",lwd=2,
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

