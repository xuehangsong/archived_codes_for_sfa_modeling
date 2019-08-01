rm(list=ls())

riverdata = read.csv("data/mass/mass1_327.csv")
riverdata[,1] = as.POSIXct(riverdata[,1],format="%Y-%m-%d %H:%M:%S",tz="GMT")
riverdata[,4] = riverdata[,4]+1.039


start.time = as.POSIXct("2013-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
end.time = as.POSIXct("2014-12-31 23:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")

selected.time = which(riverdata[,1]>start.time &
                      riverdata[,1]<end.time)                      


times = seq(0,438,1)*3600*120+as.POSIXct("2010-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")

itime = 219
for (itime in 219:438)
    {
        print(times[itime+1])
        fname = paste("figures/Xingyuan_wl/",itime,".pdf",sep="")
        pdf(file=fname,width=17,height=5)
        par(mar=c(3,5,5,2))
        plot(riverdata[selected.time,1],riverdata[selected.time,4],
             type="l",col="blue",ylim=c(104,107.5),
             ##     xlim = range(c(start.time,end.time)),
             axes=FALSE,xlab=NA,ylab=NA,lwd=2,
             main = paste(format(times[itime+1],format="%Y-%m-%d %H:%M:%S",tz="GMT")),cex.main=4
             )

        axis(2,at=seq(0,200,0.5),mgp=c(5,0.7,0),cex.axis=2)
        mtext("Water level (m)",2,line=3,cex=2)
        axis.POSIXct(1,at=seq(as.Date("2013-01-01 00:00:00",tz="GMT"),
                              to=as.Date("2016-01-01 00:00:00",tz="GMT"),by="quarter"),
                     format="%m/%Y",mgp=c(5,1.7,0),cex.axis=2)
        lines(rep(times[itime+1],2),c(0,200),lwd=8,col='red')
        box(lwd=3)
        dev.off()
    }        
stop()
time.bar =  as.POSIXct("2015-07-01 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
fname = paste("figures/river_level.pdf",sep="")
pdf(file=fname,width=9.8,height=3)
par(mar=c(2,4.5,3,4))
plot(riverdata[selected.time,1],riverdata[selected.time,4],
     type="l",col="blue",ylim=c(104,108.5),
     ##     xlim = range(c(start.time,end.time)),
     axes=FALSE,xlab=NA,ylab=NA,lwd=2,
     main = paste(format(time.bar,format="%Y-%m-%d %H:%M:%S",tz="GMT")),cex.main=2
     )

axis(2,at=seq(0,200,1),mgp=c(5,0.7,0),cex.axis=1.5,las=1)
mtext("River level (m)",2,line=3,cex=1.5)
axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                      to=as.Date("2016-01-01",tz="GMT"),by="quarter"),
             format="%m/%Y",mgp=c(5,1,0),cex.axis=1.5)
lines(c(time.bar,time.bar),c(0,200),lwd=4,col='red')
box()
dev.off()


