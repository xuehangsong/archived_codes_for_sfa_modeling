rm(list=ls())
library(rhdf5)

map_h5file = "map/map_east_pressure.h5"
default_output = "default/pflotran.h5"
HH_file = "default/east_sin.txt"
HH_grad = c(0,0.005,0.0)

air_pressure = 101325
gravity = 9.8068
water_density = 997

x = h5read(default_output,"/Coordinates/X [m]")
y = h5read(default_output,"/Coordinates/Y [m]")
z = h5read(default_output,"/Coordinates/Z [m]")

dx = diff(x)
dy = diff(y)
dz = diff(z)

nx = length(dx)
ny = length(dx)
nz = length(dz)

x = x[-(nx+1)]+dx*0.5
y = y[-(ny+1)]+dy*0.5
z = z[-(nz+1)]+dz*0.5

cells = expand.grid(1:nx,1:ny,1:nz)
cells_coord= expand.grid(x,y,z)

east_cells = which(cells[,1] == nx)
ncells = length(east_cells)
map_dataset = cbind(1:ncells,east_cells)


HH = read.table(HH_file)
HH = as.matrix(HH)
ntime = dim(HH)[1]
HH_grad = t(replicate(ntime,HH_grad))    

pressure_dataset = c()
for (icell in east_cells)
{

    temp_coord = as.numeric(cells_coord[icell,])
    temp_coord[1] = temp_coord[1]+dx[nx]*0.5
    temp_coord = t(replicate(ntime,temp_coord))

    pressure_dataset = cbind(
        pressure_dataset,
        (air_pressure + gravity*water_density*
         (rowSums((temp_coord--HH[,2:4])*HH_grad)+
             HH[,4]-temp_coord[,3]))
    )
}

times_dataset = HH[,1]/3600



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
h5writeAttribute(attr = 'h', h5obj = h5gid, name = 'Time Units')
h5writeAttribute(attr = 1, h5obj = h5gid, name = 'Transient')

H5Gclose(h5gid)
H5Fclose(h5fid)


H5close()
print("Hello World")


jpeg(paste("figures/interpolated_pressure.jpg",sep=''),width=6,height=5,units='in',res=300,quality=100)
colors = rainbow(200)
plot(HH[,1]/3600,HH[,4],xlim=c(0,1),xlab="Time (h)",
     ylab = "Pressure head (m)",
     ylim=c(0.8,2.5),type="l")
for (icell in 1:ncells)
{
    lines(times_dataset,(pressure_dataset[,icell]-air_pressure)/gravity/water_density,col=colors[icell])
}    
lines(HH[,1]/3600,HH[,4],xlim=c(0,1),
     ylim=c(0.5,2.5),col="black",lwd=5)

legend("topright",
       c("Reference pressure","Interpolated pressures"),
       lwd=2,bty="n",
       col=c("black","red"))
dev.off()
