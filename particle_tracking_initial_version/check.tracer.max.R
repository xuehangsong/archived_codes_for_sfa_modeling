rm(list=ls())
library(rhdf5)

h5file = "/files3/pin/simulations/Test11_subRiverGradient_5yr_6h/newRingold_subRiverGrad_2010_2015_6h.h5"

start.time = 0
end.time = 52560
times = seq(start.time,end.time,120)
ntime = length(times)

itime = 0
group  = paste("/Time:  ",formatC(itime,digits=5,format="E")," h",sep="")
vari.name = names(h5read(h5file,group))
nvari =  length(vari.name)

conbined.tracer = list()
for (itime in 1:ntime)
{
    print(itime)
    group  = paste("/Time:  ",formatC(times[itime],digits=5,format="E")," h",sep="")
    data = h5read(h5file,group)

    conbined.tracer[[itime]] = data[["Total_Tracer_north [M]"]]+data[["Total_Tracer_river [M]"]]
    H5close()
}

save(conbined.tracer,file="conbined.tracer.r")
    

