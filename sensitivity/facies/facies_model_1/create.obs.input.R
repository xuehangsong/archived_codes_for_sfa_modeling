rm(list=ls())
load("results/obs.well.loc.r")

nobs = length(obs.well.x)

file.remove("obs.txt")

for (iobs in 1:nobs) {

    write.table(paste("REGION Well_",iobs,sep=""),file="obs.txt",col.names=FALSE,row.names=FALSE,append=TRUE,quote=FALSE)
    write.table(paste("  COORDINATE",obs.well.x[iobs],0.5,obs.well.z[iobs]),file="obs.txt",append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
    write.table(paste("/"),file="obs.txt",append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
    write.table(paste(""),file="obs.txt",append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
}


for (iobs in 1:nobs) {

    write.table(paste("OBSERVATION"),file="obs.txt",col.names=FALSE,row.names=FALSE,append=TRUE,quote=FALSE)
    write.table(paste("  REGION Well_",iobs,sep=""),file="obs.txt",col.names=FALSE,row.names=FALSE,append=TRUE,quote=FALSE)
    write.table(paste("  VELOCITY"),file="obs.txt",append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
    write.table(paste("/"),file="obs.txt",append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
    write.table(paste(""),file="obs.txt",append=TRUE,col.names=FALSE,row.names=FALSE,quote=FALSE)
}



