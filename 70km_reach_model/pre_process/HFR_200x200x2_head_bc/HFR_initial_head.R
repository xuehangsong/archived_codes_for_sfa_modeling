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

fname_initial.h5 = "Inputs/HFR_model_200x200x2_head_bc/HFR_H_Initial.h5"
fname.BC.h5 = "Inputs/HFR_model_200x200x2_head_bc/HFR_H_BC.h5"

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

pred.grid.south = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),range_y[1]+grid.y/2) # for South boundary
pred.grid.north = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),range_y[2]-grid.y/2) # for North boundary
pred.grid.west = expand.grid(range_x[1]+grid.x/2,seq(range_y[1]+grid.y/2,range_y[2],grid.y)) # for East boundary
pred.grid.east = expand.grid(range_x[2]-grid.x/2,seq(range_y[1]+grid.y/2,range_y[2],grid.y)) # for West boundary
pred.grid.domain = expand.grid(seq(range_x[1]+grid.x/2,range_x[2],grid.x),
                               seq(range_y[1]+grid.y/2,range_y[2],grid.y)) # for domain
colnames(pred.grid.south)=c('x','y')
colnames(pred.grid.north)=c('x','y')
colnames(pred.grid.east)=c('x','y')
colnames(pred.grid.west)=c('x','y')
colnames(pred.grid.domain)=c('x','y')


