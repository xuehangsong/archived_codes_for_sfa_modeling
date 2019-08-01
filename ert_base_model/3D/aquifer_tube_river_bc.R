rm(list=ls())
library(xts)
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
source("~/repos/sbr-river-corridor-sfa/250m_3d_model.R")

coord = read.table('data/proj_coord.dat',stringsAsFactors=FALSE)
rownames(coord) = coord[,3]
coord = as.matrix(coord[,1:2])
coord_model= proj_to_model(model_origin,angle,coord)

RG3 = read.csv("data/RG3-T3_station/Raw/2017-08/RG3_T3_RG3_20170801.dat",skip=3)
RG3 = RG3[,c(1,4)]
RG3[,1] = as.POSIXct(RG3[,1],tz="GMT",format="%Y-%m-%d %H:%M:%S")
RG3[,2] = RG3[,2] + 104.224
names(RG3) = c("Time","WL")

SWS1 = read.csv("data/SWS-1_3var.csv")
SWS1 = SWS1[,c(1,4)]
SWS1[,1] = as.POSIXct(SWS1[,1],tz="GMT",format="%d-%b-%Y %H:%M:%S")
names(SWS1) = c("Time","WL")


start.time = as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2017-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
simu.start = as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
time.ticks = seq(from=start.time,to=end.time,by="4 month")
time.mini.ticks = seq(from=start.time,to=end.time,by="1 month")
interp.time = seq(start.time,end.time,3600)


SWS1.xts = SWS1
SWS1.xts = SWS1.xts[which(SWS1.xts[,1]>start.time-300),]
SWS1.xts = SWS1.xts[which(SWS1.xts[,1]<end.time+300),]
SWS1.xts = xts(SWS1.xts,SWS1.xts[,1],unique=T,tz="GMT")
SWS1.xts = SWS1.xts[,-1]
SWS1.xts = SWS1.xts[.indexmin(SWS1.xts) %in% c(57:59,0:3),]
SWS1.xts = SWS1.xts[c('2013','2014','2015','2016','2017'),]
index(SWS1.xts) = round(index(SWS1.xts),units="hours")
SWS1.xts = SWS1.xts[!duplicated(.index(SWS1.xts))]
SWS1.xts = merge(SWS1.xts,time.index)

RG3.xts = RG3
RG3.xts = RG3.xts[which(RG3.xts[,1]>start.time-300),]
RG3.xts = RG3.xts[which(RG3.xts[,1]<end.time+300),]
RG3.xts = xts(RG3.xts,RG3.xts[,1],unique=T,tz="GMT")
RG3.xts = RG3.xts[,-1]
RG3.xts = RG3.xts[.indexmin(RG3.xts) %in% c(57:59,0:3),]
RG3.xts = RG3.xts[c('2013','2014','2015','2016','2017'),]
index(RG3.xts) = round(index(RG3.xts),units="hours")
RG3.xts = RG3.xts[!duplicated(.index(RG3.xts))]
RG3.xts = merge(RG3.xts,time.index)


SWS1_fine.xts = SWS1
SWS1_fine.xts = SWS1_fine.xts[which(SWS1_fine.xts[,1]>start.time-300),]
SWS1_fine.xts = SWS1_fine.xts[which(SWS1_fine.xts[,1]<end.time+300),]
SWS1_fine.xts = xts(SWS1_fine.xts,SWS1_fine.xts[,1],unique=T,tz="GMT")
SWS1_fine.xts = SWS1_fine.xts[,-1]
SWS1_fine.xts = SWS1_fine.xts[.indexmin(SWS1_fine.xts) %in% c(13:17),]
SWS1_fine.xts = SWS1_fine.xts[c('2013','2014','2015','2016','2017'),]
#index(SWS1_fine.xts) = round(index(SWS1_fine.xts),units="hours")
SWS1_fine.xts = SWS1_fine.xts[!duplicated(.index(SWS1_fine.xts))]
SWS1_fine.xts = merge(SWS1_fine.xts,time.index+900)


