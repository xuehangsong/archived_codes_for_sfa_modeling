rm(list=ls())
library("scatterplot3d")
library("rhdf5")
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")



angle = 15/180*pi
###400*400
td_origin = c(594186,115943)
##T3 slice
t3_origin = c(594378.6,116216.3)
##T4 slice
t4_origin = c(594386.880635513,116185.502270774)
model_origin = t3_origin

west = 0
south = 0
bottom = 90

dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
dy = 1.0
dz = c(rev(0.05*1.09505408**(1:25)),rep(0.05,300))

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz

cell.coords = expand.grid(x,y,z)

face.cells = h5read("2dmodel/T3_Slice_material.h5","Regions/River/Cell Ids")
face.ids = h5read("2dmodel/T3_Slice_material.h5","Regions/River/Face Ids")

face.coords = cell.coords[face.cells,]
face.coords.proj = model_to_proj(model_origin,angle,face.coords[,1:2])
face.coords.proj = cbind(face.coords.proj,face.coords[,3])
colnames(face.coords) = c("x","y","z")
colnames(face.coords.proj) = c("x","y","z")


interpolate.range = array(NA,c(2,3))
colnames(interpolate.range) = c("x","y","z")
interpolate.range[1,1] = min(face.coords.proj[,1])-5
interpolate.range[2,1] = max(face.coords.proj[,1])+5
interpolate.range[1,2] = min(face.coords.proj[,2])-5
interpolate.range[2,2] = max(face.coords.proj[,2])+5
interpolate.range[1,3] = min(face.coords.proj[,3])-5
interpolate.range[2,3] = max(face.coords.proj[,3])+5


load("real_river/pressure1.r")
ntime = 1
for (itime in 1:ntime)
{
    print(itime)
    load(paste("real_river/pressure",itime,".r",sep=""))
    pressure.trucated = pressure[
        which(pressure[,3]>=interpolate.range[1,"x"] &
              pressure[,3]<=interpolate.range[2,"x"] &
              pressure[,4]>=interpolate.range[1,"y"] &
              pressure[,4]<=interpolate.range[2,"y"] &
              pressure[,5]>=interpolate.range[1,"z"] &
              pressure[,5]<=interpolate.range[2,"z"]),]

    if (itime == 1)
    {
        n.pressure = nrow(pressure.trucated)
        face.pressure.index = rep(NA,nrow(face.coords.proj))
        for ( i.pressure in 1:n.pressure)
        {
            temp.index = which.min(
            ## (pressure.trucated[i.pressure,"x"]-face.coords.proj[,"x"])^2+
            ## (pressure.trucated[i.pressure,"y"]-face.coords.proj[,"y"])^2+            
            (pressure.trucated[i.pressure,"z"]-face.coords.proj[,"z"])^2)

            temp.min = min(
            ## (pressure.trucated[,"x"]-face.coords.proj[temp.index,"x"])^2+
            ## (pressure.trucated[,"y"]-face.coords.proj[temp.index,"y"])^2+            
            (pressure.trucated[,"z"]-face.coords.proj[temp.index,"z"])^2)

            if (
           ## ((pressure.trucated[i.pressure,"x"]-face.coords.proj[temp.index,"x"])^2+
           ##  (pressure.trucated[i.pressure,"y"]-face.coords.proj[temp.index,"y"])^2+            
             ((pressure.trucated[i.pressure,"z"]-face.coords.proj[temp.index,"z"])^2)<=temp.min)
            {
                face.pressure.index[temp.index] = i.pressure
            }
    }

    }

    face.pressure = pressure.trucated[face.pressure.index,1]
    filled.pressure = approx(face.coords[,3],face.pressure,face.coords[,3])


    ## write.table(pressure.trucated,
    ##             file=paste("real_river/pressure",itime,".txt",sep=""),row.name=FALSE)
}




plot(pressure.trucated[,5],pressure.trucated[,1],pch=16,cex=0.5)
points(face.coords.proj[,3],face.pressure,col="red",cex=0.5)    
points(face.coords.proj[,3],filled.pressure[[2]],col="blue",cex=1)


plot(pressure.trucated[,5],pressure.trucated[,1],pch=16,cex=0.5)
points(face.coords.proj[,3],face.pressure,col="red",cex=0.5)    
points(face.coords.proj[,3],filled.pressure[[2]],col="blue",cex=1)


plot(face.coords.proj[,3],filled.pressure[[2]]/998.2/9.8+face.coords.proj[,3],col="blue",cex=1)

mean(abs(face.coords.proj[,3]-pressure.trucated[face.pressure.index,5]),na.rm=TRUE)

plot(pressure.trucated[,5],pressure.trucated[,2],pch=16,cex=0.5)


#plot(pressure.trucated[,3],pressure.trucated[,1],pch=16,cex=0.5)
## points(face.coords.proj[,1],face.pressure,col="red",cex=0.5)    

#plot(pressure.trucated[,4],pressure.trucated[,1],pch=16,cex=0.5)
## points(face.coords.proj[,2],face.pressure,col="red",cex=0.5)    



## write.table(face.coords.proj,
##             file=paste("real_river/face_coords_proj.txt",sep=""),row.name=FALSE)
## write.table(x,
##             file=paste("real_river/x.txt",sep=""),row.name=FALSE)
## write.table(y,
##             file=paste("real_river/y.txt",sep=""),row.name=FALSE)
## write.table(z,
##             file=paste("real_river/z.txt",sep=""),row.name=FALSE)

## write.table(dx,
##             file=paste("real_river/dx.txt",sep=""),row.name=FALSE)
## write.table(dy,
##             file=paste("real_river/dy.txt",sep=""),row.name=FALSE)
## write.table(dz,
##             file=paste("real_river/dz.txt",sep=""),row.name=FALSE)



## scatterplot3d(pressure.trucated[,"x"],
##               pressure.trucated[,"y"],
##               pressure.trucated[,"z"],
##               angle=45,
##               color="red",
##               xlim=interpolate.range[,"x"],
##               ylim=interpolate.range[,"y"],
##               zlim=interpolate.range[,"z"])


              

## par(new=T)
## scatterplot3d(face.coords.proj[,"x"],
##               face.coords.proj[,"y"],
##               face.coords.proj[,"z"],
##               angle=45,              
##               xlim=interpolate.range[,"x"],
##               ylim=interpolate.range[,"y"],
##               zlim=interpolate.range[,"z"])


## plot(pressure.trucated[,"y"],
##               pressure.trucated[,"z"],
##               col="red",
##               xlim=interpolate.range[,"y"],
##               ylim=interpolate.range[,"z"])

## par(new=T)
## plot(face.coords.proj[,"y"],
##      face.coords.proj[,"z"],
##      xlim=interpolate.range[,"y"],
##      ylim=interpolate.range[,"z"])


## plot(pressure.trucated[,"x"],
##      pressure.trucated[,"z"],
##      col="red",
##      xlim=interpolate.range[,"x"],
##      ylim=interpolate.range[,"z"],
##      pch=16,cex=0.5
##      )
## par(new=T)
## plot(face.coords.proj[,"x"],
##      face.coords.proj[,"z"],
##      xlim=interpolate.range[,"x"],
##      ylim=interpolate.range[,"z"],
##      pch=16,cex=0.5)
