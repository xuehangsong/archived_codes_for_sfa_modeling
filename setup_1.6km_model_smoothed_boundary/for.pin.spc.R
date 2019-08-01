rm(list=ls())

well.name = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","3-18","4-9","4-7","SWS-1","NRG")

coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% well.name,]


start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.tick = seq(from=start.time,to=end.time,by="1 year")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600


load("results/well.gauge.level.2010_2016.r") 
load("results/well.level.2010_2016.r")
load("results/mass.well.level.2010_2016.r")




time1 = as.POSIXct("2013-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time2 = as.POSIXct("2014-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time3 = as.POSIXct("2014-04-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

seleceted.well = "2-2"
plot(time.index,well.level[seleceted.well,],type='l')
##plot(time.index,mass.well.level[seleceted.well,]-well.level[seleceted.well,],type='l')
lines(time.index,rep(0,length(simu.time)),col='red')
lines(c(time1,time1),c(-2,200),col="red",lwd=3)
lines(c(time2,time2),c(-2,200),col="red",lwd=3)
lines(c(time3,time3),c(-2,200),col="red",lwd=3)



seleceted.well = "2-2"
##plot(time.index,well.level[seleceted.well,],type='l')
plot(time.index,mass.well.level[seleceted.well,]-well.level[seleceted.well,],type='l')
lines(time.index,rep(0,length(simu.time)),col='red')
lines(c(time1,time1),c(-2,200),col="red",lwd=3)
lines(c(time2,time2),c(-2,200),col="red",lwd=3)
lines(c(time3,time3),c(-2,200),col="red",lwd=3)
