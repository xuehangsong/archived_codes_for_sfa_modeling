setwd("/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/")

# rm(list=ls())
library(rhdf5)
library(scatterplot3d)
library(plot3D)
library(akima)
library(rgl)
library(gtools)
library(sp)
##-------------------INPUT----------------------##
# source("300A_prepare_facies_boundary.R")
# source("codes/300A_parameters.R")
fname_geoFramework.r = "results/geoframework.r"
fname_mass1_coord = "data/MASS1/coordinates.csv"
fname_mass1_pts = "data/MASS1/transient_1976_2016/"
fname_river.geo = "data/river_geometry_manual.csv"

# mass1_upstream=314
# mass1_downstream=330

# fname_model_coord="data/model_coord.dat"


##-------------------output---------------------##
fname_fig.surface3d="figures/surface_cell_3d.jpg"
fname_fig.surface2d="figures/surface_cell_2d.jpg"
fname_material_h5 = "Inputs/HFR_material_riverID.h5"
fname_material_r="results/HFR_material_riverID.r"
fname_fig.grids = "figures/grids.jpg"
fname_river_cell_coord = "results/river_cell_coord.csv"

# load(fname_geoFramework.r)  ## load into geologic layer from geoFramework
# load(fname_material_r)  ## load into geologic layer from geoFramework


#ID=9, Ringold fine K=1 m/d
#ID=4, Ringold gravel K=40 m/d
#ID=1, Hanford
#ID=0, river

# material.ids = array(4,c(nx,ny,nz)) #assign ID=4 for all cells=nx*ny*nz
material.ids = array(NA, c(nx,ny,nz)) #assign ID=0 for all cells=nx*ny*nz

cell.ids = array(seq(1,nx*ny*nz),c(nx,ny,nz))
cell.ids.z = (cell.ids-1)%/%(nx*ny)
cell.ids.y = (cell.ids-1-nx*ny*cell.ids.z)%/%nx
cell.ids.x = cell.ids-1-nx*cell.ids.y-nx*ny*cell.ids.z
cell.ids.x = cell.ids.x+1
cell.ids.y = cell.ids.y+1
cell.ids.z = cell.ids.z+1

for (iz in 1:nz)
{
    # material.ids[,,iz][which(cells_basalt<=z[iz])] = 1  #cells_HR: HR contact, assign id=1 to Hanford for regions above HR contact     

    material.ids[,,iz][which(cells_hanford >= z[iz])] = 1  #assign id=1 to cells below hanford surface
    material.ids[,,iz][which(cells_hanford < z[iz])] = 0  #assign id=0 to cells above hanford surface
    
    # material.ids[,,iz][which(cells_hanford == NA)] = NA 
}

face.ids = array(rep(0,nx*ny*nz),c(nx,ny,nz)) #assign initial face id=0, total six different faces
face.ids.final = vector()
face.cell.ids.final = vector()

##-----------------------------search for the faces ajacent to atmosphere (ID=0)------------------------------------##
#xdirection
if (nx>1) {
diff.material.ids = apply(material.ids, c(2,3), diff) #subtract face#2 with face#1, see "apply" function

# #if the diff=4, 4-0=4, i.e. ringold contact with river,and river is on the LEFT side of the cell
# if (any(diff.material.ids==4)) {
#     face.ids[ which(diff.material.ids==4, arr.ind=TRUE)+
#                  t(replicate(dim(which(diff.material.ids==4, arr.ind=TRUE))[1],
#                              c(1,0,0)))
#              ] = 1
# }

#if the diff=1, 1-0=1, i.e. hanford contact with river, and river is on the LEFT side of the cell, so the face# contact the river would be "1"
if (any(diff.material.ids==1)) {
    face.ids[ which(diff.material.ids==1,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==1,arr.ind=TRUE))[1],
                             c(1,0,0)))
             ] = 1
}

face.ids.final = c(face.ids.final, face.ids[face.ids==1])
face.cell.ids.final = c(face.cell.ids.final, cell.ids[face.ids==1])


