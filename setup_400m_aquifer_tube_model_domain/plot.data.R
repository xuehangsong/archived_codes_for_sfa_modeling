rm(list=ls())
library(xts)
library(lubridate)

start.time = as.POSIXct("2016-08-18 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-08-25 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="day")

data.file  = read.table("data/tom_data.csv",header=TRUE,sep=",",stringsAsFactors=FALSE)
date.and.time = paste(data.file[["Date"]])
date.and.time = as.POSIXct(date.and.time,format="%m/%d/%Y %H:%M",tz="GMT")
data.file = xts(data.file,order.by=date.and.time ,unique=T,tz="GMT")

obs.list = list()
obs.list[["N-M"]] = c("N-M-50","N-M-114")
obs.list[["S-M"]] = c("S-M-41","S-M-83")
obs.list[["N-U"]] = c("N-U-50","N-U-100")
obs.list[["S-U"]] = c("S-U-50","S-U-100","S-U-180")

location.name = c(as.character(unlist(obs.list)),"River")
tom.data = list()
for (iloc in location.name)
{
    row.index = grep(iloc,data.file[,1])
    obs.name = colnames(data.file)
    tom.obs = obs.name    
    for (iobs in obs.name)
    {
        temp = data.file[row.index,iobs]        
        temp = temp[!is.na(temp)]
        tom.data[[iloc]][[iobs]] = temp
    }
}



data.file  = read.table("data/field_data.csv",header=TRUE,sep=",",stringsAsFactors=FALSE)
date.and.time = paste(data.file[["Date"]],data.file[["Sampling.time"]])
no.data.point = grep("NA",date.and.time)
##data.file[!no.data.point,]
data.file = data.file[-c(no.data.point),]
date.and.time = date.and.time[-c(no.data.point)]
date.and.time = as.POSIXct(date.and.time,format="%m/%d/%Y %H:%M:%S",tz="GMT")
data.file = xts(data.file,order.by=date.and.time ,unique=T,tz="GMT")


field.data = list()
for (iloc in location.name)
{
    row.index = grep(iloc,data.file[,1])
    obs.name = colnames(data.file)
    field.obs = obs.name
    for (iobs in obs.name)
    {
        temp = data.file[row.index,iobs]
        temp = temp[!is.na(temp)]
        field.data[[iloc]][[iobs]] = temp
    }
}

## to correct tom's time stamp
for (iloc in location.name)
{
    temp = index(field.data[[iloc]][[1]])
    ntime = length(tom.data[[iloc]][[1]])
    correct.time = rep(start.time,ntime)
    for (itime in 1:ntime)
    {
        correct.time[itime]= temp[which.min(abs(as.numeric((difftime(temp,index(tom.data[[iloc]][[1]][itime]))))))]
    }
    for (iobs in 1:length(tom.data[[iloc]]))
    {
        tom.data[[iloc]][[iobs]] = xts(tom.data[[iloc]][[iobs]],order.by=correct.time ,unique=T,tz="GMT")
    }
    
}    




for (iloc in location.name)
{
    temp = index(field.data[[iloc]][[1]])
    ntime = length(tom.data[[iloc]][[1]])
    correct.time = rep(start.time,ntime)
    for (itime in 1:ntime)
    {
        correct.time[itime]= temp[which.min(abs(as.numeric((difftime(temp,index(tom.data[[iloc]][[1]][itime]))))))]

    }
    for (iobs in 1:length(tom.data[[iloc]]))
    {
        tom.data[[iloc]][[iobs]] = xts(tom.data[[iloc]][[iobs]],order.by=correct.time ,unique=T,tz="GMT")
    }
    
}    





stop()
## color = c("black","red","green")
color = c("green","red","black")
pchtype = c(0,1,2,3)
jpeg.name = "figures/Myron_Spc.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "Myron_SpC"
    data  = field.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(100,300),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Myron SpC (uS/cm)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(100,300,50),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("SpC (uS/cm)",2,at=200,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = field.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()


jpeg.name = "figures/Myron_Temp.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "Myron_Temp"
    data  = field.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(15,30),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Myron Temperature (DegC)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(15,30,5),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("Temperature (DegC)",2,at=22,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = field.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()





jpeg.name = "figures/MS5_DO.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "MS5_DO.mg.L."
    data  = field.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0,15),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"MS5 DO (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0,15,3),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("DO (mg/L)",2,at=8,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = field.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()



jpeg.name = "figures/MS5_pH.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "MS5_PH"
    data  = field.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(7,10),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"MS5 pH"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(7,10,1),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("pH",2,at=8.5,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = field.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()








jpeg.name = "figures/MS5_Spc.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "MS5_SpC"
    data  = field.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(100,300),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"MS5 SpC (uS/cm)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(100,300,50),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("SpC (uS/cm)",2,at=200,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = field.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()



jpeg.name = "figures/MS5_Temp.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "MS5_Temp"
    data  = field.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(15,30),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"MS5 Temperature (DegC)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(15,30,5),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("Temperature (DegC)",2,at=22,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = field.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()





jpeg.name = "figures/Tom_SpC.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "Cond"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(100,300),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Lab SpC (uS/cm)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(100,300,50),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("Lab (uS/cm)",2,at=200,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()









jpeg.name = "figures/Tom_pH.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "pH"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(7,10),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Lab pH"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(7,10,1),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("pH",2,at=8.5,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()





jpeg.name = "figures/Tom_Inorg.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "Inorg.C.as.C"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(10,30),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Lab Inorg C as C (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(10,30,5),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("Inorg C as C (mg/L)",2,at=20,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()





jpeg.name = "figures/Tom_NPOC.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "NPOC.as.C"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0,3),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Lab NPOC as C (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0,3,1),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("NPOC as C (mg/L)",2,at=1.5,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()



jpeg.name = "figures/Tom_F.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "F"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0,0.4),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"F (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0,0.4,0.1),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("F (mg/L)",2,at=0.2,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()



jpeg.name = "figures/Tom_Cl.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "Cl"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0,10),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Cl (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0,10,2),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("Cl (mg/L)",2,at=5,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()





jpeg.name = "figures/Tom_SO4.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "SO4"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0,40),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"SO4 (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0,40,10),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("SO4 (mg/L)",2,at=20,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()



jpeg.name = "figures/Tom_NO3.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "NO3"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0,15),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"NO3 (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0,15,3),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("NO3 (mg/L)",2,at=8,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()






jpeg.name = "figures/Tom_Mg.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "Mg"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(2,10),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Mg (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(2,10,2),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("Mg (mg/L)",2,at=6,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()





jpeg.name = "figures/Tom_Ca.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "Ca"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(15,40),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Ca (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(15,40,5),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("Ca (mg/L)",2,at=28,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()




jpeg.name = "figures/Tom_Na.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "Na"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0,12),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"Na (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0,12,3),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("Na (mg/L)",2,at=6,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()






jpeg.name = "figures/Tom_K.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "K"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0.5,2),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"K (mg/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0.5,2,0.5),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("K (mg/L)",2,at=1.3,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()




jpeg.name = "figures/Tom_U.jpg"
jpeg(jpeg.name,width =10, height=8,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    obs.type = "U"
    data  = tom.data[["River"]][[obs.type]]
    plot(index(data),data,
         xlim=c(start.time,end.time),
         ylim=c(0,60),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"U (ug/L)"),axes=FALSE)
    axis(1,at=time.ticks,labels=time.ticks,line=0)
    axis(2,at=seq(0,60,20),line=0)
    mtext("Time (day)",1,at=start.time+3600*3*24,line=2)
    mtext("U (ug/L)",2,at=30,line=2)    
    
    lines(index(data),data,type="l",col='blue')
    for (idepth in 1:length(obs.list[[isection]]))
    {
        data  = tom.data[[ obs.list[[isection]][idepth] ]][[obs.type]]
        points(index(data),data,col=color[idepth])
        lines(index(data),data,col=color[idepth])
            }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=1,col=c("blue",color))
}
dev.off()



##Regular Tom data
for (iloc in location.name)
{
    for (iobs in 1:length(tom.data[[iloc]]))
    {
        temp = merge(tom.data[[iloc]][[iobs]],index(field.data[[iloc]][[1]]))
        tom.data[[iloc]][[iobs]] = temp[!duplicated(.index(temp))]        
    }
}    

##Regular Tom data
for (iloc in location.name)
{
    for (iobs in 1:length(field.data[[iloc]]))
    {
        temp = merge(field.data[[iloc]][[iobs]],index(field.data[[iloc]][[1]]))
        field.data[[iloc]][[iobs]] = temp[!duplicated(.index(temp))]        
    }
}    







jpeg.name = "figures/Spc_VS.jpg"
jpeg(jpeg.name,width =9, height=9.6,units="in",res=300,quality=100)
field.type = "Myron_SpC"
tom.type = "Cond"
isection = names(obs.list)[1]
field.obs  = as.numeric(field.data[["River"]][[field.type]])
tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
plot(0,0,
     xlim=c(100,300),
     ylim=c(100,300),col='white',
     xlab=NA,
     ylab=NA,
     asp=1,
     main=paste(isection,"Myron SpC vs. ICP-OES SpC"),axes=FALSE)
box()
axis(1,at=seq(100,300,50),line=0)
axis(2,at=seq(100,300,50),line=0)
mtext("Myron SpC Measurements (uS/cm)",1,at=200,line=2)
mtext("ICP-OES SpC Measurements (uS/cm)",2,at=200,line=2)    
lines(c(0,1000),c(0,1000),col="purple")
ipch=0
points(field.obs,tom.obs,pch=pchtype[ipch])
for (isection in names(obs.list))
{
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(field.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth],pch=pchtype[ipch])
    }
    ipch = ipch+1
}

legend("topleft",c("River",unlist(obs.list)),bty="n",
                   pch= c(1,rep(pchtype[1],length(obs.list[[1]])),rep(pchtype[2],length(obs.list[[2]])),
                          rep(pchtype[3],length(obs.list[[3]])),rep(pchtype[4],length(obs.list[[4]]))),
                   col=c("blue",color[1:length(obs.list[[1]])],color[1:length(obs.list[[2]])],
                         color[1:length(obs.list[[3]])],color[1:length(obs.list[[4]])]))
dev.off()
## jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
## par(mfrow=c(2,2))
## for (isection in names(obs.list))
## {
##     field.type = "Myron_SpC"
##     tom.type = "Cond"

##     field.obs  = as.numeric(field.data[["River"]][[field.type]])
##     tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
##     plot(field.obs,tom.obs,
##          xlim=c(100,300),
##          ylim=c(100,300),col='blue',
##          xlab=NA,
##          ylab=NA,
##          asp=1,
##          main=paste(isection,"Myron SpC vs. ICP-OES SpC"),axes=FALSE)
##     box()
##     axis(1,at=seq(100,300,50),line=0)
##     axis(2,at=seq(100,300,50),line=0)
##     mtext("Myron SpC Measurements (uS/cm)",1,at=200,line=2)
##     mtext("ICP-OES SpC Measurements (uS/cm)",2,at=200,line=2)    
##     lines(c(0,1000),c(0,1000),col="purple")

    
##     for (idepth in 1:length(obs.list[[isection]]))
##     {
##         field.obs  = as.numeric(field.data[[ obs.list[[isection]][idepth] ]][[field.type]])
##         tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
##         points(field.obs,tom.obs,col=color[idepth])
##     }
##     legend("topleft",c("River",obs.list[[isection]]),bty="n",
##            pch=1,col=c("blue",color))
## }
## dev.off()






jpeg.name = "figures/Spc_VS_MS5.jpg"
## jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
## par(mfrow=c(2,2))
## for (isection in names(obs.list))
## {
##     field.type = "Myron_SpC"
##     tom.type = "MS5_SpC"

##     field.obs  = as.numeric(field.data[["River"]][[field.type]])
##     tom.obs = as.numeric(field.data[["River"]][[tom.type]])
    
##     plot(field.obs,tom.obs,
##          xlim=c(100,300),
##          ylim=c(100,300),col='blue',
##          xlab=NA,
##          ylab=NA,
##          asp=1,
##          main=paste(isection,"Myron SpC vs. MS5 SpC"),axes=FALSE)
##     box()
##     axis(1,at=seq(100,300,50),line=0)
##     axis(2,at=seq(100,300,50),line=0)
##     mtext("Myron SpC Measurements (uS/cm)",1,at=200,line=2)
##     mtext("MS5 SpC Measurements (uS/cm)",2,at=200,line=2)    
##     lines(c(0,1000),c(0,1000),col="purple")

    
##     for (idepth in 1:length(obs.list[[isection]]))
##     {
##         field.obs  = as.numeric(field.data[[ obs.list[[isection]][idepth] ]][[field.type]])
##         tom.obs = as.numeric(field.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
##         points(field.obs,tom.obs,col=color[idepth])
##     }
##     legend("topleft",c("River",obs.list[[isection]]),bty="n",
##            pch=1,col=c("blue",color))
## }
## dev.off()
jpeg(jpeg.name,width =9, height=9.6,units="in",res=300,quality=100)
field.type = "Myron_SpC"
tom.type = "MS5_SpC"
isection = names(obs.list)[1]
field.obs  = as.numeric(field.data[["River"]][[field.type]])
tom.obs = as.numeric(field.data[["River"]][[tom.type]])
plot(0,0,
     xlim=c(100,300),
     ylim=c(100,300),col='white',
     xlab=NA,
     ylab=NA,
     asp=1,
     main=paste(isection,"Myron SpC vs. MS5 SpC"),axes=FALSE)
box()
axis(1,at=seq(100,300,50),line=0)
axis(2,at=seq(100,300,50),line=0)
mtext("Myron SpC Measurements (uS/cm)",1,at=200,line=2)
mtext("MS5 SpC Measurements (uS/cm)",2,at=200,line=2)    
lines(c(0,1000),c(0,1000),col="purple")
ipch=0
points(field.obs,tom.obs,pch=pchtype[ipch])
for (isection in names(obs.list))
{
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(field.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(field.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth],pch=pchtype[ipch])
    }
    ipch = ipch+1
}

legend("topleft",c("River",unlist(obs.list)),bty="n",
                   pch= c(1,rep(pchtype[1],length(obs.list[[1]])),rep(pchtype[2],length(obs.list[[2]])),
                          rep(pchtype[3],length(obs.list[[3]])),rep(pchtype[4],length(obs.list[[4]]))),
                   col=c("blue",color[1:length(obs.list[[1]])],color[1:length(obs.list[[2]])],
                         color[1:length(obs.list[[3]])],color[1:length(obs.list[[4]])]))
dev.off()








jpeg.name = "figures/PH_VS.jpg"
jpeg(jpeg.name,width =9, height=9.6,units="in",res=300,quality=100)
field.type = "MS5_PH"
tom.type = "pH"

isection = names(obs.list)[1]
field.obs  = as.numeric(field.data[["River"]][[field.type]])
tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
plot(0,0,
     xlim=c(7,10),
     ylim=c(7,10),col='white',
     xlab=NA,
     ylab=NA,
     asp=1,
     main=paste(isection,"MS5 pH vs. ICP-OES pH"),axes=FALSE)
box()
axis(1,at=seq(1,12,1),line=0)
axis(2,at=seq(1,12,1),line=0)
mtext("MS5 pH Measurements",1,at=8.5,line=2)
mtext("ICP-OES pH Measurements",2,at=8.5,line=2)    
lines(c(0,1000),c(0,1000),col="purple")
ipch=0
points(field.obs,tom.obs,pch=pchtype[ipch])
for (isection in names(obs.list))
{
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(field.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth],pch=pchtype[ipch])
    }
    ipch = ipch+1
}

legend("topleft",c("River",unlist(obs.list)),bty="n",
                   pch= c(1,rep(pchtype[1],length(obs.list[[1]])),rep(pchtype[2],length(obs.list[[2]])),
                          rep(pchtype[3],length(obs.list[[3]])),rep(pchtype[4],length(obs.list[[4]]))),
                   col=c("blue",color[1:length(obs.list[[1]])],color[1:length(obs.list[[2]])],
                         color[1:length(obs.list[[3]])],color[1:length(obs.list[[4]])]))
dev.off()

## jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
## par(mfrow=c(2,2))
## for (isection in names(obs.list))
## {
##     field.type = "MS5_PH"
##     tom.type = "pH"

##     field.obs  = as.numeric(field.data[["River"]][[field.type]])
##     tom.obs = as.numeric(tom.data[["River"]][[tom.type]])

##     plot(field.obs,tom.obs,
##          xlim=c(7,10),
##          ylim=c(7,10),col='blue',
##          xlab=NA,
##          ylab=NA,
##          asp=1,
##          main=paste(isection,"MS5 pH vs. ICP-OES pH"),axes=FALSE)
##     box()
##     axis(1,at=seq(1,12,1),line=0)
##     axis(2,at=seq(1,12,1),line=0)
##     mtext("MS5 pH Measurements",1,at=8.5,line=2)
##     mtext("ICP-OES pH Measurements",2,at=8.5,line=2)    
## ##    lines(c(0,1000),c(0,1000),col="purple")

    
##     for (idepth in 1:length(obs.list[[isection]]))
##     {
##         field.obs  = as.numeric(field.data[[ obs.list[[isection]][idepth] ]][[field.type]])
##         tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
##         points(field.obs,tom.obs,col=color[idepth])
##     }
##     legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
##            ,col=c("blue",color))

## }
## dev.off()












jpeg.name = "figures/SpC_VS_pH.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "pH"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(7,10),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES pH vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(7,10,1),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES pH Measurements",2,at=8.5,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()







jpeg.name = "figures/SpC_VS_InorgC.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "Inorg.C.as.C"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(10,30),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES  Inorg C as C vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(10,30,5),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES Inorg C as C (mg/L)",2,at=20,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()















jpeg.name = "figures/SpC_VS_NPOC.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "NPOC.as.C"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(0,3),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES  NPOC as C vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(0,3,1),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES NPOC as C (mg/L)",2,at=1.5,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()










jpeg.name = "figures/SpC_VS_F.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "F"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(0,0.4),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES F vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(0,0.4,0.1),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES F (mg/L)",2,at=0.2,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()














jpeg.name = "figures/SpC_VS_Cl.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "Cl"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(0,10),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES Cl vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(0,10,2),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES Cl (mg/L)",2,at=5,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()














jpeg.name = "figures/SpC_VS_SO4.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "SO4"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(0,40),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES SO4 vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(0,40,10),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES SO4 (mg/L)",2,at=20,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()








jpeg.name = "figures/SpC_VS_NO3.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "NO3"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(0,15),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES NO3 vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(0,15,3),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES NO3 (mg/L)",2,at=8,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()






jpeg.name = "figures/SpC_VS_Mg.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "Mg"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(2,10),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES Mg vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(2,10,2),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES Mg (mg/L)",2,at=6,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()
















jpeg.name = "figures/SpC_VS_Ca.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "Ca"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(15,40),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES Ca vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(15,50,5),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES Ca (mg/L)",2,at=25,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()












jpeg.name = "figures/SpC_VS_Na.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "Na"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(0,12),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES Na vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(0,12,3),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES Na (mg/L)",2,at=6,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()





jpeg.name = "figures/SpC_VS_K.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "K"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(0.5,2),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES K vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(0.5,2,0.5),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES K (mg/L)",2,at=1.3,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
 dev.off()






jpeg.name = "figures/SpC_VS_U.jpg"
jpeg(jpeg.name,width =9, height=10,units="in",res=300,quality=100)
par(mfrow=c(2,2))
for (isection in names(obs.list))
{
    field.type = "Cond"
    tom.type = "U"

    field.obs  = as.numeric(tom.data[["River"]][[field.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    
    tom.obs = tom.obs[which(!is.na(field.obs))]
    field.obs = field.obs[which(!is.na(field.obs))]
    
    plot(field.obs,tom.obs,
         xlim=c(100,300),
         ylim=c(0,60),col='blue',
         xlab=NA,
         ylab=NA,
         main=paste(isection,"ICP-OES U vs. ICP-OES SpC"),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=seq(0,60,20),line=0)
    mtext("ICP-OES SpC Measurements (uS/cm)",1,at=200,line=2)
    mtext("ICP-OES U (ug/L)",2,at=30,line=2)    
##    lines(c(0,1000),c(0,1000),col="purple")

    
    for (idepth in 1:length(obs.list[[isection]]))
    {
        field.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[field.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(field.obs,tom.obs,col=color[idepth])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",pch=1
           ,col=c("blue",color))

}
dev.off()

