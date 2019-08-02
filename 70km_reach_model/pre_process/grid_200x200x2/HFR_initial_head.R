## #This file is used for calculating transient boundary conditions
## #using universal kriging 

###cov_model_sets = c('gaussian','wave','exponential','spherical')
###drift_sets = c(0,1)

setwd("/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/")

# rm(list=ls())
library(geoR)
library(rhdf5)
library(ggplot2)
# library(gstat)
library(sp)
library(maptools)
library(phylin)
##------------INPUT----------------##
# source("codes/300A_parameters.R")
H5close()
options(geoR.messages=FALSE)
# input_folder = 'data/headdata4krige_Plume_2008-2017/'
fname_geoFramework.r = "results/geoframework_200x200x2.r"
fname_river.geo = "data/river_geometry_manual.csv"

# fname_mvAwln = "/Users/shua784/Dropbox/PNNL/People/From_Patrick/SQL/mvAwln.csv"
# fname_mvAwln_id = "/Users/shua784/Dropbox/PNNL/People/From_Patrick/SQL/mvAwln_wellID_updated.csv"
# 
# fname_manual_wells_ids = "/Users/shua784/Dropbox/PNNL/People/From_Patrick/SQL/HYDRAULIC_HEAD_MV_WellID.csv"
# fname_manual_wells = "/Users/shua784/Dropbox/PNNL/People/From_Patrick/SQL/HYDRAULIC_HEAD_MV.csv"
# 
# fname_USGS_wells = "/Users/shua784/Dropbox/PNNL/People/from_Erick/Burns_well_data.csv"
# fname_USGS_wells_ids = "/Users/shua784/Dropbox/PNNL/People/from_Erick/Burns_well_attributes.csv"
# 
# fname_SFA_wells = "/Users/shua784/Dropbox/PNNL/People/Velo/300A_Well_Data/"
# fname_SFA_wells_ids = "/Users/shua784/Dropbox/PNNL/People/Velo/300A_well_coord.csv"
# fname_SFA_wells_all = "/Users/shua784/Dropbox/PNNL/People/Velo/SFA_all_wells.csv"

is.plot = F

##--------------OUTPUT---------------------##

fname_initial.h5 = "Inputs/HFR_model_200x200x2/HFR_H_Initial.h5"
# BC.h5 = "Inputs/HFR_H_BC.h5"

# fname_head.bc.r= "results/HFR_head_BC.r"
# fname_wells.r = "results/well_compiled_wl_data.r"
# fname_fig.initalH_contour = "figures/initial_head_150m.jpg"
# fname_fig.initialH_krige = "figures/initial_head_krige.jpg"
fname_fig.initialH_idw = "figures/initial_head_200x200x2.jpg"
fname.selected.wells.df = "results/selected.wells.df_2007-01-01.r"

# load(fname_geoFramework.r)

initial.time = as.POSIXct("2007-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

## for grids
grid.x = idx
grid.y = idy
grid.nx = nx
grid.ny = ny

# pred.grid.south = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),range_y[1]+grid.y/2) # for South boundary
# pred.grid.north = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),range_y[2]-grid.y/2) # for North boundary
# pred.grid.east = expand.grid(range_x[1]+grid.x/2,seq(range_y[1]+grid.y/2,range_y[2],grid.y)) # for East boundary
# pred.grid.west = expand.grid(range_x[2]-grid.x/2,seq(range_y[1]+grid.y/2,range_y[2],grid.y)) # for West boundary
pred.grid.domain = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),
                               seq(range_y[1]+grid.y/2,range_y[2],grid.y)) # for domain
# colnames(pred.grid.south)=c('x','y')
# colnames(pred.grid.north)=c('x','y')
# colnames(pred.grid.east)=c('x','y')
# colnames(pred.grid.west)=c('x','y')
colnames(pred.grid.domain)=c('x','y')


## time information
# start.time = as.POSIXct("2010-02-27 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
# end.time = as.POSIXct("2010-02-28 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

# dt = 3600  ##secs
# times = seq(start.time,end.time,dt)
# ntime = length(times)
# time.id = seq(0,ntime-1,dt/3600)  ##hourly boundary, why start from 0h?

# origin.time = as.POSIXct("2007-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S") # starting time should be 1 h early than "2008-1-1 0:0:0" to set the right index in folder/headdata4krige_Plume_2008_2017

## BC.south = array(NA,c(ntime,grid.nx))
## BC.north = array(NA,c(ntime,grid.nx))
## BC.east = array(NA,c(ntime,grid.ny))
## BC.west = array(NA,c(ntime,grid.ny))


# BC.south = c()
# BC.north = c()
# BC.east = c()
# BC.west = c()
# avail.time.id = c()



range.xcoods = c(model_origin[1], model_origin[1] + xlen)
range.ycoods = c(model_origin[2], model_origin[2] + ylen)



##---------------------------select wells with data at each time stamp-----------------------
  
  load(fname.selected.wells.df)


