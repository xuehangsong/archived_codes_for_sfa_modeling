rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list

setwd("/Users/shua784/Dropbox/PNNL/Projects/300A/John_case_optim_5/")

path = "Outputs/"

###read in all data
simu.all=list()
obs.files = list.files(path,pattern=paste("-obs-",sep=''))
for (ifile in obs.files)
{
    print(ifile)
    header=read.table(paste(path,ifile,sep=''),nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
    simu.single=read.table(paste(path,ifile,sep=""),skip=1,header=FALSE)
    colnames(simu.single)=header
    simu.all=merge.list(simu.all,simu.single)
}

save(simu.all,file=paste(path,"simu.all.r",sep=''))

