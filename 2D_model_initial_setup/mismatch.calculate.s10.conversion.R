rm(list=ls())
library(abind)
library(akima)
library(scales) 


compare.time = seq(1+24*7,24*17)
##compare.time = seq(1+24*17,888)
##compare.time = seq(1+24*7,888)
compare.time = seq(1+24*4,24*11)
compare.time = seq(1+24*4,24*7)


ntime = length(compare.time)
n.data = ntime

##observations
load("results/interp.data.r") 
obs.value = spc.value[["S10"]][compare.time]
obs.var = (pmax(0.005,obs.value*0.03))^2  #lower bound
##obs.var = rep(0.005^2,length(obs.value))  #lower bound

case.name = "regular.2"
load(paste(case.name,"/statistics/state.vector.r",sep=''))
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))
x = state.vector[,1]
y = state.vector[,2]
z = state.vector[,3]

simu.ensemble = tracer.ensemble[,1:2,compare.time]
simu.ensemble = apply(simu.ensemble,c(1,3),mean)
simu.ensemble = rescale(simu.ensemble,c(0.135,0.45))

data.mismatch = rep(0,dim(state.vector)[1])
for (ireaz in 1:dim(state.vector)[1])
{
    data.mismatch[ireaz] = (simu.ensemble[ireaz,]-obs.value) %*% diag(1/obs.var) %*% (simu.ensemble[ireaz,]-obs.value)/n.data
}

save(list=ls(),file="results/s10.conversion.12_22_to_12_24.r")

