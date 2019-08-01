rm(list=ls())
library(signal)
library(expm)




proportion = c(0.668,0.2138,0.1182)
meanlength = c(11.138724,4.872502,3.720334)
meanlength = c(20.985099,9.504060,7.974421)


proportion = c(0.668,0.2138,0.1182)
meanlength = c(1.0126113,0.4429547,0.3382122)


## tp.data = read.table("results/tp_z.0",skip=13)
tp.data = read.table("../cori_tp1_sythetic_70_95_change_proportion/results/tp_z.5",skip=12)
#tp.data = read.table("tprogs/tp_x.eas",skip=12)
tp.data = tp.data[which(tp.data[,1]>1e-6),]

nfacies = 3


proportion.mismatch = apply(tp.data[,c(2,5,8)],1,sd)+apply(tp.data[,c(3,6,9)],1,sd)+apply(tp.data[,c(4,7,10)],1,sd)


max.lag = min(which.min(proportion.mismatch),15)
#print(max.lag)

tp.m = list()
for (ilag in 1:max.lag)
{
    tp.matrix = array(as.numeric(tp.data[ilag,1:(nfacies**2)+1]),
                      c(nfacies,nfacies))
    rate.matrix = logm(tp.matrix,method="Eigen")/tp.data[ilag,1]

    tp.m.temp = lapply(tp.data[1:max.lag,1],function(x) c(expm(rate.matrix*x)))
    tp.m[[ilag]] = do.call("rbind",tp.m.temp)
}
min.lag = which.min(as.numeric(lapply(tp.m,function(x) sum((x-tp.data[1:max.lag,2:(nfacies**2)])**2))))


proportion.m = list()
meanlength.m = list()
for (ilag in 1:max.lag)
{
    tp.matrix = array(as.numeric(tp.data[ilag,1:(nfacies**2)+1]),
                      c(nfacies,nfacies))
    rate.matrix = logm(tp.matrix,method="Eigen")/tp.data[ilag,1]

    meanlength.m[[ilag]] = -1/diag(rate.matrix)
    
#    tp.m.temp = lapply(1000,function(x) c(expm(rate.matrix*x)))
    proportion.m[[ilag]] =  c(expm(rate.matrix*1000))[1:nfacies]
}

proportion.m = do.call("rbind",proportion.m)
meanlength.m = do.call("rbind",meanlength.m)
## min.lag = which.min(as.numeric(apply(proportion.m,c(1),function(x) sum((x-proportion)**2)))*
##                     as.numeric(apply(meanlength.m,c(1),function(x) sum((x-meanlength)**2))))

min.lag = which.min(as.numeric(apply(meanlength.m,c(1),function(x) sum((x-meanlength)**2))))
#min.lag = which.min(as.numeric(apply(proportion.m,c(1),function(x) sum((x-proportion)**2))))

meanlength.m[min.lag,]
proportion.m[min.lag,]
stop()
    
print(tp.data[min.lag,1])

tp.m.lags = seq(0.1,100,0.5)
tp.m = list()
for (ilag in 1:max.lag)
{
    tp.matrix = array(as.numeric(tp.data[ilag,1:(nfacies**2)+1]),
                      c(nfacies,nfacies))
    rate.matrix = logm(tp.matrix,method="Eigen")/tp.data[ilag,1]

    tp.m.temp = lapply(tp.m.lags,function(x) c(expm(rate.matrix*x)))
    tp.m[[ilag]] = do.call("rbind",tp.m.temp)
}




selected.tp = c()
for (x in c(seq(1,15,1),seq(15,50,3)))
{
   selected.tp = c(selected.tp, which.min(abs(x-tp.data[,1])))
}
     

jpeg("figures/tp.jpg",width=7,height=7,quality=100,res=300,units="in")
nplots = 9
par(mfrow=c(3,3),
    mgp=c(1.8,0.7,0),
    mar=c(3,2,1,1),
    oma=c(2,4,2,2)
    )
for (iplot in 1:nplots)
{
    plot(tp.data[,1],tp.data[,1+iplot],
         ylim=c(0,1),xlim=c(0,50),col="white",
         xlab="",
         ylab="",
         axes=FALSE,
         )
    box()

    ## for (ilag in 1:max.lag)
    ##     {
    ##         lines(tp.m.lags,tp.m[[ilag]][,iplot],col='red',lty=2)
    ##     }

    ## lines(tp.m.lags,tp.m[[min.lag]][,iplot],col='blue',lwd=2)
    
    points(tp.data[selected.tp,1],tp.data[selected.tp,1+iplot])    
    axis(1,at=seq(0,125,20))
    axis(2,at=seq(0,1,0.25))    
    ## } else
    ## {    ##  axis(1,at=seq(0,125,25),labels=FALSE)
    ##  axis(2,at=seq(0,1,0.25),labels=FALSE)
    ## }
}
par(new=T,
    mfrow=c(1,1),    
    mgp=c(1,1,1),
    mar=c(2,2,2,2),
    oma=c(0,1,1,1))
mtext(expression(italic("Lag (m)")),1)
mtext(paste("Hanford",
            "                             Ringold Gravel",
            "                     Ringold Fine"),3,line=1.25)

mtext(paste("Hanford",
            "                         Ringold Gravel",
            "                          Ringold Fine"),4,line=1.1)

mtext(expression(italic("Transition Probability")),2,line=0.5,cex=1.2,col="black")

dev.off()




## plot(1:21,aaa)
## min.points = min(which.min(aaa),13)
## points(min.points,aaa[min.points],pch=16)


## nwindows = 3
## simu.time = 1:21
## dt=1
## filt = Ma(rep(1/nwindows,nwindows))
## ma.aaa = filter(filt,aaa)
## ma.time = simu.time-dt*(nwindows-1)/2
## ma.aaa = tail(ma.aaa,-nwindows)
## ma.time = tail(ma.time,-nwindows)
## ma.aaa = c(aaa[simu.time<min(ma.time)],ma.aaa)
## ma.time = c(simu.time[simu.time<min(ma.time)],ma.time)
## ma.aaa = c(ma.aaa,aaa[simu.time>max(ma.time)])
## ma.time = c(ma.time,simu.time[simu.time>max(ma.time)])
## points(1:21,ma.aaa,col="red")
## points(which.min(ma.aaa),ma.aaa[which.min(ma.aaa)],pch=16,col="red")




## icol=2
## plot(1:length(tp.data[,1]),tp.data[,icol],type="l",ylim=c(0,1))
## lines(1:length(tp.data[,1]),tp.data[,icol+3],col="red")
## lines(1:length(tp.data[,1]),tp.data[,icol+6],col="red")


## icol=3
## plot(1:length(tp.data[,1]),tp.data[,icol],type="l",ylim=c(0,1))
## lines(1:length(tp.data[,1]),tp.data[,icol+3],col="red")
## lines(1:length(tp.data[,1]),tp.data[,icol+6],col="red")


## icol=4
## plot(1:length(tp.data[,1]),tp.data[,icol],type="l",ylim=c(0,1))
## lines(1:length(tp.data[,1]),tp.data[,icol+3],col="red")
## lines(1:length(tp.data[,1]),tp.data[,icol+6],col="red")

