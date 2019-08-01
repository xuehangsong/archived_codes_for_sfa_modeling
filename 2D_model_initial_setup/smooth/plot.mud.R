rm(list = ls())
source("codes/parameters.R")
nobs=10
obs.time=seq(0,2700,1)
time.index=obs.time
ntime=length(time.index)
load("results/obs.qlx")
load("results/obs.qlz")
load("results/obs.conc")

par(mfrow=c(5,2),mar=c(3.1,3.5,1,1),oma=c(8,2,2,2),mgp=c(1.8,0.8,0),pty='m',xpd=TRUE)
for (iobs in 1:10)#c(1,3,5,7,9,2,4,6,8,10))
{
    plot(0,0,
         type='n',
         xlim=range(time.index),
         ylim=c(0,1),
         main=obs.list[iobs],
         xlab=NA,
         ylab=NA
         )
                                        #    lines(time.index,obs.conc[iobs,iobs,which(log.time %in% time.index)],col="red")

    if (any(c(9,10)==iobs)){
        mtext(expression("Time (hour)"),side=1,line=2.2,col="black",cex=0.8)        
             }

    if (any(c(1,3,5,7,9)==iobs)){
        mtext(expression("normalized concentration"),side=2,line=2.2,col="black",cex=0.8)        
             }
    
   lines(time.index,obs.conc[7,iobs,],col="grey")
    
}

reset <- function(){
    par(mfrow=c(1,1),oma=c(2,2,2,1),mar=rep(0,4),new=TRUE,xpd=TRUE)
    plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
}
reset()
          legend(0.25,0.01,c(obs.type[1:6]),
                 lwd=1,col=c("black","red","blue","yellow","green","orange"),#,"grey"),
#                 title='Legend',
#         bty='n',
         horiz=TRUE
                 )
                                        #           )
dev.off()
