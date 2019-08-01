rm(list=ls())
library(rhdf5)
source("/Users/song884/repos/sbr-river-corridor-sfa/ifrc_120m_3d.R")

cell.ids = 1:(nx*ny*nz)

material.data = as.numeric(unlist(read.table("./tprogs/r.",skip=2)))
material.ids = rep(0,nx*ny*nz)
material.ids[which(material.data==1)] = 1
material.ids[which(material.data==2)] = 9
material.ids[which(material.data==3)] = 4

fname = "dainput/ref_material.h5"
if(file.exists(fname)) {file.remove(fname)}
h5createFile(fname)
h5createGroup(fname,"Materials")
h5write(cell.ids,fname,"Materials/Cell Ids",level=0)
h5write(material.ids,fname,"Materials/Material Ids",level=0)
H5close()

save(material.ids,file="results/material.ids.r)")

## a = h
