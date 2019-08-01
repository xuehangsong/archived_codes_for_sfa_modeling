rm(list=ls())


ivari = 20
ix = 178

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

jpg.name = paste("highlight.data/",ivari,"_",ix,".jpg",sep = "")

jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    
smoothScatter(base,smooth,
              ylab="",
              axe=FALSE,
              xlab="",              
              asp=1,xlim=c(5,20),ylim=c(5,20),
              colramp=colorRampPalette(c("white","purple")))
box()
mtext("Case with hourly hydraulic BC",1,1.5)
mtext("Case with smoothed hydraulic BC",2,1.5)
axis(1)
axis(2,las=2)
lines(c(-100,100),c(-100,100),col="black")
dev.off()


ivari = 2

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

jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    

jpg.name = paste("highlight.data/",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    
###smoothScatter(base[1:10000],smooth[1:10000],
smoothScatter(log10(base),log10(smooth),nbin=1000,
              ylab="",
              xlab="",
              axe=FALSE,
              asp=1,xlim=c(-10,-6),ylim=c(-10,-6),
              colramp=colorRampPalette(c("white","purple")))
mtext("Case with hourly hydraulic BC",1,1.5)
mtext("Case with smoothed hydraulic BC",2,1.5)

axis(1)
axis(2,las=2)

lines(c(-100,100),c(-100,100),col="black")
dev.off()




ivari = 19

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

jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    

jpg.name = paste("highlight.data/",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    
###smoothScatter(base[1:10000],smooth[1:10000],
smoothScatter(log10(base),log10(smooth),nbin=1000,
              ylab="",
              xlab="",
              axe=FALSE,
              asp=1,xlim=c(-10,-6),ylim=c(-10,-6),
              colramp=colorRampPalette(c("white","purple")))
mtext("Case with hourly hydraulic BC",1,1.5)
mtext("Case with smoothed hydraulic BC",2,1.5)

axis(1)
axis(2,las=2)

lines(c(-100,100),c(-100,100),col="black")
dev.off()










ivari = 17

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

jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    

jpg.name = paste("highlight.data/",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    
###smoothScatter(base[1:10000],smooth[1:10000],
smoothScatter(log10(base*1/2),log10(smooth*1/2),nbin=1000,
              ylab="",
              xlab="",
              axe=FALSE,
              asp=1,xlim=c(-10,-6),ylim=c(-10,-6),
              colramp=colorRampPalette(c("white","purple")))
mtext("Case with hourly hydraulic BC",1,1.5)
mtext("Case with smoothed hydraulic BC",2,1.5)

axis(1)
axis(2,las=2)

lines(c(-100,100),c(-100,100),col="black")
dev.off()






ivari = 15

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

jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    

jpg.name = paste("highlight.data/",ivari,"_",ix,".jpg",sep = "")
jpeg(jpg.name,width = 3.6,height = 3.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
par(mgp=c(2,0.6,0),mar=c(4.1,4.1,2.1,2.1))    
###smoothScatter(base[1:10000],smooth[1:10000],
smoothScatter(log10(base*3/4),log10(smooth*3/4),nbin=1000,
              ylab="",
              xlab="",
              axe=FALSE,
              asp=1,xlim=c(-10,-6),ylim=c(-10,-6),
              colramp=colorRampPalette(c("white","purple")))
mtext("Case with hourly hydraulic BC",1,1.5)
mtext("Case with smoothed hydraulic BC",2,1.5)

axis(1)
axis(2,las=2)

lines(c(-100,100),c(-100,100),col="black")
dev.off()





stop()


ivari = 5

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


jpg.name = paste("highlight.data/",ivari,"_",ix,".jpg",sep = "")
par(mgp=c(2.,0.,0),mar=c(4.1,4.1,2.1,2.1))
jpeg(jpg.name,width = 4,height = 4.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
smoothScatter(base,smooth,
              ylab="",
              xlab="",              
##              asp=1,xlim=c(0,10),ylim=c(0,10),
              colramp=colorRampPalette(c("white","blue")))
mtext("DOC consumption rate [mol_m^3-sec]",1,2)
mtext("with hourly hydraulic boundary",1,3)
mtext("DOC consumption rate [mol_m^3-sec]",2,3)
mtext("with smoothed hydraulic boundary",2,2)
axis(1)
axis(2)

lines(c(-100,100),c(-100,100))
dev.off()





ivari = 17.

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


jpg.name = paste("highlight.data/",ivari,"_",ix,".jpg",sep = "")
par(mgp=c(2.,0.,0),mar=c(4.1,4.1,2.1,2.1))
jpeg(jpg.name,width = 4,height = 4.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
smoothScatter(base,smooth,
              ylab="",
              xlab="",              
              asp=1,xlim=c(0,1.5e-7),ylim=c(0,1.5e-7),
              colramp=colorRampPalette(c("white","blue")))
mtext("NO3- consumption rate [mol_m^3-sec]",1,2)
mtext("with hourly hydraulic boundary",1,3)
mtext("NO3- consumption rate [mol_m^3-sec]",2,3)
mtext("with smoothed hydraulic boundary",2,2)
axis(1)
axis(2)

lines(c(-100,100),c(-100,100))
dev.off()







ivari = 16.

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


jpg.name = paste("highlight.data/",ivari,"_",ix,".jpg",sep = "")
par(mgp=c(2.,0.,0),mar=c(4.1,4.1,2.1,2.1))
jpeg(jpg.name,width = 4,height = 4.6,units = "in",res = 300, quality = 100)
###smoothScatter(base[1:10000],smooth[1:10000],
smoothScatter(base,smooth,
              ylab="",
              xlab="",              
              asp=1,xlim=c(0,2.5),ylim=c(0,2.5),
              colramp=colorRampPalette(c("white","blue")))
mtext("NO3- cumulvative consumption rate [mol_m^3-sec]",1,2)
mtext("with hourly hydraulic boundary",1,3)
mtext("NO3- cumulvative consumption rate [mol_m^3-sec]",2,3) #
mtext("with smoothed hydraulic boundary",2,2)
axis(1)
axis(2)

lines(c(-100,100),c(-100,100))
dev.off()

