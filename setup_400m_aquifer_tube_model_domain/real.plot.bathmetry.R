rm(list=ls())
library(fields)

###594515.6       	116176          goldman_north

west.x = 594300
east.x = 594750
south.y = 115200
north.y = 116800

west.x = 594350-100
east.x = 594650+100
south.y = 116020
north.y = 116400+400

west.x = 594350
east.x = 594650
south.y = 116020
north.y = 116400


goldman.south.gw = c(594521.1,116152.5)
goldman.south.nogw = c(594515.6,116176)

goldman.north.gw = c(594357.8,117138.2)
goldman.north.nogw = c(594367.1,117047.2)


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


## temp.loc = expand.grid(unit.x,unit.y)
## unit.z=interp.surface(temp,temp.loc)-unit.z




data = read.table('data/proj.coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])

                  
##jpeg(paste("figures/bathymetry.jpg",sep=''),width=7,height=9,units='in',res=300,quality=100)
jpeg(paste("figures/bathymetry.jpg",sep=''),width=7,height=7.9,units='in',res=300,quality=100)
filled.contour(unit.x,unit.y,unit.z,##levels=seq(0,3,0.5),
        xlim=c(west.x,east.x),
        ylim=c(south.y,north.y),
        color.palette=terrain.colors,
##        plot.title=title("Water Depth at River Level of 104.5 (m)"),
        asp=1,
        key.title=title("Ringold\nEL. (m)"),
        plot.axes = {
         axis(1);
         axis(2);

         
         contour(bath.x,bath.y,bath.z,levels=seq(103.5,105.5,1),drawlabels=FALSE,
                col="black",add=T)
         par(new=T)         

         angle=15
         text(data["array_south",1]+50,data["array_south",2]+5,"South Array",col="red")
         points(data["array_south",1],data["array_south",2],col="red",pch=16,cex=1.5)
         lines(c(data["array_south",1],(data["array_south",1]+16*cos(angle/180*pi))),
               c(data["array_south",2],(data["array_south",2]+16*sin(angle/180*pi))),
               col="red",lwd=3)

         text(data["array_north",1]+50,data["array_north",2]+5,"North Array",col="red")
         points(data["array_north",1],data["array_north",2],col="red",pch=16,cex=1.5)
         lines(c(data["array_north",1],(data["array_north",1]+16*cos(angle/180*pi))),
               c(data["array_north",2],(data["array_north",2]+16*sin(angle/180*pi))),
               col="red",lwd=3)


         
         ##((data["array_south",1]-data["array_north",1])^2+(data["array_south",2]-data["array_north",2])^2)^0.5         
         ##((tube.start[,1]-data["array_north",1])^2+(tube.start[,2]-data["array_north",2])^2)^0.5         
         ##atan((data["array_south",2]-data["array_north",2])/(data["array_south",1]-data["array_north",1]))

         ##create a line along shore line starting from south array
         angle=15+90
##         angle = -70.04518+180
         iwell="goldman_south"
         start.point = data[iwell,]
         line.length=-300
         end.point = c(c(data[iwell,1]+line.length*cos(angle/180*pi)),
                        c(data[iwell,2]+line.length*sin(angle/180*pi)))



         well.list = c("1-10A","SWS-1","4-7","3-18","1-16A","2-3")
         well.list = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","4-9","4-7","3-18")

         for (iwell in well.list) {

             text(data[iwell,1],data[iwell,2]+10,iwell,col="red")
             points(data[iwell,1],data[iwell,2],col="red",pch=16)        

         }

         iwell="SWS-1"
         text(data[iwell,1],data[iwell,2]+15,iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=16)        


         iwell="RG3"
         text(data[iwell,1]+20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=16)        



         text(goldman.south.gw[1]+40,goldman.south.gw[2]+15,"Goldman Site",col='purple')
         points(goldman.south.gw[1],goldman.south.gw[2],col="purple",pch='*',cex=3)
         points(goldman.south.nogw[1],goldman.south.nogw[2],col="purple",pch="*",cex=3)

         text(goldman.north.gw[1]+40,goldman.north.gw[2]+15,"Goldman Site",col='purple')
         points(goldman.north.gw[1],goldman.north.gw[2],col="purple",pch='*',cex=3)
         points(goldman.north.nogw[1],goldman.north.nogw[2],col="purple",pch="*",cex=3)
         

         iwell="T2"
         text(data[iwell,1]-20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T3"
         text(data[iwell,1]-20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T4"
         text(data[iwell,1]-20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T5"
         text(data[iwell,1]-20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         text(594540,116396,"River bed 105.5/104.5/103.5 (m)",col="black",cex=1)


         realpoints = read.table("data/realcoords.csv",sep=',',skip=1)
         points(realpoints[,3],realpoints[,2],pch=16,cex=0.5)
         thermindex = grep("therm",realpoints[,1])
         points(realpoints[thermindex,3],realpoints[thermindex,2],pch=1,cex=2,col="red")
         
         
        })
dev.off()

## colnames(tube.points)=c("Easting","Northing")
## write.table(tube.points,file="tube_points.txt",row.names=FALSE)
## save(tube.points,file="tubepoints.r")
