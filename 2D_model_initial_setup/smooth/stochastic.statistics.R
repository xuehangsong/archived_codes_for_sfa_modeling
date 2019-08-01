rm(list=ls())
library(hydroGOF)
source("codes/parameters.R")
nreaz=100
nobs=10
time.index=seq(1,2700)
ntime=length(time.index)
state.vector.all=list()
simu.multi.steps=list()
cov.state.simu=list()
cov.simu.simu=list()
obs.list=c("Well_01M","Well_01H","Well_02M","Well_02H","Well_03M","Well_03H","Well_04M","Well_04H","Well_05M","Well_05H")
load(paste("results/material.grid.data"))

selected.realization=seq(1,100)
to.delete=c(4,7,16,23,28,30,35,42,46,55,65,70,74,75,78,82,84,92,95)
selected.realization=setdiff(selected.realization,to.delete)




for (itime in 1:ntime)
{
    load(paste("results/simu.ensemble.",itime,sep=""))
    simu.multi.steps[[itime]]=simu.ensemble
}
simu.plot=array(rep(0,nreaz*nobs*ntime),c(ntime,nreaz,nobs))
for (iobs in 1:nobs)
{
    for (itime in 1:ntime)
        {
            simu.plot[itime,,iobs]=simu.multi.steps[[itime]][,iobs]
        }
}

load("results/obs.data")


## rmse.head=rmse(apply(simu.plot,c(1,3),mean),obs.true[which(log.time %in% time.index),])
## #format(rmse.head,scientific=TRUE)
load(paste("results/state.vector.",2699,sep=""))
cor.state.simu=array(rep(0,ntime*nobs*4),c(4,nobs,ntime))
for (itime in 1:ntime)
{    
    cor.state.simu[,,itime]=cor(state.vector[selected.realization,],simu.plot[itime,selected.realization,])
}

#format(apply(abs(cor.state.simu),c(1,2),mean),scientific=TRUE)
#format(apply(cor.state.simu,c(1,2),mean),scientific=TRUE)

## load("results/simu.all.stochastic")
## obs.type="qlx"
## simu.qlx=array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
## for (itime in 1:ntime)
## {
##     for (iobs in 1:nobs)
##         {
##             for (ireaz in 1:nreaz)
##                 {
##                     simu.col=intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
##                     simu.row=which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
##                     obs.xyz[iobs,]=as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
##                     simu.qlx[ireaz,iobs,itime]=simu.all[[ireaz]][simu.row,simu.col]
##                 }
##         }
## }
## save(simu.qlx,file="results/simu.qlx")
##load("results/simu.qlx")

## load("results/simu.all.stochastic")
## obs.type="qlz"
## simu.qlz=array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
## for (itime in 1:ntime)
## {
##     for (iobs in 1:nobs)
##         {
##             for (ireaz in 1:nreaz)
##                 {
##                     simu.col=intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
##                     simu.row=which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
##                     obs.xyz[iobs,]=as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
##                     simu.qlz[ireaz,iobs,itime]=simu.all[[ireaz]][simu.row,simu.col]
##                 }
##         }
## }
## save(simu.qlz,file="results/simu.qlz")
##load("results/simu.qlz")


## jpeg("figures/qlx.jpg",width=12,height=8,units='in',res=300,quality=100)
## par(mfrow=c(3,4),pty='m',xpd=TRUE)
## for (iobs in 1:nobs)
##     {
##         plot(time.index,apply(simu.qlx,c(2,3),mean)[iobs,],
##              xlim=range(time.index),
##              ylim=range(apply(simu.qlx,c(2,3),mean)[,]),
##              xlab="Time (hour)",
##              ylab="Horizontal velocity (m/h)",
##              type='l',   
##              main=paste("Well-",formatC(iobs,width=2,flag='0'),sep=''),
##                                         #         col=rainbow(nobs)
##              )

