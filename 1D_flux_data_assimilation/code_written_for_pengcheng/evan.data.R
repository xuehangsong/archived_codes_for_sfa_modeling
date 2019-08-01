rm(list=ls())
sp9a19.data = read.table("evan/SP9a.19.csv",header=TRUE,check.names=FALSE,sep=",")
sp9a86.data = read.table("evan/SP9a.86.csv",header=TRUE,check.names=FALSE,sep=",")
sp9a142.data = read.table("evan/SP9a.142.csv",header=TRUE,check.names=FALSE,sep=",")
river.data = read.table("evan/River.csv",header=TRUE,check.names=FALSE,sep=",")
river.level = read.table("evan/river_level.csv",header=TRUE,check.names=FALSE,sep=",")
inland.level = read.table("evan/inland_level.csv",header=TRUE,check.names=FALSE,sep=",")

sp9a19.data[,1] = as.POSIXct(sp9a19.data[,1],format="%m/%d/%y %H:%M",tz='GMT')
sp9a86.data[,1] = as.POSIXct(sp9a86.data[,1],format="%m/%d/%y %H:%M",tz='GMT')
sp9a142.data[,1] = as.POSIXct(sp9a142.data[,1],format="%m/%d/%y %H:%M",tz='GMT')
river.data[,3] = as.POSIXct(river.data[,3],format="%m/%d/%y %H:%M",tz='GMT')
river.level[,1] = as.POSIXct(river.level[,1],format="%m/%d/%Y %H:%M",tz='GMT')
inland.level[,1] = as.POSIXct(inland.level[,1],format="%m/%d/%Y %H:%M",tz='GMT')


## plot(sp9a19.data[,1],sp9a19.data[,3],type="l",ylim=c(0,25))
## lines(sp9a86.data[,1],sp9a86.data[,3],col="orange")
## lines(sp9a142.data[,1],sp9a142.data[,3],col="red")
## lines(river.data[,3],river.data[,6],col="blue")

save(list=ls(),file="results/evan.data.r")
