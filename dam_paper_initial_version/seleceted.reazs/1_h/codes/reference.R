rm(list=ls())
library(gplots)
load("statistics/parameters.r")
load("statistics/boundary.r")


x.ori = x
z.ori = z
x[c(which.min(x),which.max(x))] = c(0,143.2)
z[c(which.min(z),which.max(z))] = round(range(z))
jpg.name = paste("download.figure/referendce.jpg",sep = "")
jpeg(jpg.name,width = 9.7,height = 2.425,units = "in",res = 600, quality = 100)            
par(mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
plot(x[alluvium.river[,1]],z[alluvium.river[,2]],col="white",type="l",lty=2,
     asp=1,
     xlim = c(5.3,138),
     ylim = c(92,108),
     xlab=NA,
     ylab = "Elevation (m)",     
     axe=FALSE,     
     )
box()
mtext('Rotated east-west direction (m)',1,line=1.5)
##mtext('Elevation (m)',2,line=1.5)
axis(1)
axis(2,las=2)
rect(80,98.5,143.2,110,col="mistyrose",border=NA)
lines(x[alluvium.river[,1]],z[alluvium.river[,2]],col="blue",type="l",lwd=2,lty=2)
lines(x[hanford.river[,1]],z[hanford.river[,2]],col="blue",type="l",lwd=2,lty=2)
lines(x[alluvium.hanford[,1]],z[alluvium.hanford[,2]],col="green",lwd=2,lty=2)                       
lines(x[hanford.ringold[,1]],z[hanford.ringold[,2]],col="black",lwd=2,lty=2)
lines(x[alluvium.ringold[,1]],z[alluvium.ringold[,2]],col="black",lwd=2,lty=2)
lines(c(103,103),c(98.5,11000),lwd=1)                       
text(40,94,"Ringold formation")
text(65,103,"Hanford formation")
text(132,106,"River")
text(113,103,"Alluvium")


dev.off()
x = x.ori
z = z.ori

## filled.contour(x,z,h5data[[ivari]],
##                xlab = "",
##                ylab = "Elevation (m)",
##                zlim = c(0,25),
##                ylim = c(98.5,110),
##                ##                   zlim = c(0,25),
               
##                xlim = c(80,143.2),
##                asp=1,
##                ##                  main = paste(ivari,"   ",format(output.time[files[ifile]+1],"%Y-%m-%d %H:%M")),
##                ##                   color = function(x)rev(heat.colors(x)),
##                color = bluered,
##                plot.axes = {
##                    axis(1)
##                    axis(2,c(100,105,110))
##                    mtext("Rotated east-west direction (m)",1,1.5)                       
##                    lines(x[alluvium.river[,1]],z[alluvium.river[,2]],col="blue",lwd=2,lty=2)
##                    lines(x[alluvium.hanford[,1]],z[alluvium.hanford[,2]],col="green",lwd=2,lty=2)                       
##                    lines(x[hanford.ringold[,1]],z[hanford.ringold[,2]],col="black",lwd=2,lty=2)
##                    lines(x[alluvium.ringold[,1]],z[alluvium.ringold[,2]],col="black",lwd=2,lty=2)
##                    lines(c(103,103),c(90,11000))                       
##                }
##                )

## dev.off()
