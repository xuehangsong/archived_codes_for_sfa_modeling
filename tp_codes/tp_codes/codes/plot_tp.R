rm(list=ls())
iter = 4

tp_x = read.table(paste("results/tp_x.",iter,sep=""),skip=12)
tp_x_m = read.table(paste("results/tp_x_m.",iter,sep=""),skip=12)

tp_y = read.table(paste("results/tp_y.",iter,sep=""),skip=12)
tp_y_m = read.table(paste("results/tp_y_m.",iter,sep=""),skip=12)

tp_z = read.table(paste("results/tp_z.",iter,sep=""),skip=12)
tp_z_m = read.table(paste("results/tp_z_m.",iter,sep=""),skip=12)



## delete.index=c()
## for (irow in 1:nrow(tp_x))
## {
##     if(all(tp_x[irow,2:10]==0))
##     {
##         delete.index=cbind(delete.index,irow)
##     }

## }
## tp_x = tp_x[-delete.index,]

#tp_x = tp_x[seq(1,nrow(tp_x),6),]



jpeg(paste("figures/lateral_tp_",iter,".jpg",sep=""),width=7,height=7,quality=100,res=300,units="in")
nplots = 9
par(mfrow=c(3,3),
    mgp=c(1.8,0.7,0),
    mar=c(3,2,1,1),
    oma=c(2,4,2,2)
    )
for (iplot in 1:nplots)
{
    plot(tp_y[,1],tp_y[,1+iplot],
         ylim=c(0,1),xlim=c(0,60),
         xlab="",
         ylab="",
         axes=FALSE,
         )
    box()
    lines(tp_x_m[,1],tp_x_m[,1+iplot],col='red')
    
    ## if(iplot==7)
    ## {
        axis(1,at=seq(0,125,20))
        axis(2,at=seq(0,1,0.25))    
    ## } else
    ## {
    ##  axis(1,at=seq(0,125,25),labels=FALSE)
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


jpeg(paste("figures/vertical_tp_",iter,".jpg",sep=""),width=7,height=7,quality=100,res=300,units="in")
nplots = 9
par(mfrow=c(3,3),
    mgp=c(1.8,0.7,0),
    mar=c(3,2,1,1),
    oma=c(2,4,2,2)
    )
for (iplot in 1:nplots)
{
    plot(tp_z[,1],tp_z[,1+iplot],
         ylim=c(0,1),xlim=c(0,6),
         xlab="",
         ylab="",
         axes=FALSE,
         )
    box()
    lines(tp_z_m[,1],tp_z_m[,1+iplot],col='red')
    
    ## if(iplot==7)
    ## {
        axis(1,at=seq(0,10,2))
        axis(2,at=seq(0,1,0.25))    
    ## } else
    ## {
    ##  axis(1,at=seq(0,125,25),labels=FALSE)
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

#stop()
## nplots = 9
## par(mfrow=c(3,3))
## for (iplot in 1:nplots)
## {
##     plot(tp_y[,1],tp_y[,1+iplot],ylim=c(0,1),xlim=c(1,120))
##     lines(tp_y_m[,1],tp_y_m[,1+iplot])
## }


## nplots = 9
## par(mfrow=c(3,3))
## for (iplot in 1:nplots)
## {
##     plot(tp_z[,1],tp_z[,1+iplot],ylim=c(0,1))
##     lines(tp_z_m[,1],tp_z_m[,1+iplot])
## }

