rm(list=ls())
library(xts)
load("results/level.data.r")
level.value = obs.value 
level.time = obs.time

level.xts = list()
for (i in names(level.value)) {
    level.xts[[i]] = xts(level.value[[i]],order.by = level.time[[i]],unique=T,tz="GMT")
}


for (i in names(level.value)) {
    level.xts[[i]] = level.xts[[i]][.indexmin(level.xts[[i]]) %in% c(56:59,0:5)]
    level.xts[[i]] = level.xts[[i]][c('2013','2014','2015','2016')]
    index(level.xts[[i]]) = round(index(level.xts[[i]]),units="hours")
    level.xts[[i]] = level.xts[[i]][!duplicated(.index(level.xts[[i]]))]
}

start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
interp.time = seq(start.time,end.time,3600)

for (i in names(level.value)) {
    level.xts[[i]] = merge(level.xts[[i]],time.index)
}






load("results/temp.data.r")
temp.value = obs.value 
temp.time = obs.time

temp.xts = list()
for (i in names(temp.value)) {
    temp.xts[[i]] = xts(temp.value[[i]],order.by = temp.time[[i]],unique=T,tz="GMT")
}



for (i in names(temp.value)) {
    temp.xts[[i]] = temp.xts[[i]][.indexmin(temp.xts[[i]]) %in% c(56:59,0:5)]
    temp.xts[[i]] = temp.xts[[i]][c('2013','2014','2015','2016')]
    index(temp.xts[[i]]) = round(index(temp.xts[[i]]),units="hours")
    temp.xts[[i]] = temp.xts[[i]][!duplicated(.index(temp.xts[[i]]))]
}

start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
interp.time = seq(start.time,end.time,3600)

for (i in names(temp.value)) {
    temp.xts[[i]] = merge(temp.xts[[i]],time.index)
}





interp.data=c("level.xts","temp.xts",
              "start.time","end.time",
              "interp.time"
              )
save(list=interp.data,file="results/interp.data.r")
