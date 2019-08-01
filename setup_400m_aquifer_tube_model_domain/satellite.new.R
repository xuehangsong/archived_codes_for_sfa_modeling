rm(list=ls())
library(rgdal)
library(sp)
library(dismo)
library(GISTools)

labels = read.csv("data/aquifer_install_labeling.csv",stringsAsFactors=FALSE)
jon = read.csv('data/JonData.csv',stringsAsFactors=FALSE)
rownames(jon) = jon[,1]
jon = as.matrix(jon[,2:4])
jon = cbind(jon,NA)
jon[labels[,6],4] = labels[,3]
colnames(jon) = c(head(colnames(jon),-1),"Depth")

wgscoorbd = SpatialPoints(cbind(c(592000,596000),c(112000,120000)),
proj4string = CRS("+proj=lcc +lat_1=45.83333333333334 +lat_2=47.33333333333334 +lat_0=45.33333333333334
+lon_0=-120.5 +x_0=500000.0000000002 +y_0=0 +ellps=GRS80 +datum=NAD83 "))
utmcoorbd = spTransform(wgscoorbd,CRS("+proj=longlat +ellps=WGS84")) 

WgsToLonglat <- function(x) {
    wgscoord = SpatialPoints(x,proj4string = CRS("+proj=lcc +lat_1=45.83333333333334 +lat_2=47.33333333333334 +lat_0=45.33333333333334
                  +lon_0=-120.5 +x_0=500000.0000000002 +y_0=0 +ellps=GRS80 +datum=NAD83 "))
    longlatcoord = spTransform(wgscoord,CRS("+proj=longlat +ellps=WGS84"))
    return(longlatcoord)
}


xlim = c(594440,594530)
ylim = c(116250,116315)

utmcoorbd = WgsToLonglat(cbind(xlim,ylim))



mercator.x = seq(-13277360,-13277200,50)
mercator.x.y = 5840245
mercator.y = seq(5840245,5840370,40)
mercator.y.x = -13277275
longlat.x = Mercator(cbind(mercator.x,rep(mercator.x.y,length(mercator.x))),inverse=TRUE)[,1]
longlat.y = Mercator(cbind(rep(mercator.y.x,length(mercator.y)),mercator.y),inverse=TRUE)[,2]



##jpeg(paste("figures/satellite.jpg",sep=''),width=5.5,height=4,units='in',res=300,quality=100)
pdf(paste("figures/satellite.pdf",sep=''),width=5.5,height=4)
mymap = gmap(utmcoorbd,type="satellite",scale=2)
plot(mymap,interpolate=TRUE,
     )

indexpoint = which(jon[,"Depth"]<=75)
longlatjon = WgsToLonglat(cbind(jon[indexpoint,1],jon[indexpoint,2]))
mercatorjon = Mercator(longlatjon)
points(mercatorjon,col="green",pch=2,cex=1)

axis(1,mgp=c(-0.7,-0.8,-1.1),at=mercator.x,labels=format(longlat.x,digits=7),
     tck=-0.01,col="black",col.axis="black",cex.axis=1)
axis(2,mgp=c(-1,-0.9,-1),at=mercator.y,labels=format(longlat.y,digits=6),
     tck=-0.01,col="black",col.axis="black",cex.axis=1)


indexpoint = which(jon[,"Depth"]>75 & jon[,"Depth"]<125 )
longlatjon = WgsToLonglat(cbind(jon[indexpoint,1],jon[indexpoint,2]))
mercatorjon = Mercator(longlatjon)
points(mercatorjon,col="orange",pch=8,cex=1)

indexpoint = which(jon[,"Depth"]>=125)
longlatjon = WgsToLonglat(cbind(jon[indexpoint,1],jon[indexpoint,2]))
mercatorjon = Mercator(longlatjon)
points(mercatorjon,col="red",pch=16,cex=1)

north.arrow(xb=-13277345,yb=5840355,len=3,lab="N",col="cyan",tcol="cyan")
map.scale(xc=-13277345,yc=5840262,len=40,units="10 Meters",ndivs=4,
          tcol="cyan",scol="cyan")


legend(-13277270,5840280,c("Shallow (<0.75m)",
                           "Medium (0.75m~1.25m)",
                           "Deep (>1.25m)"),
       pch=c(2,8,16),col=c("green","orange","red"),cex=1,box.col="black",bg="white")
dev.off() 
