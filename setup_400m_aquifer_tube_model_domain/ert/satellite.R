rm(list=ls())
library(rgdal)
library(sp)
library(dismo)

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

## wgsjon = SpatialPoints(cbind(c(592000,596000),c(112000,120000)),
## proj4string = CRS("+proj=lcc +lat_1=45.83333333333334 +lat_2=47.33333333333334 +lat_0=45.33333333333334
## +lon_0=-120.5 +x_0=500000.0000000002 +y_0=0 +ellps=GRS80 +datum=NAD83 "))


WgsToUtm <- function(x) {
    wgscoord = SpatialPoints(x,proj4string = CRS("+proj=lcc +lat_1=45.83333333333334 +lat_2=47.33333333333334 +lat_0=45.33333333333334
                  +lon_0=-120.5 +x_0=500000.0000000002 +y_0=0 +ellps=GRS80 +datum=NAD83 "))
    utmcoord = spTransform(wgscoord,CRS("+proj=longlat +ellps=WGS84")) 
    return(utmcoord)
}
#utmcoorbd = WgsToUtm(cbind(c(594300,594500),c(116000,117000)))
#utmcoorbd = WgsToUtm(cbind(c(594300,594600),c(116000,116500)))

xlim = c(594440,594530)
ylim = c(116180,116315)

utmcoorbd = WgsToUtm(cbind(xlim,ylim))


jpeg(paste("figures/satellite.jpg",sep=''),width=7,height=9,units='in',res=300,quality=100)
mymap = gmap(utmcoorbd,type="satellite",lonlat=TRUE,scale=2)
plot(mymap,interpolae=TRUE,
     )
axis(1,mgp=c(-1,-0.5,-1.7),col="red",col.axis="red",cex.axis=1.5)
axis(2,mgp=c(-1,-2.5,-3.2),col="red",col.axis="red",cex.axis=1.5)

## mtext("Easting",1,line=-1.4,col="black",cex=1.5)
## mtext("Northing",2,line=-2.2,col="black",cex=1.5)

indexpoint = which(jon[,"Depth"]<=75)
utmjon = WgsToUtm(cbind(jon[indexpoint,1],jon[indexpoint,2]))
points(utmjon,col="green",pch=2,cex=1)



indexpoint = which(jon[,"Depth"]>75 & jon[,"Depth"]<125 )
utmjon = WgsToUtm(cbind(jon[indexpoint,1],jon[indexpoint,2]))
points(utmjon,col="orange",pch=8,cex=1)

indexpoint = which(jon[,"Depth"]>=125)
utmjon = WgsToUtm(cbind(jon[indexpoint,1],jon[indexpoint,2]))
points(utmjon,col="red",pch=16,cex=1)

legend(-119.2715,46.3737,c("Shallow","Medium","Deep"),
       pch=c(2,8,16),col=c("green","orange","red"),cex=1.5)
dev.off() 
