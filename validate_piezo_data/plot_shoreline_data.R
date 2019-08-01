rm(list=ls())


ERT_S_Press = readLines("ERT_S_Press_Table1.dat",skip=c(1,3,4))
ERT_S_Press = ERT_S_Press[-c(1,3,4)]
ERT_S_Press = read.csv(textConnection(ERT_S_Press),stringsAsFactors=FALSE)

ERT_S_Press[[1]] = strptime(ERT_S_Press[[1]],format="%Y-%m-%d %H:%M:%S",tz="GMT")


RG3 = read.csv("RG3.csv",stringsAsFactors=FALSE)
RG3[[1]] = strptime(RG3[[1]],format="%Y-%m-%d %H:%M:%S",tz="GMT")

start.time = range(ERT_S_Press[,1])[1]
start.time = as.POSIXct(start.time,format="%Y-%m-%d %H:%M:%S",tz="GMT")
end.time = range(ERT_S_Press[,1])[2]
end.time = as.POSIXct(end.time,format="%Y-%m-%d %H:%M:%S",tz="GMT")

time.ticks = seq(start.time-3600*24,end.time,3600*24*5)

jpeg(filename="ERT_press.jpeg",width=10,height=8,units='in',res=200,quality=100)
plot(ERT_S_Press[,1],ERT_S_Press[["ShallowP"]],type="l",ylim=c(0,3),
     xlim=range(start.time,end.time),     
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     )
lines(ERT_S_Press[,1],ERT_S_Press[["DeepP"]],col="red")
axis(side=1,at=time.ticks,label=format(time.ticks,format="%m/%d/%y"))
mtext(side=1,text="Time (day)",line=3)
axis(side=2,las=2,line=0.5)
mtext(side=2,text="Pressure (m)",line=3)

legend("bottom",c("shallow pressure","deep pressure"),lty=1,lwd=1,
       col=c("black","red"),
       bty='n'
)




par(new=T)
plot(RG3[[1]],RG3[[2]],
     ylim=c(103,106),
     xlim=range(start.time,end.time),
     type='l',col='blue',
     axes = FALSE,
     xlab = NA,
     ylab = NA,
     )

axis(side=4,las=2,line=-2,col="blue")
mtext(side=4,text="River level(m)",line=1,col="blue")

legend("top",c("RG3 river level"),lty=1,lwd=1,
       col=c("blue"),bty="n")


dev.off()

