rm(list=ls())
library(xts)

file.name = list()
time.col.name = list()
level.col.name = list()
temp.col.name = list()
spc.col.name = list()
time.format = list()

coord.data = read.table("data/proj.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% c("1-10A","1-1","1-16A","1-57","2-2",
                                                      "2-3","2-1","3-9","3-10","3-18",
                                                      "4-9","4-7","SWS-1","NRG"),]

obs.list = c(rownames(coord.data))

for (i.obs in obs.list)
{
    file.name[[i.obs]] = list.files("data/velo/",pattern=paste(i.obs,"_3var.csv",sep=''))
    file.name[[i.obs]] = paste("data/velo/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "Date.Time.PST+"
    level.col.name[[i.obs]] = "WL.m"
    temp.col.name[[i.obs]] = "degC"
    spc.col.name[[i.obs]] = "SpC"
    time.format[[i.obs]] = "%d-%b-%Y %H:%M:%S"
}

obs.data = list()
well.data = list()

for (i.obs in obs.list)
{
     print(file.name[[i.obs]])
     obs.data[[i.obs]] = read.csv(file.name[[i.obs]],stringsAsFactors=FALSE)

     well.data[[i.obs]] = list()
     well.data[[i.obs]][["time"]] = obs.data[[i.obs]][, grep(pattern=time.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
     well.data[[i.obs]][["level"]] = obs.data[[i.obs]][, grep(pattern=level.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
     well.data[[i.obs]][["temperature"]] = obs.data[[i.obs]][, grep(pattern=temp.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
     well.data[[i.obs]][["spc"]] = obs.data[[i.obs]][, grep(pattern=spc.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]     
     well.data[[i.obs]][["time"]]= as.POSIXct(well.data[[i.obs]][["time"]],format=time.format[[i.obs]],tz='GMT')

     well.data[[i.obs]] = as.data.frame(well.data[[i.obs]])
}

save(well.data,file="results/well.data.r")


start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600


well.data.xts = list()
for (i.obs in obs.list)
{
    well.data.xts[[i.obs]] = xts(well.data[[i.obs]],order.by=well.data[[i.obs]][["time"]] ,unique=T,tz="GMT")

    well.data.xts[[i.obs]] = well.data.xts[[i.obs]][.indexmin(well.data.xts[[i.obs]][,"time"]) %in% c(56:59,0:5)]
    well.data.xts[[i.obs]] = well.data.xts[[i.obs]][c('2010','2011','2012','2013','2014','2015','2016')]
    index(well.data.xts[[i.obs]]) = round(index(well.data.xts[[i.obs]]),units="hours")
    well.data.xts[[i.obs]] = well.data.xts[[i.obs]][!duplicated(.index(well.data.xts[[i.obs]]))]

    well.data.xts[[i.obs]] = merge(well.data.xts[[i.obs]],time.index)
    
}

save(well.data.xts,file="results/well.data.xts.r")
