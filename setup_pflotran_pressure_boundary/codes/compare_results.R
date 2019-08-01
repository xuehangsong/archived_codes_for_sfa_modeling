rm(list=ls())
library(rhdf5)

##please note that PFLOTRAN 
default = h5dump("default/pflotran.h5")
map = h5dump("map_step/pflotran.h5")

times = grep("Time",names(default))
ntime = length(times)

rmse = rep(NA,ntime)
default_all = list()
map_all = list()
itime=1
for (iname in names(default[[times[itime]]]))
{
    print(iname)

    default_all[[iname]] = c()
    map_all[[iname]] = c()
    for (itime in 1:ntime)
    {
        default_all[[iname]] = c(default_all[[iname]],c(default[[times[itime]]][[iname]]))
        map_all[[iname]] = c(map_all[[iname]],c(map[[times[itime]]][[iname]]))
    }

    print(range(default_all[[iname]]-map_all[[iname]]))
}


iname = "Liquid Z-Velocity [m_per_h]"
range(map_all[[iname]])
range(default_all[[iname]])


for (iname in names(default[[times[itime]]]))
{
    print(iname)
    jpeg(paste("figures/",iname,".jpg",sep=''),width=5,height=5.5,units='in',res=300,quality=100)
    plot(default_all[[iname]],map_all[[iname]],
         xlab = paste(iname,"(case 1)"),
         ylab = paste(iname,"(case 2)"),
         asp=1,
         pch = 16,
         cex = 0.5,
         )
    dev.off()
}




for (itime in 1:ntime)
{
    if(max(abs(default[[times[itime]]][[iname]]-map[[times[itime]]][[iname]]))>10)
    {
        print(itime)
    }
}
