rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list

nreaz=5
obs.time = seq(0,1080,1)
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
obs.list = c("Well_02",
             "Well_03",
             "Well_08",
             "Well_09")
nobs=length(obs.list)
case.name='2d'

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
            simu.ensemble[ireaz,iobs,itime] = simu.all[[ireaz]][simu.row,simu.col]
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




##THIS IS FOR HEAD OBSERVATIONS
##simu.ensemble = apply(((simu.ensemble-101325)/9.8068/1000),1,"+",obs.xyz[,3])
##simu.ensemble = t(simu.ensemble)
##save(obs.xyz,file='results/obs.xyz')
