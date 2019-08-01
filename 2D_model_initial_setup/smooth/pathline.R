rm(list = ls())
library(rhdf5)
load("results/material.grid.data")
load("results/obs.xyz")
load("results/mudlayer.depth")
case.name = "short.multi"

obs.time = seq(0,2700,1)
ntime = length(obs.time)
pathline.dt = 1
n.dt = 240
                                        #batch.start.t = seq(336,2400,24)
batch.start.t = seq(336,400,24)
n.batch = length(batch.start.t)

#velocity
load(paste("results/",case.name,".x.velocity",sep=''))
load(paste("results/",case.name,".z.velocity",sep=''))
x.velocity = x.velocity[,,,]
z.velocity = z.velocity[,,,]
material.ids = h5read(paste(case.name,"/Plume_Slice_AdaptiveRes_material.h5",sep=''),"Materials/Material Ids")
material.ids = array(material.ids,c(nx.new,nz.new))
for (itime in 1:ntime)
    {
        print(itime)
        x.velocity[,,itime][material.ids==1] = x.velocity[,,itime][material.ids==1]/0.2
        x.velocity[,,itime][material.ids==4] = x.velocity[,,itime][material.ids==4]/0.43
        x.velocity[,,itime][material.ids==5] = x.velocity[,,itime][material.ids==5]/0.43                
        z.velocity[,,itime][material.ids==1] = z.velocity[,,itime][material.ids==1]/0.2
        z.velocity[,,itime][material.ids==4] = z.velocity[,,itime][material.ids==4]/0.43
        z.velocity[,,itime][material.ids==5] = z.velocity[,,itime][material.ids==5]/0.43                
        
    }
stop()

#face.cells
face.cells = h5read(paste(case.name,"/Plume_Slice_AdaptiveRes_material.h5",sep=''),"Regions/River/Cell Ids")
face.ids = h5read(paste(case.name,"/Plume_Slice_AdaptiveRes_material.h5",sep=''),"Regions/River/Face Ids")
face.cells.group = list()
for(i in 1:6) {
    face.cells.group[[i]] = face.cells[face.ids==i]
}



## bed.cells = unique(face.cells)
## bed.cells.z = (bed.cells-1)%/%nx.new
## bed.cells.x = bed.cells-1-bed.cells.z*nx.new
## bed.cells.z = bed.cells.z+1
## bed.cells.x = bed.cells.x+1

## bed.cells = bed.cells[order(bed.cells.x)]
## bed.cells.z = bed.cells.z[order(bed.cells.x)]
## bed.cells.x = sort(bed.cells.x)

