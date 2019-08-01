rm(list=ls())
library(EnvStats) #for rlnormTrunc
library(msm)
args=commandArgs(trailingOnly=TRUE)
itime=as.double(args[1])

source("./codes/parameters.R")
load("results/material.grid.data")

if (itime==0)
{
    state.vector=array(rep(0,nreaz*4),c(nreaz,4))
    state.vector[,1]=rtnorm(nreaz,104.5,0.3,103.5,105.5)
    state.vector[,2]=log(rlnormTrunc(nreaz,2.15,0.2,5,15))
    state.vector[,4]=log(rlnormTrunc(nreaz,0,0.2,0.2,2.0))
    
    for (ireaz in 1:nreaz) {
        repeat{
            temp=log(rlnormTrunc(1,0,0.2,0.6,2.0))
            if(temp>=state.vector[ireaz,4]) {
                state.vector[ireaz,3]=temp
                break
            }
        }
    }    
    
    
}else{

    load("results/obs.data") # log.time,obs.value,obs.true
    log.time.index=which.min(abs(log.time-obs.time[itime]))

    obs.ensemble=array(rep(0,nreaz*nobs),c(nreaz,nobs))
    for (iobs in 1:nobs)
        {
            obs.ensemble[,iobs] = obs.value[log.time.index,iobs] + c(rnorm(nreaz,0,sqrt(obs.var[iobs])))
        }

    load(paste("results/state.vector.",itime-1,sep=''))  #state.vetor of last time
    load(paste("results/simu.ensemble.",itime,sep=''))       #current simulation

    cov.state_simu=cov(state.vector,simu.ensemble)
    cov.simu=cov(simu.ensemble,simu.ensemble)
    inv.cov.simuADDobs=solve(cov.simu+diag(obs.var))
    kalman.gain=cov.state_simu %*% inv.cov.simuADDobs
    state.vector=state.vector+(obs.ensemble-simu.ensemble) %*% t(kalman.gain)
    save(obs.ensemble,file=paste("results/","obs.ensemble.",itime,sep=''))
}

state.vector[,1][state.vector[,1]<103.5]=103.5
state.vector[,1][state.vector[,1]>105.5]=105.5
state.vector[,2][state.vector[,2]<log(5)]=log(5)
state.vector[,2][state.vector[,2]>log(15)]=log(15)
state.vector[,3][state.vector[,3]<log(0.6)]=log(0.6)
state.vector[,3][state.vector[,3]>log(2)]=log(2)
state.vector[,4][state.vector[,4]<log(0.2)]=log(0.2)
state.vector[,4][state.vector[,4]>log(2)]=log(2)

state.vector[,3][state.vector[,3]<state.vector[,4]]=state.vector[,4]
save(state.vector,file=paste("results/","state.vector.",itime,sep=''))
