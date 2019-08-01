rm(list=ls())
library(xts)
load("results/thermal.data.r")
load("results/ibutton.data.r")
start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-07-15 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

diff.head = as.numeric(river.data[,4]-inland.data[,4])
head.sign = which((diff.head[1:(length(diff.head)-1)]*diff.head[2:length(diff.head)])<=0)

data.head = as.numeric(colnames(thermal.data))
data.head = data.head[data.head<0]
data.head = sort(data.head,decreasing=TRUE)
data.head = as.character(data.head)
thermal.data = thermal.data[,data.head]

for (iblock in (1:(length(head.sign)-1)))
{
    if (diff.head[head.sign[iblock]+1]<0)
    {
        fname = paste("splited_data/thermistor_discharge/",iblock,"_",
                      head.sign[iblock+1]-head.sign[iblock],"_",
                      format(index(thermal.data)[head.sign[iblock]],"%m-%d"),".csv",sep='')
        output.data = thermal.data[(head.sign[iblock]+1):(head.sign[iblock+1]+1),]
        output.data =as.matrix(output.data)
        write.csv(output.data,file=fname)

    } else {
        
        fname = paste("splited_data/thermistor_intrusion/",iblock,"_",
                      head.sign[iblock+1]-head.sign[iblock],"_",
                      format(index(thermal.data)[head.sign[iblock]],"%m-%d"),".csv",sep='')
        output.data = thermal.data[(head.sign[iblock]+1):(head.sign[iblock+1]+1),]
        output.data = as.matrix(output.data)
        write.csv(output.data,file=fname)
        
    }
}


## head.sign.positive = head.sign[diff.head[head.sign]>=0]
## head.sign.negative = head.sign[diff.head[head.sign]<0]
