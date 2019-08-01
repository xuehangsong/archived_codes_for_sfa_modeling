rm(list=ls())
library(gplots)
library(abind)
load("statistics/parameters.r")
load("statistics/boundary.r")

fname="2duniform"

time.ticks = time.ticks = c(
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
    ix=178
    ivari=18 ## 3 14 16 18
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}

nreaz = 6
load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]

years = c(365,365,366,365,365,365)
files = 0:sum(years[2:6]*8)+(sum(years[1])*8)
nfile = length(files)


color = c("black","grey","blue","green","orange","red")

load(paste("highlight.data/",ireaz,"_",ivari,"_sum.r",sep=""))
hanford = hanford[-c(365,365+366,365*2+366,365*3+366)]
alluvium = alluvium[-c(365,365+366,365*2+366,365*3+366)]
ringold = ringold[-c(365,365+366,365*2+366,365*3+366)]
##jpeg(paste("download.figure/",ivari,"hanford.jpg",sep=""),width=6.6,height=2,units="in",res=600,quality=100)
plot(files*3*3600+start.time,hanford-hanford[1],type="l",col="white")

for (ireaz in 1:nreaz)
{
    load(paste("highlight.data/",ireaz,"_",ivari,"_sum.r",sep=""))    
    hanford = hanford[-c(365,365+366,365*2+366,365*3+366)]
    alluvium = alluvium[-c(365,365+366,365*2+366,365*3+366)]
    ringold = ringold[-c(365,365+366,365*2+366,365*3+366)]
    lines(files*3*3600+start.time,hanford-hanford[1],col=color[ireaz])    
}

legend("topleft",c("1 hour","3 hour","12 hour","24 hour","7 days","30 days"),lty=1,lwd=4,col=color)
