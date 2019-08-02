rm(list=ls())
library("stats")

fig.dir = "/Users/song884/drought/Figures/"

time.ticks = as.POSIXct(paste(as.character(1985:2088),"-01-01",sep=""),
                        tz="GMT",format="%Y-%m-%d")

start.time = as.POSIXct("2010-01-01 00:00:00",
                        tz="GMT",
                        format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-01-01 00:00:00",
                      tz="GMT",
                      format="%Y-%m-%d %H:%M:%S")
month.ticks = seq(start.time,end.time,by="1 month")

temp1 = read.csv(
    paste("/Users/song884/drought/Data/Observation_Data/",
          "PRD_flow.csv",sep=""),stringsAsFactors=FALSE)
temp2 = paste(paste(temp1[,1],temp1[,2],sep="-"),temp1[,3],sep="-")
discharge = data.frame(temp2,temp1[,4],temp1[,5])
discharge[,1] = as.POSIXct(discharge[,1],tz="GMT",format="%Y-%m-%d")

level.river = list()
level.inland = list()
temp.inland = list()
temp.river = list()

cases = c("1","4","5")
colors = c("blue","green","red")
ltys = c(1,1,1)
names(colors) = cases
names(ltys) = cases


for (icase in cases)
{
    temp.data = read.table(
        paste("/Users/song884/drought/Data/Simulation_Data/Input/1_h/",icase,
              "/DatumH_River_2010_2015_average_3.txt",sep=""))
    level.river[[icase]] = list(start.time+as.numeric(temp.data[,1]),
                                temp.data[,4])

    temp.data = read.table(
        paste("/Users/song884/drought/Data/Simulation_Data/Input/1_h/",icase,
              "/DatumH_Inland_2010_2015_average_3.txt",sep=""))
    level.inland[[icase]] = list(start.time+as.numeric(temp.data[,1]),
                                temp.data[,4])

    temp.data = read.table(
        paste("/Users/song884/drought/Data/Simulation_Data/Input/1_h/",icase,
              "/Temp_River_2010_2015_average_3.txt",sep=''))
    temp.river[[icase]] = list(start.time+as.numeric(temp.data[,1]),
                               temp.data[,2])


    temp.data = read.table(
        paste("/Users/song884/drought/Data/Simulation_Data/Input/1_h/",icase,
              "/Temp_Inland_2010_2015_average_3.txt",sep=''))
    temp.inland[[icase]] = list(start.time+as.numeric(temp.data[,1]),
                                temp.data[,2])
}


levels.fft = list()
for (icase in cases)
{
    levels.fft[[icase]]=spectrum(level.river[[icase]][[2]],
                                 log="no",plot="FALSE")
}

discharge.fft = list()
discharge.fft[[1]] = spectrum(discharge[,2],
                              log="no",plot="FALSE")
discharge.fft[[2]] = spectrum(discharge[,3],
                                 log="no",plot="FALSE")



## jpeg(file=paste(fig.dir,"fft_stage.jpg",sep=""),
##      width=10,height=6,units="in",
##      res=300,quality=100)
pdf(file=paste(fig.dir,"fft_stage.pdf",sep=""),
     width=10,height=6)
par(mar=c(2.5,3.5,2.7,0.8),mfrow=c(2,2))

plot(discharge[,1],discharge[,2]/10000,type="l",col="red",
     axes=FALSE,xlab="",ylab="",ylim=c(0,2.5),
     )
box()
lines(discharge[,1],discharge[,3]/10000,type="l",col="blue")
mtext(" (a) River discharge",3,line=1.1,cex=1.2)
axis.POSIXct(1,at=time.ticks,tck=-0.02,mgp=c(1,0.5,0))
axis(2,las=1,mgp=c(3,0.5,0),tck=-0.02)
mtext("Time (year)",1,line=1.5)
mtext(expression(paste("Discharge (10"^"4"," m"^"3","/s)",sep="")),2,line=2)
legend(#discharge[1,1]-0.5*365*24*3600,2.5,
    "topright",
    c("Real discharge","Naturalized discharge"),lty=1,lwd=2,
    col=c("blue","red"),bty="n",horiz=TRUE)



sampling.intervel=24
icase=2
spx <-discharge.fft[[icase]]$freq/sampling.intervel
spy <- 2*discharge.fft[[icase]]$spec

plot(spy~spx,col="blue",t="h",
     ylim=c(1e-15,5e8),
     xlim=c(1e-5,0.1),
     axes=FALSE,xlab=NA,ylab=NA,
     )
rect(-20,-2e10,0.05,10e10,col=rgb(0,0,1,alpha=0.04))
rect(0.05,-2e10,20,10e10,col=rgb(1,0,0,alpha=0.04))
box()

## lines(c(1/24/7*2,1/24/7*2),c(-100,1e10))
## lines(c(1/24/2.35,1/24/2.35),c(-100,1e10))

