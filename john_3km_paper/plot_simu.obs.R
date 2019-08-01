rm(list=ls())

path = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation_11/"
path = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation_13/"




path = "/files1/song884/bpt/new_simulation_13_25/"
case_name = "25_13"

## path = "/files1/song884/bpt/new_simulation_13_5/"
## case_name = "5_13"

## path = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/"
## case_name = "1_12"


## path = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation_13/"
## case_name = "1_13"

load(paste(path,"simu_wells.r",sep=''))
start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT")
simu.real.time = start.time+simu.time*3600

obs = read.csv("data/Sample_Data_2015_U.csv")
obs[,1] = paste("Well_",obs[,1],sep="")
obs[,2] = as.POSIXct(obs[,2],format="%d-%b-%Y %H:%M:%S")
obs = obs[order(obs[,2]),]

wells = names(well.data)
tracer.types = names(tracer)[c(1,2,4)]
tracer.types = c("Tracer_river_n","Tracer_river_m","Tracer_north")

###colors = c("purple","blue","green","red")
colors = c("green","blue","green","red")
names(colors) = c("Tracer_river_n","Tracer_river_m","Tracer_river_s","Tracer_north")



selected.time = which(simu.real.time<=range(obs[,2])[2] &
                      simu.real.time>=range(obs[,2])[1])                      

##selected.time = which(simu.real.time<=range(obs[,2])[2])



obs.type = 4
spc.min = min(obs[,4])
spc.max = max(obs[,4])

for (iwell in wells)
{
#    fname = paste(path,"figures/",iwell,"_SpC_",case_name,".pdf",sep="")
    fname = paste(path,"figures/",iwell,"_SpC_",case_name,".jpg",sep="")    
    print(iwell)
##    pdf(file=fname,width=7,height=5)
#    pdf(file=fname,width=5.83,height=5)
    jpeg(file=fname,width=4.3,height=2.5,unit="in",quality=100,res=300)        
    par(mar=c(2,3,2,1))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
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
###    data = (obs[obs.row,obs.type]-min(obs[obs.row,obs.type]))/(max(obs[obs.row,obs.type])-min(obs[obs.row,obs.type]))
    data = (obs[obs.row,obs.type]-spc.min)/(spc.max-spc.min)
    
    lines(obs[obs.row,2],data,lwd=3)
    points(obs[obs.row,2],data,pch=1,cex=1)

    
    ## legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.25,
    ##        c("SpC observation","Groundwater tracer"),lty=1,pch=c(1,NA),
    ##        lwd=2,col=c("black","red"),horiz=TRUE,bty="n")

    ## legend(x=as.POSIXct("2013-03-5",tz="GMT"),y=1.15,
    ##        c("River tracer north","River tracer middle"),lty=1,
    ##        lwd=2,col=colors,horiz=TRUE,bty="n")

    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.3,
           c("SpC Obs.","GW tracer"),lty=1,pch=c(1,NA),
           lwd=2,col=c("black","red"),horiz=TRUE,bty="n")

    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.15,
           c("RW N.    ","RW M."),lty=1,
           lwd=2,col=colors,horiz=TRUE,bty="n")

    
    
    dev.off()
}    
stop()
obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_u_",case_name,".pdf",sep="")
##    pdf(file=fname,width=6.5,height=5)
    pdf(file=fname,width=6.25,height=5)    
##    pdf(file=fname,width=6.25,height=5)    
    par(mar=c(2,3,2,3))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    mtext("Normalized Concentration (-)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    for (itracer in tracer.types)
    {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2)
    }

    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.25,
           c("Uranium observation","Groundwater tracer"),lty=1,pch=c(1,NA),
           lwd=c(2,2),col=c("black","red"),horiz=TRUE,bty="n")

    ## legend(x=as.POSIXct("2013-03-5",tz="GMT"),y=1.15,
    ##        c("River tracer n","River tracer m","River tracer s"),lty=1,
    ##        lwd=c(2,2),col=colors,horiz=TRUE,bty="n")
    legend(x=as.POSIXct("2013-03-5",tz="GMT"),y=1.15,
           c("River tracer north","River tracer middle"),lty=1,
           lwd=2,col=colors,horiz=TRUE,bty="n")

    
    par(new=T)
    obs.row = which(obs[,1] == iwell)
##    data = (obs[obs.row,obs.type]-min(obs[obs.row,obs.type]))/(max(obs[obs.row,obs.type])-min(obs[obs.row,obs.type]))
    data = obs[obs.row,obs.type]
    plot(obs[obs.row,2],data,pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
         xlim=range(simu.real.time[selected.time]),
         ylim = c(min(data),(max(data)-min(data))*0.2+max(data)))
    axis(4,mgp=c(5,0.7,0))
    mtext("Uranium concentration (ug/L)",4,line=1.7)    
    lines(obs[obs.row,2],data,lwd=3)

    

    
    dev.off()
}    

    


obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_u_only.pdf",sep="")

    pdf(file=fname,width=6.25,height=5)    
    par(mar=c(2,3,2,3))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.25,
           c("Uranium observation"),lty=1,pch=c(1,NA),
           lwd=c(2,2),col=c("black","red"),horiz=TRUE,bty="n")
    par(new=T)
    obs.row = which(obs[,1] == iwell)
    data = obs[obs.row,obs.type]
    plot(obs[obs.row,2],data,pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
         xlim=range(simu.real.time[selected.time]),
         ylim = c(min(data),(max(data)-min(data))*0.2+max(data)))
    axis(2,mgp=c(5,0.7,0))
    mtext("Uranium concentration (ug/L)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                          to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))

    lines(obs[obs.row,2],data,lwd=3)

    

    
    dev.off()
}    

    


obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_u_middle.pdf",sep="")