coord_model= proj_to_model(model_origin,angle,coord)
river.gradient = (RG3.xts[,"WL"]-SWS1.xts[,"WL"])/(
    coord_model["RG3",2]-coord_model["SWS-1",2])
river.gradient = as.numeric(river.gradient)

x = as.numeric(SWS1_fine.xts) - as.numeric(SWS1.xts)
lmodel = lm(river.gradient~x,na.action=na.omit)
filled.time = which((is.na(RG3.xts[,"WL"])) & (!is.na(SWS1.xts[,"WL"])))
filled.gradient =  predict(lmodel,data.frame(x=x))
    
jpg.name = paste("figures/SWS1_RG3_1.jpg",sep = "")
jpeg(jpg.name,width = 12,height = 6,units = "in",res = 300, quality = 100)            
par(mar=c(3,3,3,3))    
plot(index(SWS1.xts),SWS1.xts[,"WL"],type="l",
     axes=FALSE,
     ylim =c(100,108.5)
     )
lines(index(RG3.xts),RG3.xts[,"WL"],col="blue")
box()
axis.POSIXct(1,at=time.ticks,format="%Y-%m",mgp=c(1,0.6,0))
axis.POSIXct(1,at=time.mini.ticks,format="%Y-%m",labels=FALSE,mgp=c(10,0.6,0),tck=-0.01)
axis(2,at=seq(104,109,1),mgp=c(1,0.6,0))
mtext("Time (day)",1,line=1.7)
mtext("Water level (m)",2,line=1.7)
legend("topleft",c("SWS-1 level (m)","RG3 level (m)"),lty=1,
       col=c("black","blue"),bty="n"
       )


par(new=T)
plot(index(SWS1.xts),river.gradient,
     type="l",col="red",lty=1,ylim=c(-5e-4,2e-3),
     axes=FALSE
     )
at = seq(-3e-4,6e-4,2e-4)
axis(4,at = at,formatC(at,format="e",digits=1),mgp=c(1,0.6,0),
     col="red",col.axis="red"
     )
mtext("River gradient (-)",4,line=1.7,col="red")
legend("bottomleft",c("Observed gradient (-)"),lty=1,
       col=c("red","green"),bty="n")


dev.off()


jpg.name = paste("figures/SWS1_RG3_2.jpg",sep = "")
jpeg(jpg.name,width = 12,height = 6,units = "in",res = 300, quality = 100)            
par(mar=c(3,3,3,3))    
plot(index(SWS1.xts),SWS1.xts[,"WL"],type="l",
     axes=FALSE,
     ylim =c(100,108.5)
     )
lines(index(RG3.xts),RG3.xts[,"WL"],col="blue")
box()
axis.POSIXct(1,at=time.ticks,format="%Y-%m",mgp=c(1,0.6,0))
axis.POSIXct(1,at=time.mini.ticks,format="%Y-%m",labels=FALSE,mgp=c(10,0.6,0),tck=-0.01)
axis(2,at=seq(104,109,1),mgp=c(1,0.6,0))
mtext("Time (day)",1,line=1.7)
mtext("Water level (m)",2,line=1.7)
legend("topleft",c("SWS-1 level (m)","RG3 level (m)"),lty=1,
       col=c("black","blue"),bty="n"
       )


par(new=T)
plot(index(SWS1.xts),river.gradient,
     type="l",col="white",lty=1,ylim=c(-5e-4,2e-3),
     axes=FALSE
     )
lines(index(SWS1.xts),filled.gradient,
     col="green"
     )

at = seq(-3e-4,6e-4,2e-4)
axis(4,at = at,formatC(at,format="e",digits=1),mgp=c(1,0.6,0),
     col="red",col.axis="red"
     )
mtext("River gradient (-)",4,line=1.7,col="red")
legend("bottomleft",c("Interpolated gradient (-)"),lty=1,
       col=c("green"),bty="n")


dev.off()