time.bar =  as.POSIXct("2013-07-04 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
fname = paste("figures/river_level_high.pdf",sep="")
##pdf(file=fname,width=6,height=3)
pdf(file=fname,width=10,height=4)
par(mar=c(2,4.5,3,1.5))
plot(riverdata[selected.time,1],riverdata[selected.time,4],
     type="l",col="blue",ylim=c(104,108.5),
     ##     xlim = range(c(start.time,end.time)),
     axes=FALSE,xlab=NA,ylab=NA,lwd=2,
     main = paste(format(time.bar,format="%Y-%m-%d %H:%M:%S",tz="GMT")),cex.main=2
     )

axis(2,at=seq(0,200,1),mgp=c(5,0.7,0),cex.axis=1.5,las=1)
mtext("River level (m)",2,line=3,cex=1.5)
axis.POSIXct(1,at=seq(as.Date("2010-01-02",tz="GMT"),
                      to=as.Date("2016-01-02",tz="GMT"),by="year"),
             format="%m/%Y",mgp=c(5,1,0),cex.axis=1.5)
lines(c(time.bar,time.bar),c(0,200),lwd=4,col='red')
box()
dev.off()

time.bar =  as.POSIXct("2013-10-07 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
fname = paste("figures/river_level_low.pdf",sep="")
pdf(file=fname,width=6,height=3)
par(mar=c(2,4.5,3,1.5))
plot(riverdata[selected.time,1],riverdata[selected.time,4],
     type="l",col="blue",ylim=c(104,108.5),
     ##     xlim = range(c(start.time,end.time)),
     axes=FALSE,xlab=NA,ylab=NA,lwd=2,
     main = paste(format(time.bar,format="%Y-%m-%d %H:%M:%S",tz="GMT")),cex.main=2
     )

axis(2,at=seq(0,200,1),mgp=c(5,0.7,0),cex.axis=1.5,las=1)
mtext("River level (m)",2,line=3,cex=1.5)
axis.POSIXct(1,at=seq(as.Date("2010-01-02",tz="GMT"),
                      to=as.Date("2016-01-02",tz="GMT"),by="year"),
             format="%m/%Y",mgp=c(5,1,0),cex.axis=1.5)
lines(c(time.bar,time.bar),c(0,200),lwd=4,col='red')
box()
dev.off()

fname = paste("figures/river_level_label.pdf",sep="")
pdf(file=fname,width=6,height=4)
par(mar=c(2,4.5,1,1.4))
plot(riverdata[selected.time,1],riverdata[selected.time,4],
     type="l",col="blue",ylim=c(104,108.5),
     ##     xlim = range(c(start.time,end.time)),
     axes=FALSE,xlab=NA,ylab=NA,lwd=2,
##     main = paste(format(time.bar,format="%Y-%m-%d %H:%M:%S",tz="GMT")),cex.main=2
     )

axis(2,at=seq(0,200,1),mgp=c(5,0.7,0),cex.axis=1.5,las=1)
mtext("River level (m)",2,line=3,cex=1.5)
axis.POSIXct(1,at=seq(as.Date("2010-01-02",tz="GMT"),
                      to=as.Date("2016-01-02",tz="GMT"),by="year"),
             format="%m/%Y",mgp=c(5,1,0),cex.axis=1.5)
##lines(c(time.bar,time.bar),c(0,200),lwd=4,col='red')
box()
dev.off()



stop()

obs.type = 4
spc.min = min(obs[,4])
spc.max = max(obs[,4])
for (iwell in wells)
{
    fname = paste(path,"figures/well/",iwell,"_SpC.pdf",sep="")
    selected.time = which(riverdata[,1]<=range(obs[,2])[2] &
                      riverdata[,1]>=range(obs[,2])[1])                      
    pdf(file=fname,width=7.5,height=5)
    par(mar=c(2,3,2,3))
    plot(riverdata[selected.time,1],riverdata[selected.time,4],
         type="l",col="blue",ylim=c(104,107.5),
         xlim = range(riverdata[selected.time,1]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    selected.time = which(welldata[[iwell]][,1]<=range(obs[,2])[2] &
                      welldata[[iwell]][,1]>=range(obs[,2])[1])                      
    lines(welldata[[iwell]][selected.time,1],welldata[[iwell]][selected.time,4],col="red")    
    axis(2,at=seq(0,200,0.5),mgp=c(5,0.7,0))
    mtext("Water level (m)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=107.6,
           c("River level","GW level","SpC"),lty=1,pch=c(NA,NA,1),
           lwd=2,col=c("blue","red","black"),horiz=TRUE,bty="n")
    
    par(new=T)
    obs.row = which(obs[,1] == iwell)
    data = (obs[obs.row,obs.type]-spc.min)/(spc.max-spc.min)


    plot(obs[obs.row,2],data,pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
         ylim = c(min(data),(max(data)-min(data))*0.1+max(data)))
    axis(4,mgp=c(5,0.7,0))
    mtext("Normalized SpC (-)",4,line=1.7)    
    lines(obs[obs.row,2],data,lwd=3)
    
    
    dev.off()
}    
