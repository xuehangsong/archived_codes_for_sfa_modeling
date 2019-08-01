rm(list=ls())
library("fields")
library("akima")

west.x = 594350-100
east.x = 594650+100
south.y = 116020-1000
north.y = 116400+1000


bath.data = read.table("data/newbath_10mDEM_grid.ascii")
bath.data = t(bath.data)
bath.data = c(bath.data)
bath.x = seq(590999,595499,2)
bath.y = seq(118499,113499,-2)
bath.nx = length(bath.x)
bath.ny = length(bath.y)
bath.x = rep(bath.x,bath.ny)
bath.y = rep(bath.y,each=bath.nx)
bath.data = cbind(bath.x,bath.y,bath.data)
colnames(bath.data) = c("bathx","bathy","bath")
bath.data = bath.data[which(bath.data[,"bathx"]>west.x-20 & bath.data[,"bathx"]<east.x+20),]
bath.data = bath.data[which(bath.data[,"bathy"]>south.y-20 & bath.data[,"bathy"]<north.y+20),]
save(bath.data,file="results/bath.data.r")


