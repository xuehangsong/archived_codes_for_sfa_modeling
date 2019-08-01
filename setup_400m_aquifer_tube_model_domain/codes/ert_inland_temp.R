rm(list=ls())
library(xts)
source("codes/ert_parameters.R")
Well2_1 = read.csv("data/399-2-1_3var.csv")
Well2_1 = Well2_1[,c(1,2)]
Well2_1[,1] = as.POSIXct(Well2_1[,1],tz="GMT",format="%d-%b-%Y %H:%M:%S")
names(Well2_1) = c("Time","Temp")

Well2_2 = read.csv("data/399-2-2_3var.csv")
Well2_2 = Well2_2[,c(1,2)]
Well2_2[,1] = as.POSIXct(Well2_2[,1],tz="GMT",format="%d-%b-%Y %H:%M:%S")
names(Well2_2) = c("Time","Temp")

Well2_3 = read.csv("data/399-2-3_3var.csv")
Well2_3 = Well2_3[,c(1,2)]
Well2_3[,1] = as.POSIXct(Well2_3[,1],tz="GMT",format="%d-%b-%Y %H:%M:%S")
names(Well2_3) = c("Time","Temp")

start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2017-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
simu.start = as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.ticks = seq(from=start.time,to=end.time,by="4 month")
time.mini.ticks = seq(from=start.time,to=end.time,by="1 month")
interp.time = seq(start.time,end.time,3600)


Well2_1.xts = Well2_1
Well2_1.xts = Well2_1.xts[which(Well2_1.xts[,1]>start.time-300),]
Well2_1.xts = Well2_1.xts[which(Well2_1.xts[,1]<end.time+300),]
Well2_1.xts = xts(Well2_1.xts,Well2_1.xts[,1],unique=T,tz="GMT")
Well2_1.xts = Well2_1.xts[,-1]
Well2_1.xts = Well2_1.xts[.indexmin(Well2_1.xts) %in% c(57:59,0:3),]
Well2_1.xts = Well2_1.xts[c('2013','2014','2015','2016','2017'),]
index(Well2_1.xts) = round(index(Well2_1.xts),units="hours")
Well2_1.xts = Well2_1.xts[!duplicated(.index(Well2_1.xts))]
Well2_1.xts = merge(Well2_1.xts,time.index)

Well2_2.xts = Well2_2
Well2_2.xts = Well2_2.xts[which(Well2_2.xts[,1]>start.time-300),]
Well2_2.xts = Well2_2.xts[which(Well2_2.xts[,1]<end.time+300),]
Well2_2.xts = xts(Well2_2.xts,Well2_2.xts[,1],unique=T,tz="GMT")
Well2_2.xts = Well2_2.xts[,-1]
Well2_2.xts = Well2_2.xts[.indexmin(Well2_2.xts) %in% c(57:59,0:3),]
Well2_2.xts = Well2_2.xts[c('2013','2014','2015','2016','2017'),]
index(Well2_2.xts) = round(index(Well2_2.xts),units="hours")
Well2_2.xts = Well2_2.xts[!duplicated(.index(Well2_2.xts))]
Well2_2.xts = merge(Well2_2.xts,time.index)

Well2_3.xts = Well2_3
Well2_3.xts = Well2_3.xts[which(Well2_3.xts[,1]>start.time-300),]
Well2_3.xts = Well2_3.xts[which(Well2_3.xts[,1]<end.time+300),]
Well2_3.xts = xts(Well2_3.xts,Well2_3.xts[,1],unique=T,tz="GMT")
Well2_3.xts = Well2_3.xts[,-1]
Well2_3.xts = Well2_3.xts[.indexmin(Well2_3.xts) %in% c(57:59,0:3),]
Well2_3.xts = Well2_3.xts[c('2013','2014','2015','2016','2017'),]
index(Well2_3.xts) = round(index(Well2_3.xts),units="hours")
Well2_3.xts = Well2_3.xts[!duplicated(.index(Well2_3.xts))]
Well2_3.xts = merge(Well2_3.xts,time.index)


all_temp = cbind(as.numeric(Well2_1.xts),
                 as.numeric(Well2_2.xts),
                 as.numeric(Well2_3.xts))

combined_temp = rowMeans(all_temp,na.rm=TRUE)


simu.time = difftime(index(Well2_1.xts),simu.start,units="secs")
outputtimes = which(simu.time>=0)
ntime = length(outputtimes)

Temp_Inland = cbind(simu.time[outputtimes],
                   as.numeric(combined_temp[outputtimes]))
Temp_Inland = Temp_Inland[!is.na(Temp_Inland[,2]),]

write.table(Temp_Inland,file=paste("ert_model/Temp_Inland_ERT.txt",sep=''),col.names=FALSE,row.names=FALSE)
