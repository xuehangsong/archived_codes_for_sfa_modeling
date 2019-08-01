rm(list=ls())
library(xts)

start.time = as.POSIXct("2016-03-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-03-30 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="15 mins")

ibutton.list=list()
ibutton.list[["A"]] = as.character(seq(1,6))
ibutton.list[["B"]] = as.character(seq(1,5))
ibutton.list[["C"]] = as.character(c(seq(1,4),6))
ibutton.list[["D"]] = as.character(c(1,seq(3,6)))
ibutton.list[["E"]] = as.character(c(1,seq(3,6)))

ibutton.data = list()
ibutton.data[["A"]] = list()
ibutton.data[["B"]] = list()
ibutton.data[["C"]] = list()
ibutton.data[["D"]] = list()
ibutton.data[["E"]] = list()

for (isection in c("A","B","C","D","E"))
    {
        for (idepth in ibutton.list[[isection]])
            {
                data.file = paste("ibutton/",isection,idepth,".csv",sep="")
                ibutton.data[[isection]][[idepth]]= read.table(data.file,skip=19,sep=',',header=TRUE)
                ibutton.data[[isection]][[idepth]][,1] = as.POSIXct(ibutton.data[[isection]][[idepth]][,1],
                                                                  format="%m/%d/%y %I:%M:%S %p",tz="GMT")
                temp = ibutton.data[[isection]][[idepth]]
                temp = temp[which(temp[,1]>=start.time & temp[,1]<=end.time),]
                temp = xts(temp,order.by=temp[,1] ,unique=T,tz="GMT")
                temp = temp[.indexmin(temp) %in% c(0:5,10:20,25:35,40:50,55:59),]
                temp = temp[c('2016'),]
                index(temp) = as.POSIXct(round(as.numeric(index(temp))/(15*60))*(15*60),origin="1970-01-01",tz="GMT")
                temp = temp[!duplicated(.index(temp)),]
                temp = merge(temp,time.index)
                
                ibutton.data[[isection]][[idepth]] = temp

            }
    }

ibutton.depth = read.table("ibutton/ibutton.depth.csv",header=TRUE,sep=",",row.names=1)
colnames(ibutton.depth) = as.character(seq(1:6))
rownames(ibutton.depth) = c("A","B","C","D","E")

save(list=ls(),file="results/ibutton.data.r")


