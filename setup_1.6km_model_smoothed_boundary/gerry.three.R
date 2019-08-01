rm(list = ls())
library(rhdf5)
library(scatterplot3d)

fname = "bigplume_4mx4mxhalfRes_material_mapped.h5"
fname = "Plume_400x400x20_2mRes_material.h5"

## nx = 225
## ny = 400
## nz = 40

## west = -450.0
## east = 450.0
## south = -800.0
## north = 800.0
## bottom = 90.0
## top = 110.0


nx = 200
ny = 200
nz = 40

west = 0.0
east = 400.0
south = 0.0
north = 400.0
bottom = 90.0
top = 110.0


dx = rep((east-west)/nx,nx)
dy = rep((north-south)/ny,ny)
dz = rep((top-bottom)/nz,nz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz


cell.ids = h5read(fname,"Materials/Cell Ids")
#cell.ids = array(cell.ids,c(nx,ny,nz))
cell.ids.z = (cell.ids-1)%/%(nx*ny)
cell.ids.y = (cell.ids-1-nx*ny*cell.ids.z)%/%nx
cell.ids.x = cell.ids-1-nx*cell.ids.y-nx*ny*cell.ids.z
cell.ids.x = cell.ids.x+1
cell.ids.y = cell.ids.y+1
cell.ids.z = cell.ids.z+1

material.ids = h5read(fname,"Materials/Material Ids")
material.ids = array(material.ids,c(nx,ny,nz))

face.ids = array(rep(0,nx*ny*nz),c(nx,ny,nz))
face.ids.final = vector()
face.cell.ids.final = vector()

#xdirection
if (nx>1) {
diff.material.ids = apply(material.ids,c(2,3),diff)

if (any(diff.material.ids==4)) {
    face.ids[ which(diff.material.ids==4,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==4,arr.ind=TRUE))[1],
                             c(1,0,0)))
             ] = 1
}

if (any(diff.material.ids==1)) {
    face.ids[ which(diff.material.ids==1,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==1,arr.ind=TRUE))[1],
                             c(1,0,0)))
             ] = 1
}

face.ids.final = c(face.ids.final,face.ids[face.ids==1])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==1])


face.ids[which(diff.material.ids==-4,arr.ind=TRUE)] = 2
face.ids[which(diff.material.ids==-1,arr.ind=TRUE)] = 2

face.ids.final = c(face.ids.final,face.ids[face.ids==2])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==2])


}
#ydirection
if(ny>1) {
diff.material.ids = aperm(apply(material.ids,c(1,3),diff),c(2,1,3))


if (any(diff.material.ids==4)) {
    face.ids[which(diff.material.ids==4,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==4,arr.ind=TRUE))[1],
                             c(0,1,0)))
             ] = 3
}
if (any(diff.material.ids==1)) {
    face.ids[which(diff.material.ids==1,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==1,arr.ind=TRUE))[1],
                             c(0,1,0)))
             ] = 3
}


face.ids.final = c(face.ids.final,face.ids[face.ids==3])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==3])


face.ids[which(diff.material.ids==-4,arr.ind=TRUE)] = 4
face.ids[which(diff.material.ids==-1,arr.ind=TRUE)] = 4


face.ids.final = c(face.ids.final,face.ids[face.ids==4])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==4])


}


#zdirection
if(nz>1){
diff.material.ids = aperm(apply(material.ids,c(1,2),diff),c(2,3,1))

if (any(diff.material.ids==4)) {

    face.ids[which(diff.material.ids==4,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==4,arr.ind=TRUE))[1],
                             c(0,0,1)))
             ] = 5
}


if (any(diff.material.ids==1)) {
    face.ids[which(diff.material.ids==1,arr.ind=TRUE)+
                 t(replicate(dim(which(diff.material.ids==1,arr.ind=TRUE))[1],
                             c(0,0,1)))
             ] = 5
}

face.ids.final = c(face.ids.final,face.ids[face.ids==5])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==5])


