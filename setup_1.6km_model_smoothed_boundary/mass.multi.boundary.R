rm(list=ls())
library("xts")
load("results/mass.data.xts.r")

## start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
## end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

start.time = as.POSIXct("2012-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 24:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

start.time = as.POSIXct("2008-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")


slice.list = names(mass.data.xts)
for (islice in slice.list)
{
    mass.data.xts[[islice]] = mass.data.xts[[islice]][index(mass.data.xts[[islice]])>=start.time,]
    mass.data.xts[[islice]] = mass.data.xts[[islice]][index(mass.data.xts[[islice]])<=end.time,]    
}


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
names(y)=rownames(coord.data)

mass.level = array(NA,c(nslice,ntime))
rownames(mass.level) = slice.list
for (islice in slice.list) {
    mass.level[islice,] = mass.data.xts[[islice]][,"stage"]
}

available.date = which(colSums(mass.level,na.rm=TRUE)>200)


mass.gradient = array(NA,c(nslice,ntime))
rownames(mass.gradient) = slice.list
for (islice in 1:(nslice-1))
{
    mass.gradient[islice,] = (mass.level[islice+1,]-mass.level[islice,])/(y[islice+1]-y[islice])
}


for (islice in 1:(nslice-1))
{
    Gradients = cbind(simu.time,
                      rep(0,ntime),
                      mass.gradient[islice,],
                      rep(0,ntime))
    
    DatumH = cbind(simu.time,
                   rep(coord.data[islice,1],ntime),
                   rep(coord.data[islice,2],ntime),                                         
                   mass.level[islice,])
    
    write.table(DatumH,file=paste('DatumH_River_',slice.list[islice],'.txt',sep=""),col.names=FALSE,row.names=FALSE)
    write.table(Gradients,file=paste("Gradients_River_",slice.list[islice],".txt",sep=''),col.names=FALSE,row.names=FALSE)
    
    
}