jpg.name = paste("figures/SWS1_RG3.jpg",sep = "")
jpeg(jpg.name,width = 12,height = 6,units = "in",res = 300, quality = 100)            
par(mar=c(3,3,3,3))    
plot(index(SWS1.xts),SWS1.xts[,"WL"],type="l",
     axes=FALSE,
     ylim =c(100,108.5)
     )
lines(index(RG3.xts),RG3.xts[,"WL"],col="blue")
box()
axis.POSIXct(1,at=time.ticks,format="%Y-%m",mgp=c(1,0.6,0))
axis.POSIXct(1,at=time.mini.ticks,format="%Y-%m",labels=FALSE,mgp=c(10,0.6,0),tck=-0.01)
axis(2,at=seq(104,109,1),mgp=c(1,0.6,0))
mtext("Time (day)",1,line=1.7)
mtext("Water level (m)",2,line=1.7)
legend("topleft",c("SWS-1 level (m)","RG3 level (m)"),lty=1,
       col=c("black","blue"),bty="n"
       )


par(new=T)
plot(index(SWS1.xts),river.gradient,
     type="l",col="white",lty=1,ylim=c(-5e-4,2e-3),
     axes=FALSE
     )
lines(index(SWS1.xts),river.gradient,
     col="red"
     )

lines(index(SWS1.xts)[filled.time],filled.gradient[filled.time],
     col="green"
     )

at = seq(-3e-4,6e-4,2e-4)
axis(4,at = at,formatC(at,format="e",digits=1),mgp=c(1,0.6,0),
     col="red",col.axis="red"
     )
mtext("River gradient (-)",4,line=1.7,col="red")
legend("bottomleft",c("Observed gradient (-)","Interpolated gradient (-)"),lty=1,
       col=c("red","green"),bty="n")


dev.off()





jpg.name = paste("figures/Gradient_vs_lag.jpg",sep = "")
jpeg(jpg.name,width = 6,height = 6,units = "in",res = 300, quality = 100)            
plot(x,river.gradient,
     xlab = "Level lag (m)",
     ylab = "Gradient (-)"
     )
abline(lmodel,col="red")
dev.off()



levelmodel = lm(river.gradient~as.numeric(SWS1.xts),na.action=na.omit)
jpg.name = paste("figures/Gradient_vs_level.jpg",sep = "")
jpeg(jpg.name,width = 6,height = 6,units = "in",res = 300, quality = 100)            
plot(as.numeric(SWS1.xts),river.gradient,
     xlab = "Water level (m)",
     ylab = "Gradient (-)"
     )
abline(levelmodel,col="red")
dev.off()



jpg.name = paste("figures/Gradient_vs_Gradient.jpg",sep = "")
jpeg(jpg.name,width = 6,height = 6,units = "in",res = 300, quality = 100)            
plot(river.gradient,filled.gradient,
     xlab = "Observed Gradient (-)",
     ylab = "Interpolated Gradient (-)",
     asp=1
     )
abline(levelmodel,col="red")
dev.off()






simu.time = difftime(index(SWS1.xts),simu.start,units="secs")
outputtimes = which(simu.time>=0)

ntime = length(outputtimes)
DatumH_River = cbind(simu.time[outputtimes],
                     rep(coord_model["SWS-1",1],ntime),
                     rep(coord_model["SWS-1",2],ntime),                     
                     as.numeric(SWS1.xts[outputtimes,"WL"]))
Gradients_River = cbind(simu.time[outputtimes],
                        rep(0,ntime),
                        as.numeric(filled.gradient[outputtimes]),
                        rep(0,ntime))

Gradients_River = Gradients_River[!is.na(DatumH_River[,4]),]
DatumH_River = DatumH_River[!is.na(DatumH_River[,4]),]

DatumH_River = DatumH_River[!is.na(Gradients_River[,3]),]
Gradients_River = Gradients_River[!is.na(Gradients_River[,3]),]



write.table(DatumH_River,file=paste('ert_model/DatumH_River_aquifer_tube_2015_2017.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_River,file=paste("ert_model/Gradients_River_aquifer_tube_2015_2017.txt",sep=''),col.names=FALSE,row.names=FALSE)

 