face.ids[which(diff.material.ids==-4,arr.ind=TRUE)] = 6
face.ids[which(diff.material.ids==-1,arr.ind=TRUE)] = 6

face.ids.final = c(face.ids.final,face.ids[face.ids==6])
face.cell.ids.final = c(face.cell.ids.final,cell.ids[face.ids==6])

}

##cell.ids = array(as.integer(cell.ids),c(nx,ny,nz))
##face.ids = array(as.integer(face.ids),c(nx,ny,nz))
face.ids.final = as.integer(face.ids.final)
face.cell.ids.final = as.integer(face.cell.ids.final)

face.ids.final = face.ids.final[order(face.cell.ids.final)]
face.cell.ids.final = sort(face.cell.ids.final)


jpeg('river_face_3d.jpg',width=8,height=7.4,units='in',res=300,quality=100)
scatterplot3d(cell.ids.x[face.cell.ids.final],
              cell.ids.y[face.cell.ids.final],
              cell.ids.z[face.cell.ids.final],
              xlim=c(0,nx),
              ylim=c(0,ny),
              zlim=c(0,nz),
              xlab='Rotated southing (m)',
              ylab='Rotated westing (m)',
              zlab='Elevation (m)',
#              pch=river_face_ids_pch,
#              color=river_face_ids_color,
              cex.lab=0.8,
              cex.axis=0.8,
              scale.y=1.0
              )

dev.off()


fname = "New_Plume_400x400x20_2mRes_material.h5"

if (file.exists(fname))
{
    file.remove(fname)
}


cell.ids = as.integer(c(cell.ids))
material.ids = as.integer(c(material.ids))

h5createFile(fname)
h5createGroup(fname,"Materials")
h5write(cell.ids,fname,"Materials/Cell Ids",level=0)
h5write(material.ids,fname,"Materials/Material Ids",level=0)


h5createGroup(fname,"Regions")
h5createGroup(fname,"Regions/River")
h5write(face.cell.ids.final,fname,"Regions/River/Cell Ids",level=0)
h5write(face.ids.final,fname,"Regions/River/Face Ids",level=0)
## a=h5read(fname,"Regions/River/Cell Ids")
## b=h5read(fname,"Regions/River/Face Ids")


face.y = y[cell.ids.y[face.cell.ids.final]]
face.cell.322 = face.cell.ids.final[which(face.y<12.885)]
face.ids.322 = face.ids.final[which(face.y<12.885)]
face.cell.321 = face.cell.ids.final[which(face.y>=12.885 & face.y<=250.9596)]
face.ids.321 = face.ids.final[which(face.y>=12.885 & face.y<=250.9596)]
face.cell.320 = face.cell.ids.final[which(face.y>250.9596)]
face.ids.320 = face.ids.final[which(face.y>250.9596)]

h5createGroup(fname,"Regions/River_322")
h5write(face.cell.322,fname,"Regions/River_322/Cell Ids",level=0)
h5write(face.ids.322,fname,"Regions/River_322/Face Ids",level=0)

h5createGroup(fname,"Regions/River_321")
h5write(face.cell.321,fname,"Regions/River_321/Cell Ids",level=0)
h5write(face.ids.321,fname,"Regions/River_321/Face Ids",level=0)

h5createGroup(fname,"Regions/River_320")
h5write(face.cell.320,fname,"Regions/River_320/Cell Ids",level=0)
h5write(face.ids.320,fname,"Regions/River_320/Face Ids",level=0)


H5close()




jpeg('river_face_3d.jpg',width=8,height=7.4,units='in',res=300,quality=100)
scatterplot3d(cell.ids.x[b],
              cell.ids.y[b],
              cell.ids.z[b],
              xlim=c(0,nx),
              ylim=c(0,ny),
              zlim=c(0,nz),
              xlab='Rotated southing (m)',
              ylab='Rotated westing (m)',
              zlab='Elevation (m)',
#              pch=river_face_ids_pch,
#              color=river_face_ids_color,
              cex.lab=0.8,
              cex.axis=0.8,
              scale.y=1.0
              )

 dev.off()






