rm(list=ls())

riverdata = read.csv("data/mass/mass1_327.csv")
riverdata[,1] = as.POSIXct(riverdata[,1],format="%Y-%m-%d %H:%M:%S",tz="GMT")
riverdata[,4] = riverdata[,4]+1.039

start.time = as.POSIXct("2013-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
end.time = as.POSIXct("2015-12-31 23:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")



selected.time = which(riverdata[,1]>=start.time &
                      riverdata[,1]<=end.time)                      


#5-03
tracking_start =  as.POSIXct("2013-03-30 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
nbar = 72
tracking.end = (12912)*3600
time_section= tracking.end %/% (nbar-1)
time.bar = tracking_start+seq(time_section,tracking.end,time_section)
time.bar = c(time.bar,tracking_start+tracking.end)

for (itime in 1:length(time.bar))
#for (itime in 1)    
    {
        fname = paste("figures/2013_river/wl",itime-1,".jpg",sep="")
        jpeg(file=fname,width=4,height=2,units="in",res=600)                
        par(mar=c(1.5,4.8,1,1.2))
        plot(riverdata[selected.time,1],riverdata[selected.time,4],
             type="l",col="blue",ylim=c(104,107),
             axes=FALSE,xlab=NA,ylab=NA,lwd=1,
             )

        axis(2,at=seq(0,200,1),mgp=c(5,0.3,0),cex.axis=1,las=1,tck=0.03)
        mtext("River level (m)",2,line=2.5,cex=1)
        axis.POSIXct(1,at=seq(as.Date("2008-01-03",tz="GMT"),
                              to=as.Date("2016-01-01",tz="GMT"),by="quarter"),
                     format="%m/%Y",mgp=c(5,0.2,0),cex.axis=1,tck=0.03)

        rect(tracking_start,104,time.bar[itime],107,lwd=1,col=adjustcolor('lavenderblush3',1),border=NA)
        lines(riverdata[selected.time,1],riverdata[selected.time,4],col="blue")
        box()
        dev.off()
        
    }