icase=1
spx <-discharge.fft[[icase]]$freq/sampling.intervel+0.055
spy <- 2*discharge.fft[[icase]]$spec
lines(spy~spx,col="red",t="s")

mtext(" (b) Spectral density of river discharge",3,line=1.1,cex=1.2)
mtext("Frequency (1/hour)",1,line=1.5)
mtext(expression("Spectral density (10"^"8"~")"),2,line=1.7)
axis(1,seq(0,0.04,0.02),tck=-0.02,mgp=c(1.5,0.5,0),
     col="blue",col.ticks="blue",
     col.axis="blue",
     )
axis(1,0.055+seq(0,0.04,0.02),labels = seq(0,0.04,0.02),
     col="red",col.ticks="red",
     col.axis="red",
     tck=-0.02,mgp=c(1.5,0.5,0))
axis(2,at=seq(0,5e8,1e8),
     labels=c("0.0","1.0","2.0","3.0","4.0","5.0"),
    tck=-0.02,mgp=c(1.5,0.5,0),las=2)
axis(3,
     c(1/24,1/24/7),col="blue",
     labels=c("1d","1w"),cex.axis=1,
     col.ticks="blue",
     col.axis="blue",tck=-0.02,mgp=c(1.3,0.15,0))
axis(3,
     c(1/365/24),col="red",
     labels=c("1y"),cex.axis=1,
     col.ticks="blue",
     col.axis="blue",tck=-0.02,mgp=c(1.5,0.15,0))
axis(3,
     c(1/24,1/24/7)+0.055,col="red",
     labels=c("1d","1w"),cex.axis=1,
     col.ticks="red",
     col.axis="red",tck=-0.02,mgp=c(1.3,0.15,0))
axis(3,
     c(1/365/24)+0.055,col="red",
     labels=c("1y"),cex.axis=1,
     col.ticks="red",
     col.axis="red",tck=-0.02,mgp=c(1.5,0.15,0))

legend(0.005,5.2e8,
    c("Real discharge"),lty=1,lwd=2,
    col=c("blue","red"),bty="n",horiz=TRUE)

legend(0.005+0.05,5.2e8,
    c("Naturalized discharge"),lty=1,lwd=2,
    col=c("red"),bty="n",horiz=TRUE)

plot(level.river[["1"]][[1]],level.river[["1"]][[2]],type="l",
     col="blue",
     xlab="",
     ylab="",
     axes=FALSE,     
#     xlim = xlim,      
     ylim=c(104,109),     
     )
box()
mtext(" (c) River stage",3,line=1.1,cex=1.2)
mtext("River stage (m)",2,line=2)
mtext("Time (year)",1,line=1.5)
axis.POSIXct(1,at=time.ticks,format="%Y",tck=-0.02,mgp=c(1,0.5,0));
axis(2,seq(104,109,1),las=1,mgp=c(3,0.5,0),tck=-0.02);                        
## lines(level.inland[[1]][[1]],level.inland[[1]][[2]],col="black")
## legend(start.time,110.5,c("River stage","Inland level"),lty=1,lwd=2,
##        col=c("blue","black"),bty="n",horiz=TRUE
##        )

sampling.intervel=1
ilist = cases[1]
spx <-levels.fft[[ilist]]$freq/sampling.intervel
spy <- 2*levels.fft[[ilist]]$spec
plot(spy~spx,col="white",t="h",
     ylim=c(1e-15,1e2),
     xlim=c(1e-5,0.1),
     axes=FALSE,xlab=NA,ylab=NA,

     )
box()
for (icase in cases[c(1)])
{
    spx <-levels.fft[[icase]]$freq/sampling.intervel
    spy <- 2*levels.fft[[icase]]$spec
    lines(spy~spx,col=colors[[icase]],lty=ltys[[icase]],t="s")
}
mtext(" (d) Spectral density of river stage",3,line=1.1,cex=1.2)
mtext("Frequency (1/hour)",1,line=1.5)
mtext("Spectral density",2,line=1.7)
axis(1,seq(0,0.5,0.02),tck=-0.02,mgp=c(1.5,0.5,0))
axis(2,tck=-0.02,mgp=c(1.5,0.5,0),las=2)
axis(3,
     c(1/12,1/24,1/24/7),col="blue",
     labels=c("12h","1d","1w"),cex.axis=1,
     col.ticks="blue",
     col.axis="blue",tck=-0.02,mgp=c(1.3,0.15,0))
axis(3,
     c(1/365/24),col="blue",
     labels=c("1y"),cex.axis=1,
     col.ticks="blue",
     col.axis="blue",tck=-0.02,mgp=c(1.5,0.15,0))
dev.off()







## jpeg(file=paste(fig.dir,"temp_stage.jpg",sep=""),
##      width=10,height=6,units="in",
##      res=300,quality=100)
pdf(file=paste(fig.dir,"temp_stage.pdf",sep=""),
     width=10,height=6)
