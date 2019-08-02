rm(list=ls())

niter = 4
nreaz = 300

load("results/obs_info.r")
nwell = length(da.wells)


obs.time = list()
obs.index.start = rep(NA,nwell)
obs.index.end = rep(NA,nwell)

names(obs.index.start)=da.wells
names(obs.index.end)=da.wells

obs.index.start[da.wells[1]] = 1
for (iwell in 1:nwell)
{
    well.name = da.wells[iwell]
    obs.time[[well.name]] = as.numeric(unlist(da.list[da.wells[iwell]]))
    obs.index.end[well.name]= obs.index.start[well.name]-1+length(obs.time[[well.name]])

    obs.index.start[da.wells[iwell+1]] = obs.index.end[well.name]+1
}
obs.index.start = obs.index.start[1:nwell]

obs.all = list()
for (iwell in da.wells)
{
    obs.all[[iwell]] = obs.data[obs.index.start[iwell]:obs.index.end[iwell]]
}

simu.all = list()
for (iter in 1:niter)
{
    simu.all[[iter]] = list()
    load(paste("results/simu_ensemble.",iter,sep=""))
    for (iwell in da.wells)
    {
    
        simu.all[[iter]][[iwell]] = simu.ensemble[,obs.index.start[iwell]:obs.index.end[iwell]]
    }
}



for (iter in 1:niter)
{

    print(iter)


    jpg.name = paste("figures/hm_",iter,".jpg",sep="")
    jpeg(jpg.name,width=10,heigh=6,units="in",quality=100,res=300)
    par(mfrow=c(4,6),        
        mar=c(3,3,1,0),
        oma=c(3,2,1,1),
        mgp=c(1.5,0.7,0)
        )

    for (iwell in da.wells)
    {
        plot(obs.time[[iwell]],obs.all[[iwell]],
             pch=1,
             ##                 xlim=range(start.time,end.time),
             ylim=c(0,1.2),
             xlab="Time (h)",
             ylab="Scaled C(%)",
             col="red",
             main=iwell,
             )
        for (ireaz in 1:nreaz)
        {
            lines(obs.time[[iwell]],
                  simu.all[[iter]][[iwell]][ireaz,],
                 ,col="lightsalmon3")
        }
        lines(obs.time[[iwell]],
             colMeans( simu.all[[iter]][[iwell]][,]),
             ,lwd=2,col="blue")
        
        points(obs.time[[iwell]],obs.all[[iwell]])        
    }


    legend("topright",
           c("Observation","Mean","Realizations"),
           col=c("black","blue","lightsalmon3"),
           lty=c(NA,1,1),
           lwd=c(NA,2,1),
           pch=c(1,NA,NA),
           bty="n"
           )

    
    dev.off()


    

}
    
