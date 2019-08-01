rm(list=ls())
library(fields)
library(AtmRay) ##meshgrid
load("results/bath.data.r")




jon = read.csv('data/JonData.csv',stringsAsFactors=FALSE)
rownames(jon) = jon[,1]
jon = as.matrix(jon[,2:4])


data = read.table('data/proj.coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])




jpeg(paste("figures/jon.data.jpg",sep=''),width=8,height=10.5,units='in',res=300,quality=100)
par(mar=c(3,3.2,2.5,0))
filled.contour(unit.x,unit.y,unit.z,##levels=seq(0,3,0.5),
        xlim=c(west.x,east.x),
        ylim=c(south.y,north.y),
        zlim=c(89.5,105.5),
        color.palette=terrain.colors,
        asp=1,
        key.title=title("Ringold\nEL. (m)"),
        plot.axes = {
            
            axis(1,mgp=c(0,0.6,0));
            axis(2,mgp=c(0,0.8,0),las=0);

            mtext("Easting (m)",1,line=1.5)
            mtext("Northing (m)",2,line=1.8,las=0)         

         
         lines(c(ac[1,1],ac[2,1]),c(ac[1,2],ac[2,2]),col="lightblue",lwd=2)
         lines(c(ac[2,1],ac[3,1]),c(ac[2,2],ac[3,2]),col="lightblue",lwd=2)
         lines(c(ac[3,1],ac[4,1]),c(ac[3,2],ac[4,2]),col="lightblue",lwd=2)
         lines(c(ac[4,1],ac[1,1]),c(ac[4,2],ac[1,2]),col="lightblue",lwd=2)                  

         
         well.list = head(rownames(data),-14)

         
         for (iwell in well.list) {

             text(data[iwell,1],data[iwell,2]+20,iwell,col="red")
             points(data[iwell,1],data[iwell,2],col="red",pch=16)        

         }
         
         points(jon[,1],jon[,2],pch=16)

         lines(c(data["c1",1],data["c2",1]),c(data["c1",2],data["c2",2]),col="purple")
         lines(c(data["c2",1],data["c3",1]),c(data["c2",2],data["c3",2]),col="purple")         
         lines(c(data["c3",1],data["c4",1]),c(data["c3",2],data["c4",2]),col="purple")         
         lines(c(data["c4",1],data["c1",1]),c(data["c4",2],data["c1",2]),col="purple")         
         
         
         iwell="SWS-1"
         text(data[iwell,1],data[iwell,2]+15,iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=16)        


         iwell="RG3"
         text(data[iwell,1]+30,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=16)        


         iwell="T2"
         text(data[iwell,1]-30,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T3"
         text(data[iwell,1]-30,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T4"
         text(data[iwell,1]-30,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T5"
         text(data[iwell,1]-30,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        
         
        })
dev.off()




cells.proj = cells.model
cells.proj[,1] = td.origin[1]+cells.model[,1]*cos(angle)-cells.model[,2]*sin(angle)
cells.proj[,2] = td.origin[2]+cells.model[,1]*sin(angle)+cells.model[,2]*cos(angle)

cells.unit = interp.surface(list(x=unit.x,y=unit.y,z=unit.z),cells.proj)
cells.bath = interp.surface(list(x=bath.x,y=bath.y,z=bath.z),cells.proj)
cells.unit = array(cells.unit,c(nx,ny))
cells.bath = array(cells.bath,c(nx,ny))


jpeg(paste("figures/aquifer.model.jpg",sep=''),width=8,height=9,units='in',res=600,quality=100)
par(mar=c(3,3.2,2.5,0))
filled.contour(x,y,cells.bath-cells.unit,
               xlim=c(250,400),
               ylim=c(150,350),
               zlim=c(0,10),                              
               color.palette=cm.colors,
               asp=1,
               key.title=title("Hanford\nTHK (m)"),               

               plot.axes = {
                   axis(1,mgp=c(0,0.6,0));
                   axis(2,mgp=c(0,0.8,0),las=0);

                   mtext("Rotated easting (m)",1,line=1.5)
                   mtext("Rotated northing (m)",2,line=1.8,las=0)         
                   contour(x,y,cells.bath,levels=seq(104.2,108.9,4.7),drawlabels=FALSE,
                           col="black",add=T)
                   points(cells.model[,1],cells.model[,2],pch=16,cex=0.1)
                   lines(c(ac.model[1,1],ac.model[2,1]),c(ac.model[1,2],ac.model[2,2]),col="lightblue",lwd=2)
                   lines(c(ac.model[2,1],ac.model[3,1]),c(ac.model[2,2],ac.model[3,2]),col="lightblue",lwd=2)
                   lines(c(ac.model[3,1],ac.model[4,1]),c(ac.model[3,2],ac.model[4,2]),col="lightblue",lwd=2)
                   lines(c(ac.model[4,1],ac.model[1,1]),c(ac.model[4,2],ac.model[1,2]),col="lightblue",lwd=2)                  

                   points(jon.model[,1],jon.model[,2],pch=16)

                   
                   text(data.model["array_north",1]+10,data.model["array_north",2]+10,"north array")
                   text(data.model["array_south",1]+5,data.model["array_south",2]-10,"south array")
                   points(data.model["RG3",1],data.model["RG3",2],pch=16,col="green",cex=2)                                                         
                   points(data.model["T3",1],data.model["T3",2],pch=16,col="green",cex=1)                                                         
                   
                   lines(c(350,350),c(200,300))
                   lines(c(380,380),c(200,300))
                   lines(c(350,380),c(200,200))
                   lines(c(350,380),c(300,300))
                   text(320,320,"Watermark <-",col="black",cex=1)
                   text(322,310,"108.9/104.2 (m)",col="black",cex=1)                  


               }
)
dev.off()





jpeg(paste("figures/aquifer.model2.jpg",sep=''),width=10,height=10,units='in',res=600,quality=100)
par(mar=c(3,3.2,2.5,0))
filled.contour(x,y,cells.unit,
               xlim=c(250,400),
               ylim=c(150,350),
               zlim=c(89.5,105.5),
               color.palette=terrain.colors,
               asp=1,
               key.title=title("Ringold\nEL. (m)"),

               plot.axes = {
                   axis(1,mgp=c(0,0.6,0));
                   axis(2,mgp=c(0,0.8,0),las=0);

                   mtext("Rotated easting (m)",1,line=1.5)
                   mtext("Rotated northing (m)",2,line=1.8,las=0)         

                   contour(x,y,cells.bath,levels=seq(104.2,108.9,4.7),drawlabels=FALSE,
                           col="black",add=T)
                   points(cells.model[,1],cells.model[,2],pch=16,cex=0.1)
                   lines(c(ac.model[1,1],ac.model[2,1]),c(ac.model[1,2],ac.model[2,2]),col="lightblue",lwd=2)
                   lines(c(ac.model[2,1],ac.model[3,1]),c(ac.model[2,2],ac.model[3,2]),col="lightblue",lwd=2)
                   lines(c(ac.model[3,1],ac.model[4,1]),c(ac.model[3,2],ac.model[4,2]),col="lightblue",lwd=2)
                   lines(c(ac.model[4,1],ac.model[1,1]),c(ac.model[4,2],ac.model[1,2]),col="lightblue",lwd=2)                  

                   points(jon.model[,1],jon.model[,2],pch=16)
                   text(data.model["array_north",1]+10,data.model["array_north",2]+10,"north array")
                   text(data.model["array_south",1]+5,data.model["array_south",2]-10,"south array")

                   lines(c(350,350),c(200,300))
                   lines(c(380,380),c(200,300))
                   lines(c(350,380),c(200,200))
                   lines(c(350,380),c(300,300))
                   text(320,320,"Watermark <-",col="black",cex=1)
                   text(322,310,"108.9/104.2 (m)",col="black",cex=1)                  


               }
)
dev.off()


list=c("nx","ny","nz",
       "x","y","z",
       "dx","dy","dz",       
       "range.x","range.y","range.z",
       "cells.bath","cells.unit",
       "data.model","jon.model"
       )
save(list=list,file="results/aquifer.grids.r")

