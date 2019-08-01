rm(list=ls())
library(xts)
coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
interp.time = seq(start.time,end.time,3600)



##for data from virtual.lib
data = read.csv("data/virtual.library/SWS-1.level.csv")
level.value =  data[["Elevation..m."]]
level.time =  data[["Date.Time"]]
level.time = as.POSIXct(level.time,format="%Y-%m-%d %H:%M:%S",tz="GMT")

level.value = level.value[which(level.time>=start.time & level.time<=end.time)]
level.time = level.time[which(level.time>=start.time & level.time<=end.time)]
level.xts = xts(level.value,order.by = level.time,unique=T,tz="GMT")
level.xts = level.xts[.indexmin(level.xts) %in% c(56:59,0:5)]
level.xts = level.xts[c('2010','2011','2012','2013','2014','2015')]
index(level.xts) = round(index(level.xts),units="hours")
level.xts = level.xts[!duplicated(.index(level.xts))]
level.xts = merge(level.xts,time.index)

level.lib = level.xts



##for data from velo
data = read.csv("data/velo/SWS-1_3var.csv")
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

level.velo = level.xts


load("results/mass.data.r")

mass.trim = list()
for (islice in names(mass.data))
{
     mass.trim[[islice]][["stage"]] = mass.data[[islice]][["stage"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]+1.039
     mass.trim[[islice]][["date"]] = mass.data[[islice]][["date"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]
     mass.trim[[islice]][["temperature"]] = mass.data[[islice]][["temperature"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]     
}
level.mass = (mass.trim[["323"]][["stage"]]+mass.trim[["324"]][["stage"]])/2

level.combined = level.velo
lib.gap = which(is.na(level.combined))
level.combined[is.na(level.combined)] = level.lib[is.na(level.combined)]
mass.gap = which(is.na(level.combined))
level.combined[is.na(level.combined)] = level.mass[is.na(level.combined)]

lib.gap = lib.gap[!lib.gap %in% mass.gap]


jpeg(paste("figures/mass.gap.fill.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,level.combined,pch=16,cex=0.2,
     )
points(time.index[lib.gap],level.lib[lib.gap],col="blue",cex=0.2,pch=16)
points(time.index[mass.gap],level.mass[mass.gap],col="red",cex=0.2,pch=16)

legend("topright",c("Velo Data","Virtual Library","MASS1"),col=c("black","blue","red"),pch=16)

dev.off()


slice.list = as.character(seq(318,326))
###slice.list = as.character(seq(320,323))

nslice = length(slice.list)
ntime = length(time.index)
gradient = rep(0,ntime)
simu.time = c(1:ntime-1)*3600
mass.gradient = array(ntime*nslice,c(nslice,ntime))
rownames(mass.gradient) = slice.list

for (i in slice.list) {
    mass.gradient[i,] = mass.trim[[i]][["stage"]]
}

a = lm(mass.gradient[,]~coord.data[slice.list,2])
gradient = a$coefficients[2,]

b=summary(a)
c=c()
for (i in 1:length(b)) {
    c[i]=b[[i]]$r.squared
}


jpeg(paste("figures/river.gradient.rquare.jpeg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,c,pch=16,cex=0.2,xlab="Time (year)",ylab="R^2")
dev.off()


DatumH_River = cbind(simu.time,
                     rep(coord.data["SWS-1",1],ntime),
                     rep(coord.data["SWS-1",2],ntime),
                     level.combined)
    
Gradients_River = cbind(simu.time,
                        rep(0,ntime),
                        gradient,
                        rep(0,ntime))

save(gradient,file="results/river.gradient.r.2010_2015.r")

save(level.combined,file="results/river.level.r.2010_2015.r")

write.table(DatumH_River,file=paste('DatumH_River_2010_2015.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_River,file=paste("Gradients_River_2010_2015.txt",sep=''),col.names=FALSE,row.names=FALSE)


