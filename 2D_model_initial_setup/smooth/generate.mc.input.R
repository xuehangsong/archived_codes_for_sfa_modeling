rm(list = ls())
library(rhdf5)

args=commandArgs(trailingOnly=TRUE)
itime=as.integer(args[1])
ireaz=as.integer(args[2])

file.remove(list.files(paste(ireaz,"/",sep=""),pattern="*.tec",full.names=TRUE))

source("./codes/parameters.R")
load("results/material.grid.data")
load(paste("results/state.vector.",itime-1,sep=''))

#rewrite end time for pflotran
input.file=list.files(as.character(ireaz),"in$")    
pflotran.input=readLines(paste(ireaz,"/",input.file,sep=''),-1)
time.line=grep("FINAL_TIME",pflotran.input)
pflotran.input[time.line]=paste("  FINAL_TIME ",obs.time[itime]," h") #sprintf("d",) format(obs.time[itime],scientific=TRUE)
writeLines(pflotran.input,paste(ireaz,"/",input.file,sep=''))

#update mud layer
#river.bank=river.bank[order(river.bank[,1]+nx.new*(river.bank[,2]-1)),]

hori.elevation=state.vector[ireaz,1]
hori.length=exp(state.vector[ireaz,2])
second.depth=exp(state.vector[ireaz,3])
third.depth=exp(state.vector[ireaz,4])

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

material_ids.new=material_ids.reverse
for (ibank in 1:nbank)
    {
        left.x=river.bank[ibank,1]-as.integer(round(mudlayer.depth[ibank]/0.1))
        bottom.z=river.bank[ibank,2]-as.integer(round(mudlayer.depth[ibank]/0.1)*2)  #remember no matter in x or z direction, 0.1 is the minimum grid for mudlayer
        left.x=max(left.x,831)
        bottom.z=max(bottom.z,101)    
#        material_ids.new[left.x:river.bank[ibank,1],1,bottom.z:river.bank[ibank,2]][which(material_ids.new[left.x:river.bank[ibank,1],1,bottom.z:river.bank[ibank,2]]!=0,)]=5
        material_ids.new[river.bank[ibank,1],1,bottom.z:river.bank[ibank,2]][which(material_ids.new[river.bank[ibank,1],1,bottom.z:river.bank[ibank,2]]!=0,)]=5
    }

material_ids.new=array(as.integer(material_ids.new),c(nx.new,ny.new,nz.new))
h5file=paste(ireaz,"/Plume_Slice_AdaptiveRes_material.h5",sep='')
h5write(seq(1,nx.new*ny.new*nz.new),h5file,"Materials/Cell Ids")
h5write(c(material_ids.new),h5file,"Materials/Material Ids")

material_ids.plot=material_ids.new[,1,]
material_ids.plot[,345:400][material_ids.plot[,345:400]==0]=-1 #107.2272

obs.well.x=c(360,365.5,370,375,380)
obs.well.z=array(rep(0,10),c(5,2))
obs.well.z[1,1]=104.95
obs.well.z[1,2]=102.95
for (i in 2:5)
{
    obs.well.z[i,1]=z.new[river.bank[which.min(abs(x.new[river.bank[,1]]-obs.well.x[i])),2]]-0.15-0.05/2
    obs.well.z[i,2]=z.new[river.bank[which.min(abs(x.new[river.bank[,1]]-obs.well.x[i])),2]]-2.15-0.05/2
}    

jpegfile=paste("figures/",itime-1,"_",ireaz,"_material_2d.jpg",sep='')
jpeg(jpegfile,width=8,height=2.8,units='in',res=600,quality=100)
par(xpd=TRUE,mgp=c(2.1,1,0))
image(x.new,z.new,material_ids.plot,
      xlim=c(range(x.new)[1],400),
      ylim=range(z.new),
      xlab='Rotated east-west direction (m)',
      ylab='Elevation (m)',
      breaks=c(-0.5,0.5,1.5,4.5,5.5),
      col=c("blue","orange","grey","green"),
      cex.lab=0.8,
      cex.axis=0.8,
      asp=1.0,
      )
lines(c(363.55,400),c(105.0642,105.0642),col='yellow',lwd=0.5,lty=2)
lines(c(x.new[first.x],x.new[first.x]),c(90,110),col="red",lwd=0.5,lty=2)
lines(c(x.new[second.x],x.new[second.x]),c(90,110),col="red",lwd=0.5,lty=2)
for  (i in 1:5)
{
    points(obs.well.x[i],obs.well.z[i,1],col='red',pch=16,cex=0.2)
    points(obs.well.x[i],obs.well.z[i,2],col='red',pch=16,cex=0.2)        

}

for  (i in 1:5)
{
    text(obs.well.x[i],obs.well.z[i,1]-0.6,paste("Well-0",i,"M",sep=''),col='red',cex=0.2)
    text(obs.well.x[i],obs.well.z[i,2]-0.6,paste("Well-0",i,"H",sep=''),col='red',cex=0.2)        

}

box()
par(new=TRUE)
plot(0,0,type='n',xaxt="n",yaxt="n",xlab=NA,ylab=NA)
legend(-0.4,1.7,c('Hanford formation','Ringold formation','Mud layer'),
       pch=c(15,15,15),
       col=c('orange','grey','green'),
       bty='n',
       horiz='true',
       cex=0.8
       )
legend(0.7,1.7,c('River'),
       pch=c(15),
       col=c('blue'),
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
