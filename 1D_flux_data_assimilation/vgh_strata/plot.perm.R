rm(list=ls())

load("results/enkf_perm_temp_199.r")

ntime = length(perm.ls)
nreaz=100

perm.ls = as.data.frame(perm.ls)
perm.ls = log10(perm.ls*3600*24*9.81*1000*1000)
colors = rainbow(nreaz)

jpeg(paste("figures/perm.jpg",sep=''),width=8,height=5,units='in',res=300,quality=100)
par(mgp=c(1.8,0.6,0))
plot((1:ntime)/12,perm.ls[1,],type="l",
     ylim=range(perm.ls),
     xlab="Time (hr)",
     ylab="Hydraulic conductivity (log10 m/d)"
     )
for (ireaz in 1:nreaz)
{
    lines((1:ntime)/12,perm.ls[ireaz,],type="l",col="lightsalmon3")

}
lines((1:ntime)/12,as.numeric(colMeans(perm.ls)),lwd=2)
lines(c(1,200)/12,c(-1,1),col="blue",lty=2,lwd=2)

legend("topright",
       c("Reference","Mean","Realizations"),
       col=c("blue","black","lightsalmon3"),
       lty=c(2,1,1),
       bty="n"
       )
dev.off()


