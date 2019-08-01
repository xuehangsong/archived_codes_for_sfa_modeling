rm(list=ls())
library(xts)
load("results/thermal.data.r")

##load("results/ibutton.data.r")
start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-07-15 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

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
thermal.data[low.level,] = NA
good.data = which(!is.na(rowSums(thermal.data)))
thermal.data = thermal.data[good.data,]

fname ="splited_data/thermistor.whole.csv"
output.data = thermal.data[time.index>=start.time & time.index<=end.time,]
temp = rowSums(output.data)
output.data = output.data[!is.na(temp),]
output.data = as.matrix(output.data)
write.csv(output.data,file=fname,quote=FALSE)


fname ="splited_data/thermistor.march.csv"
start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-03-31 23:59:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
output.data = thermal.data[time.index>=start.time & time.index<=end.time,]
temp = rowSums(output.data)
output.data = output.data[!is.na(temp),]
output.data = as.matrix(output.data)
write.csv(output.data,file=fname,quote=FALSE)


fname ="splited_data/thermistor_1.csv"
start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-03-08 23:59:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
output.data = thermal.data[time.index>=start.time & time.index<=end.time,]
temp = rowSums(output.data)
output.data = output.data[!is.na(temp),]
output.data = as.matrix(output.data)
write.csv(output.data,file=fname,quote=FALSE)


level.data = cbind(river.data[,4],inland.data[,4])
colnames(level.data) = c("river","inland")
level.data = level.data[good.data,]
save(level.data,thermal.data,file="results/filtered.thermal.r")

