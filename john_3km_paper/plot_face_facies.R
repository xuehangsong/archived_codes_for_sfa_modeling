rm(list=ls())
library(rhdf5)
library(akima)
load("results/flux_profile_average.r")
materials = h5read(h5.material,"/Materials/Material Ids")
face.material = materials[river.face.cell]
facies.profile = interp(y[river.face.cell.index[,"y"]],z[river.face.cell.index[,"z"]],
      face.material,duplicate="mean")

pdf(file="figures/facies_profile.pdf",width=6,height=4)
image(facies.profile,xlab="Elevation (m)",ylab="Northing (m)",main="Facies distribution on river boundary",col = cm.colors(2),ylim=c(90,110),
      )
legend("bottomright")
dev.off()
