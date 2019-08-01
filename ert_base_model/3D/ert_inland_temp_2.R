rm(list=ls())
library(xts)
source("codes/ert_parameters.R")
Well1_21A = read.csv("data/399-1-21A_3var.csv")
Well1_21A = Well1_21A[,c(1,2)]
Well1_21A[,1] = as.POSIXct(Well1_21A[,1],tz="GMT",format="%d-%b-%Y %H:%M:%S")
names(Well1_21A) = c("Time","Temp")

start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2017-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
simu.start = as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.ticks = seq(from=start.time,to=end.time,by="4 month")
time.mini.ticks = seq(from=start.time,to=end.time,by="1 month")
interp.time = seq(start.time,end.time,3600)


Well1_21A.xts = Well1_21A
Well1_21A.xts = Well1_21A.xts[which(Well1_21A.xts[,1]>start.time-300),]
Well1_21A.xts = Well1_21A.xts[which(Well1_21A.xts[,1]<end.time+300),]
Well1_21A.xts = xts(Well1_21A.xts,Well1_21A.xts[,1],unique=T,tz="GMT")
Well1_21A.xts = Well1_21A.xts[,-1]
Well1_21A.xts = Well1_21A.xts[.indexmin(Well1_21A.xts) %in% c(57:59,0:3),]
Well1_21A.xts = Well1_21A.xts[c('2013','2014','2015','2016','2017'),]
index(Well1_21A.xts) = round(index(Well1_21A.xts),units="hours")
Well1_21A.xts = Well1_21A.xts[!duplicated(.index(Well1_21A.xts))]
Well1_21A.xts = merge(Well1_21A.xts,time.index)



combined_temp = as.numeric(Well1_21A.xts)


simu.time = difftime(index(Well1_21A.xts),simu.start,units="secs")
outputtimes = which(simu.time>=0)
ntime = length(outputtimes)

Temp_Inland = cbind(simu.time[outputtimes],
                   as.numeric(combined_temp[outputtimes]))
Temp_Inland = Temp_Inland[!is.na(Temp_Inland[,2]),]

write.table(Temp_Inland,file=paste("ert_model/Temp_Inland_ERT.txt",sep=''),col.names=FALSE,row.names=FALSE)
