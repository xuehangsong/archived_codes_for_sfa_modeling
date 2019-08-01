rm(list=ls())
load("results/interp.data.r")

model.coord = read.table("data/model.coord.dat")
well.x = model.coord[,1]
well.y = model.coord[,2]
well.list = model.coord[,3]
names(well.x)=well.list
names(well.y)=well.list

time.length = as.numeric(difftime(end.time,start.time,units='secs'))
simu.time = seq(0,time.length,3600)
ntime = length(simu.time)

DatumH_West = cbind(simu.time,rep(well.x["2-2"],ntime),rep(well.y["2-2"],ntime),
                    level.value[["2-2"]])
Gradients_West = cbind(simu.time,rep(0,ntime),rep(0,ntime),rep(0,ntime))

DatumH_River = cbind(simu.time,rep(well.x["SWS-1"],ntime),rep(well.y["SWS-1"],ntime),
(level.value[["2-2"]]+level.value[["SWS-1"]]-level.value[["4-9"]]))
Gradients_River = cbind(simu.time,rep(0,ntime),rep(0,ntime),rep(0,ntime))

condition.index = 3
save(DatumH_West,file=paste("results/DatumH_West_",condition.index,'.r',sep=''))
save(DatumH_River,file=paste("results/DatumH_River_",condition.index,'.r',sep=''))
write.table(DatumH_West,file=paste('DatumH_West_',condition.index,".txt",sep=""),col.names=FALSE,row.names=FALSE)
write.table(DatumH_River,file=paste('DatumH_River_',condition.index,'.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_West,file=paste('Gradients_West_',condition.index,".txt",sep=''),col.names=FALSE,row.names=FALSE)
write.table(Gradients_River,file=paste("Gradients_River_",condition.index,".txt",sep=''),col.names=FALSE,row.names=FALSE)


###save(output.time,file=paste("results/output.time",condition.index,'.r',sep=''))
