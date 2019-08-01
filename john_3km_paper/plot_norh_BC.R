rm(list=ls())
library(rhdf5)
fname = "/files1/song884/bpt/new_simulation_13_5/BC_2010_2015.h5"
h5name = h5ls(fname)
h5data = h5read(fname,"BC_North/Data")
h5time = h5read(fname,"BC_North/Times")


start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
simu.time = 3600*h5time+start.time


icol=225
fname = paste("figures/compare_gw_table",""2,".jpg",sep='')
jpeg(fname,width=8,height=5,units='in',res=300,quality=100)    
par(mar=c(8,4,2,2))
plot(simu.time,h5data[,icol],type="l",
         xlim=c(as.POSIXct("2012-01-01 00:00:0)",format="%Y-%m-%d %H:%M:%S",tz="GMT"),
                as.POSIXct("2014-01-01 00:00:0)",format="%Y-%m-%d %H:%M:%S",tz="GMT")),
         ylim=c(104,109),
         xlab=NA,ylab=NA,axes=FALSE,
         main=paste("Groundwater table")
     )
    axis(2)
    mtext("River stage (m)",2,line=2.5)
    axis.POSIXct(1,at=seq(simu.time[1],tail(simu.time,1),by="2 month"),format="%Y-%m")
    par(new=T)
plot(simu.time,h5data[,icol],type="l",col="red",
     xlim=c(as.POSIXct("2013-01-01 00:00:0)",format="%Y-%m-%d %H:%M:%S",tz="GMT"),
            as.POSIXct("2015-01-01 00:00:0)",format="%Y-%m-%d %H:%M:%S",tz="GMT")),
     ylim=c(104,109),
     xlab=NA,ylab=NA,axes=FALSE
     )
    axis.POSIXct(1,at=seq(simu.time[1],tail(simu.time,1),by="2 month"),format="%Y-%m",col="red",col.axis="red",line=3)    
    box()
     
dev.off()
