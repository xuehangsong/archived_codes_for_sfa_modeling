rm(list=ls())


path = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/"

load(paste(path,"simu_wells.r",sep=''))
start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT")
simu.real.time = start.time+simu.time*3600

obs = read.csv("data/Sample_Data_2015_U.csv")
obs[,1] = paste("Well_",obs[,1],sep="")
obs[,2] = as.POSIXct(obs[,2],format="%d-%b-%Y %H:%M:%S",tz="GMT")

obs = obs[order(obs[,2]),]

wells = names(well.data)
tracer.types = names(tracer)


colors = c("blue","red")
names(colors) = c("Tracer_river","Tracer_north")

selected.time = which(simu.real.time<=range(obs[,2])[2] &
                      simu.real.time>=range(obs[,2])[1])                      

obs.type = 4
spc.min = min(obs[,4])
spc.max = max(obs[,4])

for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_SpC.pdf",sep="")

    pdf(file=fname,width=7,height=5)
    par(mar=c(2,3,2,1))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.1),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    mtext("Normalized concentration (-)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    for (itracer in tracer.types)
    {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2)
    }

    obs.row = which(obs[,1] == iwell)
    data = (obs[obs.row,obs.type]-spc.min)/(spc.max-spc.min)
    
    lines(obs[obs.row,2],data,lwd=3)
    points(obs[obs.row,2],data,pch=1,cex=1)
    
    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.13,
           c("River tracer","GW tracer","SpC"),lty=1,pch=c(NA,NA,1),
           lwd=2,col=c("blue","red","black"),horiz=TRUE,bty="n")
    
    dev.off()
}    

obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_u.pdf",sep="")

    pdf(file=fname,width=7.5,height=5)
    par(mar=c(2,3,2,3))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.1),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    mtext("Normalized concentration (-)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    for (itracer in tracer.types)
    {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2)
    }

    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.13,
           c("River tracer","GW tracer",expression("U"["aq"])),lty=1,pch=c(NA,NA,1),
           lwd=2,col=c("blue","red","black"),horiz=TRUE,bty="n")

    
    par(new=T)
    obs.row = which(obs[,1] == iwell)
##    data = (obs[obs.row,obs.type]-min(obs[obs.row,obs.type]))/(max(obs[obs.row,obs.type])-min(obs[obs.row,obs.type]))
    data = obs[obs.row,obs.type]
    plot(obs[obs.row,2],data,pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
         xlim=range(simu.real.time[selected.time]),
         ylim = c(min(data),(max(data)-min(data))*0.1+max(data)))
    axis(4,mgp=c(5,0.7,0))
    mtext("Uranium concentration (ug/L)",4,line=1.7)    
    lines(obs[obs.row,2],data,lwd=3)

    

    
    dev.off()
}    

    
