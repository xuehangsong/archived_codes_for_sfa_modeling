rm(list=ls())
library("WaveletComp")

time.ticks = as.POSIXct(paste(as.character(2010:2015),"-01-01",sep=""),
                        tz="GMT",format="%Y-%m-%d")


ori.data = read.table("data/DatumH_River_2010_2015.txt")
time = ori.data[,1]
temp1 = ori.data[,4]

ori.data = read.table("data/DatumH_Inland_2010_2015.txt")
temp2 = ori.data[,4]

ori.data = read.table("data/Temp_River_2010_2015.txt")
temp3 = ori.data[,2]

ori.data = read.table("data/Temp_Inland_2010_2015.txt")
temp4 = ori.data[,2]

obs = data.frame(time,temp1,temp2,temp3,temp4)
obs[,1] = as.POSIXct("2010-01-01",tz="GMT",format="%Y-%m-%d")+obs[,1]
colnames(obs) = c("Time","River level","Inland level","River temperature","Inland temperature")



for (iobs in 2:5)
{
    my.data = data.frame(x=obs[1:8760,iobs])
    rownames(my.data) = obs[1:8760,1]
    my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/64,lowerPeriod=1,upperPeriod=64,make.pval=T,n.sim=10)
    jpeg(file=paste("figures/obs_",colnames(obs)[iobs],"_short.jpg",sep=""),width=8,height=4,units="in",res=300,quality=100)
    wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (hour)",main=colnames(obs)[iobs],
         timelab=NA
         )
    dev.off()
}


## for (iobs in 2:5)
## {
##     my.data = data.frame(x=obs[,iobs])
##     rownames(my.data) = obs[,1]
##     my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/64,lowerPeriod=1,upperPeriod=2048,make.pval=T,n.sim=10)
##     jpeg(file=paste("figures/obs_",colnames(obs)[iobs],".jpg",sep=""),width=8,height=4,units="in",res=300,quality=100)
##     wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
##          show.date = TRUE,periodlab="Period (hour)",main=colnames(obs)[iobs],
##          timelab=NA
##          )
##     dev.off()
## }


## for (iobs in 2:5)
## {
##     my.data = data.frame(x=obs[,iobs])
##     rownames(my.data) = obs[,1]
##     my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/64,lowerPeriod=1,upperPeriod=2^16,make.pval=T,n.sim=10)
##     jpeg(file=paste("figures/obs_",colnames(obs)[iobs],"_long.jpg",sep=""),width=8,height=4,units="in",res=300,quality=100)
##     wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
##          show.date = TRUE,periodlab="Period (hour)",main=colnames(obs)[iobs],
##          timelab=NA
##          )
##     dev.off()
## }
