rm(list=ls())
library(xts)
coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]

start.time = as.POSIXct("2015-10-31 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-01-28 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
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


load("results/inland.gradient.r.2013_2016.r")
start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
lines(time.index,gradient,col="red")










level.river = mass.trim[["321"]][["stage"]]

jpeg(paste("figures/2016.mass.mutiple.slice.jpg",sep=''),width=15,height=4,units='in',res=200,quality=100)

plot(time.index,level.river,pch=16,cex=0.2,col="white",
     xlab="Time (year)",
     ylab="Gradient",
     ylim=c(-1e-4,5e-4)
     )

color = topo.colors(8)
for ( islice in seq(319,326)) {
    lines(time.index,(mass.trim[[as.character(islice-1)]][["stage"]]-mass.trim[[as.character(islice)]][["stage"]])/
                     (coord.data[as.character(islice-1),2]-coord.data[as.character(islice),2]), 
          col=color[islice-318])
}



load("results/river.gradient.r.2010_2015.r")
start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
lines(time.index,gradient)

legend.label = c()
for (i in seq(1:8)) {
    legend.label[i] = paste(i+317,"-",i+318,sep="")
}


legend("topleft",legend.label,bty="n",horiz=TRUE,
       lty=1,col=c(color,"black"),pch=16)

legend("topright",c("River linear regression","Inland linear regression"),bty="n",horiz=TRUE,
       lty=1,col=c("black","red"))



dev.off()





jpeg(paste("figures/2016.mass.mutiple.slice.scale.jpg",sep=''),width=15,height=4,units='in',res=200,quality=100)

plot(time.index,level.river,pch=16,cex=0.2,col="white",
     xlab="Time (year)",
     ylab="Ratio",
     ylim=c(-0.5,3)
     )

load("results/river.gradient.r.2010_2015.r")
start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")


color = topo.colors(8)
for ( islice in seq(319,326)) {
    lines(time.index,(mass.trim[[as.character(islice-1)]][["stage"]]-mass.trim[[as.character(islice)]][["stage"]])/
                     (coord.data[as.character(islice-1),2]-coord.data[as.character(islice),2])/gradient, 
          col=color[islice-318])
}

legend.label = c()
for (i in seq(1:8)) {
    legend.label[i] = paste(i+317,"-",i+318,sep="")
}


legend("topleft",legend.label,bty="n",horiz=TRUE,
       lty=1,col=c(color,"black"))


dev.off()


mean.mass=c()
y.mass =c()
for ( islice in seq(1,9)) {
    mean.mass[islice] = mean(mass.trim[[as.character(islice+317)]][["stage"]])
    y.mass[islice] = coord.data[as.character(islice+317),2]
}
mean.lm = lm(mean.mass~y.mass)
mean.gradient = mean.lm$coefficients[2]



load("results/river.gradient.r.2010_2015.r")
mean.sws1 = mean(level.combined)
jpeg(paste("figures/2016.mean.gradient.jpg",sep=''),width=10,height=4,units='in',res=200,quality=100)

plot(y.mass,mean.mass,pch=16,cex=1,col="black",
     xlab="Y (south to north)",
     ylab="Water level(m)",
     )
abline(mean.lm)
points(-260.308,mean.sws1,col="blue")
lines(c(-1000,1000),c(mean.sws1+(-1000+260.308)*mean.gradient,mean.sws1+(1000+260.308)*mean.gradient),col="blue")

legend("topleft",c("MASS1 simulation","SWS-1 data","Fitted curve for linear regression","Interpolated river boundary"),bty="n",
       col=c("black","blue","black","blue"),lty=c(NA,NA,1,1),pch=c(16,1,NA,NA))

dev.off()
