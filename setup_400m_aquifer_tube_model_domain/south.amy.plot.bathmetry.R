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

array.north = c(594458.3,116306.4)
array.south = c(594475.308,116259.556)

goldman.south.gw = c(594521.1,116152.5)
goldman.south.nogw = c(594515.6,116176)

goldman.north.gw = c(594357.8,117138.2)
goldman.north.nogw = c(594367.1,117047.2)


units.data = read.table("data/300A_EV_surfaces_012612.dat",header=F,skip=21)
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

x = sort(as.numeric(names(table(units.data[["meshx"]]))))
y = sort(as.numeric(names(table(units.data[["meshy"]]))))
nx = length(x)
ny = length(y)
z = array(as.numeric(unlist(units.data["u1"])),c(nx,ny))
z = 104.5-z






## bath.data = read.table("data/newbath_10mDEM_grid.ascii")
## bath.data = t(bath.data)
## bath.data = c(bath.data)
## bath.x = seq(590999,595499,2)
## bath.y = seq(118499,113499,-2)
## bath.nx = length(bath.x)
## bath.ny = length(bath.y)
## bath.x = rep(bath.x,bath.ny)
## bath.y = rep(bath.y,each=bath.nx)
## bath.data = cbind(bath.x,bath.y,bath.data)
## colnames(bath.data) = c("bathx","bathy","bath")
## bath.data = bath.data[which(bath.data[,"bathx"]>west.x-20 & bath.data[,"bathx"]<east.x+20),]
## bath.data = bath.data[which(bath.data[,"bathy"]>south.y-20 & bath.data[,"bathy"]<north.y-5),]
## save(bath.data,file="results/bath.data.r")

data = read.table('data/proj.coord.dat')
rownames(data) = data[,3]

