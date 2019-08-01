rm(list=ls())

load(file="results/river.gradient.r.2010_2015.r")
river.gradient = gradient[26305:length(gradient)]

load(file="results/inland.gradient.r.2013_2016.r")
inland.gradient = gradient##[1:length(river.gradient)]

start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")



jpeg(paste("figures/compare.gradient.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)

plot(time.index[1:length(river.gradient)],river.gradient,type="l",col="blue",
     xlim=range(start.time,end.time),
     xlab="Time",
     ylab="Gradient",
     ylim = c(0,0.0004)
     
##     axes= FALSE,
     )
load("results/level.data.r")

points(time.index[1:(length(river.gradient)+152*24)],inland.gradient[1:(length(river.gradient)+152*24)],col='black',pch=16,cex=0.5)

legend("topright",c("River gradient","Inland gradient"),pch=c(NA,16),lty=c(1,NA),col=c("blue","black"))
dev.off()

compare.river = river.gradient
compare.inland = inland.gradient[1:(365*3*24)]

mean(compare.inland[!is.na(compare.inland)])
mean(compare.river[!is.na(compare.inland)])

sd(compare.inland[!is.na(compare.inland)])
sd(compare.river[!is.na(compare.inland)])
