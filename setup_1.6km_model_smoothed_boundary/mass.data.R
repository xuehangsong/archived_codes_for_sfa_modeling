rm(list=ls())
library("xts")
data = read.table('data/proj.coord.dat')
rownames(data) = data[,3]

mass = read.csv('data/mass/coordinates.csv')
rownames(mass) = mass[,1]

slice.list = as.character(seq(318,326))
mass.data = list()
for (islice in slice.list) {
    mass.data[[islice]] = read.csv(paste("data/mass/mass1_",islice,".csv",sep=""))
}
names(mass.data) = slice.list

for (islice in slice.list) {
    mass.data[[islice]][["date"]] = as.POSIXct(mass.data[[islice]][["date"]],format="%Y-%m-%d %H:%M:%S",tz='GMT')
    mass.data[[islice]][["stage"]] = mass.data[[islice]][["stage"]]+1.039
}

save(mass.data,file="results/mass.data.r")


start.time = as.POSIXct("2008-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600


mass.data.xts = list()
for (islice in slice.list)
{
    mass.data.xts[[islice]] = xts(mass.data[[islice]],order.by=mass.data[[islice]][["date"]] ,unique=T,tz="GMT")

    mass.data.xts[[islice]] = mass.data.xts[[islice]][.indexmin(mass.data.xts[[islice]][,"date"]) %in% c(56:59,0:5)]
    mass.data.xts[[islice]] = mass.data.xts[[islice]][c("2008","2009",'2010','2011','2012','2013','2014','2015')]
    index(mass.data.xts[[islice]]) = round(index(mass.data.xts[[islice]]),units="hours")
    mass.data.xts[[islice]] = mass.data.xts[[islice]][!duplicated(.index(mass.data.xts[[islice]]))]
    mass.data.xts[[islice]] = merge(mass.data.xts[[islice]],time.index)
    
}

save(mass.data.xts,file="results/mass.data.xts.r")
save(mass.data.xts,file="results/mass.data.xts_2008_2015.r")
