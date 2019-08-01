rm(list=ls())
library(rhdf5)

region_h5file = "default/east_region.h5"

nx = 20
ny = 20
nz = 10
dx = rep(10/nx,nx)
dy = rep(10/ny,ny)
dz = rep(1/nz,nz)

x = cumsum(dx)-0.5*dx
y = cumsum(dy)-0.5*dy
z = cumsum(dz)-0.5*dz

cells = expand.grid(1:nx,1:ny,1:nz)
cells_coord= expand.grid(x,y,z)

east_cells = which(cells[,1] == nx)


if (file.exists(paste(region_h5file,sep=''))) {
    file.remove(paste(region_h5file,sep=''))
} 
h5createFile(paste(region_h5file,sep=''))
h5createGroup(paste(region_h5file,sep=''),"Regions")
h5createGroup(paste(region_h5file,sep=''),"Regions/Region_East")
h5write(east_cells,paste(region_h5file,sep=''),"Regions/Region_East/Cell Ids",level=0)
h5write(rep(2,length(east_cells)),paste(region_h5file,sep=''),"Regions/Region_East/Face Ids",level=0)
H5close()
print("Hello World")

