rm(list = ls())
library(rhdf5)
library(scatterplot3d)
source("~/repos/sbr-river-corridor-sfa/1600m_3d_model.R")
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
fname = "3dmodel/real_river_1600m_material.h5"

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
#cell.ids = array(as.integer(cell.ids),c(nx,ny,nz))
#face.ids = array(as.integer(face.ids),c(nx,ny,nz))
face.ids.final = as.integer(face.ids.final)
face.cell.ids.final = as.integer(face.cell.ids.final)

face.ids.final = face.ids.final[order(face.cell.ids.final)]
face.cell.ids.final = sort(face.cell.ids.final)

jpeg('river_face_3d.jpg',width=8,height=7.4,units='in',res=300,quality=100)
scatterplot3d(x[cell.ids.x[face.cell.ids.final]],
              y[cell.ids.y[face.cell.ids.final]],
              z[cell.ids.z[face.cell.ids.final]],
              ## xlim=c(0,nx),
              ## ylim=c(0,ny),
              ## zlim=c(0,nz),
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

save(list=c("face.cell.ids.final",
    "face.ids.final"),file="real_river/face.1600m.r")

face.types = as.integer(names(table(face.ids.final)))
h5createGroup(fname,"Regions")
for (itype in face.types)
{
    h5createGroup(fname,paste("Regions/River_",itype,sep=""))
    h5write(face.cell.ids.final[which(face.ids.final==itype)],
            fname,paste("Regions/River_",itype,"/Cell Ids",sep=""),level=0)
    h5write(face.ids.final[which(face.ids.final==itype)],
            fname,paste("Regions/River_",itype,"/Face Ids",sep=""),level=0)
    
}
    


H5close()
