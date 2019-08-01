rm(list=ls())
library(gstat)
library(sp)

## mean = c(3.077,1.978)
## sd = c(0.84,0.74)
## ih = c(9.4,1)
## ratio = c(10,10)
## azimuth = c(-pi/60,pi/20)


nsim=1000

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

domain.grid = expand.grid(x,z)
names(domain.grid) = c("x","y")

hanford.p = as.list(c(8.742916,2,20,10,90-3))
alluvium.p = as.list(c(-0.1118135,0.5,8,10,90+9))


names(hanford.p) = c("mean","sd","ih","ratio","azimuth")
names(alluvium.p) = c("mean","sd","ih","ratio","azimuth")

##hanford.vgm = vgm(hanford.p$sd**2,"Exp",hanford.p$ih,0.04,anis = c(hanford.p$azimuth,1/hanford.p$ratio))
hanford.vgm = vgm(hanford.p$sd**2,"Exp",hanford.p$ih,anis = c(hanford.p$azimuth,1/hanford.p$ratio))
hanford.gstat = gstat(formula=perm~1,locations=~x+y,dummy=TRUE,beta=hanford.p$mean,model=hanford.vgm,nmax=20)
set.seed(7336)
hanford.rz = predict(hanford.gstat,domain.grid,nsim=nsim)


alluvium.vgm = vgm(alluvium.p$sd**2,"Exp",alluvium.p$ih,anis = c(alluvium.p$azimuth,1/alluvium.p$ratio))
alluvium.gstat = gstat(formula=perm~1,locations=~x+y,dummy=TRUE,beta=alluvium.p$mean,model=alluvium.vgm,nmax=20)
set.seed(8719)
alluvium.rz = predict(alluvium.gstat,domain.grid,nsim=nsim)

## a= cbind(hanford.rz[,1:2],hanford.rz[,1:nsim+2]*0.001/1000/9.81/24/3600)
## a= cbind(hanford.rz[,1:2],10^(hanford.rz[,1:nsim+2])*0.001/1000/9.81/24/3600)

## b= cbind(alluvium.rz[,1:2],alluvium.rz[,1:nsim+2]*0.001/1000/9.81/24/3600)
## b= cbind(alluvium.rz[,1:2],10^(alluvium.rz[,1:nsim+2])*0.001/1000/9.81/24/3600)

hanford.perm = cbind(hanford.rz[,1:2],exp(hanford.rz[,1:nsim+2])*0.001/1000/9.81/24/3600)
alluvium.perm = cbind(alluvium.rz[,1:2],exp(alluvium.rz[,1:nsim+2])*0.001/1000/9.81/24/3600)
## for (isim in 1:nsim)
## {
##     temp = hanford.perm[,isim+2]
##     temp[which(temp>10^-5)] = 10^-5
##     temp[which(temp<10^-11)] = 10^-11
##     hanford.perm[,isim+2] = temp

##     temp = alluvium.perm[,isim+2]
##     temp[which(temp>10^-10)] = 10^-10
##     temp[which(temp<10^-14)] = 10^-14
##     alluvium.perm[,isim+2] = temp
## }

save(list=ls(),file="results/perm.data.all.3.r")
save(list=c("hanford.perm","alluvium.perm"),file="results/perm.data.3.r")

##write.table(alluvium.perm,file="1.txt",col.name=FALSE,row.names=FALSE)
