rm(list=ls())
load("results/tracer.boundary.data.r")
case.name = c("87.1")
#case.name = c("add.lower.layer")
#case.name = c("different.depth")

##load("results/obs.combined.data.r") 

##piezometer.do[["S40"]])

ireaz = 1

load(paste(case.name,"/statistics/do.ensemble.r",sep=''))
simu.ensemble = do.ensemble*1000*31.9988

jpeg(paste("figures/",case.name,".do.depth.jpg",sep=''),width=12,height=4,units='in',res=200,quality=100)
par(mgp=c(1.8,0.6,0),mar=c(4.1,4.1,2.1,2.1))
plot(simu.time,obs.do[["S10"]],
     col='white',
     pch=16,
     cex=0.3,
     ylim=c(0,15),
     xlab='Time (days)',
     ylab='DO (mg/l)',
     axes= FALSE
     )

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 2)
box()

points(simu.time,obs.do[["S10"]],col='green',cex=0.3,pch=16)
points(simu.time,obs.do[["S40"]],col='red',cex=0.3,pch=16)


for (i.depth in 1:2)
{
    lines(simu.time,simu.ensemble[ireaz,i.depth,],col="blue")    
}

for (i.depth in 3:4)
{
    lines(simu.time,simu.ensemble[ireaz,i.depth,],col="black")    
}




##points(simu.time,obs.do[["T3"]],col='black',cex=0.3,pch=16)

## load(paste(case.name,"/statistics/do.ensemble.r",sep=''))
## load(paste(case.name,"/statistics/qlx.ensemble.r",sep=''))
## simu.ensemble = do.ensemble*abs(qlx.ensemble)
## simu.ensemble = apply(simu.ensemble,c(1,3),sum)/
##     apply(abs(qlx.ensemble),c(1,3),sum)
## simu.ensemble = simu.ensemble*1000*31.9988

## lines(simu.time/24,simu.ensemble[ireaz,simu.time],col="red")
## points(simu.time/24,obs.value,col='black',pch=16,cex=0.3)

legend("topright",c("S10 DO(mg/L)","S40 DO(mg/L)","S10 Simulations","S40 Simulations"),
       lty=c(NA,NA,1,1),
       pch=c(16,16,NA,NA),
       col=c("green","red","blue","black"),
       bty='n',
       horiz=TRUE,
       cex=0.9,
       )


dev.off()

#piezometer.spc[["S10"]] = (piezometer.spc[["S10"]]-0.1)/(0.4375-0.1)
#piezometer.spc[["S40"]] = (piezometer.spc[["S40"]]-0.1)/(0.4375-0.1)
#piezometer.spc[["T3"]] = (piezometer.spc[["T3"]]-0.1)/(0.4375-0.1)

#piezometer.spc[["S10"]][piezometer.spc[["S10"]]<0] = 0
#piezometer.spc[["S40"]][piezometer.spc[["S40"]]<0] = 0
#piezometer.spc[["T3"]][piezometer.spc[["T3"]]<0] = 0


##load(paste(case.name,"/statistics/qlx.ensemble.r",sep=''))
load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))

simu.ensemble = tracer.ensemble
#simu.ensemble = (0.001-simu.ensemble)/0.001
#1simu.ensemble[simu.ensemble<0] = 0
#simu.ensemble = simu.ensemble[,,]

jpeg(paste("figures/",case.name,".spc.depth.jpg",sep=''),width=12,height=4,units='in',res=200,quality=100)
par(mgp=c(1.8,0.6,0),mar=c(4.1,4.1,2.1,2.1))
plot(simu.time,obs.spc[["S10"]],
     col='white',
     pch=16,
     cex=0.3,
     ylim=c(0,0.6),
     xlab='Time (days)',
     ylab='SpC (mS/cm)',
     axes= FALSE
     )

axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"))
axis(side = 2)
box()

points(simu.time,obs.spc[["S10"]],col='green',cex=0.3,pch=16)
points(simu.time,obs.spc[["S40"]],col='red',cex=0.3,pch=16)



for (i.depth in 1:2)
{
   lines(simu.time,simu.ensemble[ireaz,i.depth,],col="blue")    
}


for (i.depth in 3:4)
{
   lines(simu.time,simu.ensemble[ireaz,i.depth,],col="black")    
}


#load(paste(case.name,"/statistics/do.ensemble.r",sep=''))
#load(paste(case.name,"/statistics/tracer.ensemble.r",sep=''))

#points(simu.time,obs.spc[["T3"]],col='black',cex=0.3,pch=16)


legend("topright",c("S10 SpC(mS/cm)","S40 SpC(mS/cm)","S10 Simulations","S40 Simulations"),
       lty=c(NA,NA,1,1),
       pch=c(16,16,NA,NA),
       col=c("green","red","blue","black"),
       bty='n',
       horiz=TRUE,
       cex=0.9,
       )

dev.off()


stop()

load(paste(case.name,"/statistics/qlx.ensemble.r",sep=''))
simu.ensemble = qlx.ensemble[,,simu.time]


jpeg(paste("figures/","qlx.depth.jpg",sep=''),width=8,height=4,units='in',res=200,quality=100)
par(mgp=c(1.8,0.6,0),mar=c(4.1,4.1,2.1,2.1))
plot(simu.time/24,apply(simu.ensemble,c(1,3),mean)[ireaz,simu.time],
     col='black',
     pch=16,
     cex=0.3,
     ylim=c(-0.03,0.03),
     xlab='Time (days)',
     ylab='qlx (m/h)',
     )

for (i.depth in 1:24)
{
    lines(simu.time/24,simu.ensemble[ireaz,i.depth,],col="green")    
}

simu.ensemble = apply(simu.ensemble,c(1,3),mean)

lines(simu.time/24,simu.ensemble[ireaz,simu.time],col="red")

legend("topright",c("Cell simulations","Averaged simulation"),
       lty=c(1,1),
       pch=c(NA,NA),
       col=c("green","red"),
       bty='n',
       horiz=TRUE,
       cex=0.9,
       )



dev.off()







load(paste(case.name,"/statistics/qlz.ensemble.r",sep=''))
simu.ensemble = qlz.ensemble[,,simu.time]


jpeg(paste("figures/","qlz.depth.jpg",sep=''),width=8,height=4,units='in',res=200,quality=100)
par(mgp=c(1.8,0.6,0),mar=c(4.1,4.1,2.1,2.1))
plot(simu.time/24,apply(simu.ensemble,c(1,3),mean)[ireaz,simu.time],
     col='black',
     pch=16,
     cex=0.3,
     ylim=c(-0.3,0.3),
     xlab='Time (days)',
     ylab='qlz (m/h)',
     )

for (i.depth in 1:24)
{
    lines(simu.time/24,simu.ensemble[ireaz,i.depth,],col="green")    
}

simu.ensemble = apply(simu.ensemble,c(1,3),mean)

lines(simu.time/24,simu.ensemble[ireaz,simu.time],col="red")

legend("topright",c("Cell simulations","Averaged simulation"),
       lty=c(1,1),
       pch=c(NA,NA),
       col=c("green","red"),
       bty='n',
       horiz=TRUE,
       cex=0.9,
       )



dev.off()
