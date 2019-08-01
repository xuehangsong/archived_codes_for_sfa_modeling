rm(list = ls())
library(rhdf5)
load("results/general.r")
## final.time = 744

## input.file=list.files("reference","in$")    
## pflotran.input=readLines(paste("reference/",input.file,sep=''),-1)
## time.line=grep("FINAL_TIME",pflotran.input)
## pflotran.input[time.line]=paste("  FINAL_TIME ",final.time," h") #sprintf("d",) format(obs.time[itime],scientific=TRUE)
## writeLines(pflotran.input,paste("reference/",input.file,sep=''))
#update mud layer
hori.elevation = 104 ##################################105
hori.length = 7 #7
second.depth = 1.5 #1.5
third.depth = 0.5

second.x = river.bank.x[which.min(abs(z[river.bank.z]-hori.elevation-second.depth))]
first.x = river.bank.x[which.min(abs(x[second.x]-x[river.bank.x]-hori.length))]
first.depth = z[river.bank.z[which.min(abs(x[first.x]-x[river.bank.x]))]]-hori.elevation

mudlayer.depth=rep(0,nbank)
for (ibank in 1:nbank)
{
    if (river.bank.x[ibank]<first.x)
        {
            mudlayer.depth[ibank]=first.depth*(river.bank.x[ibank]-river.bank.x[1])/(first.x-river.bank.x[1])
        }else if(river.bank.x[ibank]>second.x){
            mudlayer.depth[ibank]=second.depth+(third.depth-second.depth)*(river.bank.x[ibank]-second.x)/(max(river.bank.x)-second.x)
        }else{
            mudlayer.depth[ibank]=z[river.bank.z[ibank]]-hori.elevation
        }
}    

save(mudlayer.depth,file='results/mudlayer.depth.r')
material.ids=material.ids.reverse


for (ibank in 1:nbank)
    {
        bottom.z=river.bank.z[ibank]-mudlayer.depth[ibank] %/% 0.05  #remember no matter in x or z direction, 0.1 is the minimum grid for mudlayer
        material.ids[river.bank.x[ibank],1,bottom.z:river.bank.z[ibank]][which(material.ids[river.bank.x[ibank],1,bottom.z:river.bank.z[ibank]]!=0,)]=5
    }


obs.well.x = rep(x[river.bank.x[which.min(abs(x[river.bank.x]-111.))]],24)
obs.well.depth = 0.025 + seq(1*0.05,24*0.05,0.05)
obs.well.z = z[river.bank.z[which.min(abs(x[river.bank.x]-110.))]]-
    obs.well.depth+0.025
save(list = c("obs.well.depth","obs.well.x","obs.well.z"),file='results/obs.well.loc.r')


## ###start block
## material.ids[river.bank.x[which.min(abs(x[river.bank.x]-110.))],1,
##                  river.bank.z[which.min(abs(x[river.bank.x]-110.))]] = 5

## ###end block
## material.ids[river.bank.x[which.min(abs(x[river.bank.x]-110.))],1,
##                  (river.bank.z[which.min(abs(x[river.bank.x]-110.))]-25)] = 5

## material.ids[river.bank.x[which.min(abs(x[river.bank.x]-110.))],1,
##                  (river.bank.z[which.min(abs(x[river.bank.x]-110.))]-1:24)] = 5


hanford.ringold.boundary=rep(0,nx)
for (ix in 1:nx)
    {
        for (iz in 1:(nz-1))
            {
                if ((material.ids[ix,1,(iz+1)]-material.ids[ix,1,iz])==-3)
                    {
                        hanford.ringold.boundary[ix]=iz
                    }
            }
    }

save(hanford.ringold.boundary,file='results/hanford.ringold.boundary.r')
## add.depth = 79 #(39+1)*0.05=2
## for (ix in 1:nx)
##     {
##         material.ids[ix,1,-add.depth:0+hanford.ringold.boundary[ix]] = 1
##     }


