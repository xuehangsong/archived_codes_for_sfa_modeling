rm(list=ls())
library(gplots)
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
z = as.numeric(colnames(thermal.data))
z = -z+104.9
thermal.data = thermal.data[,order(z)]
z = sort(z)
z.middle = diff(z)*0.5+head(z,-1)
z.middle = rep(z.middle,each=2)+rep(c(-0.0001,0.0001),3)
z.bound = c(z[1],z.middle,tail(z,1))
thermal.modi = cbind(thermal.data[,1],thermal.data[,1],
                     thermal.data[,2],thermal.data[,2],
                     thermal.data[,3],thermal.data[,3],
                     thermal.data[,4],thermal.data[,4])


range = range(thermal.data)



time.ticks = c(
    as.POSIXct("2016-03-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2016-04-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2016-05-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2016-06-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2016-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2016-08-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S")                               
)




jpeg(paste("thermistor.finger.jpg",sep=""),width=10,height=4,units="in",res=200,quality=100)
par(mar=c(4,5,2,0),mgp=c(3,1,0))
filled.contour(index(thermal.data),z.bound,thermal.modi,
               color = bluered,
               ylim=c(min(z),max(river.data[,4],na.rm=TRUE)),
               xlim = range(start.time,end.time),
               zlim=range,
               ylab = "Elevation (m)",
               plot.axes = {
                   axis.POSIXct(1,at=time.ticks,format="%Y-%m");
##                   axis(2,at=seq(-0.6,0,0.2)+104.9)
                   axis(2,at=seq(104.3,108,0.2))                   
                   mtext("Time",1,line=2)
                   lines(index(river.data),river.data[,4])

                   river.part = river.data[,4]
                   river.part[which(river.data[,4]>=inland.data[,4])] = NA
                   lines(index(river.data),river.part,col="green")
                   
                   }
               )

dev.off()
