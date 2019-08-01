rm(list=ls())
library(signal)
library(expm)

nfacies = 3

ori.x.lag = 0.1960E+02
ori.z.lag = 0.5000E+00

tpx.data.file = read.table("tprogs/tp_x.eas",skip=12)
x.lag = which.min(abs(tpx.data.file[,1]-ori.x.lag))

tpz.data.file = read.table("tprogs/tp_z.eas",skip=12)
z.lag = which.min(abs(tpz.data.file[,1]-ori.z.lag))


mcmod.par = readLines("dainput/mcmod.par")
mcmod.par[13] = as.character(x.lag)
mcmod.par[18] = as.character(x.lag)
mcmod.par[23] = as.character(z.lag)

writeLines(mcmod.par,"dainput/mcmod.par")
