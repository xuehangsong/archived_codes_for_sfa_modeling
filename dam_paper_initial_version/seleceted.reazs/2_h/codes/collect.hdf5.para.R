rm(list=ls())
library(rhdf5)

fname="2duniform"


args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1
    ipara=17
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}

##find all output files with extension as .h5
h5files = grep(fname,list.files(as.character(ireaz),pattern ="*h5"),value=TRUE)

##remove checkpoint files
ckfiles = grep("h.h5",h5files)
if(length(ckfiles)>0)
{
    h5files = h5files[-ckfiles]
}

##order the h5 files in decreasing
order.h5 = order(as.numeric(gsub(".h5","",gsub("2duniform-","",h5files))))
h5files = h5files[order.h5]

##remove already collected data
## rfiles = list.files(as.character(ireaz),pattern="h5data")
## if(length(rfiles)>0)
## {
##     h5files = h5files[-rep(1:length(rfiles))]
## }
## h5files = h5files[-length(h5files)]
##

##convert h5 file to R data files
###for (ifile in 1:length(h5files)+length(rfiles))
for (ifile in 1:1000+(ipara-1)*1000)
{
    print(h5files[ifile])
    h5data = h5dump(paste(as.character(ireaz),"/",h5files[ifile],sep=""))
    h5data = h5data[[3]]
    h5names = names(h5data)
    for (ilist in h5names)
    {
        h5data[[ilist]]=t(drop(h5data[[ilist]]))
    }

    for (ilist in h5names[!h5names=="Material_ID"])
    {
        h5data[[ilist]][h5data[["Material_ID"]]==0]=NA
    }

    h5data[["Material_ID"]][h5data[["Material_ID"]]==0]=NA    
    save(h5data,file=paste(ireaz,"/h5data",ifile-1,".r",sep=''))

}


