rm(list=ls())
library("rhdf5")

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")


time.ticks = c(
    as.POSIXct("2010-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#    as.POSIXct("2010-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2011-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#    as.POSIXct("2011-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2012-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#    as.POSIXct("2012-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2013-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#    as.POSIXct("2013-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2014-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#    as.POSIXct("2014-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#    as.POSIXct("2015-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#    as.POSIXct("2015-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2016-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S")    
)
               

output.time = seq(0,(365*5+366)*24,3)*3600+start.time


obs.list = paste("Well_",seq(1,322),seq="")
nobs = length(obs.list)

x = h5read("1/2duniform-000.h5","Coordinates/X [m]")
y = h5read("1/2duniform-000.h5","Coordinates/Y [m]")
z = h5read("1/2duniform-000.h5","Coordinates/Z [m]")
x = head(x,-1)+0.5*diff(x)
y = head(y,-1)+0.5*diff(y)
z = head(z,-1)+0.5*diff(z)
nx = length(x)
ny = length(y)
nz = length(z)


##material_ids = h5read(paste("../../reazs.hete/2/T3_Slice_material.h5",sep=''),"Materials/Material Ids")
material_ids = h5read(paste("1/T3_Slice_material.h5",sep=''),"Materials/Material Ids")
material_ids = array(material_ids,c(nx,nz))


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



## hanford.river=NULL
## for (ix in 1:nx)
##     {
##         for (iz in 1:(nz-1))
##             {
##                 if ((material_ids[ix,iz+1]-material_ids[ix,iz])==-1)
##                 {
##                     hanford.river=rbind(hanford.river,c(ix,iz))
##                     break()
##                 }
##             }
##     }
## hanford.river = hanford.river[order(hanford.river[,1],hanford.river[,2]),]



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



plot(x[hanford.ringold[,1]],z[hanford.ringold[,2]],type="l",lwd=3,xlim=range(x),ylim=range(z))
lines(x[alluvium.river[,1]],z[alluvium.river[,2]],lwd=2,col="blue")
lines(x[alluvium.ringold[,1]],z[alluvium.ringold[,2]],lwd=2,col="green")
lines(x[alluvium.hanford[,1]],z[alluvium.hanford[,2]],lwd=2,col="red")



list=c("hanford.ringold",
       "alluvium.hanford",
##       "hanford.river",
       "alluvium.river",
       "alluvium.ringold",
       "x","y","z",
       "nx","ny","nz",
       "obs.list","nobs",
       "material_ids",
       "start.time",
       "end.time",
       "output.time",
       "time.ticks"
       )
save(list=list,file="statistics/parameters.r")
