rm(list=ls())

data.file = "data/T3_thermistor_array.csv"
data.file = "data/sample.csv"

data.head  = read.table(data.file,sep=",",nrows=1)
thermal.data = read.table(data.file,sep=",",skip=1)
thermal.data[,1] = as.POSIXct(thermal.data[,1],format="%m/%d/%Y %H:%M",tz='GMT')
colnames(thermal.data) = data.head

obs.time = thermal.data[,1]
thermal.data = thermal.data[,2:dim(thermal.data)[2]]

depth = as.numeric(colnames(thermal.data))
thermal.data = thermal.data[,order(depth)]
thermal.data = thermal.data[,depth<=0]
depth = as.numeric(colnames(thermal.data))

nflux = length(depth)-2
nobs = length(obs.time)-2

flux = array(0,c(nobs,nflux))
colnames(flux) = depth[1:nflux+1]

theta = 0.43
sediment.density = 2650
water.density  = 1000
sediment.mass.capacity = 920
water.mass.capacity = 4180
thermal.conductivity = 0.9334

theta = 0.35
sediment.density = 2650
water.density  = 1000
sediment.mass.capacity = 754.717
water.mass.capacity = 4180
thermal.conductivity = 2

pc = (1-theta)*sediment.mass.capacity*sediment.density+theta*water.density*water.mass.capacity
pcw = water.mass.capacity*water.density
D = thermal.conductivity/pc

for (iflux in 1:nflux)
{


    dTdt = (thermal.data[1:nobs+2,iflux+1]-thermal.data[1:nobs,iflux+1])/
        as.numeric(difftime(obs.time[1:nobs+2],obs.time[1:nobs],units="secs"))

    ## dTdt = (thermal.data[1:nobs+1,iflux]-thermal.data[1:nobs,iflux])/
    ##     as.numeric(difftime(obs.time[1:nobs+1],obs.time[1:nobs],units="secs"))
    dTdz = array(0,c(nobs,2))
    dTdz[,1] =  (thermal.data[1:nobs+1,iflux+1]-thermal.data[1:nobs+1,iflux])/
        (depth[iflux+1]-depth[iflux])
    dTdz[,2] =  (thermal.data[1:nobs+1,iflux+2]-thermal.data[1:nobs+1,iflux+1])/
        (depth[iflux+2]-depth[iflux+1])        

    dTdz2 = 2*(dTdz[,2]-dTdz[,1])/(depth[iflux+2]-depth[iflux])

    dTdz = 2*(thermal.data[1:nobs+1,iflux+2]-thermal.data[1:nobs+1,iflux])/
        (depth[iflux+2]-depth[iflux])


    flux[,iflux] = (dTdz2*D-dTdt)*pc/pcw/dTdz
}
#   plot(obs.time,thermal.data[,2],type="l")

## y
start.time = as.POSIXct("2016-06-22 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-06-25 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

start.time = as.POSIXct("2016-03-02 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-06-30 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

start.time = as.POSIXct("2009-08-31 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2009-09-05 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")


flux[!is.finite(flux)]=NA
flux[is.nan(flux)]=NA
flux=flux*3600*24
## flux[flux>10]=NA
## flux[flux< -10]=NA

color=rainbow(nflux)
time.tick = seq(from=start.time,to=end.time,by="12 hour")
plot(obs.time[1:nobs+1],flux[,1],type="l",ylim=c(-100,100),range(start.time,end.time),axes=FALSE,col="white")
axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(-100,100,50))
for (iflux in 3)
{

    lines(obs.time[1:nobs+1],flux[,iflux],col=color[iflux])
}

lines(obs.time[1:nobs+1],rowMeans(flux),col="black")

legend("topright",colnames(flux),lty=1,col=color)

colmean.flux  = colMeans(flux,na.rm=TRUE)

flux.dz.weight = depth[1:nflux+2]-depth[1:nflux]
weighted.flux  = flux %*% flux.dz.weight/sum(flux.dz.weight)
