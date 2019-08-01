rm(list=ls())
library(xts)

load("results/thermal_data.r")

source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")

start.time = as.POSIXct("2016-04-01 00:00:00",tz="GMT")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT")
time.ticks = seq(from=as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
                ,to=as.POSIXct("2017-12-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),by="1 month")                        



temp=thermistor.xts[.indexmin(thermistor.xts) %in% c(0,59,60),]
thermistor.xts=temp

temp=sws1.xts[.indexmin(sws1.xts) %in% c(0,59,60),]
sws1.xts=temp


jpeg(paste("figures/dam_thermistor_all.jpg",sep=''),width=8,height=5,units='in',res=300,quality=10)
par(mgp=c(1.8,0.7,0))
plot(well2_3[,"Time"],well2_3[,"Temp"],
     xlim=c(start.time,end.time),
     ylim = c(0,25),
     type="l",
     xlab="Time",
     axes=FALSE,
     ylab=expression(paste("Temperature ("^o,"C)"))
     )
box()
axis(side = 1,at=time.ticks,labels = format(time.ticks,format="%m/%Y"))
axis(side = 2,at=seq(0,25,5))
lines(index(thermistor.xts),thermistor.xts[,"-0.64"],col="red")
lines(index(thermistor.xts),thermistor.xts[,"-0.24"],col="orange")
lines(index(thermistor.xts),thermistor.xts[,"-0.04"],col="green")
lines(index(thermistor.xts),thermistor.xts[,"0.16"],col="blue")
#lines(index(sws1.xts),sws1.xts[,"Temp"],col="blue")


legend("topright",c("Inland","-0.64m","-0.24m","-0.04m","River"),
       col=c("black","red","orange","green","blue"),lwd=1,horiz=TRUE,
       bty="n"
       )

dev.off()


stop()

jpeg(paste("figures/thermistor_all.jpg",sep=''),width=15,height=2.5,units='in',res=300,quality=100)
par(mar=c(2.1,4.1,1,1))
plot(index(thermistor.output),thermistor.output[,1],
     type="l",col="white",
     ylim=c(0,20),
     xlab=NA,
     ylab = expression(paste("Temperature ("^o,"C)")),
     )
for (itemp in 1:4)    
{
    lines(index(thermistor.output),thermistor.output[,itemp],
          col=temp_color[itemp]
          )
}
dev.off()
