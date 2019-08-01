rm(list=ls())
library(rhdf5)
library(RCurl) #for merage list
library(xts)
source("codes/vhg_da_function.R")

nreaz = 100
ncore = 8

time.window = 3600*24

init.datum = 5
input.dir = "dainput/" 
obs.coord = c(-0.04,-0.24)
obs.sd.ratio = 0.001
nobs = length(obs.coord)
cond.mean = 0
cond.sd = 1
set.seed(999)
init.cond = 10^rnorm(nreaz,cond.mean,cond.sd)

nz = 100
dz = rep(0.64/nz,100)
z = -0.64+cumsum(dz)-0.5*dz

ntime = 200
obs = read.table("dainput/obs.dat")
obs.time = seq(300,300*ntime,300)


##initial
set.seed(0)
init.perm = init.cond*0.001/1000/9.81/24/3600
init.perm.sd = sd(log(init.perm))

system("rm -rf pflotran_mc",wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)        
system("mkdir pflotran_mc",wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)    
for (ireaz in 1:nreaz)
{
    system(paste("mkdir pflotran_mc/",ireaz,sep=""),
           wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)            
}


perm.ls = list()
perm.ls[[1]] = init.perm
for (itime in 1:ntime)        
{
    print(paste(itime,
                mean(log10(perm.ls[[itime]]*3600*24*9.81*1000*1000)),
                sd(log10(perm.ls[[itime]]*3600*24*9.81*1000*1000))))      


    window.start = which.min(abs(obs.time-(obs.time[itime]-time.window)))

    ## #forecast,each segement uses different permeability
    ## for (jtime in max(window.start-1,1):itime)
    ## {
    ##     # forecast from jtime-1 to jtime
    ##     perm = perm.ls[[jtime]]
    ##     cenkf.mc.input(jtime)
    ##     system(paste("sh codes/mc.fuji.sh",nreaz,ncore),
    ##            wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)
    ## }

    cenkf.mc.input.strata(max(window.start-1,1),itime)
    system(paste("sh codes/mc.fuji.sh",nreaz,ncore),
           wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)



    simu.ensemble = cenkf.mc.output(itime)
    set.seed(itime)
    obs.sd = obs.sd.ratio*as.numeric(obs[itime,])
    obs.ensemble = t(replicate(nreaz,as.numeric(obs[itime,]))) +
        array(rnorm(nreaz*nobs,0,1),c(nreaz,nobs))%*%diag(obs.sd)

    #update
    state.vector = c()
    for (jtime in window.start:itime)
    {
        state.vector = cbind(state.vector,array(log(perm.ls[[jtime]]),c(nreaz,1)))
    }
    
    cov.state_simu = cov(state.vector,simu.ensemble)
    cov.simu = cov(simu.ensemble,simu.ensemble)
    inv.cov.simuADDobs = solve(cov.simu+diag(obs.sd**2))
    kalman.gain = cov.state_simu %*% inv.cov.simuADDobs
    state.vector = state.vector+(obs.ensemble-simu.ensemble) %*% t(kalman.gain)


    for (jtime in window.start:itime)
    {
        perm.ls[[jtime]] = exp(state.vector[,jtime-window.start+1])
    }

    ##prepare input for next segment    
    perm.ls[[itime+1]] = perm.ls[[itime]]

    #disturb
    perm = log(perm.ls[[itime+1]])
    set.seed(itime+10^7)    
    perm = perm+rnorm(nreaz,0,max(init.perm.sd^2-sd(perm)^2,0)^0.5)
    perm.ls[[itime+1]] = exp(perm)
    
    save(list=c("perm.ls"),file=paste("results/enkf_perm_temp_",itime,".r",sep=""))    
}

save(list=ls(),file="results/enkf.r")
save(list=c("perm.ls"),file="results/enkf_perm_temp.r")
