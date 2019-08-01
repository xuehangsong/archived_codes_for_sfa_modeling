rm(list=ls())
load("results/well.data.xts.r")

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600
river.gradient = rep(NA,ntime)

well.name = c("SWS-1","NRG")

coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% well.name,]
nwell = dim(coord.data)[1]
y = coord.data[well.name,2]

river.level = array(ntime*nwell,c(nwell,ntime))
rownames(river.level) = well.name
for (iwell in well.name) {
    river.level[iwell,] = well.data.xts[[iwell]][,"level"]
}

available.date = which(colSums(river.level,na.rm=TRUE)>200)

river.rsquared = rep(NA,ntime)
river.lm = list()
river.lm[[ntime]]=NA
for (itime in available.date) {
    river.lm[[itime]]= lm(river.level[,itime]~y)
    river.gradient[itime] = river.lm[[itime]]$coefficients[2]
    river.rsquared[itime] = summary(river.lm[[itime]])$r.squared
}
save(river.gradient,river.rsquared,river.lm,file="results/river.gradient.2010_2016.r")
