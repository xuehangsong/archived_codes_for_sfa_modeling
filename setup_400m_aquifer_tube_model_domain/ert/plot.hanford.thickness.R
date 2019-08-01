rm(list=ls())
library(fields)

west.x = 594300
east.x = 594750
south.y = 115200
north.y = 116800

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
    units.data[[i.units]] = original.data[[i.units]][which(data.range>west.x-20-50 & data.range<east.x+20+50)]
}
names(units.data) = data.names
original.data = units.data
units.data = NULL
data.range = original.data[["meshy"]]
for (i.units in 1:n.data.columns)
{
    units.data[[i.units]] = original.data[[i.units]][which(data.range>south.y-20-200 & data.range<north.y+20+200)]
}
names(units.data) = data.names
unit.x = sort(as.numeric(names(table(units.data[["meshx"]]))))
unit.y = sort(as.numeric(names(table(units.data[["meshy"]]))))
unit.nx = length(unit.x)
unit.ny = length(unit.y)
unit.z=array(as.numeric(unlist(units.data["ringold.surface"])),c(unit.nx,unit.ny))
bath.interp = list(x=bath.x,y=bath.y,z=bath.z)

unit.u1=array(as.numeric(unlist(units.data["u1"])),c(unit.nx,unit.ny))
##unit.z = interp.surface(bath.interp,expand.grid(unit.x,unit.y))-unit.z
unit.z  = unit.u1 -unit.z



data = read.table('data/proj.coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])

                  
jpeg(paste("figures/bathymetry.jpg",sep=''),width=6.8,height=10,units='in',res=300,quality=100)
filled.contour(unit.x,unit.y,unit.z,##levels=seq(0,3,0.5),
        ## xlim=c(west.x,east.x),
        ## ylim=c(south.y,north.y),
        color.palette=terrain.colors,
##        plot.title=title("Water Depth at River Level of 104.5 (m)"),
        asp=1,
##        key.title=title("Ringold\nEL. (m)"),
        key.title=title("Hanford\nTHK (m)"),        
        plot.axes = {
         axis(1);
         axis(2);

         
         contour(bath.x,bath.y,bath.z,levels=seq(103.5,107.5,1),drawlabels=FALSE,
                col="black",add=T)
         contour(bath.x,bath.y,bath.z,levels=104.5,drawlabels=FALSE,
                col="black",add=T,lwd=3)
         
         par(new=T)         

         angle=15
         text(data["array_south",1]+70,data["array_south",2]+5,"South Array",col="red")
         points(data["array_south",1],data["array_south",2],col="red",pch=16,cex=1.5)
         lines(c(data["array_south",1],(data["array_south",1]+16*cos(angle/180*pi))),
               c(data["array_south",2],(data["array_south",2]+16*sin(angle/180*pi))),
               col="red",lwd=3)

         text(data["array_north",1]+70,data["array_north",2]+5,"North Array",col="red")
         points(data["array_north",1],data["array_north",2],col="red",pch=16,cex=1.5)
         lines(c(data["array_north",1],(data["array_north",1]+16*cos(angle/180*pi))),
               c(data["array_north",2],(data["array_north",2]+16*sin(angle/180*pi))),
               col="red",lwd=3)


         
         





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
         text(data[iwell,1]+30,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=16)        



         text(goldman.south.gw[1]+60,goldman.south.gw[2]+15,"Goldman Site",col='purple')
         points(goldman.south.gw[1],goldman.south.gw[2],col="purple",pch='*',cex=3)
         points(goldman.south.nogw[1],goldman.south.nogw[2],col="purple",pch="*",cex=3)


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

##         text(594540,116396,"River bed 103.5/104.5/105.5 (m)",col="black",cex=1)


        })
dev.off()

