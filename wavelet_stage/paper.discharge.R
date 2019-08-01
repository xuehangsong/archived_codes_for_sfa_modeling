rm(list=ls())
library("WaveletComp")

time.ticks = as.POSIXct(paste(as.character(1985:2008),"-01-01",sep=""),
                        tz="GMT",format="%Y-%m-%d")


temp1 = read.csv("data/PRD_flow.csv",stringsAsFactors=FALSE)
temp2 = paste(paste(temp1[,1],temp1[,2],sep="-"),temp1[,3],sep="-")
discharge = data.frame(temp2,temp1[,4],temp1[,5])
discharge[,1] = as.POSIXct(discharge[,1],tz="GMT",format="%Y-%m-%d")




## ##jpeg(file="figures/discharge_compare.jpg",width=4.7,height=2,units="in",res=300,quality=100)
## jpeg="figures/discharge_compare.jpg",width=9.8,height=2,units="in",res=300,quality=100)
jpeg(file="figures/discharge_compare.jpg",width=9.8,height=2,units="in",res=300,quality=100)
par(mar=c(2,3.5,1,1))
plot(discharge[,1],discharge[,2]/10000,type="l",col="red",
     axes=FALSE,xlab="",ylab="",ylim=c(0,2.3),
     )
box()
lines(discharge[,1],discharge[,3]/10000,type="l",col="blue")
axis.POSIXct(1,at=time.ticks,tck=-0.06,mgp=c(1,0.5,0))
axis(2,las=1,mgp=c(3,0.5,0),tck=-0.04)
##mtext("Time (yr)",1,line=1.8)
mtext(expression(paste("Discharge (1e"^"4"," m"^"3","/s)",sep="")),2,line=2)
legend(discharge[1,1]-0.5*365*24*3600,2.5,c("Observed","Naturalized"),lty=c(1,2),lwd=2,
       col=c("blue","red"),bty="n",horiz=TRUE)
dev.off()

## jpeg(file="figures/discharge_natural.hist.jpg",width=4,height=4,units="in",res=300,quality=100)
## par(mar=c(3,3,1,1))
## hist(discharge[,2],freq=FALSE,
##      axes=FALSE,
##      xlim=c(0,20000),
##      ylim=c(0,0.0004),
##      main="Historgram of naturalized discharge"
##      )
## box()
## axis(1,mgp=c(2,0.7,0))
## axis(2,mgp=c(2,0.7,0))

## mtext("Dischage",1,line=1.8)
## mtext("Relative frequency",2,line=1.8)
## dev.off()


## jpeg(file="figures/discharge_dam.hist.jpg",width=4,height=4,units="in",res=300,quality=100)
## par(mar=c(3,3,1,1))
## hist(discharge[,3],freq=FALSE,
##      xlim=c(0,20000),
##      ylim=c(0,0.0004),
##      axes=FALSE,
##      main="Historgram of observed discharge"
##      )
## box()
## axis(1,mgp=c(2,0.7,0))
## axis(2,mgp=c(2,0.7,0))

## mtext("Dischage",1,line=1.8)
## mtext("Relative frequency",2,line=1.8)
## dev.off()


## my.data = data.frame(x=discharge[,2])
## rownames(my.data) = discharge[,1]
## natural.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/250,lowerPeriod=1,upperPeriod=512,make.pval=T,n.sim=10)

## my.data = data.frame(x=discharge[,3])
## rownames(my.data) = discharge[,1]
## real.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/250,lowerPeriod=1,upperPeriod=512,make.pval=T,n.sim=10)


##save(list=ls(),file="discharge.wavelet.r")

load(file="discharge.wavelet.r")

##jpeg(file="figures/discharge_wavelet.jpg",width=2.3,height=2,units="in",res=300,quality=100)
jpeg(file="figures/discharge_wavelet.jpg",width=4.7,height=3,units="in",res=300,quality=100)
par(mar=c(3.5,3.5,0.2,0.8))
yaxis = seq(-2,10,2)
plot(real.w$Power.avg,log2(real.w$Period),type="l",lwd=2,
     col="blue",
     xlim=c(0,0.9),ylim=log2(c(0.25,512)),
     axes=FALSE,xlab=NA,ylab=NA,
     )
