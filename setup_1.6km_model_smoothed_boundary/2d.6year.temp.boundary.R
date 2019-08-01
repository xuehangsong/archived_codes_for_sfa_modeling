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

temp.mass = mass.trim[["321"]][["temperature"]]





## ##sws-1
data = read.csv("data/velo/SWS-1_3var.csv")
temp.value =  data[["Temperature.degC."]]
temp.time =  data[["Date.Time.PST."]]
temp.time = as.POSIXct(temp.time,format= "%d-%b-%Y %H:%M:%S",tz="GMT")

temp.value = temp.value[which(temp.time>=start.time & temp.time<=end.time)]
temp.time = temp.time[which(temp.time>=start.time & temp.time<=end.time)]
temp.xts = xts(temp.value,order.by = temp.time,unique=T,tz="GMT")
temp.xts = temp.xts[.indexmin(temp.xts) %in% c(56:59,0:5)]
temp.xts = temp.xts[c('2010','2011','2012','2013','2014','2015')]
index(temp.xts) = round(index(temp.xts),units="hours")
temp.xts = temp.xts[!duplicated(.index(temp.xts))]
temp.xts = merge(temp.xts,time.index)

temp.sws1 = temp.xts

temp.river = as.numeric(temp.sws1)
river.gap = which(is.na(temp.river))
temp.river[river.gap] = temp.mass[river.gap]



jpeg(paste("figures/2d.river.temp.gap.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,temp.river,pch=16,cex=0.2,col="blue",
     xlab="Time (year)",
     ylab="Temperature (DegC)"
     )
points(time.index[river.gap],temp.river[river.gap],col="red",cex=0.2,pch=16)

legend("topright",c("SWS-1","MASS1"),col=c("blue","red"),pch=16)

dev.off()







## ##2-3
data = read.csv("data/velo/399-2-3_3var.csv")
temp.value =  data[["Temperature.degC."]]
temp.time =  data[["Date.Time.PST."]]
temp.time = as.POSIXct(temp.time,format= "%d-%b-%Y %H:%M:%S",tz="GMT")

temp.value = temp.value[which(temp.time>=start.time & temp.time<=end.time)]
temp.time = temp.time[which(temp.time>=start.time & temp.time<=end.time)]
temp.xts = xts(temp.value,order.by = temp.time,unique=T,tz="GMT")
temp.xts = temp.xts[.indexmin(temp.xts) %in% c(56:59,0:5)]
temp.xts = temp.xts[c('2010','2011','2012','2013','2014','2015')]
index(temp.xts) = round(index(temp.xts),units="hours")
temp.xts = temp.xts[!duplicated(.index(temp.xts))]
temp.xts = merge(temp.xts,time.index)

temp.2_3= temp.xts

temp.inland = as.numeric(temp.2_3)
inland.gap = which(is.na(temp.inland))
temp.inland = na.approx(temp.inland,simu.time,rule=2)



jpeg(paste("figures/2d.inland.temp.gap.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,temp.inland,pch=16,cex=0.2,col="black",
     xlab="Time (year)",
     ylab="Temperature (DegC)"
     )
points(time.index[inland.gap],temp.inland[inland.gap],col="red",cex=0.2,pch=16)

legend("bottomright",c("SWS-1","Interpolation"),col=c("black","red"),pch=16)

dev.off()



jpeg(paste("figures/2d_temp.inland_river.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,temp.river,type="l",col="blue",
     xlab="Time (year)",
     ylab="Temperature (DegC)"
     )
lines(time.index,temp.inland,col="black")

legend("topright",c("River","Inland"),col=c("blue","black"),lty=1)

dev.off()




temp.river = cbind(simu.time,temp.river)
temp.inland = cbind(simu.time,temp.inland)

write.table(temp.river,file=paste('Temp_River_2010_2015.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(temp.inland,file=paste('Temp_Inland_2010_2015.txt',sep=""),col.names=FALSE,row.names=FALSE)

