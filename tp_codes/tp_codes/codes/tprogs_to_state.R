rm(list=ls())
args=(commandArgs(TRUE))
#source("codes/da_functions.R")


if(length(args)==0){
    print("no arguments supplied, use default value")
    iter=1
    nreaz=300
    nfacies=3        
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}


load(paste("results/perm_vector.",iter,sep=""))

nreaz = nrow(perm.vector)
nfacies = ncol(perm.vector)
perm.vector = perm.vector[1:nreaz,]
load(file=paste("results/tprogs.",iter,sep=""))

temp.vector  = indicator.vector
temp.vector[temp.vector!=1] = 0
facies1.mean = colMeans(temp.vector)

temp.vector  = indicator.vector
temp.vector[temp.vector!=2] = 0
facies2.mean = colMeans(temp.vector)/2
facies2.mean = facies2.mean/(1-facies1.mean)
facies2.mean[facies1.mean==1] = 0
facies1.mean = round(facies1.mean,8)
facies2.mean = round(facies2.mean,8)

facies1.mean[which(facies1.mean==0)] = 1e-8
facies1.mean[which(facies1.mean==1)] = 1-1e-8
facies2.mean[which(facies2.mean==0)] = 1e-8
facies2.mean[which(facies2.mean==1)] = 1-1e-8

nnode = length(facies1.mean)

levelset.1 = array(NA,c(nreaz,nnode))
levelset.2 = array(NA,c(nreaz,nnode))

for (inode in 1:nnode)
{
    if(!is.na(match(inode,c(1:10000)*1000)))
    {
        print(inode)
    }


    set.seed(inode+iter*inode)
    levelset1.reaz = rnorm(nreaz,0,1)+qnorm(facies1.mean[inode],0,1)    
    facies1.reaz = which(indicator.vector[,inode]==1)
    
    set.seed(inode+iter*inode+1)
    levelset1.temp = rnorm(nreaz*100,0,1)+qnorm(facies1.mean[inode],0,1)
    levelset1.reaz[facies1.reaz] = levelset1.temp[
        which(levelset1.temp>0)][1:length(facies1.reaz)]
    levelset1.reaz[-facies1.reaz] = levelset1.temp[
        which(levelset1.temp<=0)][1:(nreaz-length(facies1.reaz))]

    if(any(is.na(levelset1.reaz)))
    {
        print("1")        
        stop()
    }
    
    levelset2.reaz = rnorm(nreaz,0,1)+qnorm(facies2.mean[inode],0,1)
    facies2.reaz = which(indicator.vector[,inode]==2)


    levelset2.temp = rnorm(nreaz*100,0,1)+qnorm(facies2.mean[inode],0,1)
    levelset2.reaz[facies2.reaz] = levelset2.temp[
        which(levelset2.temp>0)][1:length(facies2.reaz)]
    levelset2.reaz[-c(facies1.reaz,facies2.reaz)] = levelset2.temp[
        which(levelset2.temp<=0)][1:(nreaz-length(c(facies1.reaz,facies2.reaz)))]       

    if(any(is.na(levelset2.reaz)))
    {
        print("2")
        stop()
    }

    
    levelset.1[,inode] = levelset1.reaz
    levelset.2[,inode] = levelset2.reaz    
}

facies.prob = array(NA,c(nnode,nfacies))
for (ifacies in 1:nfacies)
    {
        temp.matrix = indicator.vector
        temp.matrix[indicator.vector!=ifacies] = 0
        facies.prob[,ifacies] = colMeans(temp.matrix)/ifacies
    }
save(facies.prob,file=paste("results/facies_prob_",iter,".r",sep=""))

state.vector = cbind(perm.vector,levelset.1,levelset.2)
state.vector[which(is.na(state.vector))] = 0
save(state.vector,file=paste("results/state_vector.",iter,sep=""))