##         ## points(time.index,cor.state.simu[2,iobs,],col="red",pch=16,cex=0.5)
##         ## points(time.index,cor.state.simu[3,iobs,],col="blue",pch=16,cex=0.5)
##         ## points(time.index,cor.state.simu[4,iobs,],col="green",pch=16,cex=0.5)                
            
##         }


## reset <- function(){
##     par(mfrow=c(1,1),oma=c(4,4,4,1),mar=rep(0,4),new=TRUE)
##     plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
## }
## reset()
##           legend(0.817,0.185,c("Darcy velocity"),
##                  lwd=1,col=c("black"),
##                  title='Legend'
##          # bty='n',
##          )
##                                         #           )
## dev.off()





## jpeg("figures/head.match.jpg",width=12,height=8,units='in',res=300,quality=100)
## par(mfrow=c(3,4),pty='m',xpd=TRUE)
## for (iobs in 1:nobs)
## {
##     plot(time.index,obs.true[which(log.time %in% time.index),iobs],
##          type='l',
##          lwd=1,
##          col='black',
##          ylim=c(105,108),
##          xlab="Time (hour)",
##          ylab="Water table level(m)",
##          main=paste("Well-",formatC(iobs,width=2,flag='0'),sep='')
##          )

##     for (ireaz in 1:nreaz)
##         {
##             lines(time.index,simu.plot[,ireaz,iobs],col='green')

##         }
## #    lines(time.index,obs.true[which(log.time %in% time.index),iobs])
##     lines(time.index,obs.true[which(log.time %in% time.index),iobs],col="red")    
## }
##     reset <- function(){
##         par(mfrow=c(1,1),oma=c(4,4,4,1),mar=rep(0,4),new=TRUE)
##         plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
##     }
##     reset()

    
##     legend(0.817,0.185,c("Reference","Simulations"),
##            lwd=1,col=c("black","Green"),
##                                         #           bty='n'
##            title='Legend'
##            )

## dev.off()



jpeg("figures/head.difference.jpg",width=5,height=11,units='in',res=1000,quality=100)
par(mfrow=c(6,2),mar=c(3.1,2.8,2.1,2.1),mgp=c(1.8,0.8,0),pty='m',xpd=TRUE)
for (iobs in 1:nobs)
{
    plot(0,0,
         type='n',
         xlim=range(time.index),
         ylim=range(-0.11,0.11),
         xlab="Time (hour)",
         ylab="Water table level(m)",
         main=obs.list[iobs]
         )


    
    for (ireaz in selected.realization)
        {
            lines(time.index,simu.plot[,ireaz,iobs]-obs.true[which(log.time %in% time.index),iobs],col='green')

        }

    
}
    ## reset <- function(){
    ##     par(mfrow=c(1,1),oma=c(4,4,4,1),mar=rep(0,4),new=TRUE)
    ##     plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
    ## }
    ## reset()
    
    ## legend(0.817,0.185,c("Simulations"),
    ##        lwd=1,col=c("Green"),
    ##                                     #           bty='n'
    ##        title="Legend"
    ##        )

dev.off()





jpeg("figures/head.corr.jpg",width=5,height=11,units='in',res=1000,quality=100)
par(mfrow=c(6,2),mar=c(3.1,2.8,2.1,2.1),mgp=c(1.8,0.8,0),pty='m',xpd=TRUE)
for (iobs in 1:nobs)
    {
        plot(time.index,cor.state.simu[1,iobs,],
             xlim=range(time.index),
             ylim=c(-1,1),
             xlab="Time (hour)",
             ylab="Correlation coeffiicient",
             type='p',   
             main=obs.list[iobs],
             pch=16,
             cex=0.5
                                        #         col=rainbow(nobs)
             )

        points(time.index,cor.state.simu[2,iobs,],col="red",pch=16,cex=0.5)
        points(time.index,cor.state.simu[3,iobs,],col="blue",pch=16,cex=0.5)
        points(time.index,cor.state.simu[4,iobs,],col="green",pch=16,cex=0.5)                
            
        }


