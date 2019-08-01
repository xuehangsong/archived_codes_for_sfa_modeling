rm(list=ls())
library(rhdf5)

load("results/general.r")
output.matrix = array(NA,c(nx,4))
output.matrix[,1] = x


#river bed
material.ids=h5read("reference/T3_Slice_material.h5","Materials/Material Ids")
material.ids=array(material.ids,c(nx,ny,nz))
material.ids.reverse=material.ids
face.cells = h5read(paste("reference/T3_Slice_material.h5",sep=''),"Regions/River/Cell Ids")
face.ids = h5read(paste("reference/T3_Slice_material.h5",sep=''),"Regions/River/Face Ids")
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
river.bank.x = face.cells.x
river.bank.z = face.cells.z
river.bank.x = river.bank.x[order(river.bank.z,decreasing=TRUE)]
river.bank.z = river.bank.z[order(river.bank.z,decreasing=TRUE)]
output.matrix[(nx-length(river.bank.z)+1):nx,2] = z[river.bank.z]
output.matrix[,2][is.na(output.matrix[,2])] = 109.975

load("results/mudlayer.depth.r")
##handford-alluvium
output.matrix[(nx-length(mudlayer.depth)+1):nx,3] =
    output.matrix[(nx-length(mudlayer.depth)+1):nx,2] - mudlayer.depth
output.matrix[,3][is.na(output.matrix[,3])] = 0


output.matrix[,4] = z[hanford.ringold.boundary]

colnames(output.matrix) = c("x","river bed","hanford top","ringold top")

write.table(output.matrix,file="boundary.txt",row.name=F)

