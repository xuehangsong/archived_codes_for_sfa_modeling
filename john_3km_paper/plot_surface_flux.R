rm(list=ls())
library(rhdf5)
library(akima)
load("results/flux_profile_average.r")

real.start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT")
real.time = real.start.time+times*3600


materials = h5read(h5.material,"/Materials/Material Ids")
face.material = materials[river.face.cell]



facies.profile = interp(z[river.face.cell.index[,"z"]],y[river.face.cell.index[,"y"]],
      face.material,duplicate="mean")

pdf(file="figures/flux_average.pdf",width=10,height=7)
filled.contour(real.time,y,vertical.sum.flux,zlim=c(0,15),ylab="Northing (m)",color = function(x)rev(heat.colors(x)),
               main="Total exchange flux on each slice")
dev.off()


pdf(file="figures/facies_profile.pdf",width=5,height=7)
image(facies.profile,
               xlab="Depth (m)",ylab="Northing (m)",main="Facies distribution on river boundary",col = cm.colors(2))
dev.off()

##filled.contour(facies.profile) 
##y.index = unique(river.face.cell.index)

