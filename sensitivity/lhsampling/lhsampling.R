rm(list=ls())
library(lhs)
library(msm)


hanford.p = as.list(c(8.742916,2,20,10,90-3))
alluvium.p = as.list(c(-0.1118135,0.5,3,10,90+9))


hanford.threshold = c(-11,-6)
alluvium.threshold = c(-13,-11)


names(hanford.p) = c("mean","sd","ih","ratio","azimuth")
names(alluvium.p) = c("mean","sd","ih","ratio","azimuth")


set.seed(888)
nreaz = 20
nparm = 7
lhs.basic = randomLHS(nreaz,nparm)
nrank = 3000
index.hanford.hete = array(NA,c(nreaz,3))
index.alluvium.hete = array(NA,c(nreaz,3))

## First parameter is rank of hanford
ivari = 1
sampled.hanford = round((nrank-0)*(lhs.basic[,ivari]-0)/(1-0)+0.5)
load("../rank/shape1/results/rank.hanford.r")
index.hanford.hete[,1] = match(sampled.hanford,order(rank.f))
load("../rank/shape2/results/rank.hanford.r")
index.hanford.hete[,2] = match(sampled.hanford,order(rank.f))
load("../rank/shape3/results/rank.hanford.r")
index.hanford.hete[,3] = match(sampled.hanford,order(rank.f))



## Second parameter is rank of alluvium
ivari = 2
sampled.alluvium = round((nrank-0)*(lhs.basic[,ivari]-0)/(1-0)+0.5)
load("../rank/shape1/results/rank.alluvium.r")
index.alluvium.hete[,1] = match(sampled.alluvium,order(rank.f))
load("../rank/shape2/results/rank.alluvium.r")
index.alluvium.hete[,2] = match(sampled.alluvium,order(rank.f))
load("../rank/shape3/results/rank.alluvium.r")
index.alluvium.hete[,3] = match(sampled.alluvium,order(rank.f))


## Third parameter is homogeneous hanford
ivari = 3
hanford.homo = qtnorm(lhs.basic[,ivari],hanford.p[["mean"]],hanford.p[["sd"]],
                      log(10^hanford.threshold[1]/(0.001/1000/9.81/24/3600)),
                      log(10^hanford.threshold[2]/(0.001/1000/9.81/24/3600)))
hanford.homo = exp(hanford.homo)*0.001/1000/9.81/24/3600


## Fourth parameter is homogeneous alluvium
ivari = 4
alluvium.homo = qtnorm(lhs.basic[,ivari],alluvium.p[["mean"]],alluvium.p[["sd"]],
                      log(10^alluvium.threshold[1]/(0.001/1000/9.81/24/3600)),
                      log(10^alluvium.threshold[2]/(0.001/1000/9.81/24/3600)))
alluvium.homo = exp(alluvium.homo)*0.001/1000/9.81/24/3600

## 5th parameter is k1
ivari = 5
##k1 = 25.04*2*lhs.basic[,ivari]
k1 = 25.97*2*lhs.basic[,ivari]

## 6th parameter is k2
ivari = 6
##k2 = 17.82*2*lhs.basic[,ivari]
k2 = 21.39*2*lhs.basic[,ivari]

## 7th parameter is k3
ivari = 7
##k3 = 75.12*2*lhs.basic[,ivari]
k3 = 77.91*2*lhs.basic[,ivari]

save(list=ls(),file="lhsampling.r")
