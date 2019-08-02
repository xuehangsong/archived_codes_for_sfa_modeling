### For generate initial boundaries of Reach scale model
### use inverse distance model
### revised by Xuehang 03/20/2018
###---------------------------------------------------

rm(list=ls())
library(phylin)
library(akima)
library(fields)
library(rhdf5)

results.dir = "/Users/song884/Dropbox/Reach_scale_model/results/"
data.dir = "/Users/song884/Dropbox/Reach_scale_model/data/"
fig.dir = "/Users/song884/Dropbox/Reach_scale_model/figures/"
load(paste(results.dir,"/inital_data_coords.r",sep=""))
load(paste(results.dir,"/model_grids.r",sep=""))

input.dir = "/Users/song884/Dropbox/Reach_scale_model/Inputs/"
initial.h5 = "Hanford_Reach_Initial.h5"

grd$x = grd$x-538000
grd$y = grd$y-97000
data$x = data$x-538000
data$y = data$y-97000


fname_river.geo = paste(data.dir,"river_geometry_manual.csv",sep="")
river.geometry = read.csv(fname_river.geo)
river.geometry = river.geometry[, 2:3]
river.geometry.model = river.geometry
river.geometry.model$x = river.geometry.model$x-538000
river.geometry.model$y = river.geometry.model$y-97000




x = sort(unique(grd$x))
y = sort(unique(grd$y))
nx = length(x)
ny = length(y)

idw.interp = idw(values=data[,"z"],
                  coords = data[,c("x","y")],
                  grid=grd,
                  method="shepard",
                  p=2)
idw.interp = as.numeric(unlist(idw.interp))


bi.interp = interp(x=data$x, y=data$y, z=data$z,
       xo=x,yo=y,extrap=TRUE,
       duplicate = "strip")


jpeg(paste(fig.dir,"initialH_2007.jpg",sep=""),
     width=12.1,height=6,units='in',res=300,quality=100)
par(mfrow=c(1,2),oma=c(1,2,1,2),mgp=c(1.5,0.7,0))
image.plot(bi.interp,
      asp=1,
      xlab="Easting (m)",ylab="Northing (m)",
      main="(a) Liner Interpolation "
      )
polygon(river.geometry.model[, 1],
        river.geometry.model[, 2],
        border = "purple",
        col="purple"
        )
points(data[,c("x","y")],pch=16)
image.plot(x,y,array(idw.interp,c(nx,ny)),
      asp=1,
      xlab="Easting (m)",ylab="Northing (m)",
      main="(b) Inverse Distance Weighted Interpolation "
      )
polygon(river.geometry.model[, 1],
        river.geometry.model[, 2],
        border = "purple",
        col="purple"
        )
points(data[,c("x","y")],pch=16)
dev.off()



h.initial = array(idw.interp,c(nx,ny))
grid.x = unique(diff(x))
grid.y = unique(diff(y))

H5close()
##Generate the initial condition hdf5 file for the domain.
if (file.exists(paste(input.dir,initial.h5,sep=''))) {
    file.remove(paste(input.dir,initial.h5,sep=''))
}
h5createFile(paste(input.dir,initial.h5,sep=''))
h5createGroup(paste(input.dir,initial.h5,sep=''),'Initial_Head')
h5write(t(h.initial),paste(input.dir,initial.h5,sep=''),
        'Initial_Head/Data',level=0)
fid = H5Fopen(paste(input.dir,initial.h5,sep=''))
h5g = H5Gopen(fid,'/Initial_Head')
h5writeAttribute(attr = 1.0, h5obj = h5g, name = 'Cell Centered')
h5writeAttribute.character(attr = "XY", h5obj = h5g, name = 'Dimension')
h5writeAttribute(attr = c(grid.x,grid.y), h5obj = h5g, name = 'Discretization')
h5writeAttribute(attr = 500.0, h5obj = h5g, name = 'Max Buffer Size')
h5writeAttribute(attr = c(0,0), h5obj = h5g, name = 'Origin') 
H5Gclose(h5g)
H5Fclose(fid)

#s = interp(data$x, data$y, data$z, duplicate = "strip", nx=100, ny=100)





## image2D(s, shade=0.2, rasterImage = F, NAcol = "gray",
##         main = c("2007-03-28 inital head (contour)"), asp = 1, contour = T, add = F
##         )
## points(data$x, data$y, col = "white", pch = 1)
## dev.off()

## gs <- gstat(formula=perc~1,locations=data[,c("x","y")])
## nn <- interpolate(data[,"z"],gs)

## idw = idw0(formula=z~1,data=data,newdata=grd)
## idw(formula=z~1,locations=)
