rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list

nreaz=100
#case.name='new.block.long'
##case.name='regular.6'
case.name='th_richards_compare.7'
obs.time = seq(0,10296)
obs.time = seq(0,408)
##obs.time = seq(9888,10296)
ntime = length(obs.time)
obs.list = c("Well_01",
             "Well_02",
             "Well_03",
             "Well_04",
             "Well_05",
             "Well_06",
             "Well_07",
             "Well_08",
             "Well_09",
             "Well_10",
             "Well_11",             
             "Well_12",
             "Well_13",
             "Well_14",
             "Well_15",
             "Well_16",
             "Well_17",
             "Well_18",
             "Well_19",
             "Well_20",
             "Well_21",             
             "Well_22",
             "Well_23",
             "Well_24")

obs.list = c("Well_01",
             "Well_02",
             "Well_03",
             "Well_04",
             "Well_05",
             "Well_06",
             "Well_07",
             "Well_08")

## obs.list = c("Well_02",
##              "Well_03",
##              "Well_08",
##              "Well_09")

nobs=length(obs.list)


##Read in all data
simu.all = list()
for (ireaz in 1:nreaz)
{
    simu.all[[ireaz]] = list()
    for (obs.file in list.files(paste(case.name,"/",ireaz,"/",sep=''),pattern="*-obs-"))
    {     
        header = read.table(paste(case.name,"/",ireaz,"/",obs.file,sep=''),nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
        simu.single = read.table(paste(case.name,"/",ireaz,"/",obs.file,sep=''),skip=1,header=FALSE)
        colnames(simu.single) = header
        simu.all[[ireaz]] = merge.list(simu.all[[ireaz]],simu.single)
    }
}
save(simu.all,file = paste(case.name,"/statistics/simu.all.r",sep=''))
load(paste(case.name,"/statistics/simu.all.r",sep=''))


obs.type="Liquid Pressure"
simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
obs.xyz = array(rep(0,nobs*3),c(nobs,3))
for (itime in 1:ntime)
{
##    simu.ensemble=array(rep(0,nobs*nreaz),c(nreaz,nobs))
    for (iobs in 1:nobs)
        {
            for (ireaz in 1:nreaz)
                {
                    simu.col=intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
                    simu.row=which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
                    obs.xyz[iobs,]=as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
                    simu.ensemble[ireaz,iobs,itime]=simu.all[[ireaz]][simu.row,simu.col]
                }
        }
}
simu.ensemble=apply(((simu.ensemble-101325)/9.8068/1000),c(1,3),"+",obs.xyz[,3])
simu.ensemble=aperm(simu.ensemble,c(2,1,3))
level.ensemble = simu.ensemble
save(level.ensemble,file = paste(case.name,"/statistics/level.ensemble.r",sep=''))

obs.type = "Tracer"
##output
simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
for (itime in 1:ntime)
{
    print(itime)
    for (iobs in 1:nobs)
    {
        for (ireaz in 1:nreaz)
        {
            simu.col = intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
            simu.row = which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
            simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col[1]]
#####            simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]            
            ##  obs.xyz[iobs,] = as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
        }
    }
}
tracer.ensemble = simu.ensemble
save(tracer.ensemble,file = paste(case.name,"/statistics/tracer.ensemble.r",sep=''))


obs.type = "qlx"
##output
simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
for (itime in 1:ntime)
{
    print(itime)
    for (iobs in 1:nobs)
    {
        for (ireaz in 1:nreaz)
        {
            simu.col = intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
            simu.row = which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
            simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]
            ##  obs.xyz[iobs,] = as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
        }
    }
}
qlx.ensemble = simu.ensemble
save(qlx.ensemble,file = paste(case.name,"/statistics/qlx.ensemble.r",sep=''))


obs.type = "qlz"
##output
simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
for (itime in 1:ntime)
{
    print(itime)
    for (iobs in 1:nobs)
    {
        for (ireaz in 1:nreaz)
        {
            simu.col = intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
            simu.row = which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
            simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]
            ##  obs.xyz[iobs,] = as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
        }
    }
}
qlz.ensemble = simu.ensemble
save(qlz.ensemble,file = paste(case.name,"/statistics/qlz.ensemble.r",sep=''))

## obs.type = "HCO3-"
## ##output
## simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
## for (itime in 1:ntime)
## {
##     print(itime)
##     for (iobs in 1:nobs)
##     {
##         for (ireaz in 1:nreaz)
##         {
##             simu.col = intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
##             simu.row = which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
##             simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]
##             ##  obs.xyz[iobs,] = as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
##         }
##     }
## }
## hco3.ensemble = simu.ensemble
## save(hco3.ensemble,file = paste(case.name,"/statistics/hco3.ensemble.r",sep=''))



## obs.type = "CH2O"
## ##output
## simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
## for (itime in 1:ntime)
## {
##     print(itime)
##     for (iobs in 1:nobs)
##     {
##         for (ireaz in 1:nreaz)
##         {
##             simu.col = intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
##             simu.row = which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
##             simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]
##             ##  obs.xyz[iobs,] = as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
##         }
##     }
## }
## ch2o.ensemble = simu.ensemble
## save(ch2o.ensemble,file = paste(case.name,"/statistics/ch2o.ensemble.r",sep=''))






## obs.type = "O2"
## ##output
## simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
## for (itime in 1:ntime)
## {
##     print(itime)
##     for (iobs in 1:nobs)
##     {
##         for (ireaz in 1:nreaz)
##         {
##             simu.col = intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
##             simu.row = which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
##             simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]
##             ##  obs.xyz[iobs,] = as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
##         }
##     }
## }
## do.ensemble = simu.ensemble
## save(do.ensemble,file = paste(case.name,"/statistics/do.ensemble.r",sep=''))





## obs.type = "NO3-"
## ##output
## simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
## for (itime in 1:ntime)
## {
##     print(itime)
##     for (iobs in 1:nobs)
##     {
##         for (ireaz in 1:nreaz)
##         {
##             simu.col = intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
##             simu.row = which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
##             simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]
##             ##  obs.xyz[iobs,] = as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
##         }
##     }
## }
## no3.ensemble = simu.ensemble
## save(no3.ensemble,file = paste(case.name,"/statistics/no3.ensemble.r",sep=''))


## obs.type = "N2"
## ##output
## simu.ensemble = array(rep(0,nobs*nreaz*ntime),c(nreaz,nobs,ntime))
## for (itime in 1:ntime)
## {
##     print(itime)
##     for (iobs in 1:nobs)
##     {
##         for (ireaz in 1:nreaz)
##         {
##             simu.col = intersect(grep(obs.list[iobs],names(simu.all[[ireaz]])),grep(obs.type,names(simu.all[[ireaz]])))
##             simu.row = which.min(abs(obs.time[itime]-simu.all[[ireaz]][1][,1]))
##             simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]
##             ##  obs.xyz[iobs,] = as.double(tail(unlist(strsplit(colnames(simu.all[[ireaz]])[simu.col],"[() ]+")[]),3))
##         }
##     }
## }
## n2.ensemble = simu.ensemble
## save(n2.ensemble,file = paste(case.name,"/statistics/n2.ensemble.r",sep=''))






















##THIS IS FOR HEAD OBSERVATIONS
##simu.ensemble = apply(((simu.ensemble-101325)/9.8068/1000),1,"+",obs.xyz[,3])
##simu.ensemble = t(simu.ensemble)
##save(obs.xyz,file='results/obs.xyz')
