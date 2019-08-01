rm(list=ls())
library(rhdf5)


default = h5dump("default/pflotran.h5")
map = h5dump("map/pflotran.h5")

times = grep("Time",names(default))
ntime = length(times)

rmse = rep(NA,ntime)
default_all = c()
map_all = c()
for (itime in 1:ntime)
{
    print(itime)
    rmse[itime] =  (mean((default[[times[itime]]][["Total_Tracer [M]"]]-
                          map[[times[itime]]][["Total_Tracer [M]"]])^2))^0.5


    default_all = c(default_all,c(default[[times[itime]]][["Total_Tracer [M]"]]))
    map_all = c(map_all,c(map[[times[itime]]][["Total_Tracer [M]"]]))    
    
}
jpeg(paste("figures/tracer.jpg",sep=''),width=5,height=5.5,units='in',res=300,quality=100)
plot(default_all,map_all,
     xlab = "Tracer in case 1 (-)",
     ylab = "Tracer in case 2 (-)",
     asp=1,
     pch = 16,
     cex = 0.5,
     )
dev.off()
