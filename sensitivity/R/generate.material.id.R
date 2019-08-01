#### assign Hanford/Ringold material ids for
#### uniform grids

rm(list=ls())
library(rhdf5)
load('interpolated.data.r')

west = 0
east = 143.2
south = 0
north = 1
top = 110.0
bottom = 90.0

nx = round((east-west)/0.1,0.0)
ny = round((north-south)/1.0,0.0)
nz = round((top-bottom)/0.05,0.00)

dx = rep(0.10,nx)
dy = rep(1.00,ny)
dz = rep(0.05,nz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz

material.ids = array(rep(1,nx*nz),c(nx,nz))
cell.ids = array(seq(1,nx*nz),c(nx,nz))

for (ix in 1:nx)
{
    material.ids[ix,][z >= slice[["u1"]][ix]] = 0
    material.ids[ix,][z <= slice[["ringold.surface"]][ix]] = 4
}

fname = "T3_Slice_material.h5"

if(file.exists(fname)) {file.remove(fname)}

cell.ids = as.integer(c(cell.ids))
material.ids = as.integer(c(material.ids))

h5createFile(fname)
h5createGroup(fname,"Materials")
h5write(cell.ids,fname,"Materials/Cell Ids",level=0)
h5write(material.ids,fname,"Materials/Material Ids",level=0)

H5close()

save(material.ids,file="material.ids.r")
