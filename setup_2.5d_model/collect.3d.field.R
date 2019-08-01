rm(list = ls())
library(rhdf5)
#library(BurStFin) #for partial.rainbow

obs.time = seq(0,2)
ntime = length(obs.time)

case.name = "3d"
print(case.name)
prefix.h5file = paste(case.name,"/400m_nonuniform-",sep='')

nx = 200
ny = 200    
nz = 40
dz = rep(0.5,nz)
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
###    x.velocity[,,itime] = drop(simu.results)
    
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

## simu.col=grep("Total_CH2O",header,fixed = TRUE)
## simu.results = h5.data[[3]][[simu.col]]
## simu.results = aperm(simu.results,c(3,2,1))
## ch2o.conc[,,itime] = drop(simu.results)*12.0107*1000

## simu.col=grep("Total_H+",header,fixed = TRUE)
## simu.results = h5.data[[3]][[simu.col]]
## simu.results = aperm(simu.results,c(3,2,1))
## h.conc[,,itime] = drop(simu.results)*1.00794*1000

## simu.col=grep("Total_HCO3-",header,fixed = TRUE)
## simu.results = h5.data[[3]][[simu.col]]
## simu.results = aperm(simu.results,c(3,2,1))
## hco3.conc[,,itime] = drop(simu.results)*12.0107*1000

## simu.col=grep("Total_N2",header,fixed = TRUE)
## simu.results = h5.data[[3]][[simu.col]]
## simu.results = aperm(simu.results,c(3,2,1))
## n2.conc[,,itime] = drop(simu.results)*28.0134*1000

## simu.col=grep("Total_NO3-",header,fixed = TRUE)
## simu.results = h5.data[[3]][[simu.col]]
## simu.results = aperm(simu.results,c(3,2,1))
## no3.conc[,,itime] = drop(simu.results)*62.005*1000

## simu.col=grep("Total_O2",header,fixed = TRUE)
## simu.results = h5.data[[3]][[simu.col]]
## simu.results = aperm(simu.results,c(3,2,1))
## o2.conc[,,itime] = drop(simu.results)*31.9988*1000

## save(ch2o.conc,file=paste("results/",case.name,".ch2o.conc",sep=''))
## save(h.conc,file=paste("results/",case.name,".h.conc",sep=''))
## save(hco3.conc,file=paste("results/",case.name,".hco3.conc",sep=''))
## save(n2.conc,file=paste("results/",case.name,".n2.conc",sep=''))
## save(no3.conc,file=paste("results/",case.name,".no3.conc",sep=''))
## save(o2.conc,file=paste("results/",case.name,".o2.conc",sep=''))
## save(elevation.field,file=paste("results/",case.name,".elevation.field",sep=''))
## x.velocity=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## z.velocity=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## hydraulic.head=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## ch2o.conc=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## h.conc=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## hco3.conc=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## n2.conc=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## no3.conc=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## o2.conc=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))
## tracer.conc=array(rep(0,nx.new*nz.new*ntime),c(nx.new,nz.new,ntime))

