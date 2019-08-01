rm(list=ls())

start.time = as.POSIXct("2016-03-02 13:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

pflotran.intrusion = read.table("1dtemppro/pflotran_intrusion.csv",skip=1)
pflotran.intrusion[,1] = pflotran.intrusion[,1]*3600*24+start.time

temppro.intrusion = read.table("1dtemppro/1dtemppro_intrusion.csv",skip=1,sep=",")
temppro.intrusion[,1] = as.POSIXct(temppro.intrusion[,1],format="%m/%d/%Y %H:%M:%S",tz='GMT')

jpegfile="./figures/pflotran_tempro.intrusion.jpg"
jpeg(jpegfile,width=8,height=5,units='in',res=500,quality=100)
plot(pflotran.intrusion[,1],pflotran.intrusion[,5],type="l",col="green",
     xlab="Time (day)",
     ylab="Temperature (DegC)",
     ylim=c(4.5,7.5)
     )
lines(temppro.intrusion[,1],temppro.intrusion[,3],lty=2,col="green")
lines(pflotran.intrusion[,1],pflotran.intrusion[,12],col="orange")
lines(temppro.intrusion[,1],temppro.intrusion[,4],lty=2,col="orange")

lines(temppro.intrusion[,1],temppro.intrusion[,2],lty=1,col="blue",lwd=2)
lines(temppro.intrusion[,1],temppro.intrusion[,5],lty=1,col="red",lwd=2)


legend(start.time+2*3600,7.5,lty=c(1,2,1,2),lwd=2,pch=NA,c("-0.04m PFLOTRAN","-0.04m 1DtempPro","-0.24m PFLOTRAN","-0.24m 1DtempPro"),
       c("green","green","orange","orange"),
       )

dev.off()










pflotran.discharge = read.table("1dtemppro/pflotran_discharge.csv",skip=1)
pflotran.discharge[,1] = pflotran.discharge[,1]*3600*24+start.time

temppro.discharge = read.table("1dtemppro/1dtemppro_discharge.csv",skip=1,sep=",")
temppro.discharge[,1] = as.POSIXct(temppro.discharge[,1],format="%m/%d/%Y %H:%M:%S",tz='GMT')

jpegfile="./figures/pflotran_tempro.discharge.jpg"
jpeg(jpegfile,width=8,height=5,units='in',res=500,quality=100)
plot(pflotran.discharge[,1],pflotran.discharge[,5],type="l",col="green",
     xlab="Time (day)",
     ylab="Temperature (DegC)",
     ylim=c(4.5,7.5)

     )
lines(temppro.discharge[,1],temppro.discharge[,3],lty=2,col="green")
lines(pflotran.discharge[,1],pflotran.discharge[,12],col="orange")
lines(temppro.discharge[,1],temppro.discharge[,4],lty=2,col="orange")
lines(temppro.intrusion[,1],temppro.intrusion[,2],lty=1,col="blue",lwd=2)
lines(temppro.intrusion[,1],temppro.intrusion[,5],lty=1,col="red",lwd=2)

##lines(pflotran.discharge[,1],pflotran.discharge[,19],col="black")

legend(start.time+2*3600,7.5,lty=c(1,2,1,2),lwd=2,pch=NA,c("-0.04m PFLOTRAN","-0.04m 1DtempPro","-0.24m PFLOTRAN","-0.24m 1DtempPro"),
       c("green","green","orange","orange"),
       )

dev.off()