mass = read.csv('data/coordinates.csv')
rownames(mass) = mass[,1]

                  
jpeg(paste("figures/bathymetry.jpg",sep=''),width=7,height=7.9,units='in',res=300,quality=100)
z=array(as.numeric(unlist(units.data["ringold.surface"])),c(nx,ny))
filled.contour(x,y,z,##levels=seq(0,3,0.5),
        xlim=c(west.x,east.x),
        ylim=c(south.y,north.y),
        color.palette=terrain.colors,
##        plot.title=title("Water Depth at River Level of 104.5 (m)"),
        asp=1,
        key.title=title("Ringold\nEL. (m)"),
        plot.axes = {
         axis(1);
         axis(2);

         load("results/bath.data.r")
         bath.data = bath.data[order(bath.data[,"bathy"],bath.data[,"bathx"]),]
         x=sort(as.numeric(names(table(bath.data[,"bathx"]))))
         y=sort(as.numeric(names(table(bath.data[,"bathy"]))))
         nx = length(x)
         ny = length(y)
         z = array(as.numeric(unlist(bath.data[,"bath"])),c(nx,ny))         
         z = 104.5-z                  
         
         contour(x,y,z,levels=seq(0,3,1),drawlabels=FALSE,
                col="black",add=T)
         par(new=T)         
##         points(data[,1],data[,2])
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


         angle=15
         text(array.south[1]+50,array.south[2]+5,"South Array",col="red")
         points(array.south[1],array.south[2],col="red",pch=16,cex=1.5)
         lines(c(array.south[1],c(array.south[1]+16*cos(angle/180*pi))),
               c(array.south[2],c(array.south[2]+16*sin(angle/180*pi))),
               col="red",lwd=3)


         text(array.north[1]+50,array.north[2]+5,"North Array",col='red')
         points(array.north[1],array.north[2],col="red",pch=16,cex=1.5)
         lines(c(array.north[1],c(array.north[1]+16*cos(angle/180*pi))),
               c(array.north[2],c(array.north[2]+16*sin(angle/180*pi))),
               col="red",lwd=3)

         
         text(goldman.south.gw[1]+40,goldman.south.gw[2]+15,"Goldman Site",col='purple')
         points(goldman.south.gw[1],goldman.south.gw[2],col="purple",pch='*',cex=3)
         points(goldman.south.nogw[1],goldman.south.nogw[2],col="purple",pch="*",cex=3)




         iwell="T2"
         text(data[iwell,1]-10,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T3"
         text(data[iwell,1]-10,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T4"
         text(data[iwell,1]-10,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         iwell="T5"
         text(data[iwell,1]-10,data[iwell,2],iwell,col="blue")
         points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

         text(594430,116396," Water depth 01 2 3 (m)",col="black",cex=1.2)


         line.length=200
         angle=15+90
         iwell="goldman_south"
         start.point = data[iwell,]
         end.point = c(c(data[iwell,1]+line.length*cos(angle/180*pi)),
                        c(data[iwell,2]+line.length*sin(angle/180*pi)))
         lines(c(start.point[1],end.point[1]),c(start.point[2],end.point[2]),
               col="red",lwd=3)
         df1=data.frame(x=as.numeric(c(start.point[2],end.point[2]))
                      ,y=as.numeric(c(start.point[1],end.point[1])))
         f1 <- lm(y~x,df1)

         

         angle=15
         line.length=100
         iwell="2-2"
         start.point = data[iwell,]
         end.point = c(c(data[iwell,1]+line.length*cos(angle/180*pi)),
                        c(data[iwell,2]+line.length*sin(angle/180*pi)))
         lines(c(start.point[1],end.point[1]),c(start.point[2],end.point[2]),
               col="red",lwd=3)
         df2=data.frame(x=as.numeric(c(start.point[2],end.point[2]))
                      ,y=as.numeric(c(start.point[1],end.point[1])))
         f2 <- lm(y~x,df2)




         line.length=-200
         angle=15+90
         iwell="2-2"
         start.point = data[iwell,]
         end.point = c(c(data[iwell,1]+line.length*cos(angle/180*pi)),
                        c(data[iwell,2]+line.length*sin(angle/180*pi)))
         lines(c(start.point[1],end.point[1]),c(start.point[2],end.point[2]),
               col="red",lwd=3)
         df3=data.frame(x=as.numeric(c(start.point[2],end.point[2]))
                      ,y=as.numeric(c(start.point[1],end.point[1])))
         f3 <- lm(y~x,df3)

         

         
         temp = rbind(coef(f1),coef(f2))
         topleft.point = rev(c(-solve(cbind(temp[,2],-1)) %*% temp[,1]))
##         points(topleft.point[1],topleft.point[2])

         bottomleft.point = data["goldman_south",]
##         points(bottomleft.point[1],bottomleft.point[2])         
         length.along = ((topleft.point[1]-bottomleft.point[1])^2 +(
             topleft.point[2]-bottomleft.point[2])^2)^0.5
         dl = length.along/21
         dlx = dl*sin(15/180*pi)
         dly = dl*cos(15/180*pi)

         left.points = cbind(seq(data["2-2",1],data["2-2",1]+dlx*21,dlx),
                             seq(data["2-2",2],data["2-2",2]-dly*21,-dly))
         right.points = cbind(seq(data["goldman_south",1],data["goldman_south",1]-dlx*21,-dlx),
                             seq(data["goldman_south",2],data["goldman_south",2]+dly*21,+dly))
         right.points = right.points[order(right.points[,1]),]


         points(left.points[,1],left.points[,2])
         points(right.points[,1],right.points[,2])         

         load("results/bath.data.r")
         bath.data = bath.data[order(bath.data[,"bathy"],bath.data[,"bathx"]),]
         x=sort(as.numeric(names(table(bath.data[,"bathx"]))))
         y=sort(as.numeric(names(table(bath.data[,"bathy"]))))
         nx = length(x)
         ny = length(y)
         z = array(as.numeric(unlist(bath.data[,"bath"])),c(nx,ny))         

         bath.interp = list(x=x,y=y,z=z)
         required.depth = c(104,104.5,105)
         ndepth = length(required.depth)
         nsection=9
         tube.points = array(0,c(nsection*ndepth,2))
##         for (inode in c(1,2,4,8,9,11,15,16,18))
             isection=1
         for (inode in (23-c(1,2,4,8,9,11,15,16,18)))             
         {
             points(left.points[inode,1],left.points[inode,2],pch=16,col="blue")
             points(right.points[inode,1],right.points[inode,2],pch=16,col="blue")

             dfm=data.frame(x=as.numeric(c(left.points[inode,1],right.points[inode,1])),
                            y=as.numeric(c(left.points[inode,2],right.points[inode,2])))
             fm <- lm(y~x,dfm)
             line.points.x = data.frame(x=seq(594460,594560,0.01))
             line.points.y = predict(fm,line.points.x)
             line.points.x = as.numeric(unlist(line.points.x))
             line.points.y = as.numeric(line.points.y)             
##             
             line.points.z=interp.surface(bath.interp,cbind(line.points.x,line.points.y))
             for (idepth in 1:ndepth)
             {
                temp= which.min(abs(line.points.z-required.depth[idepth]))
                tube.points[idepth+(isection-1)*ndepth,] = c(line.points.x[temp],line.points.y[temp])

             }
             isection=isection+1
             points(tube.points[,1],tube.points[,2])             
         }


        })
dev.off()

colnames(tube.points)=c("Easting","Northing")
write.table(tube.points,file="tube_points.txt",row.names=FALSE)
