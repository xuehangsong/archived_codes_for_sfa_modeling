rm(list=ls())

load("statistics/parameters.r")
fname="2duniform"

args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=6
    ivari=16
    iyear=6
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}
load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari=vari.names[ivari]


##times = 0:7000+365*8
##times = 0:7+365*8
years = c(365,365,366,365,365,365)
times = 0:(years[iyear]*8)+(sum(years[0:(iyear-1)])*8)

ntime = length(times)
value = array(NA,c(nx,nz,ntime))

for (itime in 1:ntime)
{
    print(itime)    
    load(paste(ireaz,"/","h5data",times[itime],".r",sep=""))
    value[,,itime] = h5data[[ivari]]
}

save(value,file=paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
