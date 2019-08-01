rm(list=ls())
source("./dainput/parameter.sh")

args=(commandArgs(TRUE))
if(length(args)==0){
    print("no arguments supplied, use default value")
    iter=1
    alpha=4
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}
print(paste("iter=",iter))
print(paste("alpha=",alpha))

load("results/obs.data.r")
load(paste("results/simu.ensemble.",iter,sep=''))
load(paste("results/state.vector.",iter-1,sep=''))

obs.ensemble = array(0,c(nreaz,nobs*ntime))
obs.var = rep(obs_var,ntime*nobs)
obs.value = c(t(obs_value))
obs.var = obs.var*alpha

for (iobs in 1:(nobs*ntime))
{
    obs.ensemble[,iobs] = obs.value[iobs] + c(rnorm(nreaz,0,sqrt(obs.var[iobs])))
}

cov.state_simu = cov(state.vector,simu.ensemble)
cov.simu = cov(simu.ensemble,simu.ensemble)
inv.cov.simuADDobs = solve(cov.simu+diag(obs.var))
kalman.gain = cov.state_simu %*% inv.cov.simuADDobs
state.vector = state.vector+c((obs.ensemble-simu.ensemble) %*% t(kalman.gain))

save(list=ls(),file=paste("results/ies.",iter,sep=''))
save(state.vector,file=paste("results/state.vector.",iter,sep=''))
