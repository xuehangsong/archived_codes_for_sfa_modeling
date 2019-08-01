rm(list=ls())
library(RCurl) #for merage list


args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}

print(ireaz)
simu.all = list()
for (obs.file in list.files(paste(ireaz,"/",sep=''),pattern="*-obs-"))
{
    print(obs.file)        
    header = read.table(paste(ireaz,"/",obs.file,sep=''),nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
    simu.single = read.table(paste(ireaz,"/",obs.file,sep=''),
                             skip=1,header=FALSE,fill=TRUE)
    colnames(simu.single) = header
    simu.all = merge.list(simu.all,simu.single)
}

simu.all = simu.all[-which(duplicated(simu.all[,1])),]
save(simu.all,file = paste("statistics/simu.all.",ireaz,".r",sep=''))    
