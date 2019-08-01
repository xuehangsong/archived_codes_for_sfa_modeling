rm(list=ls())
library("fields")
library("akima")

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

bath.data = read.table("newbath_10mDEM_grid.ascii")
bath.data = t(bath.data)
bath.data = c(bath.data)
bath.x = seq(590999,595499,2)
bath.y = seq(118499,113499,-2)
bath.nx = length(bath.x)
bath.ny = length(bath.y)

bath.x = rep(bath.x,bath.ny)
bath.y = rep(bath.y,each=bath.nx)


proj.coord = cbind(bath.x,bath.y)
bath.x = (proj.coord[,1]-x.origin)*cos(angle)+(proj.coord[,2]-y.origin)*sin(angle)
bath.y = (proj.coord[,2]-y.origin)*cos(angle)-(proj.coord[,1]-x.origin)*sin(angle)    

data.range = bath.x
bath.x = bath.x[which(data.range>-100 & data.range<400)]
bath.y = bath.y[which(data.range>-100 & data.range<400)]
bath.data = bath.data[which(data.range>-100 & data.range<400)]

data.range = bath.y
bath.x = bath.x[which(data.range>-100 & data.range<100)]
bath.y = bath.y[which(data.range>-100 & data.range<100)]
bath.data = bath.data[which(data.range>-100 & data.range<100)]


slice=list()
###slice[[1]] = seq(0.05,143.15,0.1)
west = 0
dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
x = west+cumsum(dx)-0.5*dx
slice[[1]] = x

n.node = length(slice[[1]])
slice[[2]] = rep(0,n.node)


interp.grid = interp(bath.x,bath.y,bath.data)
slice[[3]] = interp.surface(interp.grid,cbind(slice[[1]],slice[[2]]))
save(list=ls(),file="bath.data.r")