# face.ids[which(diff.material.ids == -4, arr.ind=TRUE)] = 2 # if diff=-4 or -1, then river is on the Right hand side of the cell, so the face# contact the river would be "2"
face.ids[which(diff.material.ids == -1, arr.ind=TRUE)] = 2

face.ids.final = c(face.ids.final,face.ids[face.ids==2])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==2])


}

#ydirection
if(ny>1) {
diff.material.ids = aperm(apply(material.ids, c(1,3), diff), c(2,1,3))

# # if diff = 1 or 4, means river on the front side, and face# contact river would be 3
# if (any(diff.material.ids==4)) {
#     face.ids[which(diff.material.ids==4,arr.ind=TRUE)+
#                  t(replicate(dim(which(diff.material.ids==4,arr.ind=TRUE))[1],
#                              c(0,1,0)))
#              ] = 3
# }

if (any(diff.material.ids==1)) {
    face.ids[which(diff.material.ids==1,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==1,arr.ind=TRUE))[1],
                             c(0,1,0)))
             ] = 3
}


face.ids.final = c(face.ids.final, face.ids[face.ids==3])
face.cell.ids.final = c(face.cell.ids.final, cell.ids[face.ids==3])

# if diff = -1 or -4, means river on the front side, and face# contact river would be 4
# face.ids[which(diff.material.ids==-4,arr.ind=TRUE)] = 4
face.ids[which(diff.material.ids == -1, arr.ind=TRUE)] = 4


face.ids.final = c(face.ids.final,face.ids[face.ids==4])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==4])


}


#zdirection
if(nz>1){
diff.material.ids = aperm(apply(material.ids, c(1,2), diff), c(2,3,1))

### if diff = 1 or 4, means river on the bottom side, and face# contact river would be 5
# if (any(diff.material.ids==4)) {
# 
#     face.ids[which(diff.material.ids==4,arr.ind=TRUE)+
#                  t(replicate(dim(which(diff.material.ids==4,arr.ind=TRUE))[1],
#                              c(0,0,1)))
#              ] = 5
# }


if (any(diff.material.ids == 1, na.rm = TRUE)) {
    face.ids[which(diff.material.ids==1,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==1,arr.ind=TRUE))[1],
                             c(0,0,1)))
             ] = 5
}

face.ids.final = c(face.ids.final,face.ids[face.ids==5])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==5])

# if diff = -1 or -4, means river on the top side, and face# contact river would be 6
# face.ids[which(diff.material.ids==-4,arr.ind=TRUE)] = 6
face.ids[which(diff.material.ids==-1,arr.ind=TRUE)] = 6

face.ids.final = c(face.ids.final,face.ids[face.ids==6])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==6])

}




face.ids.final = as.integer(face.ids.final)
face.cell.ids.final = as.integer(face.cell.ids.final)

face.ids.final = face.ids.final[order(face.cell.ids.final)]
face.cell.ids.final = sort(face.cell.ids.final)



##------------------------------assign ID=0, 2, 3, ... to domain b/w hanford and basalt---------------------------------------## 

for (iz in 1:nz)
{
  material.ids[,,iz][which(z[iz]<cells_cold_creek)] = 2 # assign ID=2 for cold_creek
  material.ids[,,iz][which(z[iz]<cells_taylor_flats)] = 3 # assign ID=3 for taylor_flats
  material.ids[,,iz][which(z[iz]<cells_ringold_e)] = 4 # assign ID=4 for ringold_e
  material.ids[,,iz][which(z[iz]<cells_ringold_lm)] = 5 # assign ID=5 for ringold_lm
  material.ids[,,iz][which(z[iz]<cells_ringold_a)] = 6 # assign ID=6 for ringold_a
  
  # material.ids[,,iz][which(z[iz]<cells_basalt)] = 0 # cells below basalt is inactive
  material.ids[,,iz][which(z[iz]<cells_basalt)] = 9 # cells below basalt is inactive
  
}



## replace material id=NA with 0
material.ids[is.na(material.ids)] = 0

