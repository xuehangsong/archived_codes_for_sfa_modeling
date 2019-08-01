## rm(list=ls())

## wells = c("2-2","2-32","1-21A")

## welldata = list()
## for (iwell in wells)
## {
##     print(iwell)
##     welldata[[iwell]] = read.csv(paste("welldata/399-",iwell,"_3var.csv",sep=""))
## }

## for (iwell in wells)
## {
##     welldata[[iwell]][,1] = as.POSIXct(welldata[[iwell]][,1],format="%d-%b-%Y %H:%M:%S",tz="GMT")
## }


riverdata = read.csv("welldata/SWS-1_3var.csv")
riverdata[,1] = as.POSIXct(riverdata[,1],format="%d-%b-%Y %H:%M:%S",tz="GMT")

massdata = read.csv("data/mass/mass1_323.csv")
massdata[,1] = as.POSIXct(massdata[,1],format="%Y-%m-%d %H:%M:%S",tz="GMT")
massdata[,4] = massdata[,4]+1.039


temp = massdata[1:325164,1:4]
colnames(temp) = colnames(riverdata)
riverdata = rbind(temp,riverdata)

## wells = paste("Well_399-",wells,sep="")
## names(welldata) = wells


start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT")
end.time = as.POSIXct("2013-12-31 23:00:00",tz="GMT")

## start.time = as.POSIXct("2014-01-01 00:00:00",tz="GMT")
## end.time = as.POSIXct("2014-12-31 00:00:00",tz="GMT")




for (iwell in wells)
{
    fname = paste("figures/well_level/",iwell,"_2013.pdf",sep="")
    selected.time = which(riverdata[,1]<=end.time &
                      riverdata[,1]>=start.time)
#    pdf(file=fname,width=7.5,height=5)
    pdf(file=fname,width=5,height=3)    
    par(mar=c(2,3,2,3))
    plot(riverdata[selected.time,1],riverdata[selected.time,4],
         type="l",col="blue",ylim=c(104,107.5),
         xlim = range(start.time,end.time),
         main = iwell,axes=FALSE,xlab=NA,ylab=NA,         
         )
    box()
    selected.time = which(welldata[[iwell]][,1]<end.time &
                      welldata[[iwell]][,1]>=start.time)
    lines(welldata[[iwell]][selected.time,1],
          welldata[[iwell]][selected.time,4],
          col="red",lty=1,lwd=1)
    lines(welldata[[iwell]][selected.time,1],
          welldata[[iwell]][selected.time,4],
          col="red",lty=3,lwd=2)


    
    axis(2,at=seq(0,200,0.5),mgp=c(5,0.7,0))
    mtext("Water level (m)",2,line=1.7)
    axis.POSIXct(1,at=seq(as.Date("2013-01-02 23:59:00",tz="GMT"),
                 to=as.Date("2015-12-31",tz="GMT"),by="month"),format="%b",mgp=c(5,0.7,0))

    ## axis.POSIXct(1,at=seq(as.Date("2013-01-01 00:00:00",tz="GMT"),
    ##              to=as.Date("2016-01-01",tz="GMT"),by="month"),format="%b",mgp=c(5,0.7,0))


    ## legend(x=as.POSIXct("2013-03-20",tz="GMT"),y=107.6,
    ##        c("River level","GW level"),lty=1,pch=c(NA,NA,1),
    ##        lwd=2,col=c("blue","red","black"),horiz=TRUE,bty="n")


    legend("topright",
           c("River level","GW level"),lty=c(1,1),pch=c(NA,16,1),pt.cex=0.7,
           lwd=2,col=c("blue","red","black"),horiz=TRUE,bty="n")

    
    dev.off()
}    
