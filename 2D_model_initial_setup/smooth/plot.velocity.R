#rm(list=ls())
#load("results/short.multi.x.velocity")
#load("results/short.multi.z.velocity")
#load("results/material.grid.data")
load("results/1m.top.1.pathline")
## obs.time = seq(0,2700)
## ntime = length(obs.time)
## river.bank.vx = array(rep(0,nbank*ntime),c(nbank,ntime))
## river.bank.vz = array(rep(0,nbank*ntime),c(nbank,ntime))

for (itime in 1:ntime)
{
    print(itime)
    for (ibank in 1:nbank)
    {
        river.bank.vx[,itime] = x.velocity[river.bank[ibank,1],1,(river.bank[ibank,2]-0),itime]
        river.bank.vz[,itime] = z.velocity[river.bank[ibank,1],1,(river.bank[ibank,2]-0),itime]         
    }
}

double.face = c(intersect(face.cells.group[[1]],face.cells.group[[6]]),
                intersect(face.cells.group[[2]],face.cells.group[[6]]))
color.index=rep("black",nbank)
pch.index=rep(16,nbank)
double.face.z=(double.face-1) %/% nx.new
double.face.x=(double.face-1) - double.face.z*nx.new
double.face.z=double.face.z+1
double.face.x=double.face.x+1

double.face.z=double.face.z[order(double.face.x)]
double.face.x=sort(double.face.x)


color.index[river.bank[,1] %in% double.face.x] = 'red'
pch.index[river.bank[,1] %in% double.face.x] = 1



plot(river.bank[,1]*0.1,break.time,
     ylim=range(0,10),
     pch=16,
     cex=0.5,
     ylab="Break through time (h)",
     xlab="Rotated east-west direction (m)",
     col=color.index,
     )
stop()

plot(0,0,#river.bank[,1]*0.1,river.bank.vz[,355],#break.time,
     xlim=range(obs.time),
     ylim=range(river.bank.vz),
     pch=16,
     cex=0.3,
     ylab="Velocity(m/h)",
     xlab="Time (hour)"

     )
for (ibank in 1:101)
{
    lines(obs.time,river.bank.vz[ibank,],col=color.index[ibank])
}
