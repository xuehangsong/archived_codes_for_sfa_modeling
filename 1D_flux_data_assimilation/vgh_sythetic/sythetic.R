rm(list=ls())
library(rhdf5)
library(RCurl) #for merage list
library(xts)
source("codes/vhg_da_function.R")

nreaz = 1
ncore = 1
ntime = 200
init_cond = 10^seq(-1,1,length.out = ntime)

init_cond = 10^(rnorm(ntime,0,0.3))

#init_cond = 10^rep(-1,ntime)
nz = 100
dz = rep(0.64/nz,100)
z = -0.64+cumsum(dz)-0.5*dz


input.dir = "dainput/" 
obs.coord = c(-0.04,-0.24)
nobs = length(obs.coord)

obs.time = seq(0,300*(ntime-1),300)
simu.time = obs.time

perm.ls = list()
for (itime in 1:ntime)
{
    perm.ls[[itime]] = init_cond[itime]*0.001/1000/9.81/24/3600
}


perm = perm.ls[[1]]
obs.all = c(-10000,-10000)
for (itime in 2:ntime)        
{
    print(itime)

    #forecast
    cenkf.mc.input ()
    system(paste("sh codes/mc.fuji.sh",nreaz,ncore),
           wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)        
    simu.ensemble = cenkf.mc.output()

    
    obs.all = rbind(obs.all,simu.ensemble)
    perm = perm.ls[[itime]]
}

write.table(obs.all,file="results/obs.dat",col.names=FALSE,row.names=FALSE) 


save(list=ls(),file="results/sythetic.r")
save(list=c("perm.ls"),file="results/perm.r")
