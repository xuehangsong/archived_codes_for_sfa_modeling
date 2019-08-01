rm(list=ls())
library(gplots)
load("statistics/parameters.r")
load("statistics/boundary.r")

fname="2duniform"

args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1

}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}

    ivari=18  ##20
x.ori = x
z.ori = z
x[c(which.min(x),which.max(x))] = c(0,143.2)
z[c(which.min(z),which.max(z))] = round(range(z))

## level.river.interp = approx((level.river[[ireaz]][[1]]-start.time),level.river[[ireaz]][[2]],
##                            files*3*3600)[[2]]
## level.inland.interp = approx((level.inland[[ireaz]][[1]]-start.time),level.inland[[ireaz]][[2]],
##                            files*3*3600)[[2]]


load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]


load(paste(ireaz,"/","h5data2920.r",sep=""))
base=h5data
load(paste(ireaz,"/","h5data17528.r",sep=""))

data = log10(h5data[[ivari]]-base[[ivari]])               
zlim = c(-6,-3)
##zlim = c(-3,2)
data[data < zlim[1]] = NA
data[data > zlim[2]] = NA
jpg.name = paste("download.figure/",ireaz,"/",ivari,".jpg",sep = "")
jpeg(jpg.name,width = 6.6,height = 1.55,units = "in",res = 600, quality = 100)            
par(mgp=c(2.,0.6,0),mar=c(2.5,3,1,1))    
filled.contour(x,z,data,
               xlab = "",
               ylab = "Elevation (m)",
               zlim = zlim,
               xlim = c(80,143.2),
               ylim = c(98.5,110),
               asp=1,
               color.palette = function(x)rev(heat.colors(x)),
               levels = pretty(c(-6,2),20),
##               color = function(x)rev(heat.colors(x)),
               plot.axes = {
                   axis(1)
                   axis(2,c(100,105,110))
                   mtext("Rotated east-west direction (m)",1,1.5)
                   lines(x[alluvium.river[,1]],z[alluvium.river[,2]],col="blue",lwd=2,lty=2)
                   lines(x[alluvium.hanford[,1]],z[alluvium.hanford[,2]],col="green",lwd=2,lty=2)                       
                   lines(x[hanford.ringold[,1]],z[hanford.ringold[,2]],col="black",lwd=2,lty=2)
                   lines(x[alluvium.ringold[,1]],z[alluvium.ringold[,2]],col="black",lwd=2,lty=2)
                   
               }
               )

dev.off()

x = x.ori
z = z.ori
