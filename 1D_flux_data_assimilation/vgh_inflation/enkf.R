rm(list=ls())
library(rhdf5)
library(RCurl) #for merage list
library(xts)
source("codes/vhg_da_function.R")


nreaz = 100
ncore = 16

init.datum = 5
input.dir = "dainput/" 
obs.coord = c(-0.04,-0.24)
obs.sd = 0.01
nobs = length(obs.coord)
init_cond = 10^seq(-1,1,length.out = nreaz)
nz = 100
dz = rep(0.64/nz,100)
z = -0.64+cumsum(dz)-0.5*dz


load(paste(input.dir,"vhg_thermistor.r",sep=""))
obs = thermistor.output[,as.character(obs.coord)]
simu.time = as.numeric(difftime(index(obs),index(obs)[1],units="secs"))
ntime = length(simu.time)

temp.top = read.table(paste(input.dir,"temp_top.dat",sep=""))
temp.bottom = read.table(paste(input.dir,"temp_bottom.dat",sep=""))
head.top = read.table(paste(input.dir,"head_top.dat",sep=""))


##initial
set.seed(0)
perm = init_cond*0.001/1000/9.81/24/3600
init.perm.sd = sd(log(perm))
lm.x = c(z[nz]+0.5*dz[nz],z[1]-0.5*dz[1])
lm.y = c(temp.top[1,2],temp.bottom[1,2])
init.temp.profile = as.numeric(predict(lm(lm.y~lm.x),data.frame(lm.x=z)))
temperature.profile = t(replicate(nreaz,init.temp.profile))
init.pressure.profile = 101325-1*(z-init.datum)*9.8068*998.2
pressure.profile = t(replicate(nreaz,init.pressure.profile))

segment.start = simu.time[1]
segment.end = simu.time[2]
segment.length = segment.end-segment.start
segment.head.top = simu.segment(head.top,segment.start,segment.end)
segment.temp.top = simu.segment(temp.top,segment.start,segment.end)
segment.temp.bottom = simu.segment(temp.bottom,segment.start,segment.end)



perm.ls = list()
temp.ls = list()
perm.ls[[1]] = perm
#for (itime in 2:ntime)
for (itime in 2:20)
{
    print(itime)
    #forecast
    mc.input()
    system(paste("sh codes/mc.fuji.sh",nreaz,ncore),
           wait=TRUE,ignore.stdout=TRUE,ignore.stderr=TRUE)        
    simu.output = mc.output()
    pressure.ensemble = simu.output$pressure.ensemble
    temperature.ensemble = simu.output$temperature.ensemble
    simu.ensemble = simu.output$simu.ensemble
    set.seed(itime)
    obs.ensemble = t(replicate(nreaz,as.numeric(obs[itime,]))) +
        array(rnorm(nreaz*nobs,0,obs.sd),c(nreaz,nobs))

    #update
    state.vector = cbind(log(perm),pressure.ensemble,temperature.ensemble,obs.ensemble)
    cov.state_simu = cov(state.vector,simu.ensemble)
    cov.simu = cov(simu.ensemble,simu.ensemble)
    inv.cov.simuADDobs = solve(cov.simu+diag(rep(obs.sd,nobs)**2))
    kalman.gain = cov.state_simu %*% inv.cov.simuADDobs
    state.vector = state.vector+(obs.ensemble-simu.ensemble) %*% t(kalman.gain)
    ##prepare input for next segment
    if (itime!=ntime)
        {
            perm = exp(state.vector[,1])    
            pressure.profile = state.vector[,(1+1):(1+nz)]    
            temperature.profile = state.vector[,(1+nz+1):(1+nz*2)]
            segment.start = simu.time[itime]
            segment.end = simu.time[itime+1]
            segment.length = segment.end-segment.start
            segment.head.top = simu.segment(head.top,segment.start,segment.end)
            segment.temp.top = simu.segment(temp.top,segment.start,segment.end)
            segment.temp.bottom = simu.segment(temp.bottom,segment.start,segment.end)
        }
    perm.ls[[itime]] = exp(state.vector[,1])
    temp.ls[[itime]] = state.vector[,(1+nz*2+1):(1+nz*2+nobs)]

    
    
    perm = log(perm)
    perm = mean(perm)+(perm-mean(perm))*(init.perm.sd/sd(perm))
    perm = exp(perm)
}

save(list=ls(),file="results/enkf.r")
save(list=c("perm.ls","temp.ls"),file="results/enkf_perm_temp.r")
