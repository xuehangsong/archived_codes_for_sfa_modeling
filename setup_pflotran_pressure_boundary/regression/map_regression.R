rm(list=ls())
library(rhdf5)

material_h5 = "hete/543_river_setup.h5"
map_h5file = "hete/map_east_pressure.h5"
times = c(0,10,50,100)
east_datum = c(34,39,33,34)


origin = c(0,0,0)
dx = c(10,11,12,13,14)
dy = c(13,12,11,10)
dz = c(15,20,25)

air_pressure = 101325
gravity = 9.8068
water_density = 997

x = origin[1]+cumsum(dx)-dx*0.5
y = origin[2]+cumsum(dy)-dy*0.5
z = origin[3]+cumsum(dz)-dz*0.5

nx = length(dx)
ny = length(dy)
nz = length(dz)

cells = expand.grid(1:nx,1:ny,1:nz)
cells_coord= expand.grid(x,y,z)

east_cells = h5read(material_h5,"Regions/east/Cell Ids")
east_faces = h5read(material_h5,"Regions/east/Face Ids")
east_cells = unique(east_cells)

east_coord = cells_coord[east_cells,]


times_dataset = times
map_dataset = cbind(1:length(east_cells),east_cells)
pressure_dataset = c()
for (icell in east_cells)
{

    temp_coord = as.numeric(cells_coord[icell,])

    pressure_dataset = cbind(
        pressure_dataset,
        (air_pressure + gravity*water_density*
                      (east_datum-temp_coord[3]))
    )
}

if (file.exists(paste(map_h5file,sep=''))) {
    file.remove(paste(map_h5file,sep=''))
} 
h5createFile(paste(map_h5file,sep=''))
h5createGroup(paste(map_h5file,sep=''),"Map")
h5createGroup(paste(map_h5file,sep=''),"Pressure")
h5write(t(map_dataset),paste(map_h5file,sep=''),"Map/Data",level=0)
h5write(times_dataset,paste(map_h5file,sep=''),"Pressure/Times",level=0)
h5write(pressure_dataset,paste(map_h5file,sep=''),"Pressure/Data",level=0)

h5fid = H5Fopen(paste(map_h5file,sep=''))
h5gid = H5Gopen(h5fid,"Pressure")

h5writeAttribute(attr = 1, h5obj = h5gid, name = 'Cell Centered')
h5writeAttribute(attr = "CELL",h5obj = h5gid,name = 'Dimension')
h5writeAttribute(attr = "None",h5obj = h5gid,name = 'Interpolation Method')
h5writeAttribute(attr = 200.0, h5obj = h5gid, name = 'Max Buffer Size')
h5writeAttribute(attr = 'd', h5obj = h5gid, name = 'Time Units')
h5writeAttribute(attr = 1, h5obj = h5gid, name = 'Transient')

H5Gclose(h5gid)
H5Fclose(h5fid)


H5close()
print("Hello World")
