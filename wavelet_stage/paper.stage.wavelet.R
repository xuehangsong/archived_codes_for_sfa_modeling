## rm(list=ls())
## library("WaveletComp")

## time.ticks = as.POSIXct(paste(as.character(2010:2015),"-01-01",sep=""),
##                         tz="GMT",format="%Y-%m-%d")


## ori.data = read.table("without_delay/1/DatumH_River_2010_2015_average_3.txt")
## level1 = data.frame(x=ori.data[,4])

## ori.data = read.table("without_delay/4/DatumH_River_2010_2015_average_3.txt")
## level4 = data.frame(x=ori.data[,4])

## ori.data = read.table("without_delay/5/DatumH_River_2010_2015_average_3.txt")
## level5 = data.frame(x=ori.data[,4])



## w1 = analyze.wavelet(level1,"x",loess.span=0,dt=1,dj=1/25,lowerPeriod=1,upperPeriod=12288,make.pval=FALSE)#,make.pval=T,n.sim=10)
## w4 = analyze.wavelet(level4,"x",loess.span=0,dt=1,dj=1/25,lowerPeriod=1,upperPeriod=12288,make.pval=FALSE)#,make.pval=T,n.sim=10)
## w5 = analyze.wavelet(level5,"x",loess.span=0,dt=1,dj=1/25,lowerPeriod=1,upperPeriod=12288,make.pval=FALSE)#,make.pval=T,n.sim=10)

## save(list=ls(),file="stage.wavelet.r")
load(file="stage.wavelet.r")
yaxis = seq(-4,10,2)
jpeg(file="figures/stage_wavelet.jpg",width=4.7,height=3,units="in",res=300,quality=100)
par(mar=c(3.5,3.5,0.2,0.8))
plot(w1$Power.avg,log2(w1$Period/24),type="l",
     col="blue",lwd=2,
     xlim=c(0,0.95),
     ylim=c(-2,9),
     axes=FALSE,xlab=NA,ylab=NA,
     )
lines(w4$Power.avg,log2(w4$Period/24),col="green",lwd=2,lty=3)
lines(w5$Power.avg,log2(w5$Period/24),col="red",lwd=2,lty=2)
box()
axis(1,at=seq(0,1,0.2),tck=-0.02,mgp=c(1.5,0.5,0))
axis(2,at=yaxis,labels=2^yaxis,mgp=c(3,0.5,0),tck=-0.02,las=2)
mtext("Average wavelet power",1,line=1.5)
mtext("Period (log2 day)",2,line=2)

legend("bottomright",c("Observed hourly river stage ",
                       "Daily smoothed river stage",
                       "Weekly smoothed river stage"),
       lty=c(1,3,2),lwd=2,
       col=c("blue","green","red"),bty="n",horiz=FALSE,cex=0.9)

dev.off()

