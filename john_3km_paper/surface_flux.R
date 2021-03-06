rm(list=ls())
library(rhdf5)
h5.output = "/files3/pin/simulations/reTest7_newRingold_2010_2015_6h/pflotran_bigplume_newRingold_2010_2015_6h.h5"
h5.material = "/files3/pin/simulations/reTest7_newRingold_2010_2015_6h/bigplume_4mx4mxhalfRes_material_mapped_newRingold.h5"

dir = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation/"
h5.output = paste(dir,"pflotran_bigplume.h5",sep="")
h5.material = paste(dir,"bigplume_4mx4mxhalfRes_material_mapped_newRingold_subRiverGradient.h5",sep="")


start.time = 0
end.time = 52560
times = seq(start.time,end.time,120)
ntime = length(times)


real.start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT")
real.time = real.start.time+times*3600

nx = 225
ny = 400
nz = 40

west = -450.0
east = 450.0
south = -800.0
north = 800.0
bottom = 90.0
top = 110.0

dx = rep((east-west)/nx,nx)
dy = rep((north-south)/ny,ny)
dz = rep((top-bottom)/nz,nz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz

river.face.cell = h5read(h5.material,"/Regions/River/Cell Ids")
## river.face.id = h5read(h5.material,"/Regions/River/Face Ids")
## river.face.cell = river.face.cell[which(river.face.id<=2)]

river.face.cell = unique(river.face.cell)
nface = length(river.face.cell)
river.face.cell.index = array(NA,c(nface,3))
colnames(river.face.cell.index) = c("x","y","z")

river.face.cell.index[,"z"] = (river.face.cell-1) %/% (nx*ny)+1
river.face.cell.index[,"y"] = (river.face.cell-(river.face.cell.index[,"z"]-1)*nx*ny-1) %/% nx+1
river.face.cell.index[,"x"] = river.face.cell-(river.face.cell.index[,"z"]-1)*nx*ny-
                          (river.face.cell.index[,"y"]-1)*nx

flux = array(NA,c(ntime,nface))
for (itime in 1:ntime)
{
    print(itime)
    group  = paste("/Time:  ",formatC(times[itime],digits=5,format="E")," h",sep="")

    qlx = h5read(h5.output,paste(group,"/Liquid X-Velocity [m_per_h]",sep=""))
    qly = h5read(h5.output,paste(group,"/Liquid Y-Velocity [m_per_h]",sep=""))
    qlz = h5read(h5.output,paste(group,"/Liquid Z-Velocity [m_per_h]",sep=""))        
    
    flux[itime,] = (qlx[river.face.cell.index[,c("z","y","x")]]^2+ qly[river.face.cell.index[,c("z","y","x")]]^2+
           qlz[river.face.cell.index[,c("z","y","x")]]^2)^0.5

    H5close()
}

vertical.sum.flux = array(NA,c(ntime,ny))
for (iy in 1:ny)
{
    vertical.sum.flux[,iy] = rowSums(flux[,which(river.face.cell.index[,"y"]==iy)])

}

save(list=ls(),file=paste(dir,"flux_profile_average.r",sep=""))
