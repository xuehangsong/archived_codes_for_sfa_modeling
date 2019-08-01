rm(list = ls())
library(rhdf5)
#library(BurStFin) #for partial.rainbow

obs.time = seq(0,2)
ntime = length(obs.time)

case.name = "2d.0"
print(case.name)
prefix.h5file = paste(case.name,"/2duniform-",sep='')

nx = 1432
ny = 1   
nz = 400
dz = rep(0.05,nz)
z = 90+cumsum(dz)-0.5*dz

elevation.field = t(replicate(nx*ny,z))
elevation.field = array(c(elevation.field),c(nx,ny,nz))

x.velocity = array(rep(0,nx*ny*nz*ntime),c(nx,ny,nz,ntime))
y.velocity = array(rep(0,nx*ny*nz*ntime),c(nx,ny,nz,ntime))
z.velocity = array(rep(0,nx*ny*nz*ntime),c(nx,ny,nz,ntime))
tracer.conc = array(rep(0,nx*ny*nz*ntime),c(nx,ny,nz,ntime))
hydraulic.head = array(rep(0,nx*ny*nz*ntime),c(nx,ny,nz,ntime))


for (itime in 1:ntime) {
    print(itime)

    h5.file = paste(prefix.h5file,formatC((obs.time[itime]),width=3,flag='0'),".h5",sep='') #sprintf("%03d",x)
    h5.data = h5dump(h5.file)
    header = names(h5.data[[3]])
    
    simu.col=grep("X-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,2,1))
    x.velocity[,,,itime] = simu.results
    
    simu.col=grep("Y-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,2,1))
    y.velocity[,,,itime] = simu.results
    
    simu.col=grep("Z-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,2,1))
    z.velocity[,,,itime] = simu.results
    
    simu.col=grep("Liquid_Pressure",header,fixed = TRUE)
    simu.results = h5.data[[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,2,1))
    hydraulic.head[,,,itime] = (simu.results-101325)/9.8068/1000+elevation.field
    
    
    simu.col=grep("Total_Tracer",header,fixed = TRUE)
    simu.results = h5.data[[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,2,1))
    tracer.conc[,,,itime] = simu.results
    
}
save(x.velocity,file=paste("results/",case.name,".x.velocity",sep=''))
save(y.velocity,file=paste("results/",case.name,".y.velocity",sep=''))
save(z.velocity,file=paste("results/",case.name,".z.velocity",sep=''))
save(hydraulic.head,file=paste("results/",case.name,".hydraulic.head",sep=''))
save(tracer.conc,file=paste("results/",case.name,".tracer.conc",sep=''))
save(elevation.field,file=paste("results/",case.name,".elevation.field",sep=''))
