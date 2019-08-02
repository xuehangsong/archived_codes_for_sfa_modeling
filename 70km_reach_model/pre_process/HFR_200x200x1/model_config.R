
setwd("/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/")
paste("Working dir: ", getwd())
rm(list=ls())

install.packages("pacman")
pacman::p_load(fields, AtmRay, maptools, raster, plot3D, rhdf5, scatterplot3d, akima, rgl, gtools, sp, ggplot2, 
               phylin, geoR, xts, signal, formatR) 

# geoframework data
fname_hanford = "data/geoFramework/hanford.asc"
fname_basalt= "data/geoFramework/top_of_basalt.asc"
fname_ringold_a= "data/geoFramework/ringold_a.asc"
fname_ringold_e= "data/geoFramework/ringold_e.asc"
fname_ringold_lm= "data/geoFramework/ringold_lm.asc"
fname_cold_creek= "data/geoFramework/cold_creek.asc"
fname_taylor_flats= "data/geoFramework/taylor_flats.asc"
fname_river_bath = "data/geoFramework/river_bathymetry_20m.asc"
# mass1 data
fname_mass1_coord = "data/MASS1/coordinates.csv"
fname_mass1_pts = "data/MASS1/transient_1976_2016/"
# well data
fname_mvAwln = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/mvAwln.csv"
fname_mvAwln_id = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/mvAwln_wellID_updated.csv"
fname_manual_wells_ids = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/HYDRAULIC_HEAD_MV_WellID.csv"
fname_manual_wells = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/HYDRAULIC_HEAD_MV.csv"
fname_USGS_wells = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/Burns_well_data.csv"
fname_USGS_wells_ids = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/Burns_well_attributes.csv"
fname_SFA_wells = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/300A_Well_Data/"
fname_SFA_wells_ids = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/300A_well_coord.csv"
fname_SFA_wells_all = "~/Dropbox/PNNL/Projects/Reach_scale_model/data/well_data/SFA_all_wells.csv"
#river
fname_river.geo = "data/river_geometry_manual.csv"

# if statement
is.plot = F
is.smooth = T

imodel=c("200x200x1")
## output figures
fname_fig.basalt2d = "figures/basalt2d.jpg"
fname_fig.hanford2d = "figures/hanford2d.jpg"
fname_fig.basalt2d.model = paste("figures/basalt2d_model_", imodel, ".jpg", sep = "")
fname_fig.hanford2d.model = paste("figures/hanford2d_model_", imodel, ".jpg", sep = "")
fname_fig.ringold_a_2d = "figures/ringold_a_2d.jpg"
fname_fig.ringold_a_2d.model = paste("figures/ringold_a_2d_model_", imodel, ".jpg", sep = "")
fname_fig.ringold_e_2d = "figures/ringold_e_2d.jpg"
fname_fig.ringold_e_2d.model = paste("figures/ringold_e_2d_model_", imodel, ".jpg", sep = "")
fname_fig.ringold_lm_2d = "figures/ringold_lm_2d.jpg"
fname_fig.ringold_lm_2d.model = paste("figures/ringold_lm_model_", imodel, ".jpg", sep = "")
fname_fig.cold_creek_2d = "figures/cold_creek_2d.jpg"
fname_fig.cold_creek_2d.model = paste("figures/creek_2d_model_", imodel, ".jpg", sep = "")
fname_fig.taylor_flats_2d = "figures/taylor_flats_2d.jpg"
fname_fig.taylor_flats_2d.model = paste("figures/taylor_flats_2d_model_", imodel, ".jpg", sep = "")
fname_fig.river_bath_2d = "figures/river_bath_2d.jpg"
fname_fig.river_bath_2d.model = paste("figures/river_bath_2d_model_", imodel, ".jpg", sep = "")
fname_fig.surface3d=paste("figures/surface_cell_3d_", imodel, ".jpg", sep = "")
fname_fig.surface2d=paste("figures/surface_cell_2d_", imodel, ".jpg", sep = "")
fname_fig.grids = paste("figures/grids_", imodel, ".jpg", sep = "")
fname_fig.river.mass1 = paste("figures/river.mass1_", imodel, ".jpg", sep = "")
fname_fig.initialH_idw = paste("figures/initial_head_", imodel, ".jpg", sep = "")

