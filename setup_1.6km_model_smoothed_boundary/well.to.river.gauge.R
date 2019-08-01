rm(list=ls())
load("results/well.data.xts.r")

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600

well.name = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","3-18","4-9","4-7")
gauge.name = c("SWS-1","NRG")
nwell = length(well.name)
ngauge = length(gauge.name)

coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]

coord.well =  coord.data[rownames(coord.data) %in% well.name,]
coord.gauge =  coord.data[rownames(coord.data) %in% gauge.name,]

well.level = array(NA,c(nwell,ntime))
rownames(well.level) = well.name
for (iwell in well.name) {
    well.level[iwell,] = well.data.xts[[iwell]][,"level"]
}

well.gauge.level = array(NA,c(ngauge,ntime))
rownames(well.gauge.level) = gauge.name

available.date = which(colSums(well.level,na.rm=TRUE)>200)
for (itime in available.date) {
    well.gauge.level[,itime] = approx(coord.well[,2],well.level[,itime],coord.gauge[,2])[[2]]
}

save(well.gauge.level,file="results/well.gauge.level.2010_2016.r")
