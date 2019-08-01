rm(list=ls())
library(rhdf5)
library(gstat)
library(sp)

nreaz = 100

nx = 200
ny = 1
nz = 1


dx = rep(0.005,nx)
dy = 1
dz = 1

x = -1+cumsum(dx)-0.5*dx
y = cumsum(dy)-0.5*dy
z = cumsum(dz)-0.5*dz


domain.grid = expand.grid(x,y,z)
names(domain.grid) = c("x","y","z")

alluvium.p = as.list(c(log(3.8639e-11/(1*0.001/1000/9.81/24/3600))
                      ,0.5,5,10,90+9))
names(alluvium.p) = c("mean","sd","ih","ratio","azimuth")

alluvium.vgm = vgm(alluvium.p$sd**2,"Exp",alluvium.p$ih,anis = c(alluvium.p$azimuth,1/alluvium.p$ratio))
alluvium.gstat = gstat(formula=perm~1,locations=~x+y+z,dummy=TRUE,beta=alluvium.p$mean,model=alluvium.vgm,nmax=20)
set.seed(3673)
alluvium.rz = predict(alluvium.gstat,domain.grid,nsim=nreaz)

alluvium.perm = cbind(alluvium.rz[,1:3],exp(alluvium.rz[,1:nreaz+3])*0.001/1000/9.81/24/3600)

save(list=c("alluvium.perm"),file="results/perm.data.r")


H5close()        
h5file = "alluvium_perm.h5"


if(file.exists(h5file)) {file.remove(h5file)}

cell.ids = 1:dim(alluvium.perm)[1]

h5createFile(h5file)
h5write(cell.ids,h5file,"Cell Ids",level=0)
for (ireaz in 1:nreaz)
{
    print(ireaz)
    h5write(alluvium.perm[,(ireaz+3)],h5file,paste("Alluvium_perm",ireaz,sep=""),level=0)
    H5close()        

}

H5close()        

