rm(list=ls())
library(abind)
library(akima) 

compare.time = seq(1+24*7,24*17)
compare.time = seq(1+24*17,888)
compare.time = seq(1+24*7,888)

ntime = length(compare.time)
n.data = ntime

##observations
load("results/interp.data.r") 
obs.value = spc.value[["S40"]][compare.time]
obs.var = (pmax(0.005,obs.value*0.03))^2  #lower bound
obs.var = rep(0.005^2,length(obs.value))  #lower bound

case.name = "regular.2"
load(paste(case.name,"/statistics/state.vector.r",sep=''))
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))
x = state.vector[,1]
y = state.vector[,2]
z = state.vector[,3]

simu.ensemble = tracer.ensemble[,4,compare.time]

data.mismatch = rep(0,dim(state.vector)[1])
for (ireaz in 1:dim(state.vector)[1])
{
    data.mismatch[ireaz] = (simu.ensemble[ireaz,]-obs.value) %*% diag(1/obs.var) %*% (simu.ensemble[ireaz,]-obs.value)/n.data
}

save(list=ls(),file="results/s40.3.r")
