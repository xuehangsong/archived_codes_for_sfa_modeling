rm(list = ls())
library(rhdf5)
#library(BurStFin) #for partial.rainbow
source("codes/create.material.grid.R")

obs.time = seq(0,2700)
ntime = length(obs.time)

case.name="0m"
prefix.h5file = paste(case.name,"/2duniform-",sep='')

x.velocity=array(rep(0,nx.new*ny.new*nz.new*ntime),c(nx.new,ny.new,nz.new,ntime))
y.velocity=array(rep(0,nx.new*ny.new*nz.new*ntime),c(nx.new,ny.new,nz.new,ntime))
z.velocity=array(rep(0,nx.new*ny.new*nz.new*ntime),c(nx.new,ny.new,nz.new,ntime))
for (itime in 1:ntime) {
    print(itime)

    h5.file = paste(prefix.h5file,formatC((obs.time[itime]),width=3,flag='0'),".h5",sep='') #sprintf("%03d",x)
    h5.data = h5dump(h5.file)
    header = names(h5.data[[3]])

    simu.col=grep("X-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    x.velocity[,,,itime] = simu.results    

    simu.col=grep("Y-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    y.velocity[,,,itime] = simu.results    

    simu.col=grep("Z-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    z.velocity[,,,itime] = simu.results    
}
save(x.velocity,file=paste("results/",case.name,".x.velocity",sep=''))
save(y.velocity,file=paste("results/",case.name,".y.velocity",sep=''))
save(z.velocity,file=paste("results/",case.name,".z.velocity",sep=''))