## asign river ids = 10
material.ids = c(material.ids)
# face.cell.ids.final.unique = unique(face.cell.ids.final)
material.ids[river_cell_coord[,1]] = 10
# write.table(material.ids, file = "results/material.ids.txt")

# stop()

##-----------------------------------Plot river bed cells-----------------------------------##
jpeg(fname_fig.surface3d, width=8,height=8,units='in',res=300,quality=100)
scatterplot3d(x[cell.ids.x[face.cell.ids.final]],
              y[cell.ids.y[face.cell.ids.final]],
              z[cell.ids.z[face.cell.ids.final]],
              ## xlim=c(0,nx),
              ## ylim=c(0,ny),
              ## zlim=c(0,nz),
              xlab='Southing (m)',
              ylab='Westing (m)',
              zlab='Elevation (m)',
              cex.lab=1,
              cex.axis=1,
              scale.y=1.0,
              angle=30
              )

dev.off()

# plot(x[cell.ids.x[face.cell.ids.final]],
#      y[cell.ids.y[face.cell.ids.final]])

## plot surface-3D
face.cell.ids.final.unique = unique(face.cell.ids.final)
# surface.x = x[cell.ids.x[face.cell.ids.final.unique]]
# surface.y = y[cell.ids.y[face.cell.ids.final.unique]]
# surface.z = z[cell.ids.z[face.cell.ids.final.unique]]
surface.x = x[cell.ids.x[face.cell.ids.final]]
surface.y = y[cell.ids.y[face.cell.ids.final]]
surface.z = z[cell.ids.z[face.cell.ids.final]]

s = interp(surface.x, surface.y, surface.z, duplicate = "strip", nx=100, ny=100)
# surface3d(s$x,s$y,s$z,color="blue")

## show the perspective view of the surface plot
# open3d()
# bg3d("white")
# nbcol = 100
# color = rev(rainbow(nbcol, start = 0/6, end = 4/6))
# zcol  = cut(s$z, nbcol)
# persp3d(s$x,s$y,s$z, col = color[zcol], aspect = c(1,1,0.2))

jpeg(fname_fig.surface2d, width=8,height=8,units='in',res=300,quality=100)
image2D(s, shade=0.2, rasterImage = F, NAcol = "gray",
        main = c("surface cells"), asp = 1)
dev.off()



##--------------------------- find max-water level for mass1 pts------------------------------
# mass_info = read.csv(fname_mass1_coord)
# 
# mass_files = list.files(path = fname_mass1_pts)
# mass_files = mixedsort(sort(mass_files))
# 
# max_wl = vector()
# 
# mass_files = c("mass1_40.csv")
# # 
# for (ifile in mass_files) {
# 
#   mass_data = read.csv(paste(fname_mass1_pts, ifile, sep = ""))
#   max = max(mass_data[, 4]) + 1.039
#   max_wl = c(max_wl, max)
# 
# }
# 
# mass_info = cbind(mass_info, max_wl)


# write.csv(mass_info, file = "data/MASS1/mass_info.csv")



##-------------------------------find river cells within river geometry---------------------------------------##

## read into river geometry

river.geometry = read.csv(fname_river.geo)

river.geometry = river.geometry[, 2:3]

river.geometry.model = proj_to_model(model_origin, angle, river.geometry)
# colnames(river.geometry.model) = c("x", "y")

## look for cells inside river geometry
pts_in_poly = point.in.polygon(point.x = surface.x, point.y= surface.y, pol.x = river.geometry.model[, 1], pol.y = river.geometry.model[, 2])

river.x = surface.x[which(pts_in_poly==1)]
river.y = surface.y[which(pts_in_poly==1)]

jpeg(fname_fig.grids, width=10,height=10,units='in',res=600,quality=100)
plot(river.x, river.y, xlim = c(0, xlen), ylim = c(0, ylen), asp = 1, col = "red", pch = 20, cex=0.05)
polygon(river.geometry.model[, 1], river.geometry.model[, 2], border = "black")
points(cells_model, pch = 20, cex=0.05)
points(river.x, river.y, col = "red", pch = 20, cex=0.05)

