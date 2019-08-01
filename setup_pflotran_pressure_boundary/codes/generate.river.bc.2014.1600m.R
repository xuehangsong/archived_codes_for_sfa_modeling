rm(list=ls())
library(rhdf5)

air_pressure = 101325
gravity = 9.8068
water_density = 998.2 #997


load("real_river/pressure1.r")
source("~/repos/sbr-river-corridor-sfa/1600m_3d_model.R")
load(file="real_river/cfd.1600m.river.r")
load(file="real_river/face.1600m.r")

cfd.1600m.riverbed = array(cfd.1600m.riverbed[,3],c(nx,ny))

model.cells = expand.grid(1:nx,1:ny,1:nz)


face.type = sort(as.integer(names(table(face.ids.final))))
ntime =720
pressure.dataset = c()
for (itime in 1:ntime)
{
    print(itime)
    load(file=paste("real_river/pressure_surface",itime,".r",sep=""))
    pressure.surface = array(pressure.surface,c(nx,ny))

    center.pressure = pressure.surface[as.matrix(model.cells[face.cell.ids.final,1:2])]+
        air_pressure+gravity*water_density*(
            z[as.numeric(model.cells[face.cell.ids.final,3])]-
            cfd.1600m.riverbed[as.matrix(model.cells[face.cell.ids.final,1:2])])
    

    face.pressure = center.pressure
    
    type.index = which(face.ids.final==5)
    face.pressure[type.index] = face.pressure[type.index]-
        0.5*dz[model.cells[face.cell.ids.final[type.index],3]]

    type.index = which(face.ids.final==6)
    face.pressure[type.index] = face.pressure[type.index]+
        0.5*dz[model.cells[face.cell.ids.final[type.index],3]]

    pressure.dataset = cbind(pressure.dataset,face.pressure)
}


save(pressure.dataset,file="real_river/pressure.dataset.r")
stop()

fname = "3dmodel/river_bc_2014_1600m.h5"
if(file.exists(fname)) {file.remove(fname)}
h5createFile(fname)
for (itype in face.type)
{
    type.index = which(face.ids.final==itype)
    
    h5createGroup(fname,paste("Map_",itype,sep=""))
    data = cbind(1:length(type.index),face.cell.ids.final[type.index])
    h5write(t(data),fname,paste("Map_",itype,"/Data",sep=""),level=0)

    
    h5createGroup(fname,paste("Pressure_",itype,sep=""))
    times = 1:ntime-1
    h5write(times,fname,paste("Pressure_",itype,"/Times",sep=""),level=0)
    data = t(pressure.dataset[type.index,])
    h5write(data,fname,paste("Pressure_",itype,"/Data",sep=""),level=0)        


    h5fid = H5Fopen(paste(fname,sep=''))
    h5gid = H5Gopen(h5fid,paste("Pressure_",itype,sep=""))
    h5writeAttribute(attr = 'h', h5obj = h5gid, name = 'Time Units')

    H5Gclose(h5gid)
    H5Fclose(h5fid)
}
H5close()
