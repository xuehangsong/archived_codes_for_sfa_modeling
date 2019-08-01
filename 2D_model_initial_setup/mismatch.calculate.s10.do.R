rm(list=ls())
library(abind)
library(akima)
library(scales) 

compare.time = seq(1+24*4,24*11)
compare.time = seq(1+24*4,337)
compare.time = seq(1+24*2,24*10)


ntime = length(compare.time)
n.data = ntime

##observations
load("results/interp.data.r") 
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]+3600*0.5*24),3600*1*24)
time.ticks.minor = seq(start.time,end.time,3600*1*24)
obs.value = do.value[["S10"]]
obs.var = rep(1,length(obs.value))

case.name="rate.doc"
load(paste(case.name,"/statistics/do.ensemble.r",sep=''))
simu.ensemble = do.ensemble[,1:2,]*1000*32.0
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
load(paste(case.name,"/statistics/state.vector.r",sep=''))


obs.value = obs.value[compare.time]
obs.var = obs.var[compare.time]

simu.ensemble = simu.ensemble[,compare.time]

data.mismatch = rep(0,dim(state.vector)[1])
for (ireaz in 1:dim(state.vector)[1])
{
    data.mismatch[ireaz] = (simu.ensemble[ireaz,]-obs.value) %*% diag(1/obs.var) %*% (simu.ensemble[ireaz,]-obs.value)/n.data
}

save(list=ls(),file=paste("results/",case.name,".s10.do.r",sep=''))

