rm(list=ls())
load("results/interp.data.r")
coord.data = read.table("data/proj.coord.dat")
rownames(coord.data) = coord.data[,3]
proj.xlim = c(594000,594700)
proj.ylim = c(115700,116800)
coord.data = coord.data[which(coord.data[,1]>proj.xlim[1] & coord.data[,1]<proj.xlim[2]),]
coord.data = coord.data[which(coord.data[,2]>proj.ylim[1] & coord.data[,2]<proj.ylim[2]),]
coord.data = coord.data[which(coord.data[,2]>proj.ylim[1] & coord.data[,2]<proj.ylim[2]),]
coord.data =  coord.data[!rownames(coord.data) %in% c("T2","T3","T4","T5","S1","S","S3","N1","N2","N3","SWS-1","NRG"),]
