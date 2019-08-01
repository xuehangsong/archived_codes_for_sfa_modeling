rm(list=ls())

fname="2duniform"

args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}

load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
range = array(NA,c(nvari,2))
rownames(range) = vari.names

rfiles = list.files(as.character(ireaz),pattern ="h5data")
for (ifile in rfiles)
{
    print(ifile)
    load(paste(ireaz,"/",ifile,sep=""))    
    for (ivari in vari.names)

    {
        range[ivari,] = range(c(range[ivari,],h5data[[ivari]]),na.rm=TRUE)
    }
}

save(range,file=paste(ireaz,"/range.r",sep=''))
