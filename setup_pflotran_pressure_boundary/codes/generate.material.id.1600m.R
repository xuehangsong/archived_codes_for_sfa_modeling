rm(list=ls())
library(rhdf5)

source("~/repos/sbr-river-corridor-sfa/1600m_3d_model.R")
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
load("~/repos/sbr-river-corridor-sfa/results/layer.1600m.3d.r")

load("real_river/cfd.1600m.river.r")



material.ids = array(rep(1,nx*nz*nz),c(nx,ny,nz))
cell.ids = array(seq(1,nx*ny*nz),c(nx,ny,nz))

cfd.1600m.riverbed = array(cfd.1600m.riverbed[,3],c(nx,ny))
layer.1600m.3d = array(layer.1600m.3d[,"ringold.surface"],c(nx,ny))
for (iy in 1:ny)
{
    for (ix in 1:nx)
    {
        material.ids[ix,iy,which(z >= cfd.1600m.riverbed[ix,iy])] = 0   
        material.ids[ix,iy,which(z <= layer.1600m.3d[ix,iy])] = 4
    }
}

fname = "3dmodel/real_river_1600m_material.h5"

if(file.exists(fname)) {file.remove(fname)}

cell.ids = as.integer(c(cell.ids))
material.ids = as.integer(c(material.ids))

h5createFile(fname)
h5createGroup(fname,"Materials")
h5write(cell.ids,fname,"Materials/Cell Ids",level=0)
h5write(material.ids,fname,"Materials/Material Ids",level=0)
H5close()

save(material.ids,file="material.ids.r")
