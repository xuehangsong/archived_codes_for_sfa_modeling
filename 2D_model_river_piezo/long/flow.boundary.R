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


Gradients_River = cbind(simu.time,
                        rep(0,ntime),
                        rep(0,ntime),                        
                        rep(0,ntime))

Gradients_Inland = cbind(simu.time,
                         rep(0,ntime),
                         rep(0,ntime),                         
                         rep(0,ntime))

level.river = level.value[["SWS-1"]]+0.05


## level.river = level.value[["NRG"]]+(0.5-well.y["NRG"])*
##     (level.value[["SWS-1"]]-level.value[["NRG"]])/(well.y["SWS-1"]-well.y["NRG"])


DatumH_River = cbind(simu.time,
                     rep(143.2,ntime),
                     rep(0.5,ntime),
                     level.river)

##level.inland = unlist(read.table("data/krig.inland.txt"))
level.inland = level.value[["2-3"]]


DatumH_Inland = cbind(simu.time,
                      rep(0,ntime),
                      rep(0.5,ntime),
                      level.inland)

## DatumH_River = DatumH_River[1:1063,]
## Gradients_River = Gradients_River[1:1063,]
## DatumH_Inland = DatumH_Inland[1:1063,]
## Gradients_Inland = Gradients_Inland[1:1063,]


condition.index = "Heat"
save(DatumH_River,file=paste("results/DatumH_River_",condition.index,'.r',sep=''))
write.table(DatumH_River,file=paste('DatumH_River_',condition.index,'.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_River,file=paste("Gradients_River_",condition.index,".txt",sep=''),col.names=FALSE,row.names=FALSE)
write.table(DatumH_Inland,file=paste('DatumH_Inland_',condition.index,'.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_Inland,file=paste("Gradients_Inland_",condition.index,".txt",sep=''),col.names=FALSE,row.names=FALSE)
