rm(list=ls())

ref.reaz = 132

perm.ref = c()
niter=4
nreaz = 300
nfacies = 3


iter = 0

load(paste("../ringold/results/perm_vector.",iter,sep=""))
perm.list = list()
for (ifacies in 1:nfacies)
{
    perm.list[[ifacies]] = perm.vector[,ifacies]
}

perm.ref = rep(NA,nfacies)
for (ifacies in 1:nfacies)
{
    perm.ref[ifacies] = perm.list[[ifacies]][ref.reaz]
}


perm.mean = array(NA,c(niter+1,3))
perm.sd = array(NA,c(niter+1,3))

perm.list = list()
iter=0
load(paste("results/perm_vector.",iter,sep=""))
perm.list = list()
for (ifacies in 1:nfacies)
{
    perm.list[[ifacies]] = perm.vector[,ifacies]
    perm.mean[iter+1,] = as.numeric(apply(perm.vector,2,mean))
    perm.sd[iter+1,] = as.numeric(apply(perm.vector,2,sd))    
    
}
for (iter in 1:niter)
{
    load(paste("results/perm_vector.",iter,sep=""))
    for (ifacies in 1:nfacies)
    {
        perm.list[[ifacies]] = cbind(perm.list[[ifacies]],perm.vector[,ifacies])
    }
    perm.mean[iter+1,] = as.numeric(apply(perm.vector,2,mean))
    perm.sd[iter+1,] = as.numeric(apply(perm.vector,2,sd))    
}


title = c("(a) Hanford",
          "(b) Ringold Gravel",
          "(c) Ringold Fine")

jpeg("figures/perm.jpg",width=6.5,heigh=2,units="in",quality=100,res=300)
par(mfrow=c(1,3),        
    mar=c(3,2,1,0),
    oma=c(0,1.5,0.5,0.5),
    mgp=c(1.5,0.7,0)
    )
for (ifacies in 1:nfacies)
{
    plot(0:niter,unlist(perm.mean[,ifacies]),
         type="l",
         ylab=NA,
         col="red",
         axes=FALSE,
         xlab="Iteration [-]",         
         ylim=c(round(min(perm.list[[ifacies]]),1),
               round(max(perm.list[[ifacies]]),1)),
         main=title[ifacies]
         )

    if (ifacies == 1)
    {
        mtext(expression(paste("Permeability (log10, m"^2,")")),2,cex=0.7,line=1.7)
    }

    axis(1,0:4)
    axis(2,seq(round(min(perm.list[[ifacies]]),1),
               round(max(perm.list[[ifacies]]),1),
               length.out=5),
         labels=round(seq(round(min(perm.list[[ifacies]]),1),
               round(max(perm.list[[ifacies]]),1),
               length.out=5),1)[c(1,NA,3,NA,5)]

         )



         
    
    for (ireaz in 1:nreaz)
    {
        lines(0:niter,perm.list[[ifacies]][ireaz,],col="lightsalmon3")
    }
    lines(0:niter,unlist(perm.mean[,ifacies]),col="black",lwd=2)
    lines(0:100,rep(perm.ref[ifacies],101),col="blue",lty=2,lwd=2)

    if (ifacies==1)
    {
        legend("topright",
               c("Reference","Mean","Realization"),
               col=c("blue","black","lightsalmon3"),
               lty=c(2,1,1),
               lwd=c(2,2,1),
               bty="n"
               )

    }

}

dev.off()




