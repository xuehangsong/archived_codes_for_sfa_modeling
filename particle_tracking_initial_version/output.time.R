rm(list=ls())

times = seq(8760,61343,1)
###start from 2008/01/01
times = seq(8784,70128,1)
times = paste(times,collapse=" ")



times = strwrap(times,width=510)
times = paste(times,collapse=" \\\n")


write.table(times,file = "output.time.txt",col.names=FALSE,row.names=FALSE,quote=FALSE,sep="")
###write.table([,2],"\\"),file=fname,
