rm(list=ls())


ireaz = 1
temp = read.table(paste(ireaz,"/DatumH_Inland_2010_2015_average_3.txt",sep=''))
level.inland = temp[[4]]
temp = read.table(paste(ireaz,"/DatumH_River_2010_2015_average_3.txt",sep=''))
level.river = temp[[4]]


level.inland  = level.inland[-(1:(365*24))]
level.inland = level.inland[seq(1,length(level.inland),3)]
level.inland = t(replicate(241-174+1,level.inland))

level.river  = level.river[-(1:(365*24))]
level.river =level.river[ seq(1,length(level.river),3)]
level.river = t(replicate(241-174+1,level.river))








ivari = 2
ix = 228

load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]

ireaz = 1
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]
base = value[174:241,1:(dim(value)[2]-1)]

ireaz = 6
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]
smooth = value[174:241,1:(dim(value)[2]-1)]


jpg.name = paste("highlight.data/stage",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(level.river,log10(base)-log10(smooth),
              ylab="",
              xlab="",
              axe=FALSE,)
              ylim=c(8,16),##ylim=c(-10,-6),              
              colramp=colorRampPalette(c("white","blue")))
mtext("River stage (m)",1,1.5)
mtext("Diff. of reaction rates (log10, mol/m3-S)",2,1.5)


axis(1)
axis(2,las=2)

lines(c(-100,100),c(-100,100),col="black")
dev.off()


jpg.name = paste("highlight.data/gradient",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(level.river-level.inland,log10(base)-log10(smooth),
              ylab="",
              xlab="",
              axe=FALSE,
              ylim=c(8,16),##ylim=c(-10,-6),
              colramp=colorRampPalette(c("white","blue")))
mtext("Diff. of river/inland water level (m)",1,1.5)
mtext("Diff. of reaction rates (log,mol/m3-S)",2,1.5)

axis(1)
axis(2,las=2)

dev.off()






ivari = 19
ix = 228

load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]

ireaz = 1
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]
base = value[,1:(dim(value)[2]-1)]

ireaz = 6
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]
smooth = value[,1:(dim(value)[2]-1)]


jpg.name = paste("highlight.data/stage",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(level.river,log10(base)-log10(smooth),
              ylab="",
              xlab="",
              axe=FALSE,
              ylim=c(8,16),##ylim=c(-10,-6),              
              colramp=colorRampPalette(c("white","blue")))
mtext("River stage (m)",1,1.5)
mtext("Diff. of reaction rates (log10, mol/m3-S)",2,1.5)


axis(1)
axis(2,las=2)

lines(c(-100,100),c(-100,100),col="black")
dev.off()


jpg.name = paste("highlight.data/gradient",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(level.river-level.inland,log10(base)-log10(smooth),
              ylab="",
              xlab="",
              axe=FALSE,
              ylim=c(8,16),##ylim=c(-10,-6),
              colramp=colorRampPalette(c("white","blue")))
mtext("Diff. of river/inland water level (m)",1,1.5)
mtext("Diff. of reaction rates (log,mol/m3-S)",2,1.5)

axis(1)
axis(2,las=2)

dev.off()










ivari = 17
ix = 228

load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]

ireaz = 1
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]
base = value[,1:(dim(value)[2]-1)]

base.17 = base

ireaz = 6
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]
smooth = value[,1:(dim(value)[2]-1)]
smooth.17 = smooth


jpg.name = paste("highlight.data/stage",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    

smoothScatter(level.river,log10(base)-log10(smooth),
              ylab="",
              xlab="",
              axe=FALSE,
              ylim=c(8,16),##ylim=c(-10,-6),              
              colramp=colorRampPalette(c("white","blue")))
mtext("River stage (m)",1,1.5)
mtext("Diff. of reaction rates (log10, mol/m3-S)",2,1.5)


axis(1)
axis(2,las=2)

lines(c(-100,100),c(-100,100),col="black")
dev.off()




## jpg.name = paste("highlight.data/gradient",ivari,"_",ix,".jpg",sep = "")
## jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
## par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    
## smoothScatter(level.river-level.inland,log10(base*1/2)-log10(smooth*1/2),
##               ylab="",
##               xlab="",
##               axe=FALSE,
##               ylim=c(8,16),##ylim=c(-10,-6),
##               colramp=colorRampPalette(c("white","blue")))
## mtext("Diff. of river/inland water level (m)",1,1.5)
## mtext("Diff. of reaction rates (log,mol/m3-S)",2,1.5)

## axis(1)
## axis(2,las=2)

## dev.off()





















ivari = 15
ix = 228

load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]

ireaz = 1
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]
base = value[,1:(dim(value)[2]-1)]

ireaz = 6
load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]
smooth = value[,1:(dim(value)[2]-1)]


jpg.name = paste("highlight.data/stage",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
##smoothScatter(level.river,log10(base*3/4+base.17/2)-log10(smooth*3/4+smooth.17/2),
smoothScatter(level.river,log10(base*3/4)-log10(smooth*3/4) ,             
              ylab="",
              xlab="",
              axe=FALSE,
              ylim=c(8,16),##ylim=c(-10,-6),              
              colramp=colorRampPalette(c("white","blue")))
mtext("River stage (m)",1,1.5)
mtext("Diff. of reaction rates (log10, mol/m3-S)",2,1.5)


axis(1)
axis(2,las=2)

lines(c(-100,100),c(-100,100),col="black")
dev.off()

stop()
jpg.name = paste("highlight.data/gradient",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    
smoothScatter(level.river-level.inland,log10(base*1/2)-log10(smooth*1/2),
              ylab="",
              xlab="",
              axe=FALSE,
              ylim=c(8,16),##ylim=c(-10,-6),
              colramp=colorRampPalette(c("white","blue")))
mtext("Diff. of river/inland water level (m)",1,1.5)
mtext("Diff. of reaction rates (log,mol/m3-S)",2,1.5)

axis(1)
axis(2,las=2)

dev.off()