# if (dim(selected.wells.df)[1]>2) {
  ## ---------------use inverse distance interpolation------------------
 
  grd = expand.grid(unit_x, unit_y)
  
  # save(grd, file = "results/model_grids.r")
  
  idw.interp = idw(values=selected.wells.df[,"z"],
                   coords = selected.wells.df[,c("x","y")],
                   grid=grd,
                   method="shepard",
                   p=2)
  idw.interp = as.numeric(unlist(idw.interp))
  
  h.initial = array(idw.interp, c(nx, ny))
  
  river.geometry = read.csv(fname_river.geo)
  
  river.geometry = river.geometry[, 2:3]
  
  # itime = as.POSIXct("2007-04-01 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
  
  jpeg(fname_fig.initialH_idw, width=8,height=8,units='in',res=300,quality=100)
  # plot(selected.wells.df$x, selected.wells.df$y, col = "black", pch = 1, asp=1, xlim = c(x.range[1], x.range[2]))
  head4plot = h.initial
  head4plot[head4plot>200]=200
  image2D(z= head4plot, x= unit_x, y= unit_y, shade=0, rasterImage = T, NAcol = "grey",
          main = paste("Initial Head", initial.time), asp = 1, contour = T, zlim = c(100, 200), xlab = "Easting", ylab = "Northing")
  points(selected.wells.df$x, selected.wells.df$y, col = "white", pch = 1, asp=1)
  polygon(river.geometry$x, river.geometry$y, border = "gray", asp=1)
  
  dev.off()
# }
       
 

##----------------import initial head from Hanford_Reach_2007_Initial.h5------------------

# old_ini = h5read("Inputs/test_2007_age/Hanford_Reach_2007_Initial.h5", name = "Initial_Head/Data")
# 
# old_ini = t(old_ini)
# 
# old_ini.list = list(x = seq(from = 538000, to = 614000, by = 250), y = seq(from = 97000, to = 164000, by = 250), z = old_ini)
# 
# new_ini = interp.surface(old_ini.list, cells_proj)
# 
# new_ini[which(is.na(new_ini))] = 110
# 
# new_ini = array(new_ini, c(nx,ny))
# 
# image2D(z= new_ini, x= unit_x, y= unit_y, shade=0.2, rasterImage = F, NAcol = "white", border = NA, resfac = 3,
#         main = c("new_ini"), asp = 1)
# image2D(z= old_ini, x = seq(from = 538000, to = 614000, by = 250), y = seq(from = 97000, to = 164000, by = 250), shade=0.2, rasterImage = F, NAcol = "white",
#         main = c("old_ini"), asp = 1)
# 
# fname_initial.h5 = "Inputs/HFR_model_200m/HFR_H_Initial_new.h5"
# 
# if (file.exists(fname_initial.h5)) {
#   file.remove(fname_initial.h5)
# }
# h5createFile(fname_initial.h5)
# h5createGroup(fname_initial.h5,'Initial_Head')
# 
# h5write(t(new_ini),fname_initial.h5, ## why tranpose? to match HDF5 format
#         'Initial_Head/Data',level=0)
# fid = H5Fopen(fname_initial.h5)
# h5g = H5Gopen(fid,'/Initial_Head')
# h5writeAttribute(attr = 1.0, h5obj = h5g, name = 'Cell Centered')
# h5writeAttribute.character(attr = "XY", h5obj = h5g, name = 'Dimension')
# h5writeAttribute(attr = c(200, 200), h5obj = h5g, name = 'Discretization')
# h5writeAttribute(attr = 500.0, h5obj = h5g, name = 'Max Buffer Size')
# h5writeAttribute(attr = c(0, 0), h5obj = h5g, name = 'Origin') 
# H5Gclose(h5g)
# H5Fclose(fid)
##-----------------------------------------------------------------------------------------------





# time.id = avail.time.id


##Generate the initial condition hdf5 file for the domain.
if (file.exists(fname_initial.h5)) {
    file.remove(fname_initial.h5)
}
h5createFile(fname_initial.h5)
h5createGroup(fname_initial.h5,'Initial_Head')

h5write(t(h.initial),fname_initial.h5, ## why tranpose? to match HDF5 format
        'Initial_Head/Data',level=0)
fid = H5Fopen(fname_initial.h5)
h5g = H5Gopen(fid,'/Initial_Head')
h5writeAttribute(attr = 1.0, h5obj = h5g, name = 'Cell Centered')
h5writeAttribute.character(attr = "XY", h5obj = h5g, name = 'Dimension')
h5writeAttribute(attr = c(idx, idy), h5obj = h5g, name = 'Discretization')
h5writeAttribute(attr = 500.0, h5obj = h5g, name = 'Max Buffer Size')
h5writeAttribute(attr = c(0, 0), h5obj = h5g, name = 'Origin')
H5Gclose(h5g)
H5Fclose(fid)

