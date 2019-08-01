rm(list=ls())
library(gplots)
load("statistics/parameters.r")
load("statistics/boundary.r")

fname="2duniform"

args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=6
    ivari=2  ##20
    iyear=4
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}


x.ori = x
z.ori = z
x[c(which.min(x),which.max(x))] = c(0,143.2)
z[c(which.min(z),which.max(z))] = round(range(z))


years = c(365,365,366,365,365,365)
files = 0:(years[iyear]*8)+(sum(years[0:(iyear-1)])*8)
nfile = length(files)


level.river.interp = approx((level.river[[ireaz]][[1]]-start.time),level.river[[ireaz]][[2]],
                           files*3*3600)[[2]]
level.inland.interp = approx((level.inland[[ireaz]][[1]]-start.time),level.inland[[ireaz]][[2]],
                           files*3*3600)[[2]]


load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]


for (ifile in 1:nfile)    
{
    load(paste(ireaz,"/","h5data",files[ifile],".r",sep=""))

    print(files[ifile])
    water.mark = x[alluvium.river[which.min(abs(z[alluvium.river[,2]]-level.river.interp[ifile])),1]]
    jpg.name = paste("download.figure/",ireaz,"/",ivari,"_",files[ifile],".jpg",sep = "")
    jpeg(jpg.name,width = 6.6,height = 2,units = "in",res = 600, quality = 100)            
    par(mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))    
    filled.contour(x,z,log10(h5data[[ivari]]),
                   xlab = "",
                   ylab = "Elevation (m)",
                   zlim = c(-10,-6),
                   xlim = c(80,143.2),
                   ylim = c(98.5,110),
                   asp=1,
                   main = paste(ivari,"   ",format(output.time[files[ifile]+1],"%Y-%m-%d %H:%M")),
                   color = function(x)rev(heat.colors(x)),
##                   color = bluered,
                   plot.axes = {
                       axis(1)
                       axis(2,c(100,105,110))
                       mtext("Rotated east-west direction (m)",1,1.5)
                       lines(x[alluvium.river[,1]],z[alluvium.river[,2]],col="blue",lwd=2,lty=2)
                       lines(x[alluvium.hanford[,1]],z[alluvium.hanford[,2]],col="green",lwd=2,lty=2)                       
                       lines(x[hanford.ringold[,1]],z[hanford.ringold[,2]],col="black",lwd=2,lty=2)
                       lines(x[alluvium.ringold[,1]],z[alluvium.ringold[,2]],col="black",lwd=2,lty=2)
                       lines(c(103,103),c(98.5,11000),lwd=1)
                       lines(c(91,91),c(98.5,11000),lwd=1)
                       lines(c(115,115),c(98.5,11000),lwd=1)                                                                                            
                       
                       
                   }
                   )
    
    dev.off()

}
x = x.ori
z = z.ori
