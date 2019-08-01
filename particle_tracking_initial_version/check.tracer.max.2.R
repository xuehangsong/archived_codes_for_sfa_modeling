#rm(list=ls())
#load("conbined.tracer.r")
library(rhdf5)

ntime = length(conbined.tracer)
max.times = rep(NA,ntime)
for (itime in 1:ntime)
{
    print(itime)
    max.times[itime] = max(conbined.tracer[[itime]])

}
max.index = which(max.times)

abnormal.locations = which(conbined.tracer[[295]]>0.0010001,arr.ind=TRUE)


h5file = "/files3/pin/simulations/Test11_subRiverGradient_5yr_6h/newRingold_subRiverGrad_2010_2015_6h.h5"
itime = 0
group  = paste("/Time:  ",formatC(itime,digits=5,format="E")," h",sep="")
material_id = h5read(h5file,group)[["Material_ID"]]

saturation = h5read(h5file,group)[["Liquid_Saturation"]]  

save(list=ls(),file="check.tracer2.r")
