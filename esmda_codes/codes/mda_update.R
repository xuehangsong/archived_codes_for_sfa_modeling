rm(list=ls())
args=(commandArgs(TRUE))
source("codes/da_functions.R")

t=proc.time()

perm.log10.mean = log10(c(7.387e-9,4.724e-11,1.181e-12))
perm.log10.sd = c(0.6,0.5,0.2)
perm.log10.upper = c(-7.2,-9,-11.5555)
perm.log10.lower = perm.log10.mean*2-perm.log10.upper


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
load("results/obs_info.r")
obs.sd.ratio = 0.1

load(paste("results/state_vector.",iter-1,sep=''))
nfacies = 3
nreaz =  nrow(state.vector)
nnode =  (ncol(state.vector)-nfacies)/(floor(log2(nfacies)+1))

##current simulation
load(paste("results/simu_tracer_all_",iter,".r",sep=''))
simu.ensemble = c()
for (ireaz in 1:nreaz)
{
    simu.temp = c()
    for (iwell in da.wells)
    {
        simu.temp=c(simu.temp,
            simu.tracer.all[[ireaz]][da.list[[iwell]],iwell])
    }
    simu.ensemble = rbind(simu.ensemble,simu.temp)

}
save(simu.ensemble,file=paste("results/simu_ensemble.",iter,sep=''))

print(proc.time()-t)

##observations
obs.ensemble = array(NA,dim(simu.ensemble))
obs.var = (obs.data*obs.sd.ratio)^2
obs.var = obs.var*alpha
obs.var[obs.var<1e-4] = 1e-4

for (iobs in 1:length(obs.var))
{
    set.seed(iobs+789)
    obs.ensemble[,iobs] = obs.data[iobs] + c(rnorm(nreaz,0,sqrt(obs.var[iobs])))
}
obs.ensemble[obs.ensemble>1] = 1
obs.ensemble[obs.ensemble<0] = 0

cov.simu = cov.parallel.10(simu.ensemble,simu.ensemble)
inv.cov.simuADDobs = chol2inv(chol(cov.simu+diag(obs.var)))

print(proc.time()-t)

state.vector.all = kalman.parallel()
state.vector[,1:nfacies] = state.vector.all[,1:nfacies]
state.vector[,cells.to.update+nfacies] = state.vector.all[,cells.to.update+nfacies]
state.vector[,cells.to.update+(nnode+nfacies)] = state.vector.all[,cells.to.update+(nnode+nfacies)]

print(proc.time()-t)
save(state.vector,file=paste("results/state_vector.",iter,sep=""))
perm.vector = state.vector[,1:3]
save(perm.vector,file=paste("results/perm_vector.",iter,sep=""))

print(proc.time()-t)
