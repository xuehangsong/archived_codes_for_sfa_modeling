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

##temp.river = spc.temp.value[["NRG"]]
temp.river = spc.temp.value[["SWS-1"]]
temp.river = cbind(simu.time,temp.river)

##temp.inland = spc.temp.value[["2-2"]]
temp.inland = spc.temp.value[["2-3"]]
temp.inland = cbind(simu.time,temp.inland)

temp.s10 = spc.temp.value[["S10"]]
temp.s10 = cbind(simu.time,temp.s10)

condition.index = "Heat"
write.table(temp.river,file=paste('Temp_River_',condition.index,'.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(temp.inland,file=paste('Temp_Inland_',condition.index,'.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(temp.s10,file=paste('Temp_S10_',condition.index,'.txt',sep=""),col.names=FALSE,row.names=FALSE)


###temp.river = rep(25,length(temp.river))
###temp.inland = rep(25,length(temp.inland))

