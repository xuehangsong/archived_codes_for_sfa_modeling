rm(list = ls())
library(rhdf5)
H5close()

load("results/material.grid.data")
obs.time = seq(1,113)
ntime = length(obs.time)

## prefix.h5file = "reference.short.time/2duniform-"
## h5.data=list()
## for (itime in obs.time)
## {
##     h5.file = paste(prefix.h5file,formatC((itime-1),width=3,flag='0'),".h5",sep='') #sprintf("%03d",x)
##     h5.data[[itime]] = h5dump(h5.file)
##     print(itime)
## }
## save(h5.data,file="results/h5.short.time")
## H5close()

## stop()

river.gradients=as.matrix(read.table("reference/Gradients_River_Plume2013.txt"))
river.level=as.matrix(read.table("reference/DatumH_River_Plume2013.txt"))
east.level=array(2*dim(river.level)[1],dim=c(dim(river.level)[1],2))
east.level[,1]=river.level[,1]/3600
east.level[,2]=(y.new-river.level[,3])*river.gradients[,3]+river.level[,4]

well.level=as.matrix(read.table("reference/DatumH_West_Plume2013.txt"))
west.level=array(2*dim(well.level)[1],dim=c(dim(well.level)[1],2))
west.level[,1]=well.level[,1]/3600
west.level[,2]=well.level[,4]

jpeg.name = paste("figures/boundary",".jpg",sep = "")
jpeg(jpeg.name,width=8,height=4,units='in',res=300,quality=100)
par(mgp=c(1.8,0.6,0),mar=c(4.1,4.1,2.1,2.1))
plot(east.level[which(east.level[,1]<=2700),1],east.level[which(east.level[,1]<=2700),2],
     type='l',
     lwd=2,
     col='blue',
     xlab='Time (hour)',
     ylab='Water table level (m)',
     ylim=c(105,108),
     xlim=c(0,2700),
     main=paste("Boundary conditions")
     )
lines(west.level[which(west.level[,1]<=2700),1],west.level[which(west.level[,1]<=2700),2],lwd=2,col='red')
legend(x='topleft',c('West boundary (Well 2-03)','East boundary (River)'),
       lwd=2,
       lty=c(1,1),
       col=c("red","blue"),
       bty='n',
       )
dev.off()

                                        #for (itime in seq(1,240))

for (itime in obs.time)
{
    jpeg.name = paste("figures/long",formatC((itime-1),width = 3,flag = "0"),"_boundary",".jpg",sep = "")
    jpeg(jpeg.name,width=8,height=4,units='in',res=300,quality=100)
    par(mgp=c(1.8,0.6,0),mar=c(3.8,3.8,2.1,2.1))
    plot(east.level[which(east.level[,1]<=2700),1],east.level[which(east.level[,1]<=2700),2],
         type='l',
         lwd=2,
         col='blue',
         xlab='Time (hour)',
         ylab='Water table level (m)',
         ylim=c(105,108),
         xlim=c(0,2700),
         main=paste("Boundary conditions : T =",(itime-1)*24,"hour")
         )
    lines(west.level[which(west.level[,1]<=2700),1],west.level[which(west.level[,1]<=2700),2],lwd=2,col='red')
    lines(c(itime*24,itime*24),c(105,107.2),lty=2,lwd=2,col='black')
    legend(x='topleft',c('West boundary (Well 2-03)','East boundary (River)',"Current time"),
           lwd=2,
           lty=c(1,1,2),
           col=c("red","blue","black"),
           bty='n',
           )
    dev.off()
}


stop()
jpeg("figures/boundary.jpg",width=8,height=4,units='in',res=300,quality=100)
par(mgp=c(1.8,0.6,0),mar=c(4.1,4.1,2.1,2.1))
plot(east.level[which(east.level[,1]<=2700),1],east.level[which(east.level[,1]<=2700),2],
     type='l',
     lwd=2,
     col='blue',
     xlab='Time (day)',
     ylab='Water table level (m)',
     ylim=c(105,108),
     xlim=c(0,2700),
#     main=paste("Boundary conditions : T =",itime-1,"day")
     )
lines(west.level[which(west.level[,1]<=2700),1],west.level[which(west.level[,1]<=2700),2],lwd=2,col='red')
legend(x='topleft',c('West boundary (Well 2-03)','East boundary (River)'),
       lwd=2,
       lty=c(1,1),
       col=c("red","blue"),
       bty='n',
       )
dev.off()
