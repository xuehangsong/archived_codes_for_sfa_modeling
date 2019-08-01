library(rhdf5)
#grid of 2d slice,0.1*0.05m
#well_02-03,x=256.7615396,y=218.3865653
#origin(594386.8806,116185.5023,15)
west.new=0
east.new=143.2
south.new=0
north.new=1
top.new=110.0
bottom.new=90.0
nx.new=round((east.new-west.new)/0.1,0.0)
ny.new=round((north.new-south.new)/1.0,0.0)
nz.new=round((top.new-bottom.new)/0.05,0.00)
dx.new=rep(0.10,nx.new)
dy.new=rep(1.00,ny.new)
dz.new=rep(0.05,nz.new)
x.new=west.new+cumsum(dx.new)-0.5*dx.new
y.new=south.new+cumsum(dy.new)-0.5*dy.new
z.new=bottom.new+cumsum(dz.new)-0.5*dz.new

#creat new material id
material_ids.new=h5read("seed/Plume_Slice_AdaptiveRes_material.h5","Materials/Material Ids")
material_ids.new=array(material_ids.new,c(nx.new,ny.new,nz.new))
material_ids.reverse=material_ids.new

face.cells = h5read(paste("seed/Plume_Slice_AdaptiveRes_material.h5",sep=''),"Regions/River/Cell Ids")
face.ids = h5read(paste("seed/Plume_Slice_AdaptiveRes_material.h5",sep=''),"Regions/River/Face Ids")
face.cells.group = list()
for(i in 1:6) {
    face.cells.group[[i]] = face.cells[face.ids==i]
}

face.cells = unique(face.cells)

face.cells.z = (face.cells-1) %/% (nx.new*ny.new)
face.cells.y = (face.cells-1-nx.new*ny.new*face.cells.z) %/% nx.new
face.cells.x = face.cells-1-nx.new*ny.new*face.cells.z-nx.new*face.cells.y
face.cells.x = face.cells.x+1
face.cells.y = face.cells.y+1
face.cells.z = face.cells.z+1


#find river.bank
river.bank.x = face.cells.x[face.cells.z<370]
river.bank.z = face.cells.z[face.cells.z<370]
river.bank.z = river.bank.z[order(river.bank.x)]
river.bank.x = river.bank.x[order(river.bank.x)]

nbank=dim(river.bank.x)

save(list=ls(),file="results/general.r")

write.table(cbind(river.bank.x,river.bank.z),file='river_bed_cell.txt',col.names = FALSE,row.names = FALSE)
write.table(cbind(x.new[river.bank.x],z.new[river.bank.z]),file='river_bed_coord.txt',col.names = FALSE,row.names = FALSE)

