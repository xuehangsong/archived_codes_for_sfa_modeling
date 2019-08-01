rm(list=ls())
load("results/mass.data.xts.r")

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600
mass.gradient = rep(NA,ntime)


slice.list = as.character(seq(318,326))
nslice = length(slice.list)

coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% slice.list,]
nwell = dim(coord.data)[1]
y = coord.data[slice.list,2]


mass.level = array(NA,c(nslice,ntime))
rownames(mass.level) = slice.list
for (islice in slice.list) {
    mass.level[islice,] = mass.data.xts[[islice]][,"stage"]
}

available.date = which(colSums(mass.level,na.rm=TRUE)>200)


mass.rsquared = rep(NA,ntime)
mass.lm = list()
mass.lm[[ntime]]=NA
for (itime in available.date) {
    mass.lm[[itime]]= lm(mass.level[,itime]~y)
    mass.gradient[itime] = mass.lm[[itime]]$coefficients[2]
    mass.rsquared[itime] = summary(mass.lm[[itime]])$r.squared
}
save(y,mass.level,mass.gradient,mass.rsquared,mass.lm,file="results/mass.gradient.2010_2016.r")






## mass.lm  = lm(mass.level[,available.date]~coord.data[slice.list,2])
## mass.summary = summary(mass.lm[[available.date]])

## mass.gradient[available.date] = mass.lm$coefficients[2,]
## mass.rsquared = rep(0,ntime)
## for (itime in available.date) {
##     mass.rsquared[itime]=mass.summary[[itime]]$r.squared
## }

