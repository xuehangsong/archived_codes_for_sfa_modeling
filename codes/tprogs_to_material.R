rm(list=ls())
args=(commandArgs(TRUE))
library(rhdf5)
source("codes/ifrc_120m_3d.R")

if(length(args)==0){
    print("no arguments supplied, use default value")
    iter=0
    nreaz=300
    nfacies=3        
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}
load("results/known_ringold.r")


load(paste("results/perm_vector.",iter,sep=""))
nreaz = nrow(perm.vector)
nfacies = ncol(perm.vector)
perm.vector = perm.vector[1:nreaz,]
indicator.vector = c()

for (ireaz in 1:nreaz)
{
    print(ireaz)
    tprogs.temp = as.numeric(unlist(read.table(paste("./tprogs/",ireaz,".r",sep=""),skip=2)))
    tprogs.temp[known.ringold] = 3
    
    indicator.vector  = rbind(indicator.vector,tprogs.temp)
}
save(indicator.vector,file=paste("results/tprogs.",iter,sep=""))



fname = "pflotran_mc/mc_material.h5"
if(file.exists(fname)) {file.remove(fname)}
h5createFile(fname)
h5createGroup(fname,"Materials")

cell.ids = 1:(nx*ny*nz)
h5write(cell.ids,fname,"Materials/Cell Ids",level=0)

for (ireaz in 1:nreaz)
{
    print(ireaz)
    material.ids = rep(0,nx*ny*nz)
    material.ids[which(indicator.vector[ireaz,]==1)] = 1
    material.ids[which(indicator.vector[ireaz,]==2)] = 9
    material.ids[which(indicator.vector[ireaz,]==3)] = 4
    h5write(material.ids,fname,paste("Materials/Material Ids",ireaz,sep=""),level=0)    
}


for (ifacies in 1:nfacies)
{
    fname = paste("pflotran_mc/unit",ifacies,"_perm.h5",sep="")
    if(file.exists(fname)) {file.remove(fname)}
    h5createFile(fname)
    cell.ids = 1:(nx*ny*nz)
    h5write(cell.ids,fname,"Cell Ids",level=0)

    for (ireaz in 1:nreaz)
    {
        print(ireaz)
        perm.ireaz = rep(10^(perm.vector[ireaz,ifacies]),nx*ny*nz)
        h5write(perm.ireaz,fname,paste("unit",ifacies,"_perm",ireaz,sep=""),level=0)                    
    }
}

H5close()
