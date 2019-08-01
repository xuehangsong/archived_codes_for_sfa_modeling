rm(list = ls())
library(circular)
source("codes/parameters.R")
#source("codes/cartToPolar.R")


load("results/obs.all")
nreaz=100
nobs=10
obs.time=seq(0,2700,1)
time.index=obs.time
ntime=length(time.index)

obs.type="qlx"
obs.qlx=array(rep(0,nobs*ntime),c(nobs,ntime))
for (itime in 1:ntime)
{
    for (iobs in 1:nobs)
        {
            obs.col=intersect(grep(obs.list[iobs],names(obs.all)),grep(obs.type,names(obs.all)))
            obs.row=which.min(abs(obs.time[itime]-obs.all[1][,1]))
            obs.xyz[iobs,]=as.double(tail(unlist(strsplit(colnames(obs.all[obs.col]),"[() ]+")[]),3))
            obs.qlx[iobs,itime]=obs.all[obs.row,obs.col]
        }
}
save(obs.qlx,file="results/obs.qlx")

obs.type="qlz"
obs.qlz=array(rep(0,nobs*ntime),c(nobs,ntime))
for (itime in 1:ntime)
{
    for (iobs in 1:nobs)
        {
            obs.col=intersect(grep(obs.list[iobs],names(obs.all)),grep(obs.type,names(obs.all)))
            obs.row=which.min(abs(obs.time[itime]-obs.all[1][,1]))
            obs.xyz[iobs,]=as.double(tail(unlist(strsplit(colnames(obs.all[obs.col]),"[() ]+")[]),3))
            obs.qlz[iobs,itime]=obs.all[obs.row,obs.col]
        }
}
save(obs.qlz,file="results/obs.qlz")

obs.type=c("Tracer","HCO3-","CH2O","O2","NO3-","N2","Liquid Pressure","H+","qlx","qlz")
molar.mass=c(35.453,12.0107,12.0107,31.9988,62.0049,28.0134)   #g/mol
ntype=length(obs.type)

obs.conc=array(rep(0,ntype*nobs*ntime),c(ntype,nobs,ntime))
obs.xyz=array(rep(0,nobs*3),c(nobs,3))
colnames(obs.xyz)=c("x","y","z")

for (itype in 1:ntype)
{    
    for (itime in 1:ntime)
        {

            for (iobs in 1:nobs)
                {
                    obs.col=intersect(grep(obs.list[iobs],names(obs.all)),grep(obs.type[itype],names(obs.all),fixed=TRUE))
                    obs.row=which.min(abs(obs.time[itime]-obs.all[1][,1]))
                    obs.conc[itype,iobs,itime]=obs.all[obs.row,obs.col]
                    obs.xyz[iobs,]=as.double(tail(unlist(strsplit(colnames(obs.all[obs.col]),"[() ]+")[]),3))
                }
        }


}
for (itype in 1:6)
    {
        obs.conc[itype,,]=obs.conc[itype,,]*molar.mass[itype]*1000
    }

#obs.conc[7,,]=t(apply(((obs.conc[7,,]-101325)/9.8068/1000),2,"+",obs.xyz[,3]))
obs.conc[7,,]=(obs.conc[7,,]-101325)/9.8068/1000+replicate(ntime,obs.xyz[,3])

obs.conc[8,,]=-log10(obs.conc[8,,])

save(obs.conc,file='results/obs.conc')

## stop()
##load("results/obs.qlx")
##load("results/obs.qlz")
load("results/obs.conc")
for (itype in 1:7)
{
    obs.conc[itype,,]=(obs.conc[itype,,]-min(obs.conc[itype,,]))/
        (max(obs.conc[itype,,])-min(obs.conc[itype,,]))
}    

jpeg("figures/normalized.reference.conc.jpg",width=15,height=10,units='in',res=200,quality=100)
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
    
   lines(time.index,obs.conc[1,iobs,],col="black")    
   lines(time.index,obs.conc[2,iobs,],col="red")
   lines(time.index,obs.conc[3,iobs,],col="blue")
   lines(time.index,obs.conc[4,iobs,],col="yellow")
   lines(time.index,obs.conc[5,iobs,],col="green")
   lines(time.index,obs.conc[6,iobs,],col="peru")                
#   lines(time.index,obs.conc[7,iobs,],col="grey")
    
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

