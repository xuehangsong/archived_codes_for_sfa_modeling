rm(list=ls())
load("results/mass.data.xts.r")

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600



slice.list = as.character(seq(318,326))
nslice = length(slice.list)
well.name = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","3-18","4-9","4-7","SWS-1","NRG")
nwell = length(well.name)

coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]

coord.well =  coord.data[rownames(coord.data) %in% well.name,]
coord.slice =  coord.data[rownames(coord.data) %in% slice.list,]

mass.level = array(NA,c(nslice,ntime))
rownames(mass.level) = slice.list
for (islice in slice.list) {
    mass.level[islice,] = mass.data.xts[[islice]][,"stage"]
}

mass.well.level = array(NA,c(nwell,ntime))
rownames(mass.well.level) = well.name

available.date = which(colSums(mass.level,na.rm=TRUE)>200)
for (itime in available.date) {
    mass.well.level[,itime] = approx(coord.slice[,2],mass.level[,itime],coord.well[,2])[[2]]
}

save(mass.well.level,file="results/mass.well.level.2010_2016.r")
