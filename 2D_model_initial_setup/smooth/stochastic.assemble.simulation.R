rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list

source("./codes/parameters.R")

#read in all data
simu.all=list()

for (ireaz in 1:nreaz)
{
    simu.all[[ireaz]]=list()
    for (obs.file in list.files(paste(ireaz,"/",sep=''),pattern="*-obs-"))
        {     
            header=read.table(paste(ireaz,"/",obs.file,sep=''),nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
            simu.single=read.table(paste(ireaz,"/",obs.file,sep=''),skip=1,header=FALSE)
            colnames(simu.single)=header
            simu.all[[ireaz]]=merge.list(simu.all[[ireaz]],simu.single)
        }
}

save(simu.all,file=paste("results/simu.all.stochastic"))

#output

for (itime in 1:ntime)
{
    simu.ensemble=array(rep(0,nobs*nreaz),c(nreaz,nobs))
    for (iobs in 1:nobs)
        {
            for (ireaz in 1:nreaz)
                {
                    simu.col=intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
                    simu.row=which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
                    obs.xyz[iobs,]=as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
                    simu.ensemble[ireaz,iobs]=simu.all[[ireaz]][simu.row,simu.col]
                }
        }
    simu.ensemble=apply(((simu.ensemble-101325)/9.8068/1000),1,"+",obs.xyz[,3])
    simu.ensemble=t(simu.ensemble)
    save(simu.ensemble,file=paste("results/simu.ensemble.",itime,sep=''))
}

#save(obs.xyz,file='results/obs.xyz')
