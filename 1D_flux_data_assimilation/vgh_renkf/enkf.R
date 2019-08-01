rm(list=ls())
library(rhdf5)
library(RCurl) #for merage list
library(xts)
source("codes/vhg_da_function.R")

nreaz = 100
ncore = 8

init.datum = 5
input.dir = "dainput/" 
obs.coord = c(-0.04,-0.24)
obs.sd.ratio = 0.001
nobs = length(obs.coord)
init_cond = 10^seq(-1,1,length.out = nreaz)
nz = 100
dz = rep(0.64/nz,100)
z = -0.64+cumsum(dz)-0.5*dz

obs = read.table("dainput/obs.dat")
obs.time = seq(0,300*99,300)
ntime = length(obs.time)



##initial
set.seed(0)
perm = init_cond*0.001/1000/9.81/24/3600


perm.ls = list()
perm.ls[[1]] = perm
#for (itime in 2:ntime)
#for (itime in 2:2016)
for (itime in 2:100)        
{
    print(paste(itime,
                mean(log10(perm*3600*24*9.81*1000*1000)),
                sd(log10(perm*3600*24*9.81*1000*1000))))      

    #forecast
    cenkf.mc.input ()
    system(paste("sh codes/mc.fuji.sh",nreaz,ncore),
           wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)        
    simu.ensemble = cenkf.mc.output()
    set.seed(itime)
    obs.sd = obs.sd.ratio*as.numeric(obs[itime,])
    obs.ensemble = t(replicate(nreaz,as.numeric(obs[itime,]))) +
        array(rnorm(nreaz*nobs,0,1),c(nreaz,nobs))%*%diag(obs.sd)

    #update
    state.vector = array(log(perm),c(nreaz,1))
    cov.state_simu = cov(state.vector,simu.ensemble)
    cov.simu = cov(simu.ensemble,simu.ensemble)
    inv.cov.simuADDobs = solve(cov.simu+diag(obs.sd**2))
    kalman.gain = cov.state_simu %*% inv.cov.simuADDobs
    state.vector = state.vector+(obs.ensemble-simu.ensemble) %*% t(kalman.gain)

    ##prepare input for next segment
    perm = exp(state.vector[,1])    
    perm.ls[[itime]] = perm
}

save(list=ls(),file="results/enkf.r")
save(list=c("perm.ls"),file="results/enkf_perm_temp.r")
