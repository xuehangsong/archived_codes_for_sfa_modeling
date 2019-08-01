rm(list=ls())


west.x = 594300
east.x = 594750
south.y = 115200
north.y = 116800


west.x = 594400
east.x = 594550
south.y = 116070
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

## jpeg(paste("figures/domain.jpg",sep=''),width=6,height=15,units='in',res=100,quality=100)
## contour(x,y,z,levels=seq(104,106,0.5))
## dev.off()

## stop()



data = read.table('data/proj.coord.dat')
rownames(data) = data[,3]

mass = read.csv('data/coordinates.csv')
rownames(mass) = mass[,1]

                  
tcol = rainbow(7)
jpeg(paste("figures/bathymetry.jpg",sep=''),width=6,height=10,units='in',res=200,quality=100)
z=array(as.numeric(unlist(units.data["ringold.surface"])),c(nx,ny))
filled.contour(x,y,z,##levels=seq(0,3,0.5),
        xlim=c(west.x,east.x),
        ylim=c(south.y,north.y),
        color.palette=heat.colors,
        asp=1,
        plot.axes = {
         axis(1);
         axis(2);

        z = array(as.numeric(unlist(units.data["u1"])),c(nx,ny))
        z = 104.5-z
        contour(x,y,z,levels=seq(0,3,0.5),
##                xlim=c(west.x,east.x),
##                ylim=c(south.y,north.y),
                col=tcol,add=T
##                axe=FALSE,labcex=1,
##                asp=1)
        
        )})
dev.off()
stop()
par(new=T)
z = array(as.numeric(unlist(units.data["u1"])),c(nx,ny))
z = 104.5-z
contour(x,y,z,levels=seq(0,3,0.5),
        xlim=c(west.x,east.x),
        ylim=c(south.y,north.y),
        col=tcol,
        axe=FALSE,labcex=1,
        asp=1)
par(new=T)
plot(data[,1],data[,2],asp=1,
        xlim=c(west.x,east.x),
        ylim=c(south.y,north.y),
     xlab=NA,
     ylab=NA,
     axes=FALSE,

     )
dev.off()
stop()

box()
axis(1,seq(593000,east.x,50))
axis(3,seq(593000,east.x,50))
axis(2,seq(115000,north.y,50))
axis(4,seq(115000,north.y,50))
mtext("Easting (m)",1,at=west.x+80,line=2)
mtext("Northing (m)",2,at=south.y+180,line=2)
mtext("Water depth at river level of 104.5m",3,at=west.x+80,line=2.2,cex=1.5)

## model.domain=read.table("data/model.domain.dat")
## lines(model.domain[c(1,2,3,4,1),1],model.domain[c(1,2,3,4,1),2],lty=2,col="orange",lwd=2)
## lines(model.domain[c(5,6,7,8,5),1],model.domain[c(5,6,7,8,5),2],lty=2,col="green",lwd=2)

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
text(array.south[1],array.south[2]+10,"South Array",col="red")
points(array.south[1],array.south[2],col="red",pch=16,cex=1.5)
lines(c(array.south[1],c(array.south[1]+16*cos(angle/180*pi))),
      c(array.south[2],c(array.south[2]+16*sin(angle/180*pi))),
      col="red",lwd=3)


text(array.north[1],array.north[2]+10,"North Array",col='red')
points(array.north[1],array.north[2],col="red",pch=16,cex=1.5)
lines(c(array.north[1],c(array.north[1]+16*cos(angle/180*pi))),
      c(array.north[2],c(array.north[2]+16*sin(angle/180*pi))),
      col="red",lwd=3)

      
text(goldman.south.gw[1],goldman.south.gw[2]+10,"Goldman North GW",col='purple')
points(goldman.south.gw[1],goldman.south.gw[2],col="purple",pch='*',cex=3)

text(goldman.south.nogw[1],goldman.south.nogw[2]+10,"Goldman North NoGW",col='purple')
points(goldman.south.nogw[1],goldman.south.nogw[2],col="purple",pch="*",cex=3)

text(goldman.north.gw[1],goldman.north.gw[2]+10,"Goldman South GW",col='purple')
points(goldman.north.gw[1],goldman.north.gw[2],col="purple",pch="*",cex=3)

text(goldman.north.nogw[1],goldman.north.nogw[2]+10,"Goldman South NoGW",col='purple')
points(goldman.north.nogw[1],goldman.north.nogw[2],col="purple",pch="*",cex=3)



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




dev.off()
