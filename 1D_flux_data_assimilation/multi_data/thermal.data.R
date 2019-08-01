rm(list=ls())
library(xts)
source("dainput/parameter.sh")

start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-08-25 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 mins")

data.file = "data/T3_thermistor_array.csv"
thermal.data = read.table(data.file,sep=",",header=TRUE,check.names=FALSE)
thermal.data[,1] = as.POSIXct(thermal.data[,1],format="%m/%d/%Y %H:%M",tz='GMT')
thermal.data = thermal.data[thermal.data[,1]>=start.time & thermal.data[,1]<=end.time,]


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
river.data = river.data[c('2016'),]
river.data = river.data[!duplicated(.index(river.data)),]
temp = names(river.data)
river.data = merge(river.data,time.index)
names(river.data) = temp


inland.data = xts(inland.data,order.by=inland.data[,1] ,unique=T,tz="GMT")
inland.data = inland.data[c('2016'),]
inland.data = inland.data[!duplicated(.index(inland.data)),]
temp = names(inland.data)
inland.data = merge(inland.data,time.index)
names(inland.data) = temp


thermal.data = xts(thermal.data,order.by=thermal.data[,1] ,unique=T,tz="GMT")
thermal.data = thermal.data[c('2016'),]
thermal.data = thermal.data[!duplicated(.index(thermal.data)),]
temp = names(thermal.data)
thermal.data = merge(thermal.data,time.index)
names(thermal.data) = temp

### change the order of column, prepare data for 1DtempPro
data.head = as.numeric(names(thermal.data))
data.head = sort(data.head,decreasing=TRUE)
data.head = tail(data.head,length(which(data.head<0))+1)
data.head = as.character(data.head)
thermal.data = thermal.data[,data.head]
names(thermal.data) = as.character(pmax(-as.numeric(names(thermal.data)),0))
nthermistor = ncol(thermal.data)


## remove the themistor data in low river stage
## avoid effects from solar radiation
low.level = which(river.data[,4]<104.9)
for (ilevel in low.level) {
    thermal.data[(ilevel-8):(ilevel+8),] = NA    
}

good.data = which(!is.na(rowSums(thermal.data)))
thermal.data = thermal.data[good.data,]
time.range = as.numeric(difftime(range(index(thermal.data))[2],
                                 range(index(thermal.data))[1],units="secs"))

nsegment = (time.range-spin_up) %/% time_window+1
simu.time = as.numeric(difftime(index(thermal.data),
                                index(thermal.data)[1],units="secs"))

restart.point = rep(1:nsegment)
for (isegment in 1:nsegment)
{
    restart.point[isegment] = which.min(abs((simu.time-spin_up)-(isegment-1)*time_window))
}
save(list=ls(),file="data/thermal.data.all.r")
save(list=c("nsegment","thermal.data","restart.point"),file="data/thermal.data.r")


