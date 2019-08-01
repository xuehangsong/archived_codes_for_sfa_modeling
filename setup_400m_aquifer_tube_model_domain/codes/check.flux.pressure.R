rm(list=ls())
air_pressure = 101325
gravity = 9.8068
water_density = 998.2 #997


case.name = "homo_2"
#case.name = "hete_4_2"
column.name = "_c5"
#ccolumn.name = ""


depth = read.csv(header=FALSE,
                 paste("results/",case.name,column.name,"_depth.txt",sep=""))
depth = as.numeric(unlist(depth))
ndepth = length(depth)

simu.time = read.csv(header=FALSE,
                 paste("results/",case.name,"_time.txt",sep=""))
simu.time = as.numeric(unlist(simu.time))
ntime = length(simu.time)


vx = read.csv(header=FALSE,
    paste("results/",case.name,column.name,"_Liquid X-Velocity [m_per_h].txt",sep=""))

vy = read.csv(header=FALSE,
    paste("results/",case.name,column.name,"_Liquid Y-Velocity [m_per_h].txt",sep=""))

vz = read.csv(header=FALSE,
    paste("results/",case.name,column.name,"_Liquid Z-Velocity [m_per_h].txt",sep=""))


pressure = read.csv(header=FALSE,
    paste("results/",case.name,column.name,"_Liquid_Pressure [Pa].txt",sep=""))

head = (pressure-air_pressure)/gravity/water_density+t(replicate(ntime,depth))


river.level = read.table(header=FALSE,
                 paste(case.name,"/DatumH_River_ERT.txt",sep=""))
river.gradient = read.table(header=FALSE,
                 paste(case.name,"/Gradients_River_ERT.txt",sep=""))

coord = c(340,3328,-260.3084,105)
river.level = cbind(river.level[,1],river.level[,4]+rowSums((coord-river.level[,2:4])*river.gradient[,2:4]))

river.level = approx(river.level[,1],river.level[,2],simu.time)[[2]]


river.level = river.level-104


target.depth = 7
#plot(head[,ndepth]-river.level,vz[,ndepth]-vz[,1])
plot(river.level-head[,target.depth],rowMeans(vz[,1:target.depth]))

plot(river.level-head[,target.depth],rowMeans(vx[,1:target.depth]))

plot(river.level-head[,target.depth],rowMeans(vy[,1:target.depth]))

cond = 24*rowMeans(vz[,1:target.depth])/
             ((river.level-head[,target.depth])/abs(depth[target.depth]))

plot(1:ntime,cond,ylim=c(0,100),pch=16,cex=0.5)
plot(river.level-head[,target.depth],cond,ylim=c(0,100))

plot(river.level-head[,target.depth],cond,ylim=c(-100,100))

