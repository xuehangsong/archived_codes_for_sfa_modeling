## rm(list=ls())

## dir = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation/"
## load(paste(dir,"flux_profile_average.r",sep=""))

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT")
end.time = as.POSIXct("2013-07-01 00:00:00",tz="GMT")

difftime(end.time,start.time,units="hours")

start.time+33000*60*60 ##no.275
start.time+30720*60*60 ##no.25

