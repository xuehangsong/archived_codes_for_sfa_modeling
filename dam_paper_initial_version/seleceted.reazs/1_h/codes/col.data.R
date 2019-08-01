rm(list=ls())

load("statistics/parameters.r")

args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1
    ivari=20
    ix = 198
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}


load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]


years = 2:6
## for (ix in c(58,178,298))
## {
    temp1=c()    
    for (iyear in years)
    {
        print(iyear)
        load(paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
        temp1 = cbind(temp1,drop(value[ix,,]))
        value=temp1
    }
    save(value,file = paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))    
## }    



