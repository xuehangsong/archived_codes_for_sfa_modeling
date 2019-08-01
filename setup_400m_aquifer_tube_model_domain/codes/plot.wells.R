rm(list=ls())
library(fields)
library(AtmRay) ##meshgrid

source("codes/ert_parameters.R")



jon = read.csv('data/JonData.csv',stringsAsFactors=FALSE)
rownames(jon) = jon[,1]
jon = as.matrix(jon[,2:4])


data = read.table('data/proj_coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])


west_x = 593500
east_x = 595000
south_y = 115500
north_y = 116600



jpeg(paste("figures/Wells_domain.jpg",sep=''),width=16,height=20,units='in',res=300,quality=100)
par(mar=c(3,3.2,2.5,1))
plot(NA,NA,
     xlim=c(west_x,east_x),
     ylim=c(south_y,north_y),
     asp=1,axes=FALSE,
     )
box()            

axis(1,mgp=c(0,0.6,0));
axis(2,mgp=c(0,0.8,0),las=0);


mtext("Easting (m)",1,line=1.5)
mtext("Northing (m)",2,line=1.8,las=0)         


lines(c(at_project[1,1],at_project[2,1]),c(at_project[1,2],at_project[2,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[2,1],at_project[3,1]),c(at_project[2,2],at_project[3,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[3,1],at_project[4,1]),c(at_project[3,2],at_project[4,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[4,1],at_project[1,1]),c(at_project[4,2],at_project[1,2]),col="cyan",lwd=2,lty=2)                  

lines(c(bd_project[1,1],bd_project[2,1]),c(bd_project[1,2],bd_project[2,2]),col="blue",lwd=2,lty=2)
lines(c(bd_project[2,1],bd_project[3,1]),c(bd_project[2,2],bd_project[3,2]),col="blue",lwd=2,lty=2)
lines(c(bd_project[3,1],bd_project[4,1]),c(bd_project[3,2],bd_project[4,2]),col="blue",lwd=2,lty=2)
lines(c(bd_project[4,1],bd_project[1,1]),c(bd_project[4,2],bd_project[1,2]),col="blue",lwd=2,lty=2)                  

lines(c(sd_project[1,1],sd_project[2,1]),c(sd_project[1,2],sd_project[2,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[2,1],sd_project[3,1]),c(sd_project[2,2],sd_project[3,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[3,1],sd_project[4,1]),c(sd_project[3,2],sd_project[4,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[4,1],sd_project[1,1]),c(sd_project[4,2],sd_project[1,2]),col="purple",lwd=2,lty=2)                  


for (iwell in head(rownames(data),-20)) {
    text(data[iwell,1],data[iwell,2]+20,iwell,col="red")    
    points(data[iwell,1],data[iwell,2],col="red",pch=16)        
}



well.list = c("1-1","1-16A","1-57","1-10A",
              "2-2","2-3",
              "2-1","3-18","3-9",
              "3-10","4-9","4-7")
for (iwell in well.list) {
    text(data[iwell,1],data[iwell,2]+40,iwell,col="red")
}

iwell="SWS-1"
text(data[iwell,1]+100,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        



well.list = c("T2","T3","T4","T5")
for (iwell in well.list) {
    text(data[iwell,1]+70,data[iwell,2],iwell,col="blue")
    points(data[iwell,1],data[iwell,2],col="blue",pch=17)        
}
    

points(jon[,1],jon[,2],pch=16,cex=0.5)

legend("topright",
       c("Wells","River Gauge","Piezos","Domain A","Domain B","Domain C"),
       lty=c(NA,NA,NA,2,2,2),
       pch=c(16,16,17,NA,NA,NA),
       col=c("red","blue","blue","purple","blue","cyan"),
       bty="n",
       )
dev.off()

stop()





west_x = 594300
east_x = 594570
south_y = 116100
north_y = 116500


jpeg(paste("figures/ERT_model_domain_small.jpg",sep=''),width=6,height=8,units='in',res=300,quality=100)
par(mar=c(3,3.2,2.5,1))
plot(NA,NA,
     xlim=c(west_x,east_x),
     ylim=c(south_y,north_y),
     asp=1,axes=FALSE,
     )
box()            

axis(1,mgp=c(0,0.6,0));
axis(2,mgp=c(0,0.8,0),las=0);


mtext("Easting (m)",1,line=1.5)
mtext("Northing (m)",2,line=1.8,las=0)         


lines(c(at_project[1,1],at_project[2,1]),c(at_project[1,2],at_project[2,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[2,1],at_project[3,1]),c(at_project[2,2],at_project[3,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[3,1],at_project[4,1]),c(at_project[3,2],at_project[4,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[4,1],at_project[1,1]),c(at_project[4,2],at_project[1,2]),col="cyan",lwd=2,lty=2)                  

lines(c(bd_project[1,1],bd_project[2,1]),c(bd_project[1,2],bd_project[2,2]),col="blue",lwd=2,lty=2)
lines(c(bd_project[2,1],bd_project[3,1]),c(bd_project[2,2],bd_project[3,2]),col="blue",lwd=2,lty=2)
lines(c(bd_project[3,1],bd_project[4,1]),c(bd_project[3,2],bd_project[4,2]),col="blue",lwd=2,lty=2)
lines(c(bd_project[4,1],bd_project[1,1]),c(bd_project[4,2],bd_project[1,2]),col="blue",lwd=2,lty=2)                  

lines(c(sd_project[1,1],sd_project[2,1]),c(sd_project[1,2],sd_project[2,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[2,1],sd_project[3,1]),c(sd_project[2,2],sd_project[3,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[3,1],sd_project[4,1]),c(sd_project[3,2],sd_project[4,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[4,1],sd_project[1,1]),c(sd_project[4,2],sd_project[1,2]),col="purple",lwd=2,lty=2)                  


for (iwell in head(rownames(data),-14)) {
#    text(data[iwell,1],data[iwell,2]+20,iwell,col="red")    
    points(data[iwell,1],data[iwell,2],col="red",pch=16)        
}



well.list = c("1-1","1-16A","1-57","1-10A",
              "2-2","2-3","2-32",
              "2-1","3-18","3-9",
              "3-10","4-9","4-7")
for (iwell in well.list) {
#    text(data[iwell,1],data[iwell,2]+10,iwell,col="red")
}

iwell="SWS-1"
#text(data[iwell,1]+10,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        



well.list = c("T2","T3","T4","T5")
for (iwell in well.list) {
    text(data[iwell,1]+10,data[iwell,2],iwell,col="blue")
    points(data[iwell,1],data[iwell,2],col="blue",pch=17)        
}


well.list = c("T3_Therms")
for (iwell in well.list) {
    points(data[iwell,1],data[iwell,2],col="red",pch=1)        
}



points(jon[,1],jon[,2],pch=16,cex=0.5)


legend("topright",
       c("Wells","River Gauge","Piezos","Domain A","Domain B","Domain C"),
       lty=c(NA,NA,NA,2,2,2),
       pch=c(16,16,17,NA,NA,NA),
       col=c("red","blue","blue","purple","blue","cyan"),
       bty="n",
       )
dev.off()




