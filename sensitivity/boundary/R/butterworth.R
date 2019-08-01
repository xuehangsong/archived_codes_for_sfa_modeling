rm(list=ls())
library(signal)
##filt=butter(4,0.33,"low")


nwindows = 1  ## 1
nwindows = 3  ## 2
nwindows = 12 ## 3
nwindows = 24 ## 4
nwindows = 24*7 ##5
nwindows = 24*30 ##6

filt = Ma(rep(1/nwindows,nwindows))




##input
ori.data = read.table("Temp_River_2010_2015.txt")
ori.time = ori.data[,1]
ori.value = ori.data[,2]
##function
ma.value = filter(filt,ori.value)
ma.time = ori.time-3600*(nwindows-1)/2
ma.value = tail(ma.value,-nwindows)
ma.time = tail(ma.time,-nwindows)
ma.value = c(ori.value[ori.time<min(ma.time)],ma.value)
ma.time = c(ori.time[ori.time<min(ma.time)],ma.time)
ma.value = c(ma.value,ori.value[ori.time>max(ma.time)])
ma.time = c(ma.time,ori.time[ori.time>max(ma.time)])
ma.data = array(NA,c(length(ma.time),length(ori.data)))
##output
ma.data[,1] = ma.time
ma.data[,2] = ma.value
write.table(ma.data,file=paste('Temp_River_2010_2015_average_3.txt',sep=""),col.names=FALSE,row.names=FALSE)



##input
ori.data = read.table("Temp_Inland_2010_2015.txt")
ori.time = ori.data[,1]
ori.value = ori.data[,2]
##function
ma.value = filter(filt,ori.value)
ma.time = ori.time-3600*(nwindows-1)/2
ma.value = tail(ma.value,-nwindows)
ma.time = tail(ma.time,-nwindows)
ma.value = c(ori.value[ori.time<min(ma.time)],ma.value)
ma.time = c(ori.time[ori.time<min(ma.time)],ma.time)
ma.value = c(ma.value,ori.value[ori.time>max(ma.time)])
ma.time = c(ma.time,ori.time[ori.time>max(ma.time)])
ma.data = array(NA,c(length(ma.time),length(ori.data)))
##output
ma.data[,1] = ma.time
ma.data[,2] = ma.value
write.table(ma.data,file=paste('Temp_Inland_2010_2015_average_3.txt',sep=""),col.names=FALSE,row.names=FALSE)




##input
ori.data = read.table("DatumH_River_2010_2015.txt")
ori.time = ori.data[,1]
ori.value = ori.data[,4]
##function
ma.value = filter(filt,ori.value)
ma.time = ori.time-3600*(nwindows-1)/2
ma.value = tail(ma.value,-nwindows)
ma.time = tail(ma.time,-nwindows)
ma.value = c(ori.value[ori.time<min(ma.time)],ma.value)
ma.time = c(ori.time[ori.time<min(ma.time)],ma.time)
ma.value = c(ma.value,ori.value[ori.time>max(ma.time)])
ma.time = c(ma.time,ori.time[ori.time>max(ma.time)])
ma.data = array(NA,c(length(ma.time),length(ori.data)))
##output
ma.data[,1] = ma.time
ma.data[,4] = ma.value
ma.data[,2] = ori.data[1,2]
ma.data[,3] = ori.data[1,3]
write.table(ma.data,file=paste('DatumH_River_2010_2015_average_3.txt',sep=""),col.names=FALSE,row.names=FALSE)






##input
ori.data = read.table("DatumH_Inland_2010_2015.txt")
ori.time = ori.data[,1]
ori.value = ori.data[,4]
##function
ma.value = filter(filt,ori.value)
ma.time = ori.time-3600*(nwindows-1)/2
ma.value = tail(ma.value,-nwindows)
ma.time = tail(ma.time,-nwindows)
ma.value = c(ori.value[ori.time<min(ma.time)],ma.value)
ma.time = c(ori.time[ori.time<min(ma.time)],ma.time)
ma.value = c(ma.value,ori.value[ori.time>max(ma.time)])
ma.time = c(ma.time,ori.time[ori.time>max(ma.time)])
ma.data = array(NA,c(length(ma.time),length(ori.data)))
##output
ma.data[,1] = ma.time
ma.data[,4] = ma.value
ma.data[,2] = ori.data[1,2]
ma.data[,3] = ori.data[1,3]
write.table(ma.data,file=paste('DatumH_Inland_2010_2015_average_3.txt',sep=""),col.names=FALSE,row.names=FALSE)



## temp.river = read.table("Temp_River_2010_2015.txt")
## temp = filter(filt,temp.river[,2])
## temp[1:(nwindows-1)] = temp.river[1:(nwindows-1),2]
## temp.river[,2] = temp
## write.table(temp.river,file=paste('Temp_River_2010_2015_average_3.txt',sep=""),col.names=FALSE,row.names=FALSE)


## temp.inland = read.table("Temp_Inland_2010_2015.txt")
## temp = filter(filt,temp.inland[,2])
## temp[1:(nwindows-1)] = temp.inland[1:(nwindows-1),2]
## temp.inland[,2] = temp
## write.table(temp.inland,file=paste('Temp_Inland_2010_2015_average_3.txt',sep=""),col.names=FALSE,row.names=FALSE)

## Datum.river = read.table("DatumH_River_2010_2015.txt")
## temp = filter(filt,Datum.river[,4])
## temp[1:(nwindows-1)] = Datum.river[1:(nwindows-1),4]
## Datum.river[,4] = temp
## write.table(Datum.river,file=paste('DatumH_River_2010_2015_average_3.txt',sep=""),col.names=FALSE,row.names=FALSE)



## Datum.inland = read.table("DatumH_Inland_2010_2015.txt")
## temp = filter(filt,Datum.inland[,4])
## temp[1:(nwindows-1)] = Datum.inland[1:(nwindows-1),4]
## Datum.inland[,4] = temp
## write.table(Datum.inland,file=paste('DatumH_Inland_2010_2015_average_3.txt',sep=""),col.names=FALSE,row.names=FALSE)



