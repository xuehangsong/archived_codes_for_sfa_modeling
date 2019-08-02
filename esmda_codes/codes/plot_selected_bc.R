rm(list=ls())

selected.wells = c(
    "2-7",
    "2-8",
    "2-9",    
    "2-11",
    "2-12",
    "2-13",
    "2-14",
    "2-15",
    "2-16",
    "2-17",
    "2-18",
    "2-19",
    "2-26",
    "2-28",
    "2-34",
    "3-25")
selected.wells = paste("399-",selected.wells,sep="")
niter = length(system("ls results/simu_ensemble*",intern=TRUE))
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
    nreaz = nrow(simu.ensemble)
    for (iwell in da.wells)
    {
        
        simu.all[[iter]][[iwell]] = simu.ensemble[,obs.index.start[iwell]:obs.index.end[iwell]]
    }
}



for (iter in 1:niter)
{
    print(iter)
    jpg.name = paste("figures/selected_bc",iter,".jpg",sep="")
    jpeg(jpg.name,width=6.5,heigh=4,units="in",quality=100,res=300)
    par(mfrow=c(4,4),        
        mar=c(1.8,1.8,0,0.5),
        oma=c(1,1,2.5,0.5),
        mgp=c(1.5,0.7,0)
        )
    index = 0
    for (iwell in selected.wells)
    {
        index = index+1
        plot(collect.times[obs.time[[iwell]]],obs.all[[iwell]],
             pch=1,
             ##                 xlim=range(start.time,end.time),
             ylim=c(0,1.2),
             xlim=c(0,192), 
             xlab=NA,
             ylab=NA,
             col="red",
             axes=FALSE,
             )
        axis(1,seq(0,150,50))
        axis(2,seq(0,1,0.5))
        title(main=iwell,line=-1)
#        box()
        for (ireaz in 1:nreaz)
        {
            lines(collect.times[obs.time[[iwell]]],
                  simu.all[[iter]][[iwell]][ireaz,],
                 ,col="lightsalmon3")
        }
        lines(collect.times[obs.time[[iwell]]],
              colMeans( simu.all[[iter]][[iwell]][,]),
             ,lwd=2,col="blue")
        
        points(collect.times[obs.time[[iwell]]],obs.all[[iwell]])        

            
        
        if (!is.na(match(index,13:16)))
        {
            mtext("Time (h)",1,cex=0.7,line=1.7)
        }

        if (!is.na(match(index,c(1,5,9,13))))
        {
            mtext("Scaled C (%)",2,cex=0.7,line=1.7)
        }

    }
    par(new=T,
        mfrow=c(1,1),
        xpd=TRUE,
        oma=c(0,0,0,0),
        mar=c(0,0,0,0),        
        mgp=c(0,0,0)        
        )
        ## if(index==4)
    ## {
    plot(0,0,xlim=c(-1,1),ylim=c(-1,1),bty="n",axes=FALSE,xlab="",ylab="",col="white")
    legend("top",
           c("Observation     ","Realizations","Mean"),
           col=c("black","lightsalmon3","blue"),
           lty=c(NA,1,1),
           lwd=c(NA,1,2),
           pch=c(1,NA,NA),
           bty="n",
           cex=0.85,
           horiz=TRUE
           )
    ## }
    
    
    dev.off()
}
