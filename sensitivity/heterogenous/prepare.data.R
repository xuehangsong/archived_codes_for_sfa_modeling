rm(list=ls())
nsim = 1000
load("results/perm.data.1.r")
for (isim in 1:nsim)
{
    hanford  = hanford.perm [,2+isim]
    alluvium  = alluvium.perm [,2+isim]    
    save(list=c("hanford","alluvium"),file=paste("data/perm.",isim,".r",sep=""))
}


rm(list=ls())
nsim = 1000
load("results/perm.data.2.r")
for (isim in 1:nsim)
{
    hanford  = hanford.perm [,2+isim]
    alluvium  = alluvium.perm [,2+isim]    
    save(list=c("hanford","alluvium"),file=paste("data/perm.",isim+nsim,".r",sep=""))
}

rm(list=ls())
nsim = 1000
load("results/perm.data.3.r")
for (isim in 1:nsim)
{
    hanford  = hanford.perm [,2+isim]
    alluvium  = alluvium.perm [,2+isim]    
    save(list=c("hanford","alluvium"),file=paste("data/perm.",isim+2*nsim,".r",sep=""))
}


