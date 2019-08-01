rm(list=ls())

path = "./"
wells = c("1-10A","2-1","2-2","2-32","1-21A")


obs = read.csv("data/Sample_Data_2015_U.csv")
obs[,1] = paste("Well_",obs[,1],sep="")
obs[,2] = as.POSIXct(obs[,2],format="%d-%b-%Y %H:%M:%S",tz="GMT")
obs = obs[order(obs[,2]),]


welldata = list()
for (iwell in wells)
{
    print(iwell)
    welldata[[iwell]] = read.csv(paste("welldata/399-",iwell,"_3var.csv",sep=""))
}

for (iwell in wells)
{
    welldata[[iwell]][,1] = as.POSIXct(welldata[[iwell]][,1],format="%d-%b-%Y %H:%M:%S",tz="GMT")
}


riverdata = read.csv("welldata/SWS-1_3var.csv")
riverdata[,1] = as.POSIXct(riverdata[,1],format="%d-%b-%Y %H:%M:%S",tz="GMT")

wells = paste("Well_399-",wells,sep="")
names(welldata) = wells

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

obs.type = 6 
for (iwell in wells)
{
    fname = paste(path,"figures/well/",iwell,"_u.pdf",sep="")
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
           c("River tracer","GW tracer",expression("U"["aq"])),lty=1,pch=c(NA,NA,1),           
           lwd=2,col=c("blue","red","black"),horiz=TRUE,bty="n")
    

    par(new=T)
    obs.row = which(obs[,1] == iwell)
    data = (obs[obs.row,obs.type]-spc.min)/(spc.max-spc.min)
    data = obs[obs.row,obs.type]
    plot(obs[obs.row,2],data,pch=1,cex=1,xlab=NA,ylab=NA,axes=FALSE,
         ylim = c(min(data),(max(data)-min(data))*0.1+max(data)))
    axis(4,mgp=c(5,0.7,0))
    mtext("Uranium concentration (ug/L)",4,line=1.7)    
    lines(obs[obs.row,2],data,lwd=3)

    
    
    
    dev.off()
}    