obs.type=c("Tracer","HCO3-","CH2O","O2","NO3-","N2","Hydraulic head","PH","qlx","qlz")
load("results/obs.conc")
jpeg("figures/single.reference.conc.jpg",width=15,height=14,units='in',res=200,quality=100)
par(mfrow=c(10,2),mar=c(3.1,3.5,1,1),oma=c(2,2,2,2),mgp=c(1.8,0.8,0),pty='m',xpd=TRUE)
for (itype in c(1,2,3,4,5,6,8,7,9,10))#c(1,3,5,7,9,2,4,6,8,10))
{
    plot(0,0,
         type='n',
         xlim=range(time.index),
         ylim=range(obs.conc[itype,,]),
         ## xlim=range(time.index[337:1009]),
         ## ylim=range(obs.conc[itype,,337:1009]),
         main=obs.type[itype],
         xlab=NA,
         ylab=NA
         )
                                        #    lines(time.index,obs.conc[iobs,iobs,which(log.time %in% time.index)],col="red")

    if (any(c(10)==itype)){
        mtext(expression("Time (hour)"),side=1,line=2.2,col="black",cex=0.8)        
             }

    if (any(c(1,2,3,4,5,6)==itype)){
        mtext(expression("Concentration (mg/L)"),side=2,line=2.2,col="black",cex=0.8)        
             }

    if (any(c(7)==itype)){
        mtext(expression("Hydraulic head (m)"),side=2,line=2.2,col="black",cex=0.8)        
             }

    if (any(c(8)==itype)){
        mtext(expression("PH"),side=2,line=2.2,col="black",cex=0.8)        
             }


    
    if (any(c(9)==itype)){
        mtext(expression("Horizontal velocity (m/h)"),side=2,line=2.2,col="black",cex=0.8)        
             }

    if (any(c(10)==itype)){
        mtext(expression("Vertical velocity (m/h)"),side=2,line=2.2,col="black",cex=0.8)        
             }
    
    
     lines(time.index,obs.conc[itype,5,],col="black")
 #   lines(time.index[337:1009],obs.conc[itype,5,337:1009],col="black")        

    plot(0,0,
         type='n',
        xlim=range(time.index),
        ylim=range(obs.conc[itype,,]),
#         xlim=range(time.index[337:1009]),
#         ylim=range(obs.conc[itype,,337:1009]),
         main=obs.type[itype],
         xlab=NA,
         ylab=NA
         )
                                        #    lines(time.index,obs.conc[iobs,iobs,which(log.time %in% time.index)],col="red")

    if (any(c(10)==itype)){
        mtext(expression("Time (hour)"),side=1,line=2.2,col="black",cex=0.8)        
             }

    ## if (any(c(1,2,3,4,5,6,7)==iobs)){
    ##     mtext(expression("Concentration (mg/L)"),side=2,line=2.2,col="black",cex=0.8)        
    ##          }
    lines(time.index,obs.conc[itype,6,],col="black")    
#    lines(time.index[337:1009],obs.conc[itype,6,337:1009],col="black")        
}
dev.off()
stop()

























jpeg("figures/reference.conc.jpg",width=14,height=8,units='in',res=1000,quality=100)
par(mfrow=c(3,5),mar=c(3.1,3.5,2.1,3.5),mgp=c(1.8,0.8,0),pty='m',xpd=TRUE)
for (iobs in c(1,3,5,7,9,2,4,6,8,10))
{
    plot(0,0,
         type='n',
         xlim=range(time.index),
         ylim=range(obs.conc),
         xlab="Time (hour)",
         ylab="Concentration (mg/L)",
         main=obs.list[iobs]
         )
                                        #    lines(time.index,obs.conc[iobs,iobs,which(log.time %in% time.index)],col="red")

    lines(time.index,obs.conc[2,iobs,],col="red")
    lines(time.index,obs.conc[3,iobs,],col="blue")
    lines(time.index,obs.conc[4,iobs,],col="yellow")
    lines(time.index,obs.conc[5,iobs,],col="green")


    par(new=TRUE)
    plot(time.index,obs.conc[6,iobs,],type='l',col='orange',xlab='',ylab='',ylim=range(obs.conc[c(1,6),,]),axes=FALSE)
    lines(time.index,obs.conc[1,iobs,],col="black")
    axis(4,ylim=range(obs.conc[c(1,6),,]))
    mtext(expression("N"[2]* "& H+ Concentration (mg/L)"),side=4,line=2.2,col="orange",cex=0.8)
#    lines(time.index,obs.conc[6,iobs,],col="orange")                
    
    
}

