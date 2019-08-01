rm(list=ls())
library(xts)
coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600


load("results/mass.data.r")

mass.trim = list()
for (islice in names(mass.data))
{
     mass.trim[[islice]][["stage"]] = mass.data[[islice]][["stage"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]+1.039
     mass.trim[[islice]][["date"]] = mass.data[[islice]][["date"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]
     mass.trim[[islice]][["temperature"]] = mass.data[[islice]][["temperature"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]     
}

level.river = mass.trim[["321"]][["stage"]]

DatumH_River = cbind(simu.time,
                     rep(143.2,ntime),
                     rep(0.5,ntime),
                     level.river)
    
Gradients_River = cbind(simu.time,
                        rep(0,ntime),
                        rep(0,ntime),
                        rep(0,ntime))
write.table(DatumH_River,file=paste('DatumH_River_2010_2015.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_River,file=paste("Gradients_River_2010_2015.txt",sep=''),col.names=FALSE,row.names=FALSE)

jpeg(paste("figures/river.gap.fill.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,level.river,pch=16,cex=0.2,col="red",
     xlab="Time (year)",
     ylab="Water level (m)",     
     )

legend("topright",c("MASS1"),col=c("red"),pch=16)

dev.off()

save(level.river,file="results/2d.river.level.r.2010_2015.r")






krig.level = unlist(read.table("data/BC_Xuehang.txt"))


## ##2-3
data = read.csv("data/velo/399-2-3_3var.csv")
level.value =  data[["WL.m."]]
level.time =  data[["Date.Time.PST."]]
level.time = as.POSIXct(level.time,format= "%d-%b-%Y %H:%M:%S",tz="GMT")

level.value = level.value[which(level.time>=start.time & level.time<=end.time)]
level.time = level.time[which(level.time>=start.time & level.time<=end.time)]
level.xts = xts(level.value,order.by = level.time,unique=T,tz="GMT")
level.xts = level.xts[.indexmin(level.xts) %in% c(56:59,0:5)]
level.xts = level.xts[c('2010','2011','2012','2013','2014','2015')]
index(level.xts) = round(index(level.xts),units="hours")
level.xts = level.xts[!duplicated(.index(level.xts))]
level.xts = merge(level.xts,time.index)

level.2_3 = level.xts


level.inland = as.numeric(level.2_3)
well.gap = which(is.na(level.inland))
level.inland[well.gap] = krig.level[well.gap]


DatumH_Inland = cbind(simu.time,
                     rep(0,ntime),
                     rep(0.5,ntime),
                     level.inland)
    
Gradients_Inland = cbind(simu.time,
                        rep(0,ntime),
                        rep(0,ntime),
                        rep(0,ntime))
write.table(DatumH_Inland,file=paste('DatumH_Inland_2010_2015.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_Inland,file=paste("Gradients_Inland_2010_2015.txt",sep=''),col.names=FALSE,row.names=FALSE)

save(level.inland,file="results/2d.inland.level.r.2010_2015.r")


jpeg(paste("figures/inland.gap.fill.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,level.inland,pch=16,cex=0.2,col="black",
     xlab="Time (year)",
     ylab="Water level (m)",     
     )
points(time.index[well.gap],krig.level[well.gap],col="red",cex=0.5,pch=16)

legend("topright",c("2-3 Data","Kriging"),col=c("black","red"),pch=16)

dev.off()


jpeg(paste("figures/2d_inland_river.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,level.river,type="l",col="blue",
     xlab="Time (year)",
     ylab="Water level (m)",     
     )
lines(time.index,level.inland,col="black")

legend("topright",c("River","Inland"),col=c("blue","black"),lty=1)

dev.off()





## ##2-2
## data = read.csv("data/velo/399-2-2_3var.csv")
## level.value =  data[["WL.m"]]
## level.time =  data[["Date.Time.PST"]]
## level.time = as.POSIXct(level.time,format= "%d-%b-%Y %H:%M:%S",tz="GMT")

## level.value = level.value[which(level.time>=start.time & level.time<=end.time)]
## level.time = level.time[which(level.time>=start.time & level.time<=end.time)]
## level.xts = xts(level.value,order.by = level.time,unique=T,tz="GMT")
## level.xts = level.xts[.indexmin(level.xts) %in% c(56:59,0:5)]
## level.xts = level.xts[c('2010','2011','2012','2013','2014','2015')]
## index(level.xts) = round(index(level.xts),units="hours")
## level.xts = level.xts[!duplicated(.index(level.xts))]
## level.xts = merge(level.xts,time.index)

## level.2_2 = level.xts

## ###2-1
## data = read.csv("data/velo/399-2-1_3var.csv")
## level.value =  data[["WL.m"]]
## level.time =  data[["Date.Time.PST"]]
## level.time = as.POSIXct(level.time,format= "%d-%b-%Y %H:%M:%S",tz="GMT")

## level.value = level.value[which(level.time>=start.time & level.time<=end.time)]
## level.time = level.time[which(level.time>=start.time & level.time<=end.time)]
## level.xts = xts(level.value,order.by = level.time,unique=T,tz="GMT")
## level.xts = level.xts[.indexmin(level.xts) %in% c(56:59,0:5)]
## level.xts = level.xts[c('2010','2011','2012','2013','2014','2015')]
## index(level.xts) = round(index(level.xts),units="hours")
## level.xts = level.xts[!duplicated(.index(level.xts))]
## level.xts = merge(level.xts,time.index)

## level.2_1 = level.xts



## ###1-7
## data = read.csv("data/velo/399-1-7_3var.csv")
## level.value =  data[["WL.m"]]
## level.time =  data[["Date.Time.PST"]]
## level.time = as.POSIXct(level.time,format= "%d-%b-%Y %H:%M:%S",tz="GMT")

## level.value = level.value[which(level.time>=start.time & level.time<=end.time)]
## level.time = level.time[which(level.time>=start.time & level.time<=end.time)]
## level.xts = xts(level.value,order.by = level.time,unique=T,tz="GMT")
## level.xts = level.xts[.indexmin(level.xts) %in% c(56:59,0:5)]
## level.xts = level.xts[c('2010','2011','2012','2013','2014','2015')]
## index(level.xts) = round(index(level.xts),units="hours")
## level.xts = level.xts[!duplicated(.index(level.xts))]
## level.xts = merge(level.xts,time.index)

## level.1_7 = level.xts



## level.combined = level.2_3
## level.combined[is.na(level.combined)] = level.2_2[is.na(level.combined)]
## level.combined[is.na(level.combined)] = level.2_1[is.na(level.combined)]
## level.combined[is.na(level.combined)] = level.1_7[is.na(level.combined)]

## Gradients_Inland = cbind(simu.time,
##                         rep(0,ntime),
##                         rep(0,ntime),
##                         rep(0,ntime))
