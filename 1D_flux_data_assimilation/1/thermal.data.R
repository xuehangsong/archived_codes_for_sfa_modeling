rm(list=ls())
library(xts)

start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-08-25 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="15 mins")

data.file = "data/T3_thermistor_array.csv"
thermal.data = read.table(data.file,sep=",",header=TRUE,check.names=FALSE)
thermal.data[,1] = as.POSIXct(thermal.data[,1],format="%m/%d/%Y %H:%M",tz='GMT')
thermal.data = thermal.data[thermal.data[,1]>=start.time & thermal.data[,1]<=end.time,]
save(list=ls(),file="results/thermal.data.r")


data.file = "data/399-2-3_3var.csv"
inland.data = read.table(data.file,sep=",",header=TRUE,check.names=FALSE)
##inland.data[,1] = as.POSIXct(inland.data[,1],format="%d-%b-%Y %H:%M:%S",tz='GMT')
inland.data[,1] = as.POSIXct(inland.data[,1],format="%m/%d/%Y %H:%M",tz='GMT')
inland.data = inland.data[inland.data[,1]>=start.time & inland.data[,1]<=end.time,]


data.file = "data/SWS-1_3var.csv"
river.data = read.table(data.file,sep=",",header=TRUE,check.names=FALSE)
##river.data[,1] = as.POSIXct(river.data[,1],format="%d-%b-%Y %H:%M:%S",tz='GMT')
river.data[,1] = as.POSIXct(river.data[,1],format="%m/%d/%Y %H:%M",tz='GMT')
river.data = river.data[river.data[,1]>=start.time & river.data[,1]<=end.time,]
river.data = xts(river.data,order.by=river.data[,1] ,unique=T,tz="GMT")
river.data = river.data[.indexmin(river.data) %in% c(0:2,13:17,28:32,43:47,58:59),]
river.data = river.data[c('2016'),]
index(river.data) = as.POSIXct(round(as.numeric(index(river.data))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
river.data = river.data[!duplicated(.index(river.data)),]
##river.data = merge(river.data,time.index)
storage.mode(river.data)="numeric"

inland.data = xts(inland.data,order.by=inland.data[,1] ,unique=T,tz="GMT")
inland.data = inland.data[.indexmin(inland.data) %in% c(0:2,13:17,28:32,43:47,58:59),]
inland.data = inland.data[c('2016'),]
index(inland.data) = as.POSIXct(round(as.numeric(index(inland.data))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
inland.data = inland.data[!duplicated(.index(inland.data)),]
storage.mode(inland.data)="numeric"

thermal.data = xts(thermal.data,order.by=thermal.data[,1] ,unique=T,tz="GMT")
thermal.data = thermal.data[.indexmin(thermal.data) %in% c(0,15,30,45),]
thermal.data = thermal.data[c('2016'),]
index(thermal.data) = as.POSIXct(round(as.numeric(index(thermal.data))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
thermal.data = thermal.data[!duplicated(.index(thermal.data)),]
storage.mode(thermal.data)="numeric"

save(list=ls(),file="results/thermal.data.r")
