rm(list=ls())
load("results/interp.data.r")
load("results/mass.data.r")

mass.trim = list()
for (islice in names(mass.data))
{
     mass.trim[[islice]][["stage"]] = mass.data[[islice]][["stage"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]+1.039
     mass.trim[[islice]][["date"]] = mass.data[[islice]][["date"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]
     mass.trim[[islice]][["temperature"]] = mass.data[[islice]][["temperature"]][which(mass.data[[islice]][["date"]]>=start.time & mass.data[[islice]][["date"]]<=end.time)]     
}

jpeg(paste("figures/mass.compare.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(interp.time,level.xts[["SWS-1"]],col='blue',type="l",
     ylim=c(103.5,107.5),
     ylab="Level (m)",
     xlab="Time (year)",     
     )

## for (islice in names(mass.data))
## {
##     lines(mass.trim[[islice]][["date"]],mass.trim[[islice]][["stage"]])

## }

lines(mass.trim[["321"]][["date"]],mass.trim[["323"]][["stage"]],col="black")
lines(mass.trim[["323"]][["date"]],mass.trim[["323"]][["stage"]],col="red")



legend("topright",c("SWS-1","323","321"),col=c("blue","red","black"),lty=1)

dev.off()


jpeg(paste("figures/mass.compare.temp.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(interp.time,temp.xts[["SWS-1"]],col='blue',type="l",
     ylim=c(0,25),
     ylab="Temperature (DegC)",
     xlab="Time (year)",     
     )

##for (islice in names(mass.data))
for (islice in "321")
{
    lines(mass.trim[[islice]][["date"]],mass.trim[[islice]][["temperature"]])

}

lines(mass.trim[["323"]][["date"]],mass.trim[["323"]][["temperature"]],col="red")


legend("topright",c("SWS-1","323","321"),col=c("blue","red","black"),lty=1)

dev.off()






jpeg(paste("figures/level.regression.jpg",sep=''),width=6,height=6,units='in',res=200,quality=100)
plot(head(mass.trim[["323"]][["stage"]],(365*2*24+366*24)),head(level.xts[["SWS-1"]],(365*2*24+366*24)),asp=1,pch=16,cex=0.2,
     xlab="323",
     ylab="SWS-1",     
     )
dev.off()

jpeg(paste("figures/temp.regression.jpg",sep=''),width=6,height=6,units='in',res=200,quality=100)
plot(head(mass.trim[["323"]][["temperature"]],(365*2*24+366*24)),head(temp.xts[["SWS-1"]],(365*2*24+366*24)),asp=1,pch=16,cex=0.2,
     xlab="323",
     ylab="SWS-1",     
     )
dev.off()



##mean(mass.trim[["323"]][["stage"]][which(!is.na(level.xts[["SWS-1"]]))])
