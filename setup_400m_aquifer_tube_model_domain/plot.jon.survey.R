rm(list=ls())
library(fields)
library(AtmRay) ##meshgrid

west.x = 594000
east.x = 594700
south.y = 115700
north.y = 116800

angle = 15/180*pi

###400*400
td.origin = c(594186,115943)

##T3 slice
t3.origin = c(594378.6,116216.3)

##T4 slice
t4.origin = c(594386.880635513,116185.502270774)


load("results/bath.data.r")
bath.data = bath.data[order(bath.data[,"bathy"],bath.data[,"bathx"]),]
bath.x=sort(as.numeric(names(table(bath.data[,"bathx"]))))
bath.y=sort(as.numeric(names(table(bath.data[,"bathy"]))))
bath.nx = length(bath.x)
bath.ny = length(bath.y)
bath.z = array(as.numeric(unlist(bath.data[,"bath"])),c(bath.nx,bath.ny))         

units.data = read.table("data/300A_EV_surfaces_012612.dat",header=F,skip=21,stringsAsFactors=FALSE)
data.names = c("meshx","meshy","u1","u2","u3","u4","u5","u6","u7","u8","u9","ringold.surface")
n.data.columns = length(data.names)
names(units.data) = data.names
original.data = units.data
units.data = NULL
data.range = original.data[["meshx"]]
for (i.units in 1:n.data.columns)
{
    units.data[[i.units]] = original.data[[i.units]][which(data.range>west.x-20 & data.range<east.x+20)]
}
names(units.data) = data.names
original.data = units.data
units.data = NULL
data.range = original.data[["meshy"]]
for (i.units in 1:n.data.columns)
{
    units.data[[i.units]] = original.data[[i.units]][which(data.range>south.y-20 & data.range<north.y+20)]
}
names(units.data) = data.names
unit.x = sort(as.numeric(names(table(units.data[["meshx"]]))))
unit.y = sort(as.numeric(names(table(units.data[["meshy"]]))))
unit.nx = length(unit.x)
unit.ny = length(unit.y)
unit.z=array(as.numeric(unlist(units.data["ringold.surface"])),c(unit.nx,unit.ny))
bath.interp = list(x=bath.x,y=bath.y,z=bath.z)


jon = read.csv('data/JonData.csv',stringsAsFactors=FALSE)
rownames(jon) = jon[,1]
jon = as.matrix(jon[,2:4])


data = read.table('data/proj.coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])



##aquifer 3D
x.origin = data["2-1",1]
y.origin = data["2-1",2]
length = seq(-150,100,0.1)
x1 = x.origin+length*cos(angle)
y1 = y.origin+length*sin(angle)


x.origin = t3.origin[1]
y.origin = t3.origin[2]
length = seq(-130,200,0.1)
x2 = x.origin+length*cos(angle+0.5*pi)
y2 = y.origin+length*sin(angle+0.5*pi)


##aquifer 3D
x.origin = data["1-2",1]
y.origin = data["1-2",2]
length = seq(250,400,0.1)
x3 = x.origin+length*cos(angle)
y3 = y.origin+length*sin(angle)

x.origin = max(x3)
y.origin = max(y3)
length = seq(-300,10,0.1)
x4 = x.origin+length*cos(angle+0.5*pi)
y4 = y.origin+length*sin(angle+0.5*pi)


## ac = array(NA,c(4,2))
## ##ac1
## temp1 = (replicate(length(x2),x1)-t(replicate(length(x1),x2)))^2+
##         (replicate(length(y2),y1)-t(replicate(length(y1),y2)))^2
## temp2 = which(temp1==min(temp1),arr.ind=TRUE)[1]
## ac[1,] = c(x1[temp2],y1[temp2])
## ##ac2
## temp1 = (replicate(length(x3),x2)-t(replicate(length(x2),x3)))^2+
##         (replicate(length(y3),y2)-t(replicate(length(y2),y3)))^2
## temp2 = which(temp1==min(temp1),arr.ind=TRUE)[1]
## ac[2,] = c(x2[temp2],y2[temp2])
## ##ac3
## temp1 = (replicate(length(x4),x3)-t(replicate(length(x3),x4)))^2+
##         (replicate(length(y4),y3)-t(replicate(length(y3),y4)))^2
## temp2 = which(temp1==min(temp1),arr.ind=TRUE)[1]
## ac[3,] = c(x3[temp2],y3[temp2])
## ##ac4
## temp1 = (replicate(length(x1),x4)-t(replicate(length(x4),x1)))^2+
##         (replicate(length(y1),y4)-t(replicate(length(y4),y1)))^2
## temp2 = which(temp1==min(temp1),arr.ind=TRUE)[1]
## ac[4,] = c(x4[temp2],y4[temp2])




ac = array(NA,c(4,2))
ac[3,1] = td.origin[1]+400*cos(angle)+350*cos(angle+0.5*pi)
ac[3,2] = td.origin[2]+400*sin(angle)+350*sin(angle+0.5*pi)
ac[2,1] = ac[3,1]-150*cos(angle)
ac[2,2] = ac[3,2]-150*sin(angle)
ac[1,1] = ac[2,1]-200*cos(angle+0.5*pi)
ac[1,2] = ac[2,2]-200*sin(angle+0.5*pi)
ac[4,1] = ac[3,1]-200*cos(angle+0.5*pi)
ac[4,2] = ac[3,2]-200*sin(angle+0.5*pi)



jpeg(paste("figures/jon.data.jpg",sep=''),width=8,height=10.5,units='in',res=300,quality=100)
par(mar=c(3,3.2,2.5,0))
filled.contour(unit.x,unit.y,unit.z,##levels=seq(0,3,0.5),
        xlim=c(west.x,east.x),
        ylim=c(south.y,north.y),
        zlim=c(89.5,105.5),
        color.palette=terrain.colors,
##        plot.title=title("Water Depth at River Level of 104.5 (m)"),
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
         
         iwell="array_north"
         text(data[iwell,1],data[iwell,2]+15,iwell,col="purple")
         points(data[iwell,1],data[iwell,2],col="purple",pch=16)        

         iwell="array_south"
         text(data[iwell,1],data[iwell,2]+15,iwell,col="purple")
         points(data[iwell,1],data[iwell,2],col="purple",pch=16)        

         
        })
