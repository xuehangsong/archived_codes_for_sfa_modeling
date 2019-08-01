rm(list = ls())
library(rhdf5)

source("./codes/parameters.R")
source("./codes/create.material.grid.R")
load("results/material.grid.data")
load("results/state.vector.2699")
nreaz=100
for (ireaz in 1:nreaz)
{ 
    hori.elevation=state.vector[ireaz,1]
    hori.length=exp(state.vector[ireaz,2])
    second.depth=exp(state.vector[ireaz,3])
    third.depth=exp(state.vector[ireaz,4])

    second.x=river.bank[which.min(abs(z.new[river.bank[,2]]-hori.elevation-second.depth)),1]
    first.x=river.bank[which.min(abs(x.new[second.x]-x.new[river.bank[,1]]-hori.length)),1]
    first.depth=z.new[river.bank[which.min(abs(x.new[first.x]-x.new[river.bank[,1]])),2]]-hori.elevation

    mudlayer.depth=rep(0,nbank)
    for (ibank in 1:nbank)
        {
            if (river.bank[ibank,1]<first.x)
                {
                    mudlayer.depth[ibank]=first.depth*(river.bank[ibank,1]-river.bank[1,1])/(first.x-river.bank[1,1])
                }else if(river.bank[ibank,1]>second.x){
                    mudlayer.depth[ibank]=second.depth+(third.depth-second.depth)*(river.bank[ibank,1]-second.x)/(max(river.bank[,1])-second.x)
                }else{
                                        #            mudlayer.depth[ibank]=first.depth+
                                        #                (second.depth-first.depth)*(river.bank[ibank,1]-first.x)/(second.x-first.x)
                    mudlayer.depth[ibank]=z.new[river.bank[ibank,2]]-hori.elevation
                }
        }    


    if (mudlayer.depth[which.min(abs(x.new[river.bank[,1]]-360))]<=(z.new[river.bank[which.min(abs(x.new[river.bank[,1]]-360)),2]]-104.95+0.2))
        {
         print(ireaz)   
        }
}
