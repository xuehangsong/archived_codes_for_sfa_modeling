rm(list=ls())
library(rhdf5)
library(gstat)
library(sp)

source("codes/ert_parameters.R")
nreaz = 1

domain.grid = expand.grid(x,y,z)
names(domain.grid) = c("x","y","z")

hanford.p = as.list(c(8.742916,2,20,10,90-3))
alluvium.p = as.list(c(3.489701,0.5,5,10,90+9))

names(hanford.p) = c("mean","sd","ih","ratio","azimuth")
names(alluvium.p) = c("mean","sd","ih","ratio","azimuth")

hanford.vgm = vgm(hanford.p$sd**2,"Exp",hanford.p$ih,anis = c(hanford.p$azimuth,1/hanford.p$ratio))
hanford.gstat = gstat(formula=perm~1,locations=~x+y+z,dummy=TRUE,beta=hanford.p$mean,model=hanford.vgm,nmax=20)
set.seed(6733)
hanford.rz = predict(hanford.gstat,domain.grid,nsim=nreaz)


alluvium.vgm = vgm(alluvium.p$sd**2,"Exp",alluvium.p$ih,anis = c(alluvium.p$azimuth,1/alluvium.p$ratio))
alluvium.gstat = gstat(formula=perm~1,locations=~x+y+z,dummy=TRUE,beta=alluvium.p$mean,model=alluvium.vgm,nmax=20)
set.seed(3673)
alluvium.rz = predict(alluvium.gstat,domain.grid,nsim=nreaz)

hanford.perm = cbind(hanford.rz[,1:3],exp(hanford.rz[,1:nreaz+3])*0.001/1000/9.81/24/3600)
alluvium.perm = cbind(alluvium.rz[,1:3],exp(alluvium.rz[,1:nreaz+3])*0.001/1000/9.81/24/3600)

save(list=ls(),file="results/perm.data.all.2.r")
save(list=c("hanford.perm","alluvium.perm"),file="results/perm.data.2.r")


H5close()        
h5file = "ert_model/ERT_alluvium_2.h5"


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
h5file = "ert_model/ERT_hanford_2.h5"


if(file.exists(h5file)) {file.remove(h5file)}

cell.ids = 1:dim(hanford.perm)[1]

h5createFile(h5file)
h5write(cell.ids,h5file,"Cell Ids",level=0)
for (ireaz in 1:nreaz)
{
    print(ireaz)
    h5write(hanford.perm[,(ireaz+3)],h5file,paste("Hanford_perm",ireaz,sep=""),level=0)
    H5close()        
}






