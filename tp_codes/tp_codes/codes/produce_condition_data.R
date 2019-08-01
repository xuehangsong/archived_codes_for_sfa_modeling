rm(list=ls())
args=(commandArgs(TRUE))
library(rhdf5)
source("codes/ifrc_120m_3d.R")
###combn


sample.function <- function(sample.size){
    for (ipoint in length(ori.selected.points):1)
    {
        print(ipoint)
        for (isample in 1:sample.size)
        {
            set.seed(isample*ipoint)
            sample.index = sample(1:length(ori.selected.points),ipoint)

            selected.points = c(ori.selected.points[sample.index],borehole.loc)
            selected.prob = rbind(ori.selected.prob[sample.index,],borehole.prob)

            mean.selected.prob = colMeans(selected.prob)
            diff.selected.prob = abs(mean.selected.prob - proportion)
            
            selected.flag = diff.selected.prob
            for (ifacies in 1:nfacies)
            {
                if(diff.selected.prob[ifacies]>=min(proportion[3])*0.1)
                {
                    selected.flag[ifacies] = 1
                } else {
                    selected.flag[ifacies] = 0
                }
            }
            selected.flag  = sum(selected.flag)
            if (selected.flag==0)
            {
                print("hello")            
                return(selected.points)
            }
        }

    }
}


if(length(args)==0){
    print("no arguments supplied, use default value")
    iter=3
    nreaz=300
    nfacies=3        
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}


proportion = as.numeric(read.table(paste("results/tp_x.",iter-1,sep=""),nrows=1))

load(paste("results/state_vector_tr.",iter,sep=""))

load(paste("results/facies_prob_",0,".r",sep=""))
facies.prior = facies.prob

load(paste("results/facies_prob_",iter-1,".r",sep=""))
facies.last = facies.prob

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
save(facies.prob,file=paste("results/facies_prob_tr_",iter,".r",sep=""))

if (iter==1) {
    delta.points = c()
} else {
    load(paste("results/delta.points.",iter-1,sep=""))
}

load("results/obs_info.r")
facies.change = (facies.prob - facies.last)^2
facies.change = rowSums(facies.change)
update.change = facies.change[cells.to.update]    

delta.points = c(delta.points,cells.to.update[
                                  which(update.change>=sort(update.change,decreasing=TRUE)[
                                                           length(cells.to.update) %/% 100])])

delta.points = unique(delta.points)
delta.points = delta.points[which(!is.na(rowSums(facies.prob)[delta.points]))]
save(delta.points,file=paste("results/delta.points.",iter,sep=""))

facies.change = (facies.prob - facies.prior)^2
facies.change = rowSums(facies.change)
delta.change = facies.change[delta.points]

## delta.points.threshold = sort(delta.change,decreasing=TRUE)[min(as.integer(length(cells.to.update)*0.005),
##                                                                 length(delta.points))]
delta.points.threshold = sort(delta.change,decreasing=TRUE)[min(as.integer(nx*ny*nz*0.05),
                                                                length(delta.points))]
selected.points = delta.points[which(delta.change>=delta.points.threshold)]
selected.points  = selected.points[order(facies.change[selected.points],decreasing=TRUE)]

load("results/borehole_loc.r")
borehole.prob = facies.prob[borehole.loc,]

ori.selected.points  = selected.points
ori.selected.prob = facies.prob[ori.selected.points,]


sample.size = 300
selected.points  = sample.function(sample.size)
selected.points = unique(selected.points)
selected.points = sort(selected.points)

expand.xyz = expand.grid(x,y,z)
add.data = cbind(expand.xyz[selected.points,],facies.prob[selected.points,])

input.file = readLines("dainput/prior_data.eas",8)
writeLines(input.file,"dainput/all_data.eas")
write.table(add.data,"dainput/all_data.eas",append=TRUE,row.names=FALSE,col.names=FALSE)

save(add.data,file=paste("results/add_data_",iter,".r",sep=""))
