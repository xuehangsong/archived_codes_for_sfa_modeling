rm(list=ls())
library(abind)
library(akima)
library(scales) 

compare.time = seq(1+24*5,409-24*2)

ntime = length(compare.time)
n.data = ntime

##observations
load("results/interp.data.r") 
for (itime in seq(1,length(interp.time)))
{
    obs.value = (spc.temp.value[["S10"]]-spc.temp.value[["SWS-1"]])/(spc.temp.value[["2-3"]]-spc.temp.value[["SWS-1"]])
    
}
obs.value = obs.value[compare.time]

obs.var = rep(1^2,length(obs.value))  #lower bound

case.name = "regular.6"
load(paste(case.name,"/statistics/state.vector.r",sep=''))
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))

simu.ensemble = tracer.ensemble[,1:2,compare.time]
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
simu.ensemble = 1-simu.ensemble

data.mismatch = rep(0,dim(state.vector)[1])
for (ireaz in 1:dim(state.vector)[1])
{
    data.mismatch[ireaz] = (simu.ensemble[ireaz,]-obs.value) %*% diag(1/obs.var) %*% (simu.ensemble[ireaz,]-obs.value)/n.data
}

save(list=ls(),file="results/s10.temp.r")

