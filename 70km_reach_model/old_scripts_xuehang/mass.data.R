rm(list=ls())
library("xts")
load("/Users/song884/Dropbox/Reach_scale_model/results/geoframework.r")
data.dir = "/Users/song884/Dropbox/Reach_scale_model/data/"
data.dir = "/Users/song884/remote/sbr_sfa/Campaign A/Reach scale models/data/"
results.dir = "/Users/song884/Dropbox/Reach_scale_model/results/"

## start.time = as.POSIXct("2005-03-29 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
start.time = as.POSIXct("2007-03-28 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

mass.coord = read.csv(paste(data.dir,"MASS1/coordinates.csv",sep=""))
mass.coord[,"easting"] = mass.coord[,"easting"]-model_origin[1]
mass.coord[,"northing"] = mass.coord[,"northing"]-model_origin[2]

slice.list = as.character(mass.coord[,1])

#slice.list = c("328","329","330","331")  #--------------------------------------------

mass.data = list()
for (islice in slice.list) {
    print(islice)
    mass.data[[islice]] = read.csv(paste(data.dir,"MASS1/transient_1976_2016/mass1_",
                                         islice,".csv",sep=""))
}
names(mass.data) = slice.list

for (islice in slice.list) {
    print(islice)
    mass.data[[islice]][["date"]] =
        as.POSIXct(mass.data[[islice]][["date"]],format="%Y-%m-%d %H:%M:%S",tz='GMT')
    mass.data[[islice]][["stage"]] = mass.data[[islice]][["stage"]]+1.039
}
#save(mass.data,file=paste(results.dir,"mass.data.r",sep=""))



time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600

mass.data.xts = list()
for (islice in slice.list)
{
    print(islice)
    mass.data.xts[[islice]] = xts(mass.data[[islice]],
                                  order.by=mass.data[[islice]][["date"]] ,unique=T,tz="GMT")

    mass.data.xts[[islice]] = mass.data.xts[[islice]][
        .indexmin(mass.data.xts[[islice]][,"date"]) %in% c(56:59,0:5)]
    ## mass.data.xts[[islice]] = mass.data.xts[[islice]][
    ##     c("2009",'2010','2011','2012','2013','2014','2015')]
    index(mass.data.xts[[islice]]) = round(index(mass.data.xts[[islice]]),units="hours")
    mass.data.xts[[islice]] = mass.data.xts[[islice]][
        !duplicated(.index(mass.data.xts[[islice]]))]
    mass.data.xts[[islice]] = merge(mass.data.xts[[islice]],time.index)
    
}

save(mass.data.xts,file=paste(results.dir,"mass.data.xts.r",sep=""))
