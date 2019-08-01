rm(list=ls())
library(gplots)
library(abind)
load("statistics/parameters.r")
load("statistics/boundary.r")

fname="2duniform"


time.ticks = time.ticks = c(
    as.POSIXct("2015-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-02-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-03-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-04-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-05-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-06-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-07-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-08-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-09-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-10-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-11-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
    as.POSIXct("2015-12-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S")
    )


args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1
    ix=178
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}
ivari=3


load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]


load(paste("highlight.data/",ireaz,"_",ivari,"_",ix,".r",sep=""))
value = value[,-c(365,365+366,365*2+366,365*3+366)]


temp=c()
for (icase in 1:6)
{
    load(paste(icase,"/","range.r",sep=""))
    temp=range(temp,range[ivari,])
}
range=temp

years = c(365,365,366,365,365,365)
files = 0:sum(years[2:6]*8)+(sum(years[1])*8)
nfile = length(files)


level.river.interp = approx((level.river[[ireaz]][[1]]-start.time),level.river[[ireaz]][[2]],
                            files*3*3600)[[2]]
level.inland.interp = approx((level.inland[[ireaz]][[1]]-start.time),level.inland[[ireaz]][[2]],
                             files*3*3600)[[2]]
temp.river.interp = approx((temp.river[[ireaz]][[1]]-start.time),temp.river[[ireaz]][[2]],
                           files*3*3600)[[2]]
temp.inland.interp = approx((temp.inland[[ireaz]][[1]]-start.time),temp.inland[[ireaz]][[2]],
                            files*3*3600)[[2]]
level.river.interp.part = level.river.interp
level.river.interp.part[which(level.inland.interp<=level.river.interp)] = NA



z.ori=z
z[c(which.min(z),which.max(z))] = round(range(z))


print(ix)
ylim = range(z[which(material_ids[ix,]>0)])
jpeg(paste("download.figure/",ireaz,"/","finger.",ivari,"_",ix,".jpg",sep=""),width=10.5,height=2.25,units="in",res=200,quality=100)
field = t(value[,])
column.top = max(which(!is.na(field[1,])))    
## river.loc = 301:325
## field[,river.loc] = replicate(length(river.loc),temp.river.interp)


par(mar=c(4,5,2,0),mgp=c(2.5,1,0))
filled.contour(files*3*3600+start.time,z,log10(field),
               main = paste(ivari,", x =",round(x[ix],2),"(m)",
                            ", z =",round(z[column.top],2),"(m)"),
                                        #                   color = function(x)rev(bluered(x)),
               color = function(x)rev(heat.colors(x)),                                                         
               ##                   color = bluered,
               xlim = c(as.POSIXct("2015-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
                        as.POSIXct("2016-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S")
                        ),
               ylim = c(100,110),
               zlim = c(-1.5,1.5),
               xlab = "Time",
               ylab = "Elevation (m)",

               plot.axes = {
                   axis.POSIXct(1,at=time.ticks,format="%b");
                   axis(2,at=c(90,95,100,105,110));
                   lines(c(start.time,end.time),rep(max(z[which(material_ids[ix,]==5)]),2),col="black")
                   lines(c(start.time,end.time),rep(max(z[which(material_ids[ix,]==1)]),2),col="black")
                   lines(c(start.time,end.time),rep(max(z[which(material_ids[ix,]==4)]),2),col="black")
                   lines(files*3*3600+start.time,level.river.interp)
                   lines(files*3*3600+start.time,level.river.interp.part,col="green")
                   lines(rep(16060*3*3600+start.time,2),c(90,110))                                                             
               }
               
               )

dev.off()
##    mtext("Time",1,line=0)
##    mtext("Elevation (m)",2,line=0)    

z = z.ori
