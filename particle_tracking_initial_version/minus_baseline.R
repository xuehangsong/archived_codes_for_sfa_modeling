rm(list=ls())
library(rhdf5)

h5file = "/files3/pin/simulations/Test11_subRiverGradient_5yr_6h/re_newRingold_subRiverGrad_2010_2015_6h.h5"

start.time = 0
end.time = 52560
times = seq(start.time,end.time,120)
ntime = length(times)

real.start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT")
dt = 3600*120
real.times = real.start.time+dt*(1:ntime-1)

baseline.time = as.POSIXct("2013-04-01 00:00:00",tz="GMT")
baseline.index = real.times[which.min(abs(difftime(baseline.time,real.times)))]

group  = paste("/Time:  ",formatC(times[baseline.index],digits=5,format="E")," h",sep="")
baseline.data = h5read(h5file,group)
H5close()
    
for (itime in 1:ntime)
{
    print(itime)
    group  = paste("/Time:  ",formatC(times[itime],digits=5,format="E")," h",sep="")
    data = h5read(h5file,group)

    minus.data = data[[solute.name]] - baseline.data[[solute.name]]
    h5write(minus.data,file=h5file,name="")
    
    H5close()
}
