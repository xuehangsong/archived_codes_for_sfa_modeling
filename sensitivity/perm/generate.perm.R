rm(list=ls())
library(rhdf5)
load("perm.data.3.r")



west = 0
east = 143.2
south = 0
north = 1
top = 110.0
bottom = 90.0


dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
dy = 1.0
dz = c(rev(0.05*1.09505408**(1:25)),rep(0.05,300))

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz

cell.ids = as.integer(seq(1,nx*ny*nz))











isam = 19
fname=paste("Hanford_perm_2d_adaptive.h5",sep="")
if(file.exists(fname)) {file.remove(fname)}
h5createFile(fname)
h5write(cell.ids,fname,"Cell Ids",level=0)
h5write(hanford.perm[,isam+2],fname,paste("Hanford_perm1",sep=""),level=0)

isam = 15
fname=paste("Alluvium_perm_2d_adaptive.h5",sep="")            
if(file.exists(fname)) {file.remove(fname)}
h5createFile(fname)
h5write(cell.ids,fname,"Cell Ids",level=0)
h5write(alluvium.perm[,isam+2],fname,paste("Alluvium_perm1",sep=""),level=0)

