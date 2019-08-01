library(rhdf5)
west = 0
east = 143.2
south = 0
north = 1
top = 110.0
bottom = 90.0


hanford.threshold = c(-11,-6)
alluvium.threshold = c(-15,-11)

threshold = range(hanford.threshold,alluvium.threshold)

dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
dy = 1.0
dz = c(rev(0.05*1.09505408**(1:25)),rep(0.05,300))

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz

x[c(which.min(x),which.max(x))] = c(0,143.2)
z[c(which.min(z),which.max(z))] = c(90,110)
    

###load("../lhsampling/sampled.perm.2.r")
fname = "../facies/facies.model.4/reference/T3_Slice_material.h5"
material.ids = h5read(fname,"Materials/Material Ids")
material_ids = h5read(fname,"Materials/Material Ids")
material_ids = array(material_ids,c(nx,nz))
combined.perm = rep(0,length(nx*ny*nz))

alluvium.river=NULL
for (ix in 1:nx)
    {
        for (iz in 1:(nz-1))
            {
                if ((material_ids[ix,iz+1]-material_ids[ix,iz])==-5)
                {
                    alluvium.river=rbind(alluvium.river,c(ix,iz))
                    break()
                }
            }
    }
alluvium.river = alluvium.river[order(alluvium.river[,1],alluvium.river[,2]),]



hanford.river=NULL
for (ix in 1:nx)
    {
        for (iz in 1:(nz-1))
            {
                if ((material_ids[ix,iz+1]-material_ids[ix,iz])==-1)
                {
                    hanford.river=rbind(hanford.river,c(ix,iz))
                    break()
                }
            }
    }
##hanford.river = hanford.river[order(hanford.river[,1],hanford.river[,2]),]



##find  alluvium and hanford boundary
alluvium.hanford=NULL
for (ix in 1:nx)
    {
        for (iz in 1:(nz-1))
            {
                if ((material_ids[ix,iz+1]-material_ids[ix,iz])==4)
                {
                    alluvium.hanford=rbind(alluvium.hanford,c(ix,iz))                    
                    break()
                }
            }
    }
alluvium.hanford = alluvium.hanford[order(alluvium.hanford[,1],alluvium.hanford[,2]),]



alluvium.ringold=NULL
for (ix in 1:nx)
    {
        for (iz in 1:(nz-1))
            {
                if ((material_ids[ix,iz+1]-material_ids[ix,iz])==1)
                {
                    alluvium.ringold=rbind(alluvium.ringold,c(ix,iz))
                    break()
                }
            }
    }
alluvium.ringold = alluvium.ringold[order(alluvium.ringold[,1],alluvium.ringold[,2]),]




hanford.ringold=NULL
for (ix in 1:nx)
    {
        for (iz in 1:(nz-1))
            {
                if ((material_ids[ix,iz+1]-material_ids[ix,iz])==-3)
                {
                    hanford.ringold=rbind(hanford.ringold,c(ix,iz))
                    break()
                }
            }
    }
hanford.ringold = hanford.ringold[order(hanford.ringold[,1],hanford.ringold[,2]),]





load("results/perm.data.3.r")

combined.perm[which(material.ids==1)] = 1
combined.perm[which(material.ids==5)] = 5
combined.perm[which(material.ids==4)] = 4
combined.perm[which(material.ids==0)] = NA

x.ori = x
z.ori = z
x[c(which.min(x),which.max(x))] = c(0,143.2)
z[c(which.min(z),which.max(z))] = round(range(z))



jpegfile=paste("./figures/agu_long.jpg",sep="")
jpeg(jpegfile,width=9.5,height=3,units='in',res=600,,quality=100)
##par(mgp=c(2.,0.6,0),mar=c(2.5,3,1,1))
image(x,z,array(combined.perm,c(nx,nz)),asp=1.0,##color=function(x)rev(topo.colors(x)),
##               zlim=c(-15,-6),
               col = c("cyan","pink","pink","yellow"),
               xlim = c(0,143.2),xlab=NA,ylab=NA,
               ylim = c(90,110),axes=FALSE)
axis(1,at=seq(0,140,20),mgp=c(2,0.5,0),tck=-0.08,cex.axis=1)
axis(1,at=seq(0,140,10),labels=NA,tck=-0.05)
axis(2,at=seq(90,110,5),mgp=c(2,0.5,0),tck=-0.06,cex.axis=1,adj=1)
axis(2,at=seq(90,110,5),labels=NA,tck=-0.05)
mtext('X (m)',side=1,line=1.5,cex=1)
mtext('Elevation (m)',side=2,line=2,cex=1,las=3)
box()
lines(x[alluvium.hanford[,1]],z[alluvium.hanford[,2]],col="black",lwd=2,lty=2)                       
lines(x[hanford.ringold[,1]],z[hanford.ringold[,2]],col="black",lwd=2,lty=2)
lines(x[alluvium.ringold[,1]],z[alluvium.ringold[,2]],col="black",lwd=2,lty=2) 
lines(x[alluvium.river[,1]],z[alluvium.river[,2]],col="black",type="l",lwd=2,lty=2)                  
text(40,94,"Ringold formation")
text(50,102,"Hanford formation")
text(132,106,"River")
text(113,103,"Alluvium")
##rect(80,98.5,143.2,110,col="mistyrose",density=0)
               
dev.off()