reset <- function(){
    par(mfrow=c(1,1),oma=c(4,4,4,1),mar=rep(0,4),new=TRUE)
    plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
}
reset()
          legend(0.1,0.08,c("E","L","D1","D2"),
                 pch=16,col=c("black","red","blue","green"),
#                 title='Legend',
         bty='n',
          horiz=TRUE
                 )
                                        #           )
    
dev.off()





#load("results/simu.qlz")
#load("results/simu.qlx")
#load("results/obs.qlz")
#load("results/obs.qlx")



## jpeg("figures/stochastic.qlx.qlz.jpg",width=12,height=8,units='in',res=300,quality=100)
## par(mfrow=c(3,4),pty='m',xpd=TRUE)
## for (iobs in 1:nobs)
##     {
##         plot(0,0,
##              type='n',
## #             xlim=range(simu.qlx),
## #             ylim=range(simu.qlz),
##              xlim=c(-4,2),
##              asp=1.0,
##              xlab="Velocity in x direction (m/h)",
##              ylab="Velocity in z direction (m/h)",
##              main=paste("Well-",formatC(iobs,width=2,flag='0'),sep='')
##              )




##         for (itime in 1:ntime)
##             {
##                 for (ireaz in 1:nreaz)
##                     {
##                         lines(c(0,simu.qlx[ireaz,iobs,itime]),c(0,simu.qlz[ireaz,iobs,itime]),col='green')                      
##                 }
##             }

## ##         for (itime in 1:ntime)
## ##             {
## ##                 lines(c(0,obs.qlx[iobs,itime]),c(0,obs.qlz[iobs,itime]))                      
## ## #                arrows(0,0,obs.qlx[iobs,itime],obs.qlz[iobs,itime],length=0.05)

## ##             }
    



        
##         }


## reset <- function(){
##     par(mfrow=c(1,1),oma=c(4,4,4,1),mar=rep(0,4),new=TRUE)
##     plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
## }
## reset()
## ## legend(0.817,0.185,c("Reference","Simulations"),
## ##        lwd=1,col=c("black","green"),
## ##        title='Legend'
## ##                                         # bty='n',
## ##        )
## legend(0.817,0.185,c("Simulations"),
##        lwd=1,col=c("green"),
##        title='Legend'
##                                         # bty='n',
##        )



##                                         #           )
## dev.off()



## jpeg("figures/stochastic.qlx.qly.value.jpg",width=12,height=8,units='in',res=300,quality=100)
## par(mfrow=c(3,4),pty='m',xpd=TRUE)
## for (iobs in 1:nobs)
##     {
##         plot(0,0,
##              type='n',
##              xlim=range(time.index),
## #             ylim=range(sqrt(simu.qlz[,,]**2+simu.qlx[,,]**2)),
##              ylim=c(0,4),
##              xlab="Time (hour)",
##              ylab="Velocity value(m/h)",
##              main=paste("Well-",formatC(iobs,width=2,flag='0'),sep=''),
##                                         #         col=rainbow(nobs)
##              )




        
##         for (ireaz in 1:nreaz)
##             {
##                         lines(time.index,sqrt(simu.qlz[ireaz,iobs,1:ntime]**2+simu.qlx[ireaz,iobs,1:ntime]**2),col='green')
##                     }


## #        lines(time.index,sqrt(obs.qlz[iobs,1:ntime]**2+obs.qlx[iobs,1:ntime]**2))



        
##         }


## reset <- function(){
##     par(mfrow=c(1,1),oma=c(4,4,4,1),mar=rep(0,4),new=TRUE)
##     plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
## }
## reset()
##          ##  legend(0.817,0.185,c("Reference","Simulations"),
##          ##         lwd=1,col=c("black","green"),
##          ##         title='Legend'
##          ## # bty='n',
##          ## )
## legend(0.817,0.185,c("Simulations"),
##        lwd=1,col=c("green"),
##        title='Legend'
##                                         # bty='n',
##        )



##                                         #           )
## dev.off()

