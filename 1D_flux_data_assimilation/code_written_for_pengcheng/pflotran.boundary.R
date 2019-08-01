rm(list=ls())
library(xts)

### change the order of column, prepare data for 1DtempPro
load("results/thermal.data.r")
data.head = as.numeric(names(thermal.data))
data.head = sort(data.head,decreasing=TRUE)
data.head = tail(data.head,length(which(data.head<0))+1)
data.head = as.character(data.head)
thermal.data = thermal.data[,data.head]
names(thermal.data) = as.character(pmax(-as.numeric(names(thermal.data)),0))
nthermistor = ncol(thermal.data)

## remove the themistor data in low river stage
## avoid effects from solar radiation
low.level = which(river.data[,4]<104.9)
thermal.data[low.level,] = NA
good.data = which(!is.na(rowSums(thermal.data)))
thermal.data = thermal.data[good.data,]
##plot(index(thermal.data),thermal.data[,1],type="l",col="blue")

##output temperature boundary
obs.time = difftime(index(thermal.data),index(thermal.data)[1],units="secs")

write.table(cbind(obs.time,thermal.data[,1]),file="temp_top.txt",
            col.names=FALSE,row.names=FALSE)

write.table(cbind(obs.time,thermal.data[,nthermistor]),file="temp_bottom.txt",
            col.names=FALSE,row.names=FALSE)


## high.level = which(river.data[,4]>=104.9)
## plot(time.index[high.level],thermal.data[high.level,6],type="l",col="blue")
## lines(time.index[high.level],thermal.data[high.level,5],col="cyan")
## lines(time.index[high.level],thermal.data[high.level,4],col="green")
## lines(time.index[high.level],thermal.data[high.level,3],col="orange")
## lines(time.index[high.level],thermal.data[high.level,2],col="pink")
## lines(time.index[high.level],thermal.data[high.level,1],col="red")


