rm(list=ls())
library(xts)
load("results/aquifer.grids.r")

start.time = as.POSIXct("2016-08-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-09-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.ticks = seq(from=start.time,to=end.time,by="5 day")
time.mini.ticks = seq(from=start.time,to=end.time,by="1 day")
interp.time = seq(start.time,end.time,3600)


sws1 = read.csv("well/Amy_SWS-1_20160909.csv",stringsAsFactors=FALSE)
sws1 = sws1[,c(1,2,4,8),]
sws1[,1] = as.POSIXct(sws1[,1],tz="GMT",format="%m/%d/%Y %H:%M")
colnames(sws1) = c("Time","Temperature","SpC","WL")

rg3 = read.csv("well/Realtime_RG3.csv",stringsAsFactors=FALSE)
rg3 = rg3[,c(1,3,5,2)]
rg3[,1] = as.POSIXct(rg3[,1],tz="GMT",format="%Y-%m-%d %H:%M:%S")
rg3[,3] = rg3[,3]/1000
colnames(rg3) = c("Time","Temperature","SpC","WL")

erts = readLines("well/Xuehang_ERT_S_Press_Table1.dat",skip=c(1,3,4))
erts = read.csv(textConnection(erts),stringsAsFactors=FALSE)
erts = erts[,c(1,5)]
erts[,2] = erts[,2]*0.703070  ## PSI to mH2O when g=9.80665m/s^2 and water density=1000
erts[,1] = as.POSIXct(erts[,1],tz="GMT",format="%Y-%m-%d %H:%M:%S")
colnames(erts) = c("Time","WL")



## plot(sws1[,c("Time","WL")],type="l")
## lines(rg3[,c("Time","WL")],col="red")
## lines(erts[,c("Time","WL")],col="green")

sws1.xts = sws1
sws1.xts = sws1.xts[which(sws1.xts[,1]>start.time-300),]
sws1.xts = sws1.xts[which(sws1.xts[,1]<end.time+300),]
sws1.xts = xts(sws1.xts,sws1.xts[,1],unique=T,tz="GMT")
sws1.xts = sws1.xts[,-1]
sws1.xts = sws1.xts[.indexmin(sws1.xts) %in% c(57:59,0:3),]
sws1.xts = sws1.xts[c('2016'),]
index(sws1.xts) = round(index(sws1.xts),units="hours")
sws1.xts = sws1.xts[!duplicated(.index(sws1.xts))]
sws1.xts = merge(sws1.xts,time.index)

rg3.xts = rg3
rg3.xts = rg3.xts[which(rg3.xts[,1]>start.time-300),]
rg3.xts = rg3.xts[which(rg3.xts[,1]<end.time+300),]
rg3.xts = xts(rg3.xts,rg3.xts[,1],unique=T,tz="GMT")
rg3.xts = rg3.xts[,-1]
rg3.xts = rg3.xts[.indexmin(rg3.xts) %in% c(57:59,0:3),]
rg3.xts = rg3.xts[c('2016'),]
index(rg3.xts) = round(index(rg3.xts),units="hours")
rg3.xts = rg3.xts[!duplicated(.index(rg3.xts))]
rg3.xts = merge(rg3.xts,time.index)



river.gradient = (rg3.xts[,"WL"]-sws1.xts[,"WL"])/(data.model["RG3",2]-data.model["SWS-1",2])

jpg.name = paste("figures/sws1_rg3.jpg",sep = "")
jpeg(jpg.name,width = 6,height = 4,units = "in",res = 300, quality = 100)            
par(mar=c(3,3,3,3))    
plot(index(sws1.xts),sws1.xts[,"WL"],type="l",
     axes=FALSE,
     ylim =c(104.5,106)
     )
lines(index(rg3.xts),rg3.xts[,"WL"],col="blue")
box()
axis.POSIXct(1,at=time.ticks,format="%b-%d",mgp=c(1,0.6,0))
axis.POSIXct(1,at=time.mini.ticks,format="%b-%d",mgp=c(10,0.6,0),tck=-0.025)
axis(2,at=seq(104.5,106,0.5),mgp=c(1,0.6,0))
mtext("Time (day)",1,line=1.7)
mtext("Water level (m)",2,line=1.7)
legend("topleft",c("SWS-1 level (m)","RG3 level (m)"),lty=1,
       col=c("black","blue"),bty="n"
       )


par(new=T)
plot(index(sws1.xts),river.gradient,
     type="l",col="red",lty=3,ylim=c(-9e-5,1.5e-4),
     axes=FALSE
     )

##plot(as.numeric(rg3.xts[,"WL"]),as.numeric(rg3.xts[,"WL"]-sws1.xts[,"WL"]))
at = seq(-9e-5,1.5e-4,0.8e-4)
axis(4,at = at,formatC(at,format="e",digits=1),mgp=c(1,0.6,0),
     col="red",col.axis="red"
     )
mtext("River gradient (-)",4,line=1.7,col="red")
legend("topright",c("Calculated gradient (-)"),lty=3,
       col=c("red","green"),bty="n")


dev.off()

## linear interpolation
good.time = which(!is.na(rg3.xts[,"WL"]))
x = as.numeric(sws1.xts[good.time,"WL"])
y = as.numeric(river.gradient[good.time])
lmodel = lm(y~x)
new.x = as.numeric(sws1.xts[-good.time,"WL"])
new.y = predict(lmodel,data.frame(x=new.x))
filled.gradient = river.gradient
filled.gradient[-good.time] = new.y

jpg.name = paste("figures/sws1_rg3.oneToone.jpg",sep = "")
jpeg(jpg.name,width = 5,height = 5,units = "in",res = 300, quality = 100)            
par(mar=c(3,3,1,1))    
plot(x,y,axes=FALSE,
     xlim =c(104.5,106),
     ylim=c(-9e-5,1.5e-4),xlab="",ylab=""
     )
abline(lmodel,col="red")
axis(1,at=seq(104.5,106,0.5),mgp=c(1,0.6,0))
at = seq(-9e-5,1.5e-4,0.8e-4)
axis(2,at = at,formatC(at,format="e",digits=1))
box()
mtext("River Gradient (-)",2,line=1.8)
mtext("Water level (m)",1,line=1.8)
dev.off()

jpg.name = paste("figures/sws1_rg3.filled.jpg",sep = "")
jpeg(jpg.name,width = 6,height = 4,units = "in",res = 300, quality = 100)            
par(mar=c(3,3,3,3))    
plot(index(sws1.xts),sws1.xts[,"WL"],type="l",
     axes=FALSE,
     ylim =c(104.5,106)
     )
lines(index(rg3.xts),rg3.xts[,"WL"],col="blue")
box()
axis.POSIXct(1,at=time.ticks,format="%b-%d",mgp=c(1,0.6,0))
axis.POSIXct(1,at=time.mini.ticks,format="%b-%d",mgp=c(10,0.6,0),tck=-0.025)
axis(2,at=seq(104.5,106,0.5),mgp=c(1,0.6,0))
mtext("Time (day)",1,line=1.7)
mtext("Water level (m)",2,line=1.7)
legend("topleft",c("SWS-1 level (m)","RG3 level (m)"),lty=1,
       col=c("black","blue"),bty="n"
       )



filled.plot = filled.gradient
filled.plot[good.time] =NA
par(new=T)
plot(index(sws1.xts),filled.plot,
     type="l",col="green",lty=3,ylim=c(-9e-5,1.5e-4),
     axes=FALSE
     )

lines(index(sws1.xts),river.gradient,col="red",lty=3)
##plot(as.numeric(rg3.xts[,"WL"]),as.numeric(rg3.xts[,"WL"]-sws1.xts[,"WL"]))
at = seq(-9e-5,1.5e-4,0.8e-4)
axis(4,at = at,formatC(at,format="e",digits=1),mgp=c(1,0.6,0),
     col="red",col.axis="red"
     )
mtext("River gradient (-)",4,line=1.7,col="red")
legend("topright",c("Calculated gradient (-)","Filled gradient (-)"),lty=3,
       col=c("red","green"),bty="n"
       )
dev.off()


simu.time = difftime(index(sws1.xts),start.time,units="secs")
ntime = length(simu.time)
DatumH_River = cbind(simu.time,
                     rep(data.model["SWS-1",1],ntime),
                     rep(data.model["SWS-1",2],ntime),                     
                     as.numeric(sws1.xts[,"WL"]))
Gradients_River = cbind(simu.time,
                        rep(0,ntime),
                        as.numeric(filled.gradient),
                        rep(0,ntime))
write.table(DatumH_River,file=paste('DatumH_River_ERT_agu.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_River,file=paste("Gradients_River_ERT_agu.txt",sep=''),col.names=FALSE,row.names=FALSE)