dev.off()


ac.model = array(NA,c(4,2))
ac.model[,1] = (ac[,1]-td.origin[1])*cos(angle)+(ac[,2]-td.origin[2])*sin(angle)
ac.model[,2] = (ac[,2]-td.origin[2])*cos(angle)-(ac[,1]-td.origin[1])*sin(angle)    
jon.model = jon
jon.model[,1] = (jon[,1]-td.origin[1])*cos(angle)+(jon[,2]-td.origin[2])*sin(angle)
jon.model[,2] = (jon[,2]-td.origin[2])*cos(angle)-(jon[,1]-td.origin[1])*sin(angle)    
data.model = data
data.model[,1] = (data[,1]-td.origin[1])*cos(angle)+(data[,2]-td.origin[2])*sin(angle)
data.model[,2] = (data[,2]-td.origin[2])*cos(angle)-(data[,1]-td.origin[1])*sin(angle)    


dx = c(rev(round(0.5*1.0999674^seq(1,31),3)),rep(0.5,(380-350)/0.5),round(0.5*1.08925^seq(1,17),3))
dy = c(rev(round(1*1.0997085^seq(1,18),3)),rep(1,(300-200)/1),round(1*1.0997085^seq(1,18),3))
dz = c(rev(round(0.25*1.097^seq(1,11),3)),rep(0.25,(110-95)/0.25))
###dz = c(rev(round(0.25*1.089259^seq(1,17),3)),rep(0.25,(110-100)/0.25))

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = 250+cumsum(dx)-0.5*dx
y = 150+cumsum(dy)-0.5*dy
z = 90+cumsum(dz)-0.5*dz
cells.model = expand.grid(x,y)

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
##               zlim=c(89.5,105.5),
               zlim=c(0,10),                              
               color.palette=cm.colors,
               asp=1,
##               key.title=title("Ringold\nEL. (m)"),
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


                   ## points(jon.model["T3E2D10",1],jon.model["T3E2D10",2],pch=16,col="red")
                   ## points(jon.model["T3E2D40",1],jon.model["T3E2D40",2],pch=16,col="red")
                   ## points(jon.model["P3E3River",1],jon.model["P3E3River",2],pch=16,col="red")                                                         
                   ## points(jon.model["T3E3D10",1],jon.model["T3E3D10",2],pch=16,col="red")
                   ## points(jon.model["T3E3D40",1],jon.model["T3E3D40",2],pch=16,col="red")

                   
                   text(data.model["array_north",1]+10,data.model["array_north",2]+10,"north array")
                   text(data.model["array_south",1]+5,data.model["array_south",2]-10,"south array")
                   ## points(data.model["array_north",1],data.model["array_north",2],pch=16,col="green",cex=2)
                   ## points(data.model["array_south",1],data.model["array_south",2],pch=16,col="green",cex=2)

##                   points(data.model["RG3",1],data.model["RG3",2],pch=16,col="green",cex=2)                                                         
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
##               key.title=title("Hanford\nTHK (m)"),               

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


range.x = c(250,400)
range.y = c(150,350)
range.z = c(90,110)
## line1 = cbind(x,rep(150,nx))
## line2 = cbind(x,rep(350,nx))
## line3 = cbind(rep(250,ny),y)
list=c("nx","ny","nz",
       "x","y","z",
       "dx","dy","dz",       
       "range.x","range.y","range.z",
       "cells.bath","cells.unit",
       "data.model","jon.model"
       )
save(list=list,file="results/aquifer.grids.r")

