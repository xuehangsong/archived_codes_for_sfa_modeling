rm(list=ls())
library(xts)
load("results/thermal.data.r")
start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-07-15 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

diff.head = as.numeric(river.data[,4])-as.numeric(inland.data[,4])
head.sign = which((diff.head[1:(length(diff.head)-1)]*diff.head[2:length(diff.head)])<=0)

data.file = "data/T3_thermistor_array.csv"
thermal.data = read.table(data.file,sep=",",header=TRUE,check.names=FALSE)
thermal.data[,1] = as.POSIXct(thermal.data[,1],format="%m/%d/%Y %H:%M",tz='GMT')
thermal.data = thermal.data[thermal.data[,1]>=start.time & thermal.data[,1]<=end.time,]
data.head = as.numeric(names(thermal.data))
data.head = data.head[data.head<0]
data.head = sort(data.head,decreasing=TRUE)
data.head = as.character(data.head)
thermal.data = cbind(thermal.data[,1],thermal.data[,data.head])
names(thermal.data) = c("",data.head)

for (iblock in (1:(length(head.sign)-1)))
{

    if (diff.head[head.sign[iblock]+1]<0)
    {
        fname = paste("splited_data/thermistor_discharge/",iblock,"_",
            head.sign[iblock+1]-head.sign[iblock],"_",
            format(thermal.data[head.sign[iblock],1],"%m-%d"),".csv",sep='')
        output.data = thermal.data[which(thermal.data[,1]>=index(inland.data)[head.sign[iblock]+1] &
                                             thermal.data[,1]<=index(inland.data)[head.sign[iblock+1]]),]

    } else if (diff.head[head.sign[iblock]+1]>0){

        fname = paste("splited_data/thermistor_intrusion/",iblock,"_",
            head.sign[iblock+1]-head.sign[iblock],"_",
            format(thermal.data[head.sign[iblock],1],"%m-%d"),".csv",sep='')
        output.data = thermal.data[which(thermal.data[,1]>=index(inland.data)[head.sign[iblock]+1] &
                                             thermal.data[,1]<=index(inland.data)[head.sign[iblock+1]]),]

    }
    write.csv(output.data,file=fname,quote=FALSE,row.names=FALSE)
}