par(mar=c(2.5,3.5,2.7,0.8),mfrow=c(2,2))


### time series of river stage and groundwater level
plot(level.river[["1"]][[1]],level.river[["1"]][[2]],type="l",
     col="blue",
     xlab="",
     ylab="",
     axes=FALSE,     
#     xlim = xlim,      
     ylim=c(104,109),     
     )
box()
mtext(" (a) Monitored river stage and groundwater level",
      3,line=1.1,cex=1.2)
mtext("Water level (m)",2,line=2)
mtext("Time (year)",1,line=1.5)
axis.POSIXct(1,at=time.ticks,format="%Y",tck=-0.02,mgp=c(1,0.5,0));
axis(2,seq(104,109,1),las=1,mgp=c(3,0.5,0),tck=-0.02);                        
lines(level.inland[["1"]][[1]],level.inland[["1"]][[2]],col="black")
legend("topright",c("River stage","Groundwater level"),lty=1,lwd=2,
       col=c("blue","black"),bty="n",horiz=TRUE
       )


plot(temp.river[["1"]][[1]],temp.river[["1"]][[2]],type="l",
     col="blue",
     xlab="",
     ylab="",
     axes=FALSE,     
#     xlim = xlim,      
     ylim=c(0,25),     
     )
box()
mtext(" (b) Monitored river and groundwater temperature",
      3,line=1.1,cex=1.2)
mtext(expression("Water temperature ("^"o"~"C)"),2,line=2)
mtext("Time (year)",1,line=1.5)
axis.POSIXct(1,at=time.ticks,format="%Y",tck=-0.02,mgp=c(1,0.5,0));
axis(2,seq(0,25,5),las=1,mgp=c(3,0.5,0),tck=-0.02);                        
lines(temp.inland[["1"]][[1]],temp.inland[["1"]][[2]],col="black")
legend("topright",c("River temperature","Groundwater temperature"),lty=1,lwd=2,
       col=c("blue","black"),bty="n",horiz=TRUE
       )


## filtered river boundary
plot(level.river[["1"]][[1]],level.river[["1"]][[2]],type="l",
     col="blue",
     xlab="",
     ylab="",
     axes=FALSE,     
     xlim= c(as.POSIXct(
         "2013-03-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
         as.POSIXct(
             "2013-09-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S")),
     ylim=c(104,109),     
     )
for (icase in c("4","5"))
{
    lines(level.inland[[icase]][[1]],
          level.inland[[icase]][[2]],
          col=colors[[icase]],
          lty=ltys[[icase]],lwd=2)
}

box()
mtext(" (c) Original/smoothed river stage",
      3,line=1.1,cex=1.2)
mtext("Water level (m)",2,line=2)
mtext("Time (month)",1,line=1.5)
axis.POSIXct(1,
             at=month.ticks,
             format="%m/%Y",tck=-0.02,mgp=c(1,0.5,0));
axis(2,seq(104,109,1),las=1,mgp=c(3,0.5,0),tck=-0.02);                        
legend("topright",c("1 hour","1 day","1 week"),lty=ltys,lwd=2,
       col=colors,bty="n",horiz=TRUE
       )


## fft results
sampling.intervel=1
ilist = cases[1]
spx <-levels.fft[[ilist]]$freq/sampling.intervel
spy <- 2*levels.fft[[ilist]]$spec
plot(spy~spx,col="white",t="h",
     ylim=c(1e-15,1e2),
     xlim=c(1e-5,0.1),
     axes=FALSE,xlab=NA,ylab=NA,

     )
box()
for (icase in c("1","4","5"))
{
    spx <-levels.fft[[icase]]$freq/sampling.intervel
    spy <- 2*levels.fft[[icase]]$spec
    lines(spy~spx,col=colors[[icase]],lty=ltys[[icase]],t="s")
}
mtext(" (d) Spectral density of river stage",3,line=1.1,cex=1.2)
mtext("Frequency (1/hour)",1,line=1.5)
mtext("Spectral density",2,line=1.7)
axis(1,seq(0,0.5,0.02),tck=-0.02,mgp=c(1.5,0.5,0))
axis(2,tck=-0.02,mgp=c(1.5,0.5,0),las=2)
axis(3,
     c(1/12,1/24,1/24/7),col="black",
     labels=c("12h","1d","1w"),cex.axis=1,
     col.ticks="black",
     col.axis="black",tck=-0.02,mgp=c(1.3,0.15,0))
axis(3,
     c(1/365/24),col="black",
     labels=c("1y"),cex.axis=1,
     col.ticks="black",
     col.axis="black",tck=-0.02,mgp=c(1.5,0.15,0))
legend("topright",c("1 hour","1 day","1 week"),lty=ltys,lwd=2,
       col=colors,bty="n",horiz=TRUE
       )


## temperature


dev.off()


