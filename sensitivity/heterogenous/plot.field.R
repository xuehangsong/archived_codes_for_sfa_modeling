library(rhdf5)
west = 0
east = 143.2
south = 0
north = 1
top = 110.0
bottom = 90.0

hanford.threshold = c(-11,-6)
alluvium.threshold = c(-15,-11)

threshold = range(hanford.threshold,alluvium.threshold)

dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
dy = 1.0
dz = c(rev(0.05*1.09505408**(1:25)),rep(0.05,300))

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz

x[c(which.min(x),which.max(x))] = c(0,143.2)
z[c(which.min(z),which.max(z))] = c(90,110)
    

###load("../lhsampling/sampled.perm.2.r")
fname = "../facies/facies.model.4/reference/T3_Slice_material.h5"
material.ids = h5read(fname,"Materials/Material Ids")
combined.perm = rep(0,length(nx*ny*nz))




load("results/perm.data.3.r")

for (i in 1:20+2) {

## jpegfile=paste("./figures/hanford_",i,".jpg",sep="")
## jpeg(jpegfile,width=12,height=3.2,units='in',res=300,quality=100)
## filled.contour(x,z,array(log10(hanford.perm[,i]),c(nx,nz)),asp=1.0,color=function(x)rev(topo.colors(x)),
##                xlab="x(m)",
##                ylab="z(m)",
##                zlim=hanford.threshold,
##                main=paste("Hanford permeabilty m^2 (log scale)",": Realization",i)
##                )
## dev.off()


## jpegfile=paste("./figures/alluvium_",i-2,".jpg",sep="")
## jpeg(jpegfile,width=12,height=3.2,units='in',res=300,quality=100)
## filled.contour(x,z,array(log10(alluvium.perm[,i]),c(nx,nz)),asp=1.0,color=function(x)rev(topo.colors(x)),
##                xlab="x(m)",
##                ylab="z(m)",
##                zlim=alluvium.threshold,                              
##                main=paste("Alluvium permeabilty m^2 (log scale)",": Realization",i)
##                )
## dev.off()

combined.perm[which(material.ids==1)] = log10(hanford.perm[,i])[which(material.ids==1)]
combined.perm[which(material.ids==5)] = 0
combined.perm[which(material.ids==4)] = log10(1e-15)
combined.perm[which(material.ids==0)] = 0

jpegfile=paste("./figures/combined.perm1_",i-2,".jpg",sep="")
jpeg(jpegfile,width=12,height=3.2,units='in',res=300,,quality=100)
filled.contour(x,z,array(combined.perm,c(nx,nz)),asp=1.0,color=function(x)rev(topo.colors(x)),
               zlim=hanford.threshold,
               main=paste("Hanford permeabilty m^2 (log scale), Realization",i-2),               
               plot.axes = {axis(1,at=seq(0,140,20),mgp=c(2,0.5,0),tck=-0.08,cex.axis=1)
                   axis(1,at=seq(0,140,10),labels=NA,tck=-0.05)
                   axis(2,at=seq(90,110,10),mgp=c(2,0.5,0),tck=-0.06,cex.axis=1,adj=1)
                   axis(2,at=seq(90,110,5),labels=NA,tck=-0.05)
                   mtext('Rotated east-west direction (m)',side=1,at=70,line=1.5,cex=1)
                   mtext('Elevation (m)',side=2,at=100,line=2,cex=1,las=3)
               }
               
               )
dev.off()







combined.perm[which(material.ids==1)] = 0
combined.perm[which(material.ids==5)] = log10(alluvium.perm[,i])[which(material.ids==5)]
combined.perm[which(material.ids==4)] = log10(1e-15)
combined.perm[which(material.ids==0)] = 0

jpegfile=paste("./figures/combined.perm2_",i-2,".jpg",sep="")

jpeg(jpegfile,width=12,height=3.2,units='in',res=300,,quality=100)
filled.contour(x,z,array(combined.perm,c(nx,nz)),asp=1.0,color=function(x)rev(topo.colors(x)),
               zlim=alluvium.threshold,
               main=paste("Alluvium permeabilty m^2 (log scale), Realization",i-2),
               plot.axes = {axis(1,at=seq(0,140,20),mgp=c(2,0.5,0),tck=-0.08,cex.axis=1)
                   axis(1,at=seq(0,140,10),labels=NA,tck=-0.05)
                   axis(2,at=seq(90,110,10),mgp=c(2,0.5,0),tck=-0.06,cex.axis=1,adj=1)
                   axis(2,at=seq(90,110,5),labels=NA,tck=-0.05)
                   mtext('Rotated east-west direction (m)',side=1,at=70,line=1.5,cex=1)
                   mtext('Elevation (m)',side=2,at=100,line=2,cex=1,las=3)
               }

)
    dev.off()


    
}
