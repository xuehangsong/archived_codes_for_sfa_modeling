rm(list=ls())
library(signal)
library(expm)

nfacies = 3
proportion = read.table("tprogs/tp_x.eas",nrows=1)

tp.data = read.table("tprogs/tp_x.eas",skip=12)
tp.data = tp.data[which(tp.data[,1]>1e-6),]
tp.data = tp.data[which(tp.data[,2]>0.3),]

proportion.mismatch = apply(tp.data[,c(2,5,8)],1,sd)+apply(tp.data[,c(3,6,9)],1,sd)+apply(tp.data[,c(4,7,10)],1,sd)
max.lag = min(which.min(proportion.mismatch),which.min(abs(tp.data[,1]-30)))
print(max.lag)


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
    proportion.m[[ilag]] =  c(expm(rate.matrix*1000))[1:nfacies]
}

proportion.m = do.call("rbind",proportion.m)
meanlength.m = do.call("rbind",meanlength.m)

min.lag = which.min(as.numeric(apply(proportion.m,c(1),function(x) sum((x-proportion)**2))))

meanlength.m[min.lag,]
proportion.m[min.lag,]
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
    selected.tp = c(selected.tp,which.min(abs(x-tp.data[,1])))
}


jpeg("figures/prior_tp_x.jpg",width=7,height=7,quality=100,res=300,units="in")
nplots = 9
par(mfrow=c(3,3),
    mgp=c(1.8,0.7,0),
    mar=c(3,2,1,1),
    oma=c(2,4,2,2)
    )
for (iplot in 1:nplots)
{
    plot(tp.data[,1],tp.data[,1+iplot],
         ylim=c(0,1),xlim=c(0,30),col="white",
         xlab="",
         ylab="",
         axes=FALSE,
         )
    box()

    ## for (ilag in 1:max.lag)
    ## {
    ##     if(max(as.numeric(tp.m[[ilag]][,iplot]))<=1 &
    ##        min(as.numeric(tp.m[[ilag]][,iplot]))>=0 )
    ##         {
    ##             lines(tp.m.lags,tp.m[[ilag]][,iplot],col='red',lty=2)
    ##         }
    ## }

    lines(tp.m.lags,tp.m[[min.lag]][,iplot],col='blue',lwd=2)
    
    points(tp.data[selected.tp,1],tp.data[selected.tp,1+iplot])    
    axis(1,at=seq(0,125,10))
    axis(2,at=seq(0,1,0.25))    
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

tpx.data.file = read.table("tprogs/tp_x.eas",skip=12)
x.lag = which.min(abs(tpx.data.file[,1]-tp.data[min.lag,1]))


#=========================================================================
tp.data = read.table("tprogs/tp_z.eas",skip=12)
tp.data = tp.data[which(tp.data[,1]>1e-6),]
tp.data = tp.data[which(tp.data[,2]>0.3),]

proportion.mismatch = apply(tp.data[,c(2,5,8)],1,sd)+apply(tp.data[,c(3,6,9)],1,sd)+apply(tp.data[,c(4,7,10)],1,sd)
max.lag = min(which.min(proportion.mismatch),which.min(abs(tp.data[,1]-10)))
print(max.lag)

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
    proportion.m[[ilag]] =  c(expm(rate.matrix*1000))[1:nfacies]
}

proportion.m = do.call("rbind",proportion.m)
meanlength.m = do.call("rbind",meanlength.m)

min.lag = which.min(as.numeric(apply(proportion.m,c(1),function(x) sum((x-proportion)**2))))

meanlength.m[min.lag,]
proportion.m[min.lag,]
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
for (x in c(seq(1,15,0.05),seq(15,50,3)))
{
    selected.tp = c(selected.tp,which.min(abs(x-tp.data[,1])))
}


jpeg("figures/prior_tp_z.jpg",width=7,height=7,quality=100,res=300,units="in")
nplots = 9
par(mfrow=c(3,3),
    mgp=c(1.8,0.7,0),
    mar=c(3,2,1,1),
    oma=c(2,4,2,2)
    )
for (iplot in 1:nplots)
{
    plot(tp.data[,1],tp.data[,1+iplot],
         ylim=c(0,1),xlim=c(0,10),col="white",
         xlab="",
         ylab="",
         axes=FALSE,
         )
    box()

    ## for (ilag in 1:max.lag)
    ## {
    ##     if(max(as.numeric(tp.m[[ilag]][,iplot]))<=1 &
    ##        min(as.numeric(tp.m[[ilag]][,iplot]))>=0 )
    ##         {
    ##             lines(tp.m.lags,tp.m[[ilag]][,iplot],col='red',lty=2)
    ##         }
    ## }

    lines(tp.m.lags,tp.m[[min.lag]][,iplot],col='blue',lwd=2)
    
    points(tp.data[selected.tp,1],tp.data[selected.tp,1+iplot])    
    axis(1,at=seq(0,125,5))
    axis(2,at=seq(0,1,0.25))    
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

tpz.data.file = read.table("tprogs/tp_z.eas",skip=12)
z.lag = which.min(abs(tpz.data.file[,1]-tp.data[min.lag,1]))

mcmod.par = readLines("dainput/mcmod.par")
mcmod.par[13] = as.character(x.lag)
mcmod.par[18] = as.character(x.lag)
mcmod.par[23] = as.character(z.lag)
writeLines(mcmod.par,"dainput/mcmod.par")

save(list=ls(),file="results/prior_tp.r")
