rm(list=ls())
library(rhdf5)
west = 0
east = 143.2
south = 0
north = 1
top = 110.0
bottom = 90.0


nbody = 10
nsim=3000

dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
dy = 1.0
dz = c(rev(0.05*1.09505408**(1:25)),rep(0.05,300))

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz



rank.f = rep(0,nsim)
for (isim in 1:nsim) {
    print(isim)
    load(paste("results/hanford/code.",isim,".r",sep=''))
    rank.f[isim]=length(which(net.code<=nbody & net.code>0))/length(which(net.code>0))
}

save(rank.f,file=paste("results/rank.hanford.r",sep=''))


jpegfile=paste("./figures/rank.code.hanford_",nbody,".jpg",sep="")
jpeg(jpegfile,width=6,height=4,units='in',res=200,,quality=100)
hist(rank.f,breaks=20,prob=TRUE,
      xlab="Rank coeffient",
      ylab="Density",
#     xlim=c(0.4,1),     
     main=paste("Threshold = 1e-12 m^2",", Nbody =",nbody))
lines(density(rank.f))
lines(c(rank.f[25],rank.f[25]),c(0,10),lty=2,col="red",lwd=2)
lines(c(rank.f[11],rank.f[11]),c(0,10),lty=2,col="orange",lwd=2)
lines(c(rank.f[2],rank.f[2]),c(0,10),lty=2,col="green",lwd=2)
lines(c(rank.f[3],rank.f[3]),c(0,10),lty=2,col="blue",lwd=2)

dev.off()
