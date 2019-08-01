library(rhdf5)
#grid of 2d slice,0.1*0.05m
#well_02-03,x=256.7615396,y=218.3865653
#origin(594386.8806,116185.5023,15)

## west=0
## east=143.2
## south=0
## north=1
## top=110.0
## bottom=90.0
## nx=round((east-west)/0.1,0.0)
## ny=round((north-south)/1.0,0.0)
## nz=round((top-bottom)/0.05,0.00)
## dx=rep(0.10,nx)
## dy=rep(1.00,ny)
## dz=rep(0.05,nz)
## x=west+cumsum(dx)-0.5*dx
## y=south+cumsum(dy)-0.5*dy
## z=bottom+cumsum(dz)-0.5*dz

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





#creat new material id
material.ids=h5read("seed/T3_Slice_material.h5","Materials/Material Ids")
material.ids=array(material.ids,c(nx,ny,nz))
material.ids.reverse=material.ids

face.cells = h5read(paste("seed/T3_Slice_material.h5",sep=''),"Regions/River/Cell Ids")
face.ids = h5read(paste("seed/T3_Slice_material.h5",sep=''),"Regions/River/Face Ids")
face.cells.group = list()
for(i in 1:6) {
    face.cells.group[[i]] = face.cells[face.ids==i]
}

face.cells = unique(face.cells)

face.cells.z = (face.cells-1) %/% (nx*ny)
face.cells.y = (face.cells-1-nx*ny*face.cells.z) %/% nx
face.cells.x = face.cells-1-nx*ny*face.cells.z-nx*face.cells.y
face.cells.x = face.cells.x+1
face.cells.y = face.cells.y+1
face.cells.z = face.cells.z+1


#find river.bank
river.bank.x = face.cells.x[face.cells.z<301]
river.bank.z = face.cells.z[face.cells.z<301]
river.bank.z = river.bank.z[order(river.bank.x)]
river.bank.x = river.bank.x[order(river.bank.x)]

nbank=dim(river.bank.x)

save(list=ls(),file="results/general.r")

write.table(cbind(river.bank.x,river.bank.z),file='results/river_bed_cell.txt',col.names = FALSE,row.names = FALSE)
write.table(cbind(x[river.bank.x],z[river.bank.z]),file='results/river_bed_coord.txt',col.names = FALSE,row.names = FALSE)
