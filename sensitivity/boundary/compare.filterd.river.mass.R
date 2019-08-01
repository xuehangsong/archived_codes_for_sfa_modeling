rm(list=ls())
library(xts)
start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
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

temp.mass = mass.trim[["323"]][["temperature"]]


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
temp.value = as.numeric(data[,2])
temp.time = data[,1]
temp.time = as.POSIXct(temp.time,format= "%Y-%m-%d %H:%M:%S",tz="GMT")

temp.value = temp.value[which(temp.time>=start.time & temp.time<=end.time)]
temp.time = temp.time[which(temp.time>=start.time & temp.time<=end.time)]
temp.xts = xts(temp.value,order.by = temp.time,unique=T,tz="GMT")
temp.xts = temp.xts[.indexmin(temp.xts) %in% c(56:59,0:5)]
temp.xts = temp.xts[c('2010','2011','2012','2013','2014','2015')]
index(temp.xts) = round(index(temp.xts),units="hours")
temp.xts = temp.xts[!duplicated(.index(temp.xts))]
temp.xts = merge(temp.xts,time.index)

temp.sws1 = temp.xts

temp.river = as.numeric(temp.sws1)
river.gap = which(is.na(temp.river))
temp.river[river.gap] = temp.mass[river.gap]

jpeg(paste("figures/mass.compare.temp.filterd.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(interp.time,temp.xts[["SWS-1"]],col='blue',type="l",
     ylim=c(0,25),
     ylab="Temperature (DegC)",
     xlab="Time (year)",     
     )

##for (islice in names(mass.data))
lines(mass.trim[["323"]][["date"]],mass.trim[["323"]][["temperature"]],col="red")
legend("topright",c("SWS-1","323","321"),col=c("blue","red","black"),lty=1)

dev.off()

