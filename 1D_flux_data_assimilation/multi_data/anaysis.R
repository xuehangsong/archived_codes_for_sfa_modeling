rm(list=ls())
source("./shell/parameter.sh")
source("./dainput/obs.R")

args=(commandArgs(TRUE))
if(length(args)==0){
    print("no arguments supplied, use default value")
    iter=1
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}


state.vector = as.matrix(read.table(paste("results/state_vector.",iter,sep='')))

nfacies = 2
nreaz =  nrow(state.vector)
nnode =  ncol(state.vector)-nfacies



indicator.vector = state.vector[,1:nnode]
indicator.vector[indicator.vector>=0] = 1
indicator.vector[indicator.vector<0] = 0

indicator.vector[state.vector[,1:nnode]<0] = 0

mean.indicator = colMeans(indicator.vector)
sd.indicator = apply(indicator.vector,2,sd)

mean.state = colMeans(state.vector[,1:nnode])
sd.state = apply(state.vector[,1:nnode],2,sd)

ref.indicator = as.matrix(read.table("dainput/ref.dat"))[,1]
diff.indicator = apply((indicator.vector - t(replicate(nreaz,ref.indicator)))**2,2,mean)
rmse.indicator = (mean.indicator-ref.indicator)**2

write.table(cbind(mean.indicator,sd.indicator,rmse.indicator,diff.indicator,mean.state,sd.indicator),
      file=paste("results/prob.",iter,sep=""),col.names=FALSE,row.names=FALSE)

