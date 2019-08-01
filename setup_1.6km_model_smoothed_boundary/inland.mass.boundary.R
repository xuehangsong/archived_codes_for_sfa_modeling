rm(list=ls())
load("results/well.data.xts.r")

## start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
## end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")


start.time = as.POSIXct("2012-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 24:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")



time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600
inland.gradient = rep(NA,ntime)

well.name = c("SWS-1")

coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% well.name,]
nwell = dim(coord.data)[1]
y = coord.data[well.name,2]

load("results/inland.gradient.2010_2016.r")

Gradients = cbind(simu.time,
                  rep(0,ntime),
                  inland.gradient,
                  rep(0,ntime))

DatumH = cbind(simu.time,
               rep(coord.data["SWS-1",1],ntime),
               rep(coord.data["SWS-1",2],ntime),
               well.data.xts[["SWS-1"]])


write.table(DatumH,file=paste('DatumH_River_inland.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients,file=paste("Gradients_River_inland.txt",sep=''),col.names=FALSE,row.names=FALSE)
