rm(list=ls())
load("results/well.data.xts.r")

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600
inland.gradient = rep(NA,ntime)

well.name = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","3-18","4-9","4-7")
## well.name = c("1-57","2-2","2-3","2-1","3-9","3-10","3-18")
## well.name = c("2-2","2-3"1)

##inland gradient
coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% well.name,]
nwell = dim(coord.data)[1]
y = coord.data[well.name,2]

inland.level = array(ntime*nwell,c(nwell,ntime))
rownames(inland.level) = well.name
for (iwell in well.name) {
    inland.level[iwell,] = well.data.xts[[iwell]][,"level"]
}

available.date = which(colSums(inland.level,na.rm=TRUE)>200)

inland.rsquared = rep(NA,ntime)
inland.lm = list()
inland.lm[[ntime]]=NA
for (itime in available.date) {
    inland.lm[[itime]]= lm(inland.level[,itime]~y)
    inland.gradient[itime] = inland.lm[[itime]]$coefficients[2]
    inland.rsquared[itime] = summary(inland.lm[[itime]])$r.squared
}
save(inland.level,inland.gradient,inland.rsquared,inland.lm,file="results/inland.gradient.2010_2016.r")
