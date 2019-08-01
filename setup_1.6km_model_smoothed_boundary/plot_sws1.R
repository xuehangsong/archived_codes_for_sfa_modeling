## rm(list=ls())

## river = read.csv("data/velo/SWS-1_3var.csv")
## river[,1] = as.POSIXct(river[,1],format="%d-%b-%Y %H:%M:%S",tz="GMT")


rm(list=ls())
library("xts")
setwd("~/history/boundary.dataset/")
load("results/mass.data.xts.r")


start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")


slice.list = names(mass.data.xts)
for (islice in slice.list)
{
    mass.data.xts[[islice]] = mass.data.xts[[islice]][index(mass.data.xts[[islice]])>=start.time,]
    mass.data.xts[[islice]] = mass.data.xts[[islice]][index(mass.data.xts[[islice]])<=end.time,]    
}



time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600

nslice = length(slice.list)


coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% slice.list,]
nwell = dim(coord.data)[1]
y = coord.data[slice.list,2]
names(y)=rownames(coord.data)



mass.level = array(NA,c(nslice,ntime))
rownames(mass.level) = slice.list
for (islice in slice.list) {
    print(islice)
    mass.level[islice,] = mass.data.xts[[islice]][,"stage"]
}

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
simu.time = simu.time+start.time
for (islice in 1:nslice)
{
    fname = paste("figures/compare_wl_",as.character(slice.list[islice]),".jpg",sep='')
    jpeg(fname,width=8,height=5,units='in',res=300,quality=100)    
    par(mar=c(8,4,2,2))
    plot(simu.time,mass.level[islice,],type="l",
         xlim=c(as.POSIXct("2012-01-01 00:00:0)",format="%Y-%m-%d %H:%M:%S",tz="GMT"),
                as.POSIXct("2014-01-01 00:00:0)",format="%Y-%m-%d %H:%M:%S",tz="GMT")),
         ylim=c(104,109),
         xlab=NA,ylab=NA,axes=FALSE,
         main=paste("MASS1 Section",as.character(slice.list[islice]))
         )
    axis(2)
    mtext("River stage (m)",2,line=2.5)
    axis.POSIXct(1,at=seq(simu.time[1],tail(simu.time,1),by="2 month"),format="%Y-%m")
    par(new=T)
    plot(simu.time,mass.level[islice,],type="l",col="red",
         xlim=c(as.POSIXct("2013-01-01 00:00:0)",format="%Y-%m-%d %H:%M:%S",tz="GMT"),
                as.POSIXct("2015-01-01 00:00:0)",format="%Y-%m-%d %H:%M:%S",tz="GMT")),
         ylim=c(104,109),
         xlab=NA,ylab=NA,axes=FALSE         
     )
    axis.POSIXct(1,at=seq(simu.time[1],tail(simu.time,1),by="2 month"),format="%Y-%m",col="red",col.axis="red",line=3)    
    box()
    dev.off()
}
