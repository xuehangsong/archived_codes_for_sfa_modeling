rm(list=ls())
library(signal)



nwindows = 24
dt = 1/24
filt = Ma(rep(1/nwindows,nwindows))


##input
discharge_data  = read.csv("discharge.csv",header=FALSE)
ori.time = discharge_data[,1]
ori.value = discharge_data[,5]
##function
ma.value = filter(filt,ori.value)
ma.time = ori.time-dt*(nwindows-1)/2
ma.value = tail(ma.value,-nwindows)
ma.time = tail(ma.time,-nwindows)
ma.value = c(ori.value[ori.time<min(ma.time)],ma.value)
ma.time = c(ori.time[ori.time<min(ma.time)],ma.time)
ma.value = c(ma.value,ori.value[ori.time>max(ma.time)])
ma.time = c(ma.time,ori.time[ori.time>max(ma.time)])
ma.data = array(NA,c(length(ma.time),2))
##output
ma.data[,1] = ma.time
ma.data[,2] = ma.value


ori.data = array(NA,c(length(ori.time),2))
ori.data[,1] = ori.time
ori.data[,2] = ori.value




plot(ori.time,ori.value,type="l",#xlim=c(38179,38200),ylim=c(1500,5000),
     xlab="time",
     ylab="discharge (m^3/s)"
     )
lines(ma.time,ma.value,type="l",col="red",lty=2,lwd=2)
legend("topright",c("hourly","daily"),col=c("black","red"),lty=c(1,2),lwd=c(1,2),bty="n")

write.table(ma.data,"daily_averaged_discharge.txt",col.names=FALSE,row.name=FALSE)

save(list=c("ori.data","ma.data"),file="tian_data.r")