# grid(nx, ny, lty = "solid")

dev.off()

river_cell_coord = cbind(
  face.cell.ids.final[which(pts_in_poly==1)],
  face.ids.final[which(pts_in_poly==1)],
                        river.x, 
                         river.y
                         )

colnames(river_cell_coord)=c("cell_id", "face_id", "x", "y")
river_cell_coord =river_cell_coord[order[river_cell_coord[,"cell_id"]],]




write.csv(river_cell_coord, file = fname_river_cell_coord, row.names = F)

##------------------------------write hdf5 file-----------------------------------------------##

if(file.exists(fname_material_h5)) {file.remove(fname_material_h5)}
cell.ids = as.integer(c(cell.ids))
material.ids = as.integer(c(material.ids))

h5createFile(fname_material_h5)
h5createGroup(fname_material_h5,"Materials")
h5write(cell.ids,fname_material_h5,"Materials/Cell Ids",level=0)
h5write(material.ids,fname_material_h5,"Materials/Material Ids",level=0)

# h5createGroup(fname_material_h5,"Regions")
# h5createGroup(fname_material_h5,"Regions/River")
# h5write(face.cell.ids.final,fname_material_h5,"Regions/River/Cell Ids",level=0)
# h5write(face.ids.final,fname_material_h5,"Regions/River/Face Ids",level=0)




# slice.list = as.character(seq(mass1_upstream,mass1_downstream))
# nslice=length(slice.list)
# coord.data = read.table("data/model_coord.dat")
# rownames(coord.data) = coord.data[,1]
# coord.data =  coord.data[rownames(coord.data) %in% slice.list,]
# nwell = dim(coord.data)[1]
# slice.y = coord.data[slice.list,3]
# names(slice.y) = coord.data[,1]

# slice.y = c(3537.057, 3298.302, 3061.7, 2823.879, 2587.02, 2349.808, 2316.3012, 2238.7497, 2112.863, 2004.5795,
#         1879.014, 1776.3436, 1651.489, 1544.5214, 1418.22100000001, 1314.4924, 1183.591, 1083.7055, 953.428, 852.6411, 756.0486, 718.235000000001, 480.813999999998,
#         245.392999999996, 12.7920000000013, -227.096000000005)
# slice.list = c("314","315","316","317","318","319","bank_1", "bank_2", "320", "bank_3", 
#                "321","bank_4", "322","bank_5", "323","bank_6", "324","bank_7", "325", "bank_8", "bank_9", "326", "327", 
#                "328", "329", "330")

# slice.y =  c(3300, 2316.3012, 2004.5795, 1544.5214)
# slice.list = c("northBC","bank_1", "bank_3", "bank_5")
# slice.list = c("River_upstream","River_north", "River_middle", "River_south")
# # slice.list = paste("River_",slice.list,sep="")
# 
# names(slice.y)= slice.list
# nslice = length(slice.y)
# 
# 
# 
# face.y = y[cell.ids.y[face.cell.ids.final]]
# for (islice in slice.list[nslice:1]) #from bottom up 330, 329 ...
# { 
#   face.cell = face.cell.ids.final[which(face.y<slice.y[islice])]
#   face.ids = face.ids.final[which(face.y<slice.y[islice])]
#   
#   face.cell.ids.final = face.cell.ids.final[which(face.y>=slice.y[islice])]
#   face.ids.final = face.ids.final[which(face.y>=slice.y[islice])]
#   face.y = face.y[which(face.y>=slice.y[islice])]
#   
#   #write region below islice with name of islice, i.e. "River_318" includes region between "318" and " 319"
#   if(length(face.cell)>0)
#   {
#     h5createGroup(fname_material_h5,paste("Regions/",islice,sep=''))
#     h5write(face.cell,fname_material_h5,paste("Regions/",islice,"/Cell Ids",sep=''),level=0) 
#     h5write(face.ids,fname_material_h5,paste("Regions/",islice,"/Face Ids",sep=''),level=0)
#     
#   }
# }






H5close()

save(list=ls(),file=fname_material_r)
