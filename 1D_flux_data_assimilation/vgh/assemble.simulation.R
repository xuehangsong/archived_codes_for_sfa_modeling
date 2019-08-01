rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list

source("./vhg_codes/parameter.sh")
load("vhg_case/results/vhg_data.r")

obs.type="Temperature"
obs.list = rep("Obs_",nobs)
for (iobs in 1:nobs)
{obs.list[iobs] = paste(obs.list[iobs],as.character(iobs),sep='') }

###read in all data
simu.all=list()
for (ireaz in 1:nreaz)
{
    print(ireaz)
    simu.all[[ireaz]]=list()
##    for (obs.file in list.files(paste("pflotran_mc/",ireaz,"/",sep=''),pattern=paste("R",ireaz,"-obs-",sep='')))
    for (obs.file in list.files(paste(mc_dir,ireaz,"/",sep=''),pattern=paste("-obs-",sep='')))    
        {     
            header=read.table(paste(mc_dir,ireaz,"/",obs.file,sep=''),
                              nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
            simu.single=read.table(paste(mc_dir,ireaz,"/",obs.file,sep=''),skip=1,header=FALSE)
            colnames(simu.single)=header
            simu.all[[ireaz]]=merge.list(simu.all[[ireaz]],simu.single)
        }
}
save(simu.all,file=paste(output_dir,"simu.all.r",sep=''))

###output
simu.ensemble=array(NA,c(ntime,nobs,nreaz))
for (iobs in 1:nobs)
{
    ireaz=1
    simu.col=intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),
                       grep(obs.type,names(simu.all[[ireaz]])))
    for (ireaz in 1:nreaz)
    {
        itime = 1
        for (irow in 1:nrow(simu.all[[ireaz]]))
        {
            if(abs(obs_time[itime]-simu.all[[ireaz]][1][irow,1])<100 & itime<=ntime)
            {
                simu.row=irow
                simu.ensemble[itime,iobs,ireaz]=simu.all[[ireaz]][simu.row,simu.col]
                itime = itime+1
            } 
        }
    }
}
save(simu.ensemble,file=paste(output_dir,"simu.ensemble.r",sep=''))
