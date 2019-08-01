rm(list = ls())
library(rhdf5)
source("./codes/create.material.grid.R")
#load("results/material.grid.data")
source("./codes/parameters.R")


input.file=list.files("reference","in$")    
pflotran.input=readLines(paste("reference/",input.file,sep=''),-1)
time.line=grep("FINAL_TIME",pflotran.input)
pflotran.input[time.line]=paste("  FINAL_TIME ",obs.time[ntime]," h") #sprintf("d",) format(obs.time[itime],scientific=TRUE)
writeLines(pflotran.input,paste("reference/",input.file,sep=''))
#update mud layer



#10/02/2015 this is for james's
#the lowest elevation mudelayer could reach(103)
## hori.elevation=103
## second.depth=0.2
## second.x=river.bank[which.min(abs(z.new[river.bank[,2]]-hori.elevation-second.depth)),1]
## x.new[second.x]
## results=375.55
## it means the elevation handford observation wells which is within x < 375 must be less than 103
## handford well on x=360 need to 102.95

#As the river level could drop to 105.064, and the piezometer must be installed deepth than this elevation
#mudlayer.depth[which.min(abs(x.new[river.bank[,1]]-360))]

#obs.well[1,1]=z.new[river.bank[which.min(abs(x.new[river.bank[,1]]-360)),2]]-0.15-0.05/2
#obs.well[1,2]=z.new[river.bank[which.min(abs(x.new[river.bank[,1]]-360)),2]]-2.15-0.05/2

obs.well.x=c(105,107.5,110,112.5,115)
obs.well.z=array(rep(0,10),c(5,2))
#obs.well.z[1,1]=104.95
#obs.well.z[1,2]=102.95
for (i in 1:5)
{
#    obs.well.z[i,1]=z.new[river.bank[which.min(abs(x.new[river.bank[,1]]-obs.well.x[i])),2]]-0.15-0.05/2
#    obs.well.z[i,2]=z.new[river.bank[which.min(abs(x.new[river.bank[,1]]-obs.well.x[i])),2]]-2.15-0.05/2
    obs.well.z[i,1]=min( (z.new[river.bank[which.min(abs(x.new[river.bank[,1]]-obs.well.x[i])),2]]-0.15-0.05/2)
                        ,(105.0642-0.15-0.05/2))

    obs.well.z[i,2]=obs.well.z[i,1]-1.5
}    


#river.bank=river.bank[order(river.bank[,1]+nx.new*(river.bank[,2]-1)),]
hori.elevation=104
hori.length=7
second.depth=1.0
third.depth=0.5
second.x=river.bank[which.min(abs(z.new[river.bank[,2]]-hori.elevation-second.depth)),1]
first.x=river.bank[which.min(abs(x.new[second.x]-x.new[river.bank[,1]]-hori.length)),1]
first.depth=z.new[river.bank[which.min(abs(x.new[first.x]-x.new[river.bank[,1]])),2]]-hori.elevation

mudlayer.depth=rep(0,nbank)
for (ibank in 1:nbank)
{
    if (river.bank[ibank,1]<first.x)
        {
            mudlayer.depth[ibank]=first.depth*(river.bank[ibank,1]-river.bank[1,1])/(first.x-river.bank[1,1])
        }else if(river.bank[ibank,1]>second.x){
            mudlayer.depth[ibank]=second.depth+(third.depth-second.depth)*(river.bank[ibank,1]-second.x)/(max(river.bank[,1])-second.x)
        }else{
#            mudlayer.depth[ibank]=first.depth+
#                (second.depth-first.depth)*(river.bank[ibank,1]-first.x)/(second.x-first.x)
             mudlayer.depth[ibank]=z.new[river.bank[ibank,2]]-hori.elevation
        }
}    


