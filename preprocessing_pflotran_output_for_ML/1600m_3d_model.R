angle = 15/180*pi
###400*400
td_origin = c(594186,115943)
##T3 slice
t3_origin = c(594378.6,116216.3)
##T4 slice
t4_origin = c(594386.880635513,116185.502270774)
model_origin = t3_origin

model_origin = td_origin
west = -450
east = 450
south = -800
north = 800
bottom = 90
top = 110

range_x = c(west,east)
range_y = c(south,north)
range_z = c(bottom,top)

dx = rep(4,(east-west)/4)
dy = rep(4,(north-south)/4)
dz = rep(0.5,(top-bottom)/0.5)

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = cumsum(dx)-0.5*dx[1]+west
y = cumsum(dy)-0.5*dy[1]+south
z = cumsum(dz)-0.5*dz[1]+bottom

## ###read material data
## source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
## library("fields")
## library("akima")


## units.data = read.table("data/300A_EV_surfaces_012612.dat",header=F,skip=21)
## data.names = c("meshx","meshy","u1","u2","u3","u4","u5","u6","u7","u8","u9","ringold.surface")
## n.data.columns = length(data.names)
## names(units.data) = data.names

## temp = proj_to_model(model_origin,angle,cbind(units.data[["meshx"]],units.data[["meshy"]]))
## units.data[["meshx"]] = temp[,1]
## units.data[["meshy"]] = temp[,2]

## original.data = units.data

## ####truncated in east-west direction
## units.data = NULL
## data.range = original.data[["meshx"]]
## for (i.units in 1:n.data.columns)
## {
##     units.data[[i.units]] = original.data[[i.units]][which(data.range>west-100 & data.range<east+100)]
## }
## names(units.data) = data.names


## ####truncated in north-south direction
## original.data = units.data
## units.data = NULL
## data.range = original.data[["meshy"]]
## for (i.units in 1:n.data.columns)
## {
##     units.data[[i.units]] = original.data[[i.units]][which(data.range>south-100 & data.range<north+100)]
## }
## names(units.data) = data.names

## layer.1600m.3d = list()
## layer.1600m.3d[[1]] = expand.grid(x,y)[,1]
## layer.1600m.3d[[2]] = expand.grid(x,y)[,2]
## names(layer.1600m.3d)[1] = "meshx"
## names(layer.1600m.3d)[2] = "meshy"


## interp.grid = list()
## for (i.units in 3:n.data.columns)
## {
##     print(i.units)
##     if(sum(!is.na(units.data[[i.units]]))>4) 
##     {
##         print("ok")
##         interp.grid[[data.names[i.units]]] = interp(units.data[["meshx"]][!is.na(units.data[[i.units]])],
##                                                     units.data[["meshy"]][!is.na(units.data[[i.units]])],
##                                                     units.data[[i.units]][!is.na(units.data[[i.units]])])
##         layer.1600m.3d[[data.names[i.units]]] = interp.surface(
##             interp.grid[[data.names[i.units]]],cbind(layer.1600m.3d[[1]],layer.1600m.3d[[2]]))
##     }
## }
## layer.1600m.3d = as.data.frame(layer.1600m.3d)
## save(layer.1600m.3d,file="results/layer.1600m.3d.r")
