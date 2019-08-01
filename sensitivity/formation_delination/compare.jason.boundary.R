rm(list=ls())
library("openxlsx")
load("results/general.r")
load("results/hanford.ringold.boundary.r")
write.table(cbind(x.new,z.new[hanford.ringold.boundary]),file='hanford.ringold.boundary.txt',col.names=FALSE,row.names=FALSE)

###facies.units = read.csv("data/slice1_Facies_units_1_1_0.5_short_adjustRiverbed.csv",stringsAsFactors=FALSE)

###proj.coord = cbind(facies.units[["meshx"]],facies.units[["meshy"]])

###angle = 15/180*pi
###x.origin = 594386.880635513
###y.origin = 116185.502270774

###facies.units[,1] = (proj.coord[,1]-x.origin)*cos(angle)+(proj.coord[,2]-y.origin)*sin(angle)
###facies.units[,2]= (proj.coord[,2]-y.origin)*cos(angle)-(proj.coord[,1]-x.origin)*sin(angle)    

## jpegfile="./figures/jason.boundary.jpg"
## jpeg(jpegfile,width=8,height=2.8,units='in',res=3000,quality=100)
## par(xpd=TRUE,mgp=c(2.1,1,0))
## image(facies.units[,"meshx"],facies.units[,"meshz"],facies.units[,"unitid"],
##       xlim=c(west.new,east.new),
##       ylim=range(bottom.new,top.new),
##       xlab='Rotated east-west direction (m)',
##       ylab='Elevation (m)',
##       breaks=c(-1.5,-0.5,0.5,1.5,4.5,5.5,12),
##       col=c("lightblue1","blue","lightgoldenrod","grey","green","red"),
##       cex.lab=0.8,
##       cex.axis=0.8,
##       asp=1.0,
##       )
## dev.off()



## load("results/hanford.ringold.boundary.r")
