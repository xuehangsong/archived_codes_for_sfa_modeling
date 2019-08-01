rm(list=ls())
library("fields")
library("akima")

units.data = read.table("300A_EV_surfaces_012612.dat",header=F,skip=21)
data.names = c("meshx","meshy","u1","u2","u3","u4","u5","u6","u7","u8","u9","ringold.surface")
n.data.columns = length(data.names)
names(units.data) = data.names

angle = 15/180*pi

##old slice
x.origin = 594386.880635513
y.origin = 116185.502270774

##well 2-3
x.origin = 594377.49	
y.origin = 116220.4

##new slice
x.origin = 594378.6
y.origin = 116216.3

proj.coord = cbind(units.data[["meshx"]],units.data[["meshy"]])


units.data[["meshx"]] = (proj.coord[,1]-x.origin)*cos(angle)+(proj.coord[,2]-y.origin)*sin(angle)
units.data[["meshy"]]= (proj.coord[,2]-y.origin)*cos(angle)-(proj.coord[,1]-x.origin)*sin(angle)    

original.data = units.data
units.data = NULL
data.range = original.data[["meshx"]]
for (i.units in 1:n.data.columns)
{
    units.data[[i.units]] = original.data[[i.units]][which(data.range>-100 & data.range<400)]
}
names(units.data) = data.names


original.data = units.data
units.data = NULL
data.range = original.data[["meshy"]]
for (i.units in 1:n.data.columns)
{
    units.data[[i.units]] = original.data[[i.units]][which(data.range>-100 & data.range<100)]
}
names(units.data) = data.names

slice=list()
##slice[[1]] = seq(0.05,143.15,0.1)
west = 0
dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
x = west+cumsum(dx)-0.5*dx
slice[[1]] = x



n.node = length(slice[[1]])
slice[[2]] = rep(0,n.node)
names(slice)[1] = "meshx"
names(slice)[2] = "meshy"


interp.grid = list()

for (i.units in 3:n.data.columns)
{
    print(i.units)
    if(sum(!is.na(units.data[[i.units]]))>4) 
    {
        interp.grid[[data.names[i.units]]] = interp(units.data[["meshx"]][!is.na(units.data[[i.units]])],
                                                    units.data[["meshy"]][!is.na(units.data[[i.units]])],
                                                    units.data[[i.units]][!is.na(units.data[[i.units]])])
        slice[[data.names[i.units]]] = interp.surface(interp.grid[[data.names[i.units]]],cbind(slice[[1]],slice[[2]]))
    }
}
      
save(list=ls(),file="interpolated.data.r")
