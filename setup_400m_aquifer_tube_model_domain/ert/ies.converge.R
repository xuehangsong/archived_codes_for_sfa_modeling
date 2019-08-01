rm(list=ls())
source("./shell/parameter.sh")
source("./dainput/obs.R")

iter=2

##observations
load("results/obs.data") 
obs.ensemble = array(rep(0,nreaz*nobs*ntime),c(nreaz,nobs*ntime))
obs.var = rep(obs.var,ntime)
obs.value = c(t(obs.value))
for (iobs in 1:(nobs*ntime))
{
    obs.ensemble[,iobs] = obs.value[iobs] + c(rnorm(nreaz,0,sqrt(obs.var[iobs])))
}

####1st
temp = new.env()
load(paste("results/ies.",iter-1,sep=''),temp)
simu.ensemble = get("simu.ensemble",temp)
rm(temp)
data.mismatch = 0
for (ireaz in 1:nreaz)
{
    data.mismatch = data.mismatch+(simu.ensemble-obs.ensemble)[ireaz,] %*% diag(1/obs.var) %*% (simu.ensemble-obs.ensemble)[ireaz,]
}
mismatch.old = data.mismatch/length(simu.ensemble)

##2st
temp = new.env()
load(paste("results/ies.",iter,sep=''),temp)
simu.ensemble = get("simu.ensemble",temp)
rm(temp)

data.mismatch = 0
for (ireaz in 1:nreaz)
{
    data.mismatch = data.mismatch+(simu.ensemble-obs.ensemble)[ireaz,] %*% diag(1/obs.var) %*% (simu.ensemble-obs.ensemble)[ireaz,]
}
mismatch.new = data.mismatch/length(simu.ensemble)


if(mismatch.new<mismatch.old)
{
    print("increase beta")
} else {
    print("decrease beta")
}    





## if ((mismatch.old-mismatch.new)/mismatch.old>mismatch.flag)
## {
##     if(max(abs(state.vector.1-state.vector.2))>change.flag)
##     {
##         print("not converage")
##     } else {
##         print("CONVERAGE!!")
##     }
## }
