rm(list=ls())
library(gplots)
library(abind)
load("statistics/parameters.r")
load("statistics/boundary.r")

fname="2duniform"

time.ticks = c(
    as.POSIXct("2011-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2012-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2013-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2014-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S")
    )
args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}


years = 2:6
vec = c()
for (iyear in years)
{
    print(iyear)

    ivari = "Liquid X-Velocity [m_per_h]"    
    load(paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
    tempx = value

    ivari = "Liquid Z-Velocity [m_per_h]"    
    load(paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
    tempz = value

    temp = tempz^2+tempx^2
    vec = abind(vec,temp,along=3)
}

save(value,file = paste("highlight.data/",ireaz,"_vec.r",sep=""))    
