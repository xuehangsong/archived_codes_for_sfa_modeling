rm(list=ls())
library(rhdf5)

args=(commandArgs(TRUE))
if(length(args)==0){
    print("no arguments supplied, use default value")
    iter=0
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}

nfacies = 2

state.vector = as.matrix(read.table(paste("results/state_vector.",iter,sep='')))
nreaz =  nrow(state.vector)
nnode =  ncol(state.vector)-nfacies

fname = "pflotran_mc/mc_perm.h5"
file.remove(fname)
h5createFile(fname)
h5write(as.integer(seq(1,nnode)),fname,"Cell Ids",level=0)

perm.field = c()
for (ireaz in 1:nreaz ){
    
    perm.field[which(state.vector[ireaz,1:nnode]>0)] = 10**state.vector[ireaz,nnode+1]
    perm.field[which(state.vector[ireaz,1:nnode]<=0)] = 10**state.vector[ireaz,nnode+2]
    
    h5write(perm.field,fname,paste("Permeability",ireaz,sep=""),level=0)
}
H5close()
