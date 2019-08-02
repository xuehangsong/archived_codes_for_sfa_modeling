rm(list=ls())
library(rhdf5)
library(abind)

output.dir = "/Users/song884/remote/reach/Outputs/2007_solute/"
results.dir = "/Users/song884/remote/reach/results/"

river.bed = read.csv(paste(results.dir,"river_cell_coord.csv",sep=""))
river.id = as.numeric(river.bed[,1])
cell.id = as.numeric(river.bed[,2])

h5.files = list.files(out.dir,"h5")

nx = 304
ny = 268
nz = 40
grids = expand.grid(1:nx,1:ny,1:nz)

for (ifile in h5.files)
{
    fid = paste(out.dir,ifile,sep="")
    times = as.character(h5ls(fid)[[1]])
    times = times[grep('Time',times)]


    for (itime in times[10])
    {

        x.flux = h5read(fid,paste(itime,"/Liquid X-Flux Velocities",sep=""))
        x.flux = aperm(x.flux,c(3,2,1))
        west.flux = c(abind(array(x.flux[1,,],c(1,ny,nz)),x.flux,along=1))
        east.flux = c(abind(x.flux,array(x.flux[1,,],c(1,ny,nz)),along=1))        

        y.flux = h5read(fid,paste(itime,"/Liquid Y-Flux Velocities",sep=""))
        y.flux = aperm(y.flux,c(3,2,1))
        south.flux = c(abind(array(y.flux[,1,],c(nx,1,nz)),y.flux,along=2))
        north.flux = c(abind(y.flux,array(y.flux[,1,],c(nx,1,nz)),along=2))        

        z.flux = h5read(fid,paste(itime,"/Liquid Z-Flux Velocities",sep=""))
        z.flux = aperm(z.flux,c(3,2,1))
        bottom.flux = c(abind(array(z.flux[,,1],c(nx,ny,1)),z.flux,along=3))
        top.flux = c(abind(z.flux,array(z.flux[,,1],c(nx,ny,1)),along=3))        
        
        

        west.flux[river.id][which(cell.id==1)]
        east.flux[river.id][which(cell.id==2)]        
        south.flux[river.id][which(cell.id==3)]
        north.flux[river.id][which(cell.id==4)]        
        bottom.flux[river.id][which(cell.id==5)]
        top.flux[river.id][which(cell.id==6)]        

        
    }
stop()

}
