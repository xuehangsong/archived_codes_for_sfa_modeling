rm(list=ls())
library(xts)
coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600


data = read.csv("data/velo/399-2-3_3var.csv")
temp.value =  data[["Temperature.degC."]]
temp.time =  data[["Date.Time.PST."]]
temp.time = as.POSIXct(temp.time,format= "%d-%b-%Y %H:%M:%S",tz="GMT")

temp.value = temp.value[which(temp.time>=start.time & temp.time<=end.time)]
temp.time = temp.time[which(temp.time>=start.time & temp.time<=end.time)]
temp.xts = xts(temp.value,order.by = temp.time,unique=T,tz="GMT")
temp.xts = temp.xts[.indexmin(temp.xts) %in% c(56:59,0:5)]
temp.xts = temp.xts[c('2010','2011','2012','2013','2014','2015')]
index(temp.xts) = round(index(temp.xts),units="hours")
temp.xts = temp.xts[!duplicated(.index(temp.xts))]
temp.xts = merge(temp.xts,time.index)

temp.2_3= temp.xts
