rm(list=ls())
library(xts)
load("results/evan.data.r")
start.time = as.POSIXct("2004-08-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2005-06-30 14:30:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="30 mins")

river.data = river.data[river.data[,3]>=start.time & river.data[,3]<=end.time,]
river.data = xts(river.data,order.by=river.data[,3] ,unique=T,tz="GMT")
river.data = river.data[.indexmin(river.data) %in% c(0:2,28:32,58:59),]
river.data = river.data[c('2004',"2005"),]
index(river.data) = as.POSIXct(round(as.numeric(index(river.data))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
river.data = river.data[!duplicated(.index(river.data)),]
river.data = merge(river.data,time.index)

sp9a19.data = sp9a19.data[sp9a19.data[,1]>=start.time & sp9a19.data[,1]<=end.time,]
sp9a19.data = xts(sp9a19.data,order.by=sp9a19.data[,1] ,unique=T,tz="GMT")
sp9a19.data = sp9a19.data[.indexmin(sp9a19.data) %in% c(0:2,28:32,58:59),]
sp9a19.data = sp9a19.data[c('2004',"2005"),]
index(sp9a19.data) = as.POSIXct(round(as.numeric(index(sp9a19.data))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
sp9a19.data = sp9a19.data[!duplicated(.index(sp9a19.data)),]
sp9a19.data = merge(sp9a19.data,time.index)


sp9a86.data = sp9a86.data[sp9a86.data[,1]>=start.time & sp9a86.data[,1]<=end.time,]
sp9a86.data = xts(sp9a86.data,order.by=sp9a86.data[,1] ,unique=T,tz="GMT")
sp9a86.data = sp9a86.data[.indexmin(sp9a86.data) %in% c(0:2,28:32,58:59),]
sp9a86.data = sp9a86.data[c('2004',"2005"),]
index(sp9a86.data) = as.POSIXct(round(as.numeric(index(sp9a86.data))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
sp9a86.data = sp9a86.data[!duplicated(.index(sp9a86.data)),]
sp9a86.data = merge(sp9a86.data,time.index)


sp9a142.data = sp9a142.data[sp9a142.data[,1]>=start.time & sp9a142.data[,1]<=end.time,]
sp9a142.data = xts(sp9a142.data,order.by=sp9a142.data[,1] ,unique=T,tz="GMT")
sp9a142.data = sp9a142.data[.indexmin(sp9a142.data) %in% c(0:2,28:32,58:59),]
sp9a142.data = sp9a142.data[c('2004',"2005"),]
index(sp9a142.data) = as.POSIXct(round(as.numeric(index(sp9a142.data))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
sp9a142.data = sp9a142.data[!duplicated(.index(sp9a142.data)),]
sp9a142.data = merge(sp9a142.data,time.index)

river.level = river.level[river.level[,1]>=start.time & river.level[,1]<=end.time,]
river.level = xts(river.level,order.by=river.level[,1] ,unique=T,tz="GMT")
river.level = river.level[.indexmin(river.level) %in% c(0:2,28:32,58:59),]
river.level = river.level[c('2004',"2005"),]
index(river.level) = as.POSIXct(round(as.numeric(index(river.level))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
river.level = river.level[!duplicated(.index(river.level)),]
river.level = merge(river.level,time.index)

inland.level = inland.level[inland.level[,1]>=start.time & inland.level[,1]<=end.time,]
inland.level = xts(inland.level,order.by=inland.level[,1] ,unique=T,tz="GMT")
inland.level = inland.level[.indexmin(inland.level) %in% c(0:2,28:32,58:59),]
inland.level = inland.level[c('2004',"2005"),]
index(inland.level) = as.POSIXct(round(as.numeric(index(inland.level))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
inland.level = inland.level[!duplicated(.index(inland.level)),]
inland.level = merge(inland.level,time.index)

diff.head = as.numeric(river.level[,2]-inland.level[,2])
head.sign = which((diff.head[1:(length(diff.head)-1)]*diff.head[2:length(diff.head)])<=0)

#thermal.data = array(0,c(dim(sp9a19.data)[1],5))
thermal.data = list()
thermal.data[[1]] = time.index
thermal.data[[2]] = river.data[,6]
thermal.data[[3]] = sp9a19.data[,3]
thermal.data[[4]] = sp9a86.data[,3]
thermal.data[[5]] = sp9a142.data[,3]
thermal.data = as.data.frame(thermal.data)
for (iblock in (1:(length(head.sign)-1)))
{
    if (diff.head[head.sign[iblock]+1]<0)
    {
        fname = paste("splited_data/evan_discharge/",iblock,"_",
                      head.sign[iblock+1]-head.sign[iblock],"_",
                      format((thermal.data[,1])[head.sign[iblock]],"%m-%d"),".csv",sep='')
        output.data = thermal.data[(head.sign[iblock]+1):(head.sign[iblock+1]+1),]
        output.data =as.matrix(output.data)
        colnames(output.data) = c("","0","0.42","1.09","1.65")
        ## temp = output.data[,2:5]
        temp = output.data[,2:4]
        class(temp) <- "numeric"
#        output.data = output.data[which(!is.na(rowSums(temp))),]
        output.data = output.data[which(!is.na(rowSums(temp))),1:4]                
        write.table(output.data,file=fname,quote=FALSE,sep=",",row.names=FALSE) 
    } else {
        
        fname = paste("splited_data/evan_intrusion/",iblock,"_",
                      head.sign[iblock+1]-head.sign[iblock],"_",
                      format(thermal.data[,1][head.sign[iblock]],"%m-%d"),".csv",sep='')
        output.data = thermal.data[(head.sign[iblock]+1):(head.sign[iblock+1]+1),]
        output.data = as.matrix(output.data)
        colnames(output.data) = c("","0","0.42","1.09","1.65")
        ## temp = output.data[,2:5]
        temp = output.data[,2:4]        
        class(temp) <- "numeric"
        ##     output.data = output.data[which(!is.na(rowSums(temp))),]
        output.data = output.data[which(!is.na(rowSums(temp))),1:4]                        
        write.table(output.data,file=fname,quote=FALSE,sep=",",row.names=FALSE) 
    }
}


