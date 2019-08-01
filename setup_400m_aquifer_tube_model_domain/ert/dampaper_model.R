rm(list=ls())
library(rgdal)
library(sp)
library(dismo)
library(GISTools)

well.loc = read.table("data/proj.coord.dat",stringsAsFactors=FALSE)
rownames(well.loc) = well.loc[,3]
well.loc = well.loc[,1:2]


## wgscoorbd = SpatialPoints(cbind(c(592000,596000),c(112000,120000)),
## proj4string = CRS("+proj=lcc +lat_1=45.83333333333334 +lat_2=47.33333333333334 +lat_0=45.33333333333334
## +lon_0=-120.5 +x_0=500000.0000000002 +y_0=0 +ellps=GRS80 +datum=NAD83 "))
## utmcoorbd = spTransform(wgscoorbd,CRS("+proj=longlat +ellps=WGS84")) 

## wgsjon = SpatialPoints(cbind(c(592000,596000),c(112000,120000)),
## proj4string = CRS("+proj=lcc +lat_1=45.83333333333334 +lat_2=47.33333333333334 +lat_0=45.33333333333334
## +lon_0=-120.5 +x_0=500000.0000000002 +y_0=0 +ellps=GRS80 +datum=NAD83 "))


WgsToLonglat <- function(x) {
    wgscoord = SpatialPoints(x,proj4string = CRS("+proj=lcc +lat_1=45.83333333333334 +lat_2=47.33333333333334 +lat_0=45.33333333333334
                  +lon_0=-120.5 +x_0=500000.0000000002 +y_0=0 +ellps=GRS80 +datum=NAD83 "))
    longlatcoord = spTransform(wgscoord,CRS("+proj=longlat +ellps=WGS84"))
    return(longlatcoord)
}

###utmcoorbd = WgsToLonglat(cbind(c(594300,594500),c(116000,117000)))
###utmcoorbd = WgsToLonglat(cbind(c(594300,594600),c(116000,116500)))

xlim = c(594280,594510)
ylim = c(116140,116385)
utmcoorbd = WgsToLonglat(cbind(xlim,ylim))


jpeg(paste("figures/dampaper_satellite.jpg",sep=''),width=4.7,height=5,units='in',res=300,quality=100)
##pdf(paste("figures/dampaper_satellite.pdf",sep=''),width=4.7,height=5)##,units='in',res=300,quality=100)
##mymap = gmap(utmcoorbd,type="satellite",lonlat=TRUE,scale=2)
mymap = gmap(utmcoorbd,type="satellite",scale=2)
plot(mymap,interpolate=TRUE,mar=c(10,3,3,3)
     )
## axis(1,mgp=c(-1,-0.5,-1.7),col="red",col.axis="red",cex.axis=1)
## axis(2,mgp=c(-1,-2.5,-3.2),col="red",col.axis="red",cex.axis=1)

well.name = c("RG3","2-3")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
lines(mercatorwell[,1],mercatorwell[,2],
     col="red",lwd=3)



well.name = c("2-3")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="pink",pch=16,cex=1)
text(mercatorwell[,1],mercatorwell[,2]+20,
     c("W2-3"),
     col="pink",pch=2,cex=1)


## well.name = c("2-2","2-3","2-32")
## longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
## mercatorwell = Mercator(longlatwell)
## points(mercatorwell,col="pink",pch=16,cex=1)
## text(mercatorwell[,1],mercatorwell[,2]+20,
##      c("W2-2","W2-3","W2-32"),
##      col="pink",pch=2,cex=1)


## well.name = c("T2","T3","T4","T5")
## longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
## mercatorwell = Mercator(longlatwell)
## points(mercatorwell,col="green",pch=8,cex=1)
## text(mercatorwell[,1],mercatorwell[,2]+20,
##      c("P2","P3","P4","P5"),
##      col="green",cex=1)


well.name = c("RG3")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="cyan",pch=17,cex=1)
text(mercatorwell[,1]+30,mercatorwell[,2],
     c("RG3"),
     col="cyan",cex=1)




## legend(-13277540,5840460,c("Monitoring Wells",
##                            "In-river Piezometers",
##                            "River gauage",
##                            "2D model domain"),
##        pch=c(16,8,17,NA),lwd=c(NA,NA,NA,3),col=c("pink","green","cyan","red"),cex=1)



legend(-13277540,5840460,c("Monitoring Well",
                           "River gauge",
                           "2D model domain"),
       pch=c(16,17,NA),lwd=c(NA,NA,3),col=c("pink","cyan","red"),cex=1)
north.arrow(xb=-13277570,yb=5840440,len=5,lab="N",col="black",tcol="black")
map.scale(xc=-13277450,yc=5840120,len=200,units="50 Meters",ndivs=4,
          tcol="black",scol="black")

dev.off() 
