### This file is used to re-interploate the material on new grids

rm(list=ls())
library(rhdf5)
library("fields")
##library("akima")


west=0
east=143.2
south=0
north=1
top=110.0
bottom=90.0
nx=round((east-west)/0.1,0.0)
ny=round((north-south)/1.0,0.0)
nz=round((top-bottom)/0.05,0.00)
dx=rep(0.10,nx)
dy=rep(1.00,ny)
dz=rep(0.05,nz)
x=west+cumsum(dx)-0.5*dx
y=south+cumsum(dy)-0.5*dy
z=bottom+cumsum(dz)-0.5*dz

material.ids=h5read("seed/Plume_Slice_AdaptiveRes_material.h5","Materials/Material Ids")
material.ids=array(material.ids,c(nx,ny,nz))
material.ids.reverse=material.ids

dx.new = c(rev((0.1*1.0954155745**(1:48))),rep(0.1,532))
nx.new = length(dx.new)
x.new = west+cumsum(dx.new)-0.5*dx.new

dz.new = c(rev(0.05*1.09505408**(1:25)),rep(0.05,300))
nz.new = length(dz.new)
z.new=bottom+cumsum(dz.new)-0.5*dz.new


grid = list(x,z,material.ids.reverse[,1,])
grid.new = cbind(rep(x.new,nz.new),rep(z.new,each = nx.new))

material.ids = interp.surface(grid,grid.new)
