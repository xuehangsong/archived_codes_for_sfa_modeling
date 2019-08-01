rm(list=ls())


nreaz=60
hanford.total=c()
alluvium.total=c()
for (ireaz in 1:nreaz)
{
    load(paste("data/perm.",ireaz,".r",sep=""))
    hanford.total=c(hanford.total,hanford)
    alluvium.total=c(alluvium.total,alluvium)
}

jpegfile=paste("./figures/alluvium.hist.jpeg")
jpeg(jpegfile,width=5,height=4,units='in',res=200,,quality=100)
hist(log10(alluvium.total),breaks=20,prob=TRUE,
     xlab="Permeability (log10)",
     ylab="Density")
##     main=paste("Threshold = 1e-12 m^2",", Nbody =",nbody))
dev.off()


jpegfile=paste("./figures/hanford.hist.jpeg")
jpeg(jpegfile,width=5,height=4,units='in',res=200,,quality=100)
hist(log10(hanford.total),breaks=20,prob=TRUE,
     xlab="Permeability (log10)",
     ylab="Density")
##     main=paste("Threshold = 1e-12 m^2",", Nbody =",nbody))
dev.off()