box()
lines(natural.w$Power.avg,log2(natural.w$Period),col="red",lty=2,lwd=2)
axis(1,at=seq(0,1,0.2),tck=-0.02,mgp=c(1.5,0.5,0))
axis(2,at=yaxis,labels=2^yaxis,mgp=c(3,0.5,0),tck=-0.02,las=2)
mtext("Average wavelet power",1,line=1.5)
mtext("Period (log2 day)",2,line=2)

legend("bottomright",c("Observed discharge","Naturalized discharge"),
       lty=c(1,2),lwd=2,
       col=c("blue","red"),bty="n",horiz=FALSE,cex=0.9)


dev.off()


stop()

jpeg(file="figures/wps_natural_long.jpg",width=9,height=3,units="in",res=300,quality=100)
par(mar=c(2,3,0,1),mgp=c(1,0.5,0))
wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (day)",
         timelab=NA,
         axes=FALSE,
##         main="Wavelet power spectrum of naturalized discharge",         
         )
dev.off()

stop()

jpeg(file="figures/wps_natural_long_year.jpg",width=8,height=4,units="in",res=300,quality=100)
par(mgr=c(3,3,1,1),mgp=c(1,0.5,0))
wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (day)",
         main="Wavelet power spectrum of naturalized discharge",                  
         timelab=NA
         )
dev.off()



my.data = data.frame(x=discharge[,2])
rownames(my.data) = discharge[,1]
my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/250,lowerPeriod=1,upperPeriod=64,make.pval=T,n.sim=10)
jpeg(file="figures/wps_natural_short.jpg",width=8,height=4,units="in",res=300,quality=100)
par(mgr=c(3,3,1,1),mgp=c(1,0.5,0))
wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (day)",
         main="Wavelet power spectrum of naturalized discharge",                  
         timelab=NA
         )
dev.off()


my.data = data.frame(x=discharge[1:365,2])
rownames(my.data) = discharge[1:365,1]
my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/250,lowerPeriod=1,upperPeriod=64,make.pval=T,n.sim=10)
jpeg(file="figures/wps_natural_short_year.jpg",width=8,height=4,units="in",res=300,quality=100)
par(mgr=c(3,3,1,1),mgp=c(1,0.5,0))
wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (day)",
         main="Wavelet power spectrum of naturalized discharge",                  
         timelab=NA
         )
dev.off()







my.data = data.frame(x=discharge[,3])
rownames(my.data) = discharge[,1]
my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/250,lowerPeriod=1,upperPeriod=2048,make.pval=T,n.sim=10)
jpeg(file="figures/wps_dam_long.jpg",width=8,height=4,units="in",res=300,quality=100)
par(mgr=c(3,3,1,1),mgp=c(1,0.5,0))
wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (day)",
         main="Wavelet power spectrum of observed discharge",                  
         timelab=NA
         )
dev.off()


my.data = data.frame(x=discharge[1:365,3])
rownames(my.data) = discharge[1:365,1]
my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/250,lowerPeriod=1,upperPeriod=2048,make.pval=T,n.sim=10)
jpeg(file="figures/wps_dam_long_year.jpg",width=8,height=4,units="in",res=300,quality=100)
par(mgr=c(3,3,1,1),mgp=c(1,0.5,0))
wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (day)",
         main="Wavelet power spectrum of observed discharge",                           
         timelab=NA
         )
dev.off()



my.data = data.frame(x=discharge[,3])
rownames(my.data) = discharge[,1]
my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/250,lowerPeriod=1,upperPeriod=64,make.pval=T,n.sim=10)
jpeg(file="figures/wps_dam_short.jpg",width=8,height=4,units="in",res=300,quality=100)
par(mgr=c(3,3,1,1),mgp=c(1,0.5,0))
wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (day)",
         main="Wavelet power spectrum of observed discharge",                           
         timelab=NA
         )
dev.off()


my.data = data.frame(x=discharge[1:365,3])
rownames(my.data) = discharge[1:365,1]
my.w = analyze.wavelet(my.data,"x",loess.span=0,dt=1,dj=1/250,lowerPeriod=1,upperPeriod=64,make.pval=T,n.sim=10)
jpeg(file="figures/wps_dam_short_year.jpg",width=8,height=4,units="in",res=300,quality=100)
par(mgr=c(3,3,1,1),mgp=c(1,0.5,0))
wt.image(my.w,color.key="quantile",n.levels=250,legend.params=list(lab="wavelet power levels",mar=4.7),
         show.date = TRUE,periodlab="Period (day)",
         main="Wavelet power spectrum of observed discharge",                           
         timelab=NA
         )
dev.off()
