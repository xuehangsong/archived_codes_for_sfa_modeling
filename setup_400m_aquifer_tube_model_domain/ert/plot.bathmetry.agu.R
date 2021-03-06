rm(list=ls())
library(fields)

west.x = 594300
east.x = 594750
south.y = 115200
north.y = 116800

west.x = 594300
east.x = 594650
south.y = 115520
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

                  
jpeg(paste("figures/bathymetry.jpg",sep=''),width=4.4,height=4.7,units='in',res=300,quality=100)
par(mar=c(3,3.2,2.5,0))
filled.contour(unit.x,unit.y,unit.z,##levels=seq(0,3,0.5),
        xlim=c(594320,594600),
        ylim=c(115980,north.y),
        color.palette=terrain.colors,
##        plot.title=title("Water Depth at River Level of 104.5 (m)"),
        asp=1,
        key.title=title("Ringold\nEL. (m)"),
        plot.axes = {
         axis(1,mgp=c(0,0.6,0));
         axis(2,mgp=c(0,0.8,0),las=0);
         mtext("Easting (m)",1,line=1.5)
         mtext("Northing (m)",2,line=1.8,las=0)         
         
         
         contour(bath.x,bath.y,bath.z,levels=seq(104.2,108.9,4.7),drawlabels=FALSE,
                col="black",add=T)
         par(new=T)         

         angle=15
         ## text(data["array_south",1]+50,data["array_south",2]+5,"South Array",col="red")
         ## points(data["array_south",1],data["array_south",2],col="red",pch=16,cex=1.5)
         ## lines(c(data["array_south",1],(data["array_south",1]+16*cos(angle/180*pi))),
         ##       c(data["array_south",2],(data["array_south",2]+16*sin(angle/180*pi))),
         ##       col="red",lwd=3)

         ## text(data["array_north",1]+50,data["array_north",2]+5,"North Array",col="red")
         ## points(data["array_north",1],data["array_north",2],col="red",pch=16,cex=1.5)
         ## lines(c(data["array_north",1],(data["array_north",1]+16*cos(angle/180*pi))),
         ##       c(data["array_north",2],(data["array_north",2]+16*sin(angle/180*pi))),
         ##       col="red",lwd=3)


         
         ##((data["array_south",1]-data["array_north",1])^2+(data["array_south",2]-data["array_north",2])^2)^0.5         
         ##((tube.start[,1]-data["array_north",1])^2+(tube.start[,2]-data["array_north",2])^2)^0.5         
         ##atan((data["array_south",2]-data["array_north",2])/(data["array_south",1]-data["array_north",1]))

         ##create a line along shore line starting from south array
         angle=15+90
##         angle = -70.04518+180
         iwell="array_south"
         start.point = data[iwell,]
         line.length=-300
         end.point = c(c(data[iwell,1]+line.length*cos(angle/180*pi)),
                        c(data[iwell,2]+line.length*sin(angle/180*pi)))
         ## lines(c(start.point[1],end.point[1]),c(start.point[2],end.point[2]),
         ##       col="cyan",lwd=3)

         line.length=300
         end.point = c(c(data[iwell,1]+line.length*cos(angle/180*pi)),
                        c(data[iwell,2]+line.length*sin(angle/180*pi)))
         ## lines(c(start.point[1],end.point[1]),c(start.point[2],end.point[2]),
         ##       col="cyan",lwd=3)
         
         


         required.depth = c(108.9,104.2)
         nsection = 10
         ndepth = length(required.depth)
         dl = seq(-8,50,6)
         tube.start = array(0,c(nsection,2))
         tube.start[,1] = start.point[1]+dl*cos(angle/180*pi)
         tube.start[,2] = start.point[2]+dl*sin(angle/180*pi)
         tube.points = array(0,c(nsection*ndepth,2))

         
##         points(tube.start)
         ipoint=1
         for (isection in 1:nsection)
         {
             dstep = seq(-100,100,0.01)
             line.points.x = tube.start[isection,1]+dstep*cos((angle-90)/180*pi)
             line.points.y = tube.start[isection,2]+dstep*sin((angle-90)/180*pi)
             line.points.z=interp.surface(bath.interp,cbind(line.points.x,line.points.y))
##             lines(line.points.x,line.points.y,)
            for (idepth in 1:ndepth)
             {
                temp= which.min(abs(line.points.z-required.depth[idepth]))
                tube.points[ipoint,] = c(line.points.x[temp],line.points.y[temp])
                ipoint=ipoint+1
             }
         }

##         points(tube.points,cex=0.8,pch=16)




         well.list = c("1-10A","SWS-1","4-7","3-18","1-16A","2-3")
         well.list = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","4-9","4-7","3-18")

         for (iwell in well.list) {

             text(data[iwell,1],data[iwell,2]+20,iwell,col="red")
             points(data[iwell,1],data[iwell,2],col="red",pch=16)        

         }

         iwell="SWS-1"
         text(data[iwell,1],data[iwell,2]+15,iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=16)        


         ## iwell="RG3"
         ## text(data[iwell,1]+30,data[iwell,2],iwell,col="blue")
         ## points(data[iwell,1],data[iwell,2],col="blue",pch=16)        



         ## text(goldman.south.gw[1]+40,goldman.south.gw[2]+15,"Goldman Site",col='purple')
         ## points(goldman.south.gw[1],goldman.south.gw[2],col="purple",pch='*',cex=3)
         ## points(goldman.south.nogw[1],goldman.south.nogw[2],col="purple",pch="*",cex=3)


         iwell="T2"
         text(data[iwell,1]+20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T3"
         text(data[iwell,1]+20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T4"
         text(data[iwell,1]+20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T5"
         text(data[iwell,1]+20,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         text(594520,116380,"-> Watermark",col="black",cex=1)
         text(594525,116355,"108.9/104.2 (m)",col="black",cex=1)                  

         lines(c(data["2-3",1],data["T3",1]),c(data["2-3",2],data["T3",2]),
               col="purple",lwd=3
               )
         text(594420,116200,"2D slice",col="purple",cex=1)
         
        })
dev.off()

colnames(tube.points)=c("Easting","Northing")
write.table(tube.points,file="tube_points.txt",row.names=FALSE)
save(tube.points,file="tubepoints.r")