material.ids=array(as.integer(material.ids),c(nx,ny,nz))
h5file="./reference/T3_Slice_material.h5"
h5write(seq(1,nx*ny*nz),h5file,"Materials/Cell Ids")
h5write(c(material.ids),h5file,"Materials/Material Ids")

material.ids.plot = material.ids
## material.ids.plot[river.bank.x[which.min(abs(x[river.bank.x]-110.))],1,
##                  river.bank.z[which.min(abs(x[river.bank.x]-110.))]] = 5
## material.ids.plot[river.bank.x[which.min(abs(x[river.bank.x]-110.))],1,
##                  (river.bank.z[which.min(abs(x[river.bank.x]-110.))]-25)] = 5


material.ids.plot = material.ids.plot[,1,]
material.ids.plot[,345:400][material.ids.plot[,345:400]==0] = -2 #105.0642
material.ids.plot[,302:345][material.ids.plot[,302:345]==0] = -1 #107.2273

jpegfile="./figures/reference_material_2d.jpg"
jpeg(jpegfile,width=6.5,height=2.6,units='in',res=300,quality=100)
#jpeg(jpegfile,width=8,height=2.8,units='in',res=3000,quality=100)
par(xpd=TRUE)
image(x,z,material.ids.plot,
      xlim=c(west,east),
      ylim=range(bottom,top),
#      xlab='Rotated east-west direction (m)',
#      ylab='Elevation (m)',
      breaks=c(-1.5,-0.5,0.5,1.5,4.5,5.5,12),
      col=c("lightblue1","blue","lightgoldenrod","grey","green","red"),
#      cex.lab=0.8,
#      cex.axis=0.8,
      asp=1.0,
      axes=FALSE,
      xlab=NA,
      ylab=NA
      )
axis(1,at=seq(0,140,20),mgp=c(1.5,0.2,0),tck=-0.08,cex.axis=0.8)
axis(1,at=seq(0,140,10),labels=NA,tck=-0.05)
axis(2,at=seq(90,110,10),mgp=c(1.5,0.4,0),tck=-0.08,cex.axis=0.8,adj=1)
axis(2,at=seq(90,110,5),labels=NA,tck=-0.05)
mtext('Rotated east-west direction (m)',side=1,at=70,line=0.9,cex=0.8)
mtext('Elevation (m)',side=2,at=100,line=1.2,cex=0.8)

#lines(c(357,400),c(105.0642,105.0642),col='yellow',lwd=0.5,lty=2)
#lines(c(x[first.x],x[first.x]),c(90,110),col="red",lwd=0.5,lty=2)
#lines(c(x[second.x],x[second.x]),c(90,110),col="red",lwd=0.5,lty=2)

for  (i in 1:length(obs.well.x))
{
   points(obs.well.x[i],obs.well.z[i],col='red',pch=16,cex=0.1)
}


## for  (i in 1:2)
## {
##     text(obs.well.x[i],obs.well.z[i,1]-0.9,paste("0",i,"M",sep=''),col='black',cex=0.3)
##     text(obs.well.x[i],obs.well.z[i,2]-0.9,paste("0",i,"H",sep=''),col='black',cex=0.3)        

## }

#lines(x,z[hanford.ringold.boundary])

box()
legend(9,117,c('Hanford','Ringold','Alluvium'),
       pch=c(15,15,15),
       col=c('lightgoldenrod','grey','green'),
       bty='n',
       horiz='true',
       cex=0.8
       )
legend(70,117,c('Piezometer'),
       pch=c(15),
       col=c('red'),
       bty='n',
       horiz='true',
       cex=0.8
       )
legend(95,117,c('River'),
       pch=c(15),
       col=c('blue'),
       bty='n',
       horiz='true',
       cex=0.8
       )

legend(110,117,c('Fluctuation zone'),
       pch=c(15),
       col=c('lightblue2'),
       bty='n',
       horiz='true',
       cex=0.8
       )


## legend(0.9,1.7,c('Wells'),
##        pch=c(16),
##        col=c('red'),
##        bty='n',
##        horiz='true',
##        cex=0.8
##        )
dev.off()


H5close()
