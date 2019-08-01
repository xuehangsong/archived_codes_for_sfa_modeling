rm(list=ls())
args=(commandArgs(TRUE))

if(length(args)==0){
    print("no arguments supplied, use default value")
    nreaz = 300
    iter = 0
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}

input.dir = "outputs/"
simu.tracer.all = list()
for (ireaz in 1:nreaz)
{
    print(ireaz)
    load(paste(input.dir,"simu_tracer_",ireaz,".r",sep=""))

    simu.tracer.all[[ireaz]] = simu.tracer
}
save(simu.tracer.all,file=paste("results/simu_tracer_all_",iter,".r",sep=""))    