##    pdf(file=fname,width=6.5,height=5)
    pdf(file=fname,width=6.25,height=5)    
##    pdf(file=fname,width=6.25,height=5)    
    par(mar=c(2,3,2,3))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    mtext("Normalized Concentration (-)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    for (itracer in "Tracer_river_m")
    {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2)
    }

    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.25,
           c("Uranium observation","River tracer middle"),lty=1,pch=c(1,NA),
           lwd=c(2,2),col=c("black","blue"),horiz=TRUE,bty="n")


    
    par(new=T)
    obs.row = which(obs[,1] == iwell)
##    data = (obs[obs.row,obs.type]-min(obs[obs.row,obs.type]))/(max(obs[obs.row,obs.type])-min(obs[obs.row,obs.type]))
    data = obs[obs.row,obs.type]
    plot(obs[obs.row,2],data,pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
         xlim=range(simu.real.time[selected.time]),
         ylim = c(min(data),(max(data)-min(data))*0.2+max(data)))
    axis(4,mgp=c(5,0.7,0))
    mtext("Uranium concentration (ug/L)",4,line=1.7)    
    lines(obs[obs.row,2],data,lwd=3)

    

    
    dev.off()
}    




obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_u_gw.pdf",sep="")
    pdf(file=fname,width=6.25,height=5)    
    par(mar=c(2,3,2,3))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    mtext("Normalized Concentration (-)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    for (itracer in "Tracer_north")
    {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2)
    }

    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.25,
           c("Uranium observation","Groundwater tracer"),lty=1,pch=c(1,NA),
           lwd=c(2,2),col=c("black","red"),horiz=TRUE,bty="n")

    
    par(new=T)
    obs.row = which(obs[,1] == iwell)
##    data = (obs[obs.row,obs.type]-min(obs[obs.row,obs.type]))/(max(obs[obs.row,obs.type])-min(obs[obs.row,obs.type]))
    data = obs[obs.row,obs.type]
    plot(obs[obs.row,2],data,pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
         xlim=range(simu.real.time[selected.time]),
         ylim = c(min(data),(max(data)-min(data))*0.2+max(data)))
    axis(4,mgp=c(5,0.7,0))
    mtext("Uranium concentration (ug/L)",4,line=1.7)    
    lines(obs[obs.row,2],data,lwd=3)

    

    
    dev.off()
}    



obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_u_north_middle.pdf",sep="")

##    pdf(file=fname,width=6.5,height=5)
    pdf(file=fname,width=6.25,height=5)    
##    pdf(file=fname,width=6.25,height=5)    
    par(mar=c(2,3,2,3))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    mtext("Normalized Concentration (-)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    for (itracer in c("Tracer_river_n","Tracer_river_m"))
    {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2)
    }

    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.25,
           c("Uranium observation"),lty=1,pch=c(1,NA),
           lwd=c(2,2),col=c("black","red"),horiz=TRUE,bty="n")

    legend(x=as.POSIXct("2013-03-5",tz="GMT"),y=1.15,
           c("River tracer north","River tracer middle"),lty=1,
           lwd=2,col=colors,horiz=TRUE,bty="n")

    
    par(new=T)
    obs.row = which(obs[,1] == iwell)
##    data = (obs[obs.row,obs.type]-min(obs[obs.row,obs.type]))/(max(obs[obs.row,obs.type])-min(obs[obs.row,obs.type]))
    data = obs[obs.row,obs.type]
    plot(obs[obs.row,2],data,pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
         xlim=range(simu.real.time[selected.time]),
         ylim = c(min(data),(max(data)-min(data))*0.2+max(data)))
    axis(4,mgp=c(5,0.7,0))
    mtext("Uranium concentration (ug/L)",4,line=1.7)    
    lines(obs[obs.row,2],data,lwd=3)

    

    
    dev.off()
}    





obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_north_middle.pdf",sep="")

##    pdf(file=fname,width=6.5,height=5)
    pdf(file=fname,width=6.25,height=5)    
##    pdf(file=fname,width=6.25,height=5)    
    par(mar=c(2,3,2,3))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    mtext("Normalized Concentration (-)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    for (itracer in c("Tracer_river_n","Tracer_river_m"))
    {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2)
    }

    legend(x=as.POSIXct("2013-03-5",tz="GMT"),y=1.25,
           c("River tracer north","River tracer middle"),lty=1,
           lwd=2,col=colors,horiz=TRUE,bty="n")

    
    dev.off()
}    



obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/",iwell,"_gw_north_middle.pdf",sep="")
    pdf(file=fname,width=6.25,height=5)    
    par(mar=c(2,3,2,3))
    plot(simu.real.time[selected.time],tracer[[1]][[iwell]][selected.time]/0.001,type="l",col="white",ylim=c(0,1.2),
         xlim = range(simu.real.time[selected.time]),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    axis(2,at=seq(0,1,0.2),mgp=c(5,0.7,0))
    mtext("Normalized Concentration (-)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2010-01-01",tz="GMT"),
                 to=as.Date("2016-01-01",tz="GMT"),by="quarter"),format="%m/%Y",mgp=c(5,0.7,0))
    
    for (itracer in tracer.types)
    {
        lines(simu.real.time[selected.time],tracer[[itracer]][[iwell]][selected.time]/0.001,col=colors[itracer],lwd=2)
    }

    legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=1.25,
           c("Groundwater tracer"),lty=1,pch=c(NA),
           lwd=c(2),col=c("red"),horiz=TRUE,bty="n")

    legend(x=as.POSIXct("2013-03-5",tz="GMT"),y=1.15,
           c("River tracer north","River tracer middle"),lty=1,
           lwd=2,col=colors,horiz=TRUE,bty="n")

    dev.off()
}    
