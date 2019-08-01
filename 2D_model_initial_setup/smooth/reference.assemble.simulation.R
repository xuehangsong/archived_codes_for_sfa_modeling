rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list
source("./codes/parameters.R")

#read in all data
obs.all=list()

for (obs.file in list.files("./long.multi/",pattern="*-obs-"))
    {     
        header=read.table(paste("./long.multi/",obs.file,sep=''),nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
        obs.single=read.table(paste("./long.multi/",obs.file,sep=''),skip=1,header=FALSE)
        colnames(obs.single)=header
        obs.all=merge.list(obs.all,obs.single)
    }

save(obs.all,file="results/obs.all")

#output
ntime.all=dim(obs.all)[1]


obs.true=array(rep(0,ntime.all*nobs),c(ntime.all,nobs))
obs.value=array(rep(0,ntime.all*nobs),c(ntime.all,nobs))
log.time=rep(0,ntime.all)

for (iobs in 1:nobs)
    {
        obs.col=intersect(grep(obs.list[iobs],names(obs.all)),grep(obs.type,names(obs.all)))
        obs.xyz[iobs,]=as.double(tail(unlist(strsplit(colnames(obs.all[obs.col]),"[() ]+")[]),3))
        obs.true[,iobs]=obs.all[,obs.col]
    }
log.time=obs.all[1][,]
obs.true=apply(((obs.true-101325)/9.8068/1000),1,"+",obs.xyz[,3])
obs.true=t(obs.true)
for (iobs in 1:nobs)
{
    obs.value[,iobs]=obs.true[,iobs]+c(rnorm(ntime.all,0,sqrt(obs.var[iobs])))
}
    
save(obs.value,obs.true,log.time,file="results/obs.data")
save(obs.xyz,file='results/obs.xyz')
