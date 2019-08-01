rm(list=ls())
library("rhdf5")
library(xts)


obs.coord = c(-0.04,-0.24)
obs.sd = 0.01
input.dir = "dainput/" 
load(paste(input.dir,"vhg_thermistor.r",sep=""))
obs = thermistor.output[,as.character(obs.coord)]
simu.time = as.numeric(difftime(index(obs),index(obs)[1],units="secs"))
ntime = length(simu.time)

ireaz = 1
h5data = h5dump(paste("pflotran_mc/",ireaz,"/1dthermal.h5",sep=""))


itime = 8
h5group = h5data[[paste("Time:",sprintf("%12.5E",simu.time[itime]),"s")]]