save(mudlayer.depth,file='results/mudlayer.depth')
material_ids.new=material_ids.reverse
for (ibank in 1:nbank)
    {
        left.x=river.bank[ibank,1]-as.integer(round(mudlayer.depth[ibank]/0.1))
        bottom.z=river.bank[ibank,2]-as.integer(round(mudlayer.depth[ibank]/0.1)*2)  #remember no matter in x or z direction, 0.1 is the minimum grid for mudlayer
        left.x=max(left.x,831)
        bottom.z=max(bottom.z,101)    
#        material_ids.new[left.x:river.bank[ibank,1],1,bottom.z:river.bank[ibank,2]][which(material_ids.new[left.x:river.bank[ibank,1],1,bottom.z:river.bank[ibank,2]]!=0,)]=5
#        keep in mind what we're using here,we're using vertical line, not blocks to define mud layer
        material_ids.new[river.bank[ibank,1],1,bottom.z:river.bank[ibank,2]][which(material_ids.new[river.bank[ibank,1],1,bottom.z:river.bank[ibank,2]]!=0,)]=5
    }


hanford.ringold.boundary=rep(0,nx.new)
for (ix in 1:nx.new)
    {
        for (iz in 1:(nz.new-1))
            {
                if ((material_ids.new[ix,1,(iz+1)]-material_ids.new[ix,1,iz])==-3)
                    {
                        hanford.ringold.boundary[ix]=iz
                    }
            }
    }


add.depth = 79 #(39+1)*0.05=2
for (ix in 1:nx.new)
    {
        material_ids.new[ix,1,-add.depth:0+hanford.ringold.boundary[ix]] = 1
    }


material_ids.new=array(as.integer(material_ids.new),c(nx.new,ny.new,nz.new))
h5file="./reference/Plume_Slice_AdaptiveRes_material.h5"
h5write(seq(1,nx.new*ny.new*nz.new),h5file,"Materials/Cell Ids")
h5write(c(material_ids.new),h5file,"Materials/Material Ids")

material_ids.plot=material_ids.new[,1,]
material_ids.plot[,345:400][material_ids.plot[,345:400]==0]=-2 #105.0642
material_ids.plot[,302:345][material_ids.plot[,302:345]==0]=-1 #107.2273

jpegfile="./figures/reference_material_2d.jpg"
jpeg(jpegfile,width=8,height=2.8,units='in',res=2500,quality=100)
par(xpd=TRUE,mgp=c(2.1,1,0))
image(x.new,z.new,material_ids.plot,
      xlim=c(west.new,east.new),
      ylim=range(bottom.new,top.new),
      xlab='Rotated east-west direction (m)',
      ylab='Elevation (m)',
      breaks=c(-1.5,-0.5,0.5,1.5,4.5,5.5),
      col=c("lightblue1","blue","lightgoldenrod","grey","green"),
      cex.lab=0.8,
      cex.axis=0.8,
      asp=1.0,
      )

lines(c(357,400),c(105.0642,105.0642),col='yellow',lwd=0.5,lty=2)
lines(c(x.new[first.x],x.new[first.x]),c(90,110),col="red",lwd=0.5,lty=2)
lines(c(x.new[second.x],x.new[second.x]),c(90,110),col="red",lwd=0.5,lty=2)

for  (i in 1:5)
{
    points(obs.well.x[i],obs.well.z[i,1],col='red',pch=16,cex=0.4)
    points(obs.well.x[i],obs.well.z[i,2],col='red',pch=16,cex=0.4)        

}

for  (i in 1:5)
{
    text(obs.well.x[i],obs.well.z[i,1]-0.9,paste("0",i,"M",sep=''),col='black',cex=0.3)
    text(obs.well.x[i],obs.well.z[i,2]-0.9,paste("0",i,"H",sep=''),col='black',cex=0.3)        

}

lines(x.new,z.new[hanford.ringold.boundary])

box()
par(new=TRUE)
plot(0,0,type='n',xaxt="n",yaxt="n",xlab=NA,ylab=NA)
legend(-0.75,1.7,c('Hanford formation','Ringold formation','Mud layer'),
       pch=c(15,15,15),
       col=c('lightgoldenrod','grey','green'),
       bty='n',
       horiz='true',
       cex=0.8
       )
legend(0.35,1.7,c('River'),
       pch=c(15),
       col=c('blue'),
       bty='n',
       horiz='true',
       cex=0.8
       )

legend(0.52,1.7,c('Fluctuation zone'),
       pch=c(15),
       col=c('lightblue2'),
       bty='n',
       horiz='true',
       cex=0.8
       )


legend(0.9,1.7,c('Wells'),
       pch=c(16),
       col=c('red'),
       bty='n',
       horiz='true',
       cex=0.8
       )
dev.off()


H5close()
