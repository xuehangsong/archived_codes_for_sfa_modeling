rm(list=ls())
library(rgdal)
library(sp)
library(dismo)
library(GISTools)

source("codes/xuehang_R_functions.R")
well.loc = read.table("data/proj_coord.dat",stringsAsFactors=FALSE)
rownames(well.loc) = well.loc[,3]
well.loc = well.loc[,1:2]

xlim = c(594250,594750)
ylim = c(116000,117100)
utmcoorbd = WgsToLonglat(cbind(xlim,ylim))


jpeg(paste("figures/dampaper_satellite.jpg",sep=''),width=4,height=9.6,units='in',res=300,quality=100)
mymap = gmap(utmcoorbd,type="satellite",scale=2)
plot(mymap,interpolate=TRUE,mar=c(10,3,3,3)
     )
well.name = c("2-3")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="pink",pch=16,cex=1)
text(mercatorwell[,1]-150,mercatorwell[,2],
     c("W2-3"),
     col="pink",pch=2,cex=1)


well.name = c("iButton_A1",
              "iButton_B2",
              "iButton_C3",
              "iButton_D4",
              "iButton_E5"
              )
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="purple",pch=16,cex=2)
## text(mercatorwell[,1]+100,mercatorwell[,2]-10,
##      well.name,col="purple")


well.name = c("T3Piezo_UD",
              "T3Piezo_US",
              "T3Piezo_LD",                                          
              "T3Piezo_LS"
              )
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="orange",pch=16,cex=1)



well.name = c("Thermistor")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="red",pch=16,cex=1)

well.name = c("RG3","SWS-1")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="cyan",pch=16,cex=1)
text(mercatorwell[,1]+150,mercatorwell[,2],
     well.name,col="cyan")

legend(-13277250,5842200,c("Well 2-3",
                           "River gauge",
                           "ibutton",                           
                           "Thermistor",
                           "Piezometers"),
       pch=c(16,16,16,16,16),
       col=c("pink","cyan","purple","red","orange"),
       cex=c(1,1,1,1,1))
north.arrow(xb=-13277570,yb=5840440,len=5,lab="N",col="black",tcol="black")
map.scale(xc=-13277650,yc=5839500,len=400,units="100 Meters",ndivs=4,
          tcol="black",scol="black")
#legend(-13277300,5842200,c("Well 2-3",
dev.off() 




xlim = c(594450,594500)
ylim = c(116230,116280)
utmcoorbd = WgsToLonglat(cbind(xlim,ylim))

jpeg(paste("figures/thermistor_satellite_fine.jpg",sep=''),width=5,height=5,units='in',res=300,quality=100)
mymap = gmap(utmcoorbd,type="satellite",scale=2)
plot(mymap,interpolate=TRUE,mar=c(10,3,3,3)
     )
well.name = c("2-3")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="pink",pch=16,cex=1)
text(mercatorwell[,1]-150,mercatorwell[,2],
     c("W2-3"),
     col="pink",pch=2,cex=1)


well.name = c("iButton_A1",
              "iButton_B2",
              "iButton_C3",
              "iButton_D4",
              "iButton_E5"
              )
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="purple",pch=16,cex=2)
## text(mercatorwell[,1]+100,mercatorwell[,2]-10,
##      well.name,col="purple")


well.name = c("T3Piezo_UD",
              "T3Piezo_US",
              "T3Piezo_LD",                                          
              "T3Piezo_LS"
              )
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="orange",pch=16,cex=1)


well.name = c("Thermistor")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="red",pch=16,cex=1)

well.name = c("RG3","SWS-1")
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="cyan",pch=16,cex=1)
text(mercatorwell[,1]+150,mercatorwell[,2],
     well.name,col="cyan")

well.name = "T3Piezo_LS"
longlatwell = WgsToLonglat(cbind(well.loc[well.name,1],well.loc[well.name,2]))
mercatorwell = Mercator(longlatwell)
points(mercatorwell,col="orange",pch=1,cex=2)



legend(-13277350,5840500,c("Well 2-3",
                           "River gauge",
                           "ibutton",                           
                           "Thermistor",
                           "Piezometers"),
       pch=c(16,16,16,16,16),
       col=c("pink","cyan","purple","red","orange"),
       cex=c(1,1,1,1,1))
north.arrow(xb=-13277570,yb=5840440,len=5,lab="N",col="black",tcol="black")
map.scale(xc=-13277350,yc=5840500,len=400,units="100 Meters",ndivs=4,
          tcol="black",scol="black")
dev.off() 
