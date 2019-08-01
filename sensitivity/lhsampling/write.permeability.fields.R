rm(list=ls())
library(rhdf5)

load("lhsampling.r")
hanford.threshold = c(-11,-6)
alluvium.threshold = c(-13,-11)
nshape = 3


west = 0
east = 143.2
south = 0
north = 1
top = 110.0
bottom = 90.0


dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
dy = 1.0
dz = c(rev(0.05*1.09505408**(1:25)),rep(0.05,300))

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz

hanford.perm = array(0,c(nx*ny*nz,nreaz))
alluvium.perm = array(0,c(nx*ny*nz,nreaz))

for (ishape in 1:nshape)
{

    for (ireaz in 1:nreaz)
    {
        print(ireaz)
        load(paste("../heterogenous/data/perm.",index.hanford.hete[ireaz,ishape],".r",sep=""))
        hanford[which(hanford>10^(hanford.threshold[2]))] = 10^(hanford.threshold[2])
        hanford[which(hanford<10^(hanford.threshold[1]))] = 10^(hanford.threshold[1])
        hanford.perm[,ireaz] = hanford
    }

    for (ireaz in 1:nreaz)
    {
        print(ireaz)    
        load(paste("../heterogenous/data/perm.",index.alluvium.hete[ireaz,ishape],".r",sep=""))
        alluvium[which(alluvium>10^(alluvium.threshold[2]))] = 10^(alluvium.threshold[2])
        alluvium[which(alluvium<10^(alluvium.threshold[1]))] = 10^(alluvium.threshold[1])
        alluvium.perm[,ireaz] = alluvium
    }

    cell.ids = as.integer(seq(1,nx*ny*nz))
    save(list=c("alluvium.perm","hanford.perm","cell.ids"),file=paste("sampled.perm.",ishape,".r",sep=""))
}
