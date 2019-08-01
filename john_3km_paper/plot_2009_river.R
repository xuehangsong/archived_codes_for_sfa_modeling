rm(list=ls())

riverdata = read.csv("data/mass/mass1_327.csv")
riverdata[,1] = as.POSIXct(riverdata[,1],format="%Y-%m-%d %H:%M:%S",tz="GMT")
riverdata[,4] = riverdata[,4]+1.039

start.time = as.POSIXct("2013-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
end.time = as.POSIXct("2015-12-31 23:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")

tracking.end = start.time+(365*2+60)*24*3600

selected.time = which(riverdata[,1]>=start.time &
                      riverdata[,1]<=end.time)                      


##times = seq(0,438,1)*3600*120+as.POSIXct("2010-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")

time.bar =  as.POSIXct("2013-10-07 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
nbar = 72
time.bar = time.bar+seq(0,365*24*3600,365*24*3600/72)

for (itime in 1:length(time.bar))
    {
        fname = paste("figures/2013_river/wl",itime-1,".pdf",sep="")
        pdf(file=fname,width=8*0.9,height=4*0.9)
        par(mar=c(2,4.5,1,2))
        plot(riverdata[selected.time,1],riverdata[selected.time,4],
             type="l",col="blue",ylim=c(104,107),
             axes=FALSE,xlab=NA,ylab=NA,lwd=2,
             )

        axis(2,at=seq(0,200,1),mgp=c(5,0.7,0),cex.axis=1.5,las=1)
        mtext("River level (m)",2,line=3,cex=1.5)
        axis.POSIXct(1,at=seq(as.Date("2008-01-01",tz="GMT"),
                              to=as.Date("2016-01-01",tz="GMT"),by="quarter"),
                     format="%m/%Y",mgp=c(5,1,0),cex.axis=1.5)

        rect(time.bar[1],0,time.bar[itime],200,lwd=1,col=adjustcolor('purple',0.3),border=NA)
        lines(riverdata[selected.time,1],riverdata[selected.time,4],col="blue")
        box()
        dev.off()
    }

