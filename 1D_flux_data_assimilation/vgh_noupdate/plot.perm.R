rm(list=ls())

load("results/enkf_perm_temp.r")

ntime = length(perm.ls)
nreaz=100

perm.ls = as.data.frame(perm.ls)
perm.ls = log10(perm.ls*3600*24*9.81*1000*1000)
colors = rainbow(nreaz)

jpeg(paste("figures/perm.jpg",sep=''),width=8,height=5,units='in',res=300,quality=100)
plot(1:ntime,perm.ls[1,],type="l",
     ylim=range(perm.ls),
     xlab="DA step",
     ylab="K (log10 m/d)"
     )
for (ireaz in 1:nreaz)
{
    lines(1:ntime,perm.ls[ireaz,],type="l",col=colors[ireaz])

}
dev.off()


