rm(list=ls())
library("msm")
library("rhdf5")

source("./codes/ifrc_120m_3d.R")
args=(commandArgs(TRUE))
if(length(args)==0){
    print("no arguments supplied, use default value")
    nreaz = 300    
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}
print(paste("nreaz =",nreaz))


factor=0.001/1000/9.81/24/3600
## estimate.sd = sd(log10(10^(rnorm(10000,3.077,0.84))*factor))
## estimate.sd = sd(log10(10^(rnorm(10000,1.978,0.74))*factor))
## estimate.mean = mean(log10(10^(rnorm(10000,3.077,0.84))*factor))
## estimate.mean = mean(log10(10^(rnorm(10000,1.978,0.74))*factor))

perm.log10.mean = log10(c(7.387e-9,4.724e-11,1.181e-12))
perm.log10.sd = c(0.8,0.5,0.2)
perm.log10.upper = c(-7.33,-9.83,-11.63)
perm.log10.lower = c(-8.93,-10.83,-12.23)


##2nd
perm.log10.mean = log10(c(7.387e-9,4.724e-11,1.181e-12))
perm.log10.sd = c(0.8,0.5,0.2)
perm.log10.upper = c(-7,-9,-11.4555)
perm.log10.lower = perm.log10.mean*2-perm.log10.upper


##3rd
perm.log10.mean = log10(c(7.387e-9,4.724e-11,1.181e-12))
perm.log10.sd = c(0.6,0.5,0.2)
perm.log10.upper = c(-7.2,-9,-11.5555)
perm.log10.lower = perm.log10.mean*2-perm.log10.upper



nfacies = length(perm.log10.mean)

perm = list()
for (ifacies in 1:nfacies)
{
    ###    set.seed(10000+ifacies)  ##this the first round
    set.seed(10000+ifacies)
    perm[[ifacies]] = rtnorm(nreaz,
                             perm.log10.mean[ifacies],
                             perm.log10.sd[ifacies],
                             perm.log10.lower[ifacies],
                             perm.log10.upper[ifacies]                             
                             )
}

perm.vector=as.matrix(as.data.frame(perm))
save(perm.vector,file="results/perm_vector.0")

jpeg("figures/hist.jpg",width=8,heigh=6,units="in",quality=100,res=300)
hist(perm[[1]],xlim=c(-13,-6),ylim=c(0,2.5),xlab="",ylab="",
     breaks=20,col="blue",freq=FALSE,density=0.1)
par(new=T)
hist(perm[[2]],xlim=c(-13,-6),ylim=c(0,2.5),xlab="",ylab="",
     breaks=20,col="green",freq=FALSE,density=0.1)
par(new=T)
hist(perm[[3]],xlim=c(-13,-6),ylim=c(0,2.5),xlab=expression(paste("Permeablity (m"^2,")")),ylab="Probability density",
     breaks=20,col="red",freq=FALSE,density=0.1)
dev.off()
