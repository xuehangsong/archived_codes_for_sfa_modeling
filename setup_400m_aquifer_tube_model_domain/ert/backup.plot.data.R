rm(list=ls())
data.file  = read.table("data/field_data.csv",header=TRUE,sep=",",stringsAsFactors=FALSE)
date.and.time = paste(data.file[["Date"]],data.file[["Sampling.time"]])


no.data.point = grep("NA",date.and.time)
##data.file[!no.data.point,]
data.file = data.file[-c(no.data.point),]
date.and.time = date.and.time[-c(no.data.point)]
date.and.time = as.POSIXct(date.and.time,format="%m/%d/%Y %H:%M:%S",tz="GMT")

jpeg.name = "figures/S-M_SpC.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("S-M-41",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"Myron_SpC"],
     ylim=c(100,300),
     xlab="Time (day)",
     ylab="SpC"

     )
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="black")

row.name = grep("S-M-83",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="blue")


legend("topleft",c("S-M-41","S-M-83","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-M_SpC.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-M-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"Myron_SpC"],
     ylim=c(100,300),
     xlab="Time (day)",
     ylab="SpC"

     )
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="black")

row.name = grep("N-M-114",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="blue")


legend("topleft",c("N-M-50","N-M-114","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-U_SpC.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"Myron_SpC"],
     ylim=c(100,300),
     xlab="Time (day)",
     ylab="SpC"

     )
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="black")

row.name = grep("N-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="blue")


legend("topleft",c("N-U-50","N-U-100","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()


jpeg.name = "figures/S-U_SpC.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"Myron_SpC"],
     ylim=c(100,300),
     xlab="Time (day)",
     ylab="SpC"

     )
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="black")

row.name = grep("S-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")

row.name = grep("S-U-180",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="green")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="green")


row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="blue")


legend("topleft",c("S-U-50","S-U-100","S-U-180","River"),lwd=2,lty=1,col=c("black","red","green","blue"))

dev.off()


























jpeg.name = "figures/S-M_Temp.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("S-M-41",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"Myron_Temp"],
     ylim=c(15,30),
     xlab="Time (day)",
     ylab="Temp"

     )
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="black")

row.name = grep("S-M-83",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="blue")


legend("topleft",c("S-M-41","S-M-83","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-M_Temp.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-M-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"Myron_Temp"],
     ylim=c(15,30),
     xlab="Time (day)",
     ylab="Temp"

     )
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="black")

row.name = grep("N-M-114",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="blue")


legend("topleft",c("N-M-50","N-M-114","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-U_Temp.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"Myron_Temp"],
     ylim=c(15,30),
     xlab="Time (day)",
     ylab="Temp"

     )
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="black")

row.name = grep("N-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="blue")


legend("topleft",c("N-U-50","N-U-100","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()


jpeg.name = "figures/S-U_Temp.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"Myron_Temp"],
     ylim=c(15,30),
     xlab="Time (day)",
     ylab="Temp"

     )
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="black")

row.name = grep("S-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="red")

row.name = grep("S-U-180",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="green")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="green")


row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"Myron_Temp"],lwd=2,col="blue")


legend("topleft",c("S-U-50","S-U-100","S-U_180","River"),lwd=2,lty=1,col=c("black","red","green","blue"))

dev.off()



































jpeg.name = "figures/S-M_MS5_DO.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("S-M-41",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],
     ylim=c(0,12),
     xlab="Time (day)",
     ylab="MS5_DO"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="black")

row.name = grep("S-M-83",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="blue")


