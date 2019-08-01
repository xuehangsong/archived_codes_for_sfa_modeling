rm(list=ls())
library(RColorBrewer)
library(MASS)

load("statistics/parameters.r")
fname="2duniform"

args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=4
    iyear=2 ##4,6
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}

ireaz=5

load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)

ivari = "CO2_Rate [mol_m^3-sec]"    

base=c()
compare=c()
for (iyear in 2:6)
{
    print(iyear)
    load(paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
    material_array = replicate(dim(value)[3],material_ids)    
    compare = c(base,value[which(material_array==5)])

    load(paste(1,"/",ivari,"_",iyear,".r",sep=""))
    base = c(base,value[which(material_array==5)])
    
}

ncol=9
my.cols = rev(brewer.pal(ncol,"RdYlBu"))
my.cols = brewer.pal(ncol,"RdPu")
##plot.z = kde2d(log10(base[!is.na(base)]),log10(compare[!is.na(compare)]))

max.axis = log10(max(max(compare,na.rm=TRUE),max(base,na.rm=TRUE)))

jpg.name = paste("download.figure/alluvium",ivari,"_",ireaz,"_.2.jpg",sep = "")
jpeg(jpg.name,width = 4.7,height = 4.7,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(log10(base),log10(compare),
              ylab="",
              axe=FALSE,
              xlab="",              
              asp=1,
              xlim=c(-12,max.axis),ylim=c(-12,max.axis),              
              colramp=colorRampPalette(my.cols))
##              colramp=function(x)rev(heat.colors(x)))                            
##contour(plot.z,drawlabels=FALSE,nlevels=ncol,col=my.cols,add=TRUE)


box()
mtext("Hourly hydraulic BC",1,1.5)
mtext("Weekly averaged hydraulic BC",2,2)
axis(1)
axis(2,las=2)
lines(c(-100,100),c(-100,100),col="black")
dev.off()
