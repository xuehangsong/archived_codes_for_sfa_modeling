rm(list=ls())
library("xts")
library("signal")

model.dir = "/Users/song884/remote/reach/Inputs/"
#load("/Users/song884/remote/reach/results/geoframework.r")
data.dir = "/Users/song884/remote/reach/data/"
data.dir = "/Users/song884/remote/reach/data/"
results.dir = "/Users/song884/remote/reach/results/"
load(paste(results.dir,"mass.data.xts.r",sep=""))

mass.coord = read.csv(paste(data.dir,"MASS1/coordinates.csv",sep=""))
mass.coord[,"easting"] = mass.coord[,"easting"]-model_origin[1]
mass.coord[,"northing"] = mass.coord[,"northing"]-model_origin[2]
rownames(mass.coord) = mass.coord[,1]

start.time = as.POSIXct("2007-03-28 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

slice.list = names(mass.data.xts)
nslice = length(slice.list)
for (islice in slice.list)
{
    mass.data.xts[[islice]] = mass.data.xts[[islice]][
        index(mass.data.xts[[islice]])>=start.time,]
    mass.data.xts[[islice]] = mass.data.xts[[islice]][
        index(mass.data.xts[[islice]])<=end.time,]    
}


time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600
mass.gradient = rep(NA,ntime)


mass.level = array(NA,c(nslice,ntime))
rownames(mass.level) = slice.list
for (islice in slice.list) {
    mass.level[islice,] = mass.data.xts[[islice]][,"stage"]
}

available.date = which(colSums(mass.level,na.rm=TRUE)>200)

#-----------------------------smooth river stage-------------------------------##
nwindows = 6 #hour？
dt = 3600
filt = Ma(rep(1/nwindows,nwindows))
new.mass.level = array(NA,c(nslice,ntime+1)) #moving average (ma) add 1 extra time
for (islice in 1:nslice)
{
    print(islice)
    ori_time = simu.time
    ori_value = mass.level[islice,]
    ma_value = filter(filt,ori_value)
    ma_time = ori_time-dt*(nwindows-1)/2 # ma_time offset by dt/2
    ma_value = tail(ma_value,-nwindows)
    ma_time = tail(ma_time,-nwindows)
    ma_value = c(ori_value[ori_time<min(ma_time)],ma_value)
    ma_time = c(ori_time[ori_time<min(ma_time)],ma_time)
    ma_value = c(ma_value,ori_value[ori_time>max(ma_time)])
    ma_time = c(ma_time,ori_time[ori_time>max(ma_time)])
    new.mass.level[islice,] = ma_value
}
mass.level = new.mass.level
simu.time = ma_time
ntime = length(simu.time)
#-----------------------------smooth river stage-------------------------------##

mass.gradient.x = array(NA,c(nslice,ntime))
mass.gradient.y = array(NA,c(nslice,ntime))
rownames(mass.gradient.y) = slice.list
rownames(mass.gradient.x) = slice.list
for (islice in 1:(nslice-1))
{
    distance = sqrt((mass.coord[islice+1,
                                "northing"]-mass.coord[islice,"northing"])^2 +
                    (mass.coord[islice+1,"easting"]-mass.coord[islice,"easting"])^2)
    ## calculate grad based on x-direction
    mass.gradient.x[islice,] = (mass.level[islice+1,]-mass.level[islice,]
    )/distance*(mass.coord[islice+1,"easting"]-mass.coord[islice,"easting"])/distance   

    ## calculate grad based on y-direction    
    mass.gradient.y[islice,] = (mass.level[islice+1,]-mass.level[islice,]
    )/distance*(mass.coord[islice+1,"northing"]-mass.coord[islice,"northing"])/distance 
}

 
for (islice in 1:(nslice-1))
{
    Gradients = cbind(simu.time,
                      mass.gradient.x[islice,],
                      mass.gradient.y[islice,],
                      rep(0,(ntime)))
    
    DatumH = cbind(simu.time,
                   rep(mass.coord[islice,"easting"],ntime),
                   rep(mass.coord[islice,"northing"],ntime),
                   mass.level[islice,])

    write.table(DatumH,file=paste(model.dir,
                                  'bc_smooth/DatumH_Mass1_',
                                  slice.list[islice],'.txt',sep=""),
                col.names=FALSE,row.names=FALSE)
    write.table(Gradients,file=paste(model.dir,
                                     "/bc_smooth/Gradients_Mass1_",
                                     slice.list[islice],".txt",sep=''),
                col.names=FALSE,row.names=FALSE)
}