reset <- function(){
    par(mfrow=c(1,1),oma=c(4,4,4,1),mar=rep(0,4),new=TRUE)
    plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
}
reset()
          legend(0.2,0.2,c(obs.type[2:6],obs.type[1]),
                 lwd=1,col=c("red","blue","yellow","green","orange","black"),
#                 title='Legend',
#         bty='n',
         horiz=TRUE
                 )
                                        #           )
    





dev.off()






## jpeg("figures/reference.rose.jpg",width=25,height=12,units='in',res=300,quality=100)
## par(mfrow=c(2,5),pty='m',xpd=TRUE)
## for (iobs in c(1,3,5,7,9,2,4,6,8,10))
##     {

##         velocity.value=cartToPolar(obs.qlx[iobs,1:ntime],obs.qlz[iobs,1:ntime],2)$r
##         velocity.dir=cartToPolar(obs.qlx[iobs,1:ntime],obs.qlz[iobs,1:ntime],2)$phi        

## #        velocity.dir=(velocity.dir+90)%%360
##         velocity.dir=circular(velocity.dir,units="degrees")
##         breaks=circular(seq(0,2*pi,by=pi/10))
##         breaks=breaks[-2]
        
##         windrose(velocity.dir,velocity.value,#breaks=breaks,
##                  axes=FALSE,
##                  main=obs.list[iobs],
##                  plot.mids=FALSE,
##                  bins=4,
##                  xlim=c(-1.5,1.5),
##                  ylim=c(-1.5,1.5),                 
##                  ticks=TRUE,
##                  num.ticks=20,
##                  asp=1.0,
##                  bty="n"
## )



##         ## points(time.index,cor.state.simu[2,iobs,],col="red",pch=16,cex=0.5)
##         ## points(time.index,cor.state.simu[3,iobs,],col="blue",pch=16,cex=0.5)
##         ## points(time.index,cor.state.simu[4,iobs,],col="green",pch=16,cex=0.5)                


        
##         }



## dev.off()


## jpeg("figures/reference.qlx.qlz.jpg",width=5,height=10,units='in',res=300,quality=100)
## par(mfrow=c(5,2),pty='m',xpd=TRUE)
## for (iobs in 1:nobs)
##     {
##         plot(0,0,
##              type='n',
## #             xlim=range(obs.qlx),
## #             ylim=range(obs.qlz),
##              xlim=c(-4,2),
##              asp=1.0,
##              xlab="Velocity in x direction (m/h)",
##              ylab="Velocity in z direction (m/h)",
##              main=paste("Well-",formatC(iobs,width=2,flag='0'),sep='')
##              )
##         for (itime in 1:ntime)
##             {
##                 lines(c(0,obs.qlx[iobs,itime]),c(0,obs.qlz[iobs,itime]))                      
## #                arrows(0,0,obs.qlx[iobs,itime],obs.qlz[iobs,itime],length=0.05)

##             }

                
##         }


## reset <- function(){
##     par(mfrow=c(1,1),oma=c(4,4,4,1),mar=rep(0,4),new=TRUE)
##     plot(0:1,0:1,type='n',xlab="",ylab="",axes=FALSE)
## }
## reset()
## legend(0.617,0.185,c("Velocity vector"),
##        lwd=1,col=c("black"),
##        title='Legend'
##                                         # bty='n',
##        )
##                                         #           )
## dev.off()


## stop()
## jpeg("figures/reference.qlx.qly.value.jpg",width=12,height=8,units='in',res=300,quality=100)
## par(mfrow=c(3,4),pty='m',xpd=TRUE)
## for (iobs in 1:nobs)
##     {
##         plot(time.index,sqrt(obs.qlz[iobs,1:ntime]**2+obs.qlx[iobs,1:ntime]**2),
##              xlim=range(time.index),
##              ylim=range(sqrt(obs.qlz[,]**2+obs.qlx[,]**2)),
##              xlab="Time (hour)",
##              ylab="Velocity value(m/h)",
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
##           legend(0.817,0.185,c("Velocity value"),
##                  lwd=1,col=c("black"),
##                  title='Legend'
##          # bty='n',
##          )
##                                         #           )
## dev.off()
