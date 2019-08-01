rm(list=ls())
library(RColorBrewer)
library(MASS)


ivari = 20
ix = 228

load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]


ireaz = 1
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
base = value

ireaz = 6
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
smooth = value

jpg.name = paste("download.figure/",ivari,"_",ix,".jpg",sep = "")

jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(base,smooth,
              ylab="",
              axe=FALSE,
              xlab="",              
              asp=1,xlim=c(0,20),ylim=c(0,20),
              colramp=colorRampPalette(c("white","purple")))
box()
mtext("Case with hourly hydraulic BC",1,1.5)
mtext("Case with 30d averaged hydraulic BC",2,1.5)
axis(1)
axis(2,las=2)
lines(c(-100,100),c(-100,100),col="black")
dev.off()

ivari = 2
ix = 228
load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]

ireaz = 1
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
base = value

ireaz = 6
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
smooth = value


ncol=9
my.cols = rev(brewer.pal(ncol,"RdYlBu"))
my.cols = brewer.pal(ncol,"BuGn")
plot.z = kde2d(log10(base[!is.na(base)]),log10(smooth[!is.na(smooth)]))


jpg.name = paste("download.figure/",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(log10(base),log10(smooth),
              ylab="",
              axe=FALSE,
              xlab="",              
              asp=1,
              xlim=c(-12,-6),ylim=c(-12,-6),              
##              colramp=colorRampPalette(c("white","black")))
                            colramp=colorRampPalette(my.cols))
##              colramp=function(x)rev(heat.colors(x)))              

contour(plot.z,drawlabels=FALSE,nlevels=ncol,col=my.cols,add=TRUE)


box()
mtext("Hourly hydraulic BC",1,1.5)
mtext("Weekly averaged hydraulic BC",2,2)
axis(1)
axis(2,las=2)
lines(c(-100,100),c(-100,100),col="black")

dev.off()


