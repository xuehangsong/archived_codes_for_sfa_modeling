rm(list=ls())
library(xts)
start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S") 
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
interp.time = seq(start.time,end.time,3600)


load("results/mass.data.r")
mass.trim = list()
for (islice in names(mass.data))
{
     mass.trim[[islice]][["stage"]] = mass.data[[islice]][["stage"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]+1.039
     mass.trim[[islice]][["date"]] = mass.data[[islice]][["date"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]
     mass.trim[[islice]][["temperature"]] = mass.data[[islice]][["temperature"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]     
}

level.mass = mass.trim[["323"]][["stage"]]


folders=list.files("data/Filtered_Hourly_Data/")
data=NA
for (ifolder in folders)
{
    files = dir(paste("data/Filtered_Hourly_Data/",ifolder,sep=""))
    files = files[grep("SWS-1",files)]
    print(ifolder)
    print(files)
    if(length(files)>0)
    {
        
        temp = read.csv(paste("data/Filtered_Hourly_Data/",ifolder,"/",files,sep=""),header=FALSE,skip=1)
        if (length(data)<10) {
            data = as.matrix(temp)
        }else{
            data = rbind(data,as.matrix(temp))
        }
    }

}
level.value = as.numeric(data[,4])
level.time = data[,1]
level.time = as.POSIXct(level.time,format= "%Y-%m-%d %H:%M:%S",tz="GMT")

level.value = level.value[which(level.time>=start.time & level.time<=end.time)]
level.time = level.time[which(level.time>=start.time & level.time<=end.time)]
level.xts = xts(level.value,order.by = level.time,unique=T,tz="GMT")
level.xts = level.xts[.indexmin(level.xts) %in% c(56:59,0:5)]
level.xts = level.xts[c('2010','2011','2012','2013','2014','2015')]
index(level.xts) = round(index(level.xts),units="hours")
level.xts = level.xts[!duplicated(.index(level.xts))]
level.xts = merge(level.xts,time.index)

level.sws1 = level.xts

level.river = as.numeric(level.sws1)
river.gap = which(is.na(level.river))
level.river[river.gap] = level.mass[river.gap]


jpeg(paste("figures/mass.compare.filted.jpg",sep=''),width=8,height=3.5,units='in',res=200,quality=100)
plot(mass.trim[["323"]][["date"]],mass.trim[["323"]][["stage"]],col="black",type="l",
##     time.index,level.xts[["SWS-1"]],col='darkblue',type="l",
     ylim=c(104,109),
 ##    axes=FALSE,
     xlab=NA,
     ylab=NA,
     
     ## ylab="",
     ## xlab="",     
     )

mtext("Time (year)",side=1,at=start.time+24*3*365*3600,line=2,cex=1)
mtext("River Level (m)",side=2,at=106.5,line=2.2,cex=1)

lines(time.index,as.numeric(level.sws1),col='darkblue',type="l")
##lines(mass.trim[["323"]][["date"]][river.gap],mass.trim[["323"]][["stage"]][river.gap],col="black")

legend("topright",c("SWS-1","MASS1"),col=c("darkblue","black"),lty=1,bty="n")

dev.off()


jpeg(paste("figures/mass.merge.filted.jpg",sep=''),width=8,height=3.5,units='in',res=200,quality=100)
plot(mass.trim[["323"]][["date"]],mass.trim[["323"]][["stage"]],col="white",type="l",
##     time.index,level.xts[["SWS-1"]],col='darkblue',type="l",
     ylim=c(104,109),
 ##    axes=FALSE,
     xlab=NA,
     ylab=NA,
     
     ## ylab="",
     ## xlab="",     
     )

mtext("Time (year)",side=1,at=start.time+24*3*365*3600,line=2,cex=1)
mtext("River Level (m)",side=2,at=106.5,line=2.2,cex=1)

lines(time.index,level.river,col='darkblue',type="l")
##lines(mass.trim[["323"]][["date"]][river.gap],mass.trim[["323"]][["stage"]][river.gap],col="black")

##legend("topright",c("SWS-1","MASS1"),col=c("darkblue","black"),lty=1,bty="n")

dev.off()



