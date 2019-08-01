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

DatumH_River = cbind(simu.time,
                    rep(well.x["SWS-1"],ntime),
                    rep(well.y["SWS-1"],ntime),
                    level.value[["SWS-1"]])
Gradients_River = cbind(simu.time,
                        rep(0,ntime),
                        (level.value[["SWS-1"]]-level.value[["NRG"]])/(well.y["SWS-1"]-well.y["NRG"]),
                        rep(0,ntime))
Gradients_Inland = cbind(simu.time,
                        rep(0,ntime),
                        (level.value[["4-9"]]-level.value[["2-2"]])/(well.y["4-9"]-well.y["2-2"]),
                        rep(0,ntime))


stop()
DatumH_River = DatumH_River[1:1063,]
Gradients_River = Gradients_River[1:1063,]

condition.index = "2.5d"
save(DatumH_River,file=paste("results/DatumH_River_",condition.index,'.r',sep=''))
write.table(DatumH_River,file=paste('DatumH_River_',condition.index,'.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_River,file=paste("Gradients_River_",condition.index,".txt",sep=''),col.names=FALSE,row.names=FALSE)