## time information
start.time = as.POSIXct("2007-03-28 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

dt = 3600  ##secs
times = seq(start.time,end.time,dt)
ntime = length(times)
time.id = seq(0,ntime-1,dt/3600)  ##hourly boundary, why start from 0h?

# origin.time = as.POSIXct("2007-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S") # starting time should be 1 h early than "2008-1-1 0:0:0" to set the right index in folder/headdata4krige_Plume_2008_2017

## BC.south = array(NA,c(ntime,grid.nx))
## BC.north = array(NA,c(ntime,grid.nx))
## BC.east = array(NA,c(ntime,grid.ny))
## BC.west = array(NA,c(ntime,grid.ny))


BC.south = c()
BC.north = c()
BC.east = c()
BC.west = c()
avail.time.id = c()



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
  
  # jpeg(fname_fig.initialH_idw, width=8,height=8,units='in',res=300,quality=100)
  # plot(selected.wells.df$x, selected.wells.df$y, col = "black", pch = 1, asp=1, xlim = c(x.range[1], x.range[2]))
  head4plot = h.initial
  head4plot[head4plot>200]=200
  image2D(z= head4plot, x= unit_x, y= unit_y, shade=0, rasterImage = T, NAcol = "grey",
          main = paste("Initial Head", initial.time), asp = 1, contour = T, zlim = c(100, 200), xlab = "Easting", ylab = "Northing")
  points(selected.wells.df$x, selected.wells.df$y, col = "white", pch = 1, asp=1)
  polygon(river.geometry$x, river.geometry$y, border = "gray", asp=1)
  
  # dev.off()
# }
       
  ## add constant head to inland bc
  grd.east = data.frame(x = pred.grid.east$x + model_origin[1], y = pred.grid.east$y + model_origin[2])
  grd.west = data.frame(x = pred.grid.west$x + model_origin[1], y = pred.grid.west$y + model_origin[2])
  grd.north = data.frame(x = pred.grid.north$x + model_origin[1], y = pred.grid.north$y + model_origin[2])
  grd.south = data.frame(x = pred.grid.south$x + model_origin[1], y = pred.grid.south$y + model_origin[2])
  
  idw.interp.east = idw(values=selected.wells.df[,"z"],
                   coords = selected.wells.df[,c("x","y")],
                   grid=grd.east,
                   method="shepard",
                   p=2)
  idw.interp.east = as.numeric(unlist(idw.interp.east))
  BC.east = array(idw.interp.east, c(1, ny))
  
  idw.interp.west = idw(values=selected.wells.df[,"z"],
                        coords = selected.wells.df[,c("x","y")],
                        grid=grd.west,
                        method="shepard",
                        p=2)
  idw.interp.west = as.numeric(unlist(idw.interp.west))
  BC.west = array(idw.interp.west, c(1, ny))
  
  idw.interp.north = idw(values=selected.wells.df[,"z"],
                        coords = selected.wells.df[,c("x","y")],
                        grid=grd.north,
                        method="shepard",
                        p=2)
  idw.interp.north = as.numeric(unlist(idw.interp.north))
  BC.north = array(idw.interp.north, c(1, ny))
  
  idw.interp.south = idw(values=selected.wells.df[,"z"],
                        coords = selected.wells.df[,c("x","y")],
                        grid=grd.south,
                        method="shepard",
                        p=2)
  idw.interp.south = as.numeric(unlist(idw.interp.south))
  BC.south = array(idw.interp.south, c(1, ny))
  ## ------------------- Krige------------------------------------------       
  # data = as.geodata(data)
  ##This bins and esimator.type is defined by Xingyuan
  # if (nrow(data$coords)>27) {
  #     # bin1 = variog(data,uvec=c(0,50,100,seq(150,210,30),250,300),trend='cte',bin.cloud=T,estimator.type='modulus')
  #   bin1 = variog(data, uvec=c(0, 500, 1000, 2000, 2500, 3500, 4500, 5500, seq(6000,60000,100)),trend='cte',bin.cloud=T,estimator.type='modulus', option = "cloud")
  # } else {
  #     bin1 = variog(data,uvec=c(0,100,seq(150,210,30),250,300),trend='cte',bin.cloud=T,estimator.type='modulus')
  # }
  # initial.values <- expand.grid(max(bin1$v),seq(300))
  # wls = variofit(bin1,ini = initial.values,fix.nugget=T,nugget = 0.00001,fix.kappa=F,cov.model='exponential')
  
  
  #check the varigram
  # if (itime %% 1000 == 1) {
  # jpeg(filename=paste('figures/Semivariance Time = ',start.time,".jpg", sep=''),
  #      width=5,height=5,units="in",quality=100,res=300)
  # plot(bin1,main = paste('Time = ',start.time, sep=''),col='red', pch = 19, cex = 1, lty = "solid", lwd = 2)
  # text(bin1$u,bin1$v,labels=bin1$n, cex= 0.7,pos = 2)
  # lines(wls)
  # dev.off()
  # print(times[itime])
  # }
  
  
  # ## Generate boundary and initial condition
  # kc.south = krige.conv(data, loc = pred.grid.south, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))    
  # kc.north = krige.conv(data, loc = pred.grid.north, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
  # kc.east = krige.conv(data, loc = pred.grid.east, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
  # kc.west = krige.conv(data, loc = pred.grid.west, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))            
  # 
  # BC.south = rbind(BC.south,kc.south$predict)
  # BC.north = rbind(BC.north,kc.north$predict)
  # BC.east = rbind(BC.east,kc.east$predict)
  # BC.west = rbind(BC.west,kc.west$predict)                        
  
  ## krige initial head
  # if (itime==start.time)
  # {
  #     kc.domain = krige.conv(data, loc = pred.grid.domain, krige = krige.control(obj.m=wls,type.krige='OK',trend.d='cte',trend.l='cte'))
  #     h.initial = as.vector(kc.domain$predict)
  #     dim(h.initial) = c(grid.nx,grid.ny)
  # }
  
  # jpeg(fname_fig.initialH_krige, width=8,height=8,units='in',res=300,quality=100)
  # image2D(z= h.initial, x= unit_x, y= unit_y, shade=0.2, rasterImage = F, NAcol = "white",
  #         main = paste("Initial Head", start.time), asp = 1)
  # dev.off()
  
  
  #     }
  # }
  






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


##=================Generate the BC hdf5 file===========================.

# time.id = as.integer(time.id) 
time.id = as.integer(0) 

if (file.exists(fname.BC.h5)) {
    file.remove(fname.BC.h5)
}

h5createFile(fname.BC.h5)

### write data
h5createGroup(fname.BC.h5,'BC_South')
h5write(time.id, fname.BC.h5,'BC_South/Times',level=0)
h5write(BC.south, fname.BC.h5,'BC_South/Data',level=0)

h5createGroup(fname.BC.h5,'BC_North')
h5write(time.id,fname.BC.h5,'BC_North/Times',level=0)
h5write(BC.north,fname.BC.h5,'BC_North/Data',level=0)

h5createGroup(fname.BC.h5,'BC_East')
h5write(time.id,fname.BC.h5,'BC_East/Times',level=0)
h5write(BC.east,fname.BC.h5,'BC_East/Data',level=0)

h5createGroup(fname.BC.h5,'BC_West')
h5write(time.id,fname.BC.h5,'BC_West/Times',level=0)
h5write(BC.west,fname.BC.h5,'BC_West/Data',level=0)

### write attribute
fid = H5Fopen(fname.BC.h5)
h5g.south = H5Gopen(fid,'/BC_South')
h5g.north = H5Gopen(fid,'/BC_North')
h5g.east = H5Gopen(fid,'/BC_East')
h5g.west = H5Gopen(fid,'/BC_West')


h5writeAttribute(attr = 1.0, h5obj = h5g.south, name = 'Cell Centered')
h5writeAttribute(attr = 'X', h5obj = h5g.south, name = 'Dimension')
h5writeAttribute(attr = grid.x, h5obj = h5g.south, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g.south, name = 'Max Buffer Size')
h5writeAttribute(attr = range_x[1], h5obj = h5g.south, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g.south, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g.south, name = 'Transient')


h5writeAttribute(attr = 1.0, h5obj = h5g.north, name = 'Cell Centered')
h5writeAttribute(attr = 'X', h5obj = h5g.north, name = 'Dimension')
h5writeAttribute(attr = grid.x, h5obj = h5g.north, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g.north, name = 'Max Buffer Size')
h5writeAttribute(attr = range_x[1], h5obj = h5g.north, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g.north, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g.north, name = 'Transient')


h5writeAttribute(attr = 1.0, h5obj = h5g.east, name = 'Cell Centered')
h5writeAttribute(attr = 'Y', h5obj = h5g.east, name = 'Dimension')
h5writeAttribute(attr = grid.y, h5obj = h5g.east, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g.east, name = 'Max Buffer Size')
h5writeAttribute(attr = range_y[1], h5obj = h5g.east, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g.east, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g.east, name = 'Transient')


h5writeAttribute(attr = 1.0, h5obj = h5g.west, name = 'Cell Centered')
h5writeAttribute(attr = 'Y', h5obj = h5g.west, name = 'Dimension')
h5writeAttribute(attr = grid.y, h5obj = h5g.west, name = 'Discretization')
h5writeAttribute(attr = 200.0, h5obj = h5g.west, name = 'Max Buffer Size')
h5writeAttribute(attr = range_y[1], h5obj = h5g.west, name = 'Origin')
h5writeAttribute(attr = 'h', h5obj = h5g.west, name = 'Time Units')
h5writeAttribute(attr = 1.0, h5obj = h5g.west, name = 'Transient')


H5Gclose(h5g.south)
H5Gclose(h5g.north)
H5Gclose(h5g.east)
H5Gclose(h5g.west)
H5Fclose(fid)
