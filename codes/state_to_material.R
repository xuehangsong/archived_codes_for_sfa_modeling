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
load(paste("results/state_vector.",iter,sep=""))


ncell = nx*ny*nz
levelset.1 = state.vector[,1:ncell+nfacies]
levelset.2 = state.vector[,1:ncell+(nfacies+ncell)]

indicator.matrix = array(NA,c(nreaz,ncell))
indicator.matrix[which(levelset.1 > 0)] = 1
indicator.matrix[which(levelset.1 <= 0 & levelset.2 > 0)] = 2
indicator.matrix[which(levelset.1 <= 0 & levelset.2 <= 0)] = 3

facies.prob = array(NA,c(ncell,nfacies))
for (ifacies in 1:nfacies)
    {
        temp.matrix = indicator.matrix
        temp.matrix[indicator.matrix!=ifacies] = 0
        facies.prob[,ifacies] = colMeans(temp.matrix)/ifacies
    }
save(facies.prob,file=paste("results/facies_prob_",iter,".r",sep=""))


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
    material.ids[which(indicator.matrix[ireaz,]==1)] = 1
    material.ids[which(indicator.matrix[ireaz,]==2)] = 9
    material.ids[which(indicator.matrix[ireaz,]==3)] = 4
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
        perm.ireaz = rep(10^(state.vector[ireaz,ifacies]),nx*ny*nz)
        h5write(perm.ireaz,fname,paste("unit",ifacies,"_perm",ireaz,sep=""),level=0)                    
    }
}

H5close()
