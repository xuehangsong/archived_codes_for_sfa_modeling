rm(list=ls())
library(xts)
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
source("~/repos/sbr-river-corridor-sfa/250m_3d_model.R")

SWS1 = read.csv("data/SWS-1_3var.csv")
SWS1 = SWS1[,c(1,2)]
SWS1[,1] = as.POSIXct(SWS1[,1],tz="GMT",format="%d-%b-%Y %H:%M:%S")
names(SWS1) = c("Time","Temp")

RG3 = read.csv("data/RG3-T3_station/Raw/2017-08/RG3_T3_RG3_20170801.dat",skip=3)
RG3 = RG3[,c(1,5)]
RG3[,1] = as.POSIXct(RG3[,1],tz="GMT",format="%Y-%m-%d %H:%M:%S")
names(RG3) = c("Time","Temp")


start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2017-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
simu.start = as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.ticks = seq(from=start.time,to=end.time,by="4 month")
time.mini.ticks = seq(from=start.time,to=end.time,by="1 month")
interp.time = seq(start.time,end.time,3600)


SWS1.xts = SWS1
SWS1.xts = SWS1.xts[which(SWS1.xts[,1]>start.time-300),]
SWS1.xts = SWS1.xts[which(SWS1.xts[,1]<end.time+300),]
SWS1.xts = xts(SWS1.xts,SWS1.xts[,1],unique=T,tz="GMT")
SWS1.xts = SWS1.xts[,-1]
SWS1.xts = SWS1.xts[.indexmin(SWS1.xts) %in% c(57:59,0:3),]
SWS1.xts = SWS1.xts[c('2013','2014','2015','2016','2017'),]
index(SWS1.xts) = round(index(SWS1.xts),units="hours")
SWS1.xts = SWS1.xts[!duplicated(.index(SWS1.xts))]
SWS1.xts = merge(SWS1.xts,time.index)

RG3.xts = RG3
RG3.xts = RG3.xts[which(RG3.xts[,1]>start.time-300),]
RG3.xts = RG3.xts[which(RG3.xts[,1]<end.time+300),]
RG3.xts = xts(RG3.xts,RG3.xts[,1],unique=T,tz="GMT")
RG3.xts = RG3.xts[,-1]
RG3.xts = RG3.xts[.indexmin(RG3.xts) %in% c(57:59,0:3),]
RG3.xts = RG3.xts[c('2013','2014','2015','2016','2017'),]
index(RG3.xts) = round(index(RG3.xts),units="hours")
RG3.xts = RG3.xts[!duplicated(.index(RG3.xts))]
RG3.xts = merge(RG3.xts,time.index)


combined_temp = as.numeric(RG3.xts[,"Temp"])
combined_temp[is.na(combined_temp)] = as.numeric(SWS1.xts[,"Temp"])[is.na(combined_temp)]

simu.time = difftime(index(SWS1.xts),simu.start,units="secs")
outputtimes = which(simu.time>=0)
ntime = length(outputtimes)



Temp_River = cbind(simu.time[outputtimes],
                   as.numeric(combined_temp[outputtimes]))
plot_time = index(SWS1.xts)[outputtimes][!is.na(Temp_River[,2])]
Temp_River = Temp_River[!is.na(Temp_River[,2]),]


write.table(Temp_River,file=paste("ert_model/Temp_River_aquifer_tube_2015_2017.txt",sep=''),col.names=FALSE,row.names=FALSE)



jpeg(paste("figures/River_temp.jpg",sep=''),width=6,height=5,units='in',res=300,quality=100)
plot(plot_time,Temp_River[,2],
     type="l",
     col="blue",
     xlab="Time",
     ylab="Temperature (DegC)",
     ylim=c(0,30))
legend("topright",
       "River temperature",
       lty=1,
       lwd=3,
       col="blue",
       bty="n",
       )
dev.off()