legend("topleft",c("S-M-41","S-M-83","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-M_MS5_DO.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-M-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],
     ylim=c(0,12),
     xlab="Time (day)",
     ylab="MS5_DO"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="black")

row.name = grep("N-M-114",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="blue")


legend("topleft",c("N-M-50","N-M-114","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-U_MS5_DO.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],
     ylim=c(0,12),
     xlab="Time (day)",
     ylab="MS5_DO"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="black")

row.name = grep("N-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="blue")


legend("topleft",c("N-U-50","N-U-100","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()


jpeg.name = "figures/S-U_MS5_DO.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],
     ylim=c(0,12),
     xlab="Time (day)",
     ylab="MS5_DO"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="black")

row.name = grep("S-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="red")

row.name = grep("S-U-180",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="green")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="green")


row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_DO.mg.L."],lwd=2,col="blue")


legend("topleft",c("S-U-50","S-U-100","S-U_180","River"),lwd=2,lty=1,col=c("black","red","green","blue"))

dev.off()

























jpeg.name = "figures/S-M_MS5_PH.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("S-M-41",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_PH"],
     ylim=c(7,10),
     xlab="Time (day)",
     ylab="MS5_PH"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="black")

row.name = grep("S-M-83",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="blue")


legend("topleft",c("S-M-41","S-M-83","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-M_MS5_PH.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-M-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_PH"],
     ylim=c(7,10),
     xlab="Time (day)",
     ylab="MS5_PH"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="black")

row.name = grep("N-M-114",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="blue")


legend("topleft",c("N-M-50","N-M-114","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-U_MS5_PH.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_PH"],
     ylim=c(7,10),
     xlab="Time (day)",
     ylab="MS5_PH"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="black")

row.name = grep("N-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="blue")


legend("topleft",c("N-U-50","N-U-100","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()


jpeg.name = "figures/S-U_MS5_PH.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_PH"],
     ylim=c(7,10),
     xlab="Time (day)",
     ylab="MS5_PH"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="black")

row.name = grep("S-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="red")

row.name = grep("S-U-180",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="green")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="green")


row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_PH"],lwd=2,col="blue")


legend("topleft",c("S-U-50","S-U-100","S-U_180","River"),lwd=2,lty=1,col=c("black","red","green","blue"))

dev.off()













jpeg.name = "figures/S-M_MS5_SpC.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("S-M-41",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_SpC"],
     ylim=c(100,300),
     xlab="Time (day)",
     ylab="SpC"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="black")

row.name = grep("S-M-83",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="blue")


legend("topleft",c("S-M-41","S-M-83","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-M_MS5_SpC.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-M-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_SpC"],
     ylim=c(100,300),
     xlab="Time (day)",
     ylab="SpC"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="black")

row.name = grep("N-M-114",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="blue")


legend("topleft",c("N-M-50","N-M-114","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-U_MS5_SpC.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_SpC"],
     ylim=c(100,300),
     xlab="Time (day)",
     ylab="SpC"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="black")

row.name = grep("N-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="blue")


legend("topleft",c("N-U-50","N-U-100","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()


jpeg.name = "figures/S-U_MS5_SpC.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_SpC"],
     ylim=c(100,300),
     xlab="Time (day)",
     ylab="SpC"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="black")

row.name = grep("S-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="red")

row.name = grep("S-U-180",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="green")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="green")


row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_SpC"],lwd=2,col="blue")


legend("topleft",c("S-U-50","S-U-100","S-U-180","River"),lwd=2,lty=1,col=c("black","red","green","blue"))

dev.off()









































jpeg.name = "figures/S-M_MS5_Temp.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("S-M-41",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_Temp"],
     ylim=c(15,30),
     xlab="Time (day)",
     ylab="Temp"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="black")

row.name = grep("S-M-83",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="blue")


legend("topleft",c("S-M-41","S-M-83","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-M_MS5_Temp.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-M-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_Temp"],
     ylim=c(15,30),
     xlab="Time (day)",
     ylab="Temp"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="black")

row.name = grep("N-M-114",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="blue")


legend("topleft",c("N-M-50","N-M-114","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()




jpeg.name = "figures/N-U_MS5_Temp.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_Temp"],
     ylim=c(15,30),
     xlab="Time (day)",
     ylab="Temp"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="black")

row.name = grep("N-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="red")

row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="blue")


legend("topleft",c("N-U-50","N-U-100","River"),lwd=2,lty=1,col=c("black","red","blue"))

dev.off()


jpeg.name = "figures/S-U_MS5_Temp.jpg"
jpeg(jpeg.name,width =8, height=6,units="in",res=300,quality=100)
row.name = grep("N-U-50",data.file[,1])
plot(date.and.time[row.name],data.file[row.name,"MS5_Temp"],
     ylim=c(15,30),
     xlab="Time (day)",
     ylab="Temp"

     )
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="black")

row.name = grep("S-U-100",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="red")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="red")

row.name = grep("S-U-180",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="green")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="green")


row.name = grep("River",data.file[,1])
lines(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="blue")
points(date.and.time[row.name],data.file[row.name,"MS5_Temp"],lwd=2,col="blue")


legend("topleft",c("S-U-50","S-U-100","S-U_180","River"),lwd=2,lty=1,col=c("black","red","green","blue"))

dev.off()










##stop()
## row.name = grep("S-U-100",data.file[,1])
## lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="green")
## points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="green")

## stop()
## row.name = grep("S-M-100",data.file[,1])
## lines(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")
## points(date.and.time[row.name],data.file[row.name,"Myron_SpC"],lwd=2,col="red")