# R object files
fname_geoFramework.r = paste("results/geoframework_", imodel, ".r", sep = "")
fname_ascii.r = "results/ascii.r"
fname_model_inputs.r = paste("results/model_inputs_", imodel, ".r", sep = "")
fname_material_r= paste("results/HFR_material_", imodel, ".r", sep = "")
fname_wells.r = "results/well_compiled_wl_data.r"
fname.selected.wells.df = "results/selected.wells.df_2007-01-01.r"
fname_mass1_xts = "results/mass.data.xts.r"
fname_mass1_data.r = "results/mass.data.r"

# PFLOTRAN input files
fname_material_h5 = paste("Inputs/HFR_model_", imodel, "/HFR_material_river.h5", sep = "")
fname_initial.h5 = paste("Inputs/HFR_model_", imodel, "/HFR_H_Initial.h5", sep = "")
fname_DatumH = "Inputs/river_bc/bc_1w_smooth/DatumH_Mass1_"
fname_Gradients = "Inputs/river_bc/bc_1w_smooth/Gradients_Mass1_"
fname_pflotran.in = paste("Inputs/HFR_model_", imodel, "/pflotran_", imodel, "_6h_bc.in", sep = "")

# # input deck names
# fname_material.h5.in = c("HFR_material_river.h5")
# fname_H.initial.h5.in = c("HFR_H_Initial.h5")
# fname_bc_dir = "bc_6h_smooth/"
# fname.DatumH.in = c("DatumH_Mass1_")
# fname.Gradient.in = c("Gradients_Mass1_")

proj_to_model <- function(origin,angle,coord)
{
  output = array(NA,dim(coord))
  rownames(output) = rownames(coord)
  colnames(output) = colnames(coord)    
  output[,1] = (coord[,1]-origin[1])*cos(angle)+(coord[,2]-origin[2])*sin(angle)
  output[,2] = (coord[,2]-origin[2])*cos(angle)-(coord[,1]-origin[1])*sin(angle)
  return(output)
}   


model_to_proj <- function(origin,angle,coord)
{
  output = array(NA,dim(coord))
  rownames(output) = rownames(coord)
  colnames(output) = colnames(coord)    
  output[,1] = origin[1]+coord[,1]*cos(angle)-coord[,2]*sin(angle)
  output[,2] = origin[2]+coord[,1]*sin(angle)+coord[,2]*cos(angle)
  return(output)
}   

#grid cell size
idx = 200
idy = 200
idz = 1

# rotating angle of model
angle = 0

#hanford reach
# model_origin = c(538000, 97000)
model_origin = c(551600, 104500)

xlen = 60*1000 #x boundary length
ylen = 60*1000 #y boundary length

zlen = 200 #z boundary length
# zlen = 100 #z boundary length

# model origin
z0 = 0 
x0 = model_origin[1]
y0 = model_origin[2]

dx = rep(idx, xlen/idx)
dy = rep(idy, ylen/idy)
dz = rep(idz, zlen/idz)

nx = length(dx)
ny = length(dy)
nz = length(dz)

#create x,y,z coordinates for each cell center
x = cumsum(dx)-0.5*dx
y = cumsum(dy)-0.5*dy
z = z0 + cumsum(dz)-0.5*dz

#min and max x,y,z coord
range_x = c(x[1]-0.5*dx[1], x[length(x)]+0.5*dx[length(x)])
range_y = c(y[1]-0.5*dy[1], y[length(y)]+0.5*dy[length(y)])
range_z = c(z[1]-0.5*dz[1], z[length(z)]+0.5*dz[length(z)])

##dimension of model domain in CRS
west_x = x0
east_x = x0 + xlen
south_y = y0
north_y = y0 + ylen

# interpolate model coordinates 
cells_model = expand.grid(x,y) # expand grid to include all x-y coordinates
cells_proj = model_to_proj(model_origin,angle,cells_model) # convert model coord. to proj. coord.

unit_x = sort(as.numeric(names(table(cells_proj[, 1]))))
unit_y = sort(as.numeric(names(table(cells_proj[, 2]))))

save(list = ls(), file = fname_model_inputs.r)
print(paste("model inputs is save in ", getwd(), "/", fname_model_inputs.r, sep=""))

R.Version()