for (i.batch in 1:n.batch)
{

    drift.t = batch.start.t[i.batch]

    n.partical = dim(river.bank)[1]
    partical.loc = array(seq(n.partical*2),c(n.partical,2))

    #on the center of river bed surface
    partical.loc[,1] = x.new[river.bank[,1]]
    partical.loc[,2] = z.new[river.bank[,2]]

    #on the top of river bed surface
#    partical.loc[,1] = x.new[river.bank[,1]]
#    partical.loc[,2] = z.new[river.bank[,2]]+0.025
    
    #in the center of mudlayer
#    partical.loc[,1] = x.new[river.bank[,1]]
#    partical.loc[,2] = z.new[river.bank[,2]]-0.5*mudlayer.depth

    partical.line = array(rep(0,n.partical*2*(n.dt+1)),c(n.partical,2,(n.dt+1)))
    partical.line[,,1] = partical.loc
    break.time = rep(0,n.partical)

    for (i.dt in 1:n.dt) {

        print(i.dt)
#       pathline.t = drift.t+i.dt*pathline.dt
        pathline.t = drift.t+(i.dt-1)*pathline.dt
        
        first.t =  which.min(abs(obs.time-pathline.t))
        second.t = order(abs(obs.time-pathline.t))[2]
        x.velocity.current = x.velocity[,,first.t]+
            (pathline.t-obs.time[first.t])/(obs.time[second.t]-obs.time[first.t])*
                (x.velocity[,,second.t]-x.velocity[,,first.t])
        z.velocity.current = z.velocity[,,first.t]+
            (pathline.t-obs.time[first.t])/(obs.time[second.t]-obs.time[first.t])*
                (z.velocity[,,second.t]-z.velocity[,,first.t])

        x.velocity.point=rep(0,n.partical)
        z.velocity.point=rep(0,n.partical)

        for (i.partical in 1:n.partical) {
            first.x =  which.min(abs(x.new-partical.loc[i.partical,1]))
            second.x =  order(abs(x.new-partical.loc[i.partical,1]))[2]
            first.z =  which.min(abs(z.new-partical.loc[i.partical,2]))
            second.z =  order(abs(z.new-partical.loc[i.partical,2]))[2]

            
            
            if ((partical.loc[i.partical,1]==east.new)||
                (partical.loc[i.partical,1]==west.new)||
                (partical.loc[i.partical,2]==bottom.new)||
                (partical.loc[i.partical,2]==top.new)){                        
            }else{

                x.velocity.point[i.partical] = approx(c(z.new[first.z],z.new[second.z]),
                                    c(approx(c(x.new[first.x],x.new[second.x]),
                                             c(x.velocity.current[first.x,first.z],
                                               x.velocity.current[second.x,first.z]),
                                             partical.loc[i.partical,1],
                                             rule=2)$y,
                                      approx(c(x.new[first.x],x.new[second.x]),
                                             c(x.velocity.current[first.x,second.z],
                                               x.velocity.current[second.x,second.z]),
                                             partical.loc[i.partical,1],
                                             rule=2)$y),
                                    partical.loc[i.partical,2],rule=2)$y      
                
                z.velocity.point[i.partical] = approx(c(z.new[first.z],z.new[second.z]),
                                    c(approx(c(x.new[first.x],x.new[second.x]),
                                             c(z.velocity.current[first.x,first.z],
                                               z.velocity.current[second.x,first.z]),
                                             partical.loc[i.partical,1],
                                             rule=2)$y,
                                      approx(c(x.new[first.x],x.new[second.x]),
                                             c(z.velocity.current[first.x,second.z],
                                               z.velocity.current[second.x,second.z]),
                                             partical.loc[i.partical,1],
                                             rule=2)$y),
                                    partical.loc[i.partical,2],rule=2)$y      


                if(material.ids[which.min(abs(x.new-partical.loc[i.partical,1])),
                                which.min(abs(z.new-partical.loc[i.partical,2]))]==5){
                    partical.loc[i.partical,1] = partical.loc[i.partical,1] +
                        pathline.dt*x.velocity.point[i.partical]
                    partical.loc[i.partical,2] = partical.loc[i.partical,2] +
                        pathline.dt*z.velocity.point[i.partical]

                    if(material.ids[which.min(abs(x.new-partical.loc[i.partical,1])),
                                    which.min(abs(z.new-partical.loc[i.partical,2]))]==1){
                        break.time[i.partical]=i.dt*pathline.dt
                    }
                    
                } else {
                    partical.loc[i.partical,1] = partical.loc[i.partical,1] +
                        pathline.dt*x.velocity.point[i.partical]
                    partical.loc[i.partical,2] = partical.loc[i.partical,2] +
                        pathline.dt*z.velocity.point[i.partical]
                }
            }

            partical.loc[i.partical,1]=max(west.new,partical.loc[i.partical,1])
            partical.loc[i.partical,1]=min(east.new,partical.loc[i.partical,1])
            partical.loc[i.partical,2]=max(bottom.new,partical.loc[i.partical,2])        
            partical.loc[i.partical,2]=min(top.new,partical.loc[i.partical,2])            
            
            
            
        }
        partical.line[,,(i.dt+1)] = partical.loc 

        
    }

    color.index=rainbow(n.partical)
    jpeg(paste("figures/",case.name,i.batch,".pathline.jpg",sep=''),
         width=12,height=4,units="in",res=600,quality=100)
    par(mgp=c(2.1,1,0),mar=c(3.5,3.5,2.1,2.1))
    plot(0,0,
         asp=1.
         )

    image(x.new,z.new,material.ids,
          xlim=c(90,east.new),
          ylim=c(100,top.new),
          xlab='Rotated east-west direction (m)',
          ylab='Elevation (m)',
          main=paste("Injection time : T =",drift.t,"hour"),
          breaks=c(1.5,4.5,5.5),
          col=c("grey","snow2"),
          cex.lab=0.8,
          cex.axis=0.8,
          asp=1.0,
          )

    for (i.partical in 1:n.partical){
        lines(partical.line[i.partical,1,],partical.line[i.partical,2,],col=color.index[i.partical],lwd=0.3)
    }
    points(obs.xyz[,1],obs.xyz[,3],col='red',pch=16)
    dev.off()

#    write.table(break.time,file=paste("results/",case.name,i.batch,".dat",sep=''),col.names=FALSE,row.names=FALSE)
#    save(break.time,file=paste("results/",case.name,i.batch,".dat",sep=''),col.names=FALSE,row.names=FALSE)    
    save(ls()[!ls() %in% c("x.velocity","z.velocity")],file = paste("results/",case.name,i.batch,".data",sep=''))
}
