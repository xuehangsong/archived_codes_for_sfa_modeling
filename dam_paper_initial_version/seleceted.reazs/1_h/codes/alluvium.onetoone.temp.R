rm(list=ls())
load("statistics/parameters.r")
fname="2duniform"

args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=2
    iyear=2 ##4,6
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}


load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)

ivari = "CO2_Rate [mol_m^3-sec]"    
load(paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
material_array = replicate(dim(value)[3],material_ids)
compare = value[which(material_array==5)]


ireaz=1
load(paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
base = value[which(material_array==5)]


jpg.name = paste("download.figure/alluvium",ivari,"_",ireaz,"_",iyear,"y.jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(log10(base),log10(compare),
              ylab="",
              axe=FALSE,
              xlab="",              
              asp=1,
              xlim=c(-12,-6),ylim=c(-12,-6),
              colramp=colorRampPalette(c("white","purple")))
box()
mtext("Case with hourly hydraulic BC",1,1.5)
mtext("Case with 30d averaged hydraulic BC",2,1.5)
axis(1)
axis(2,las=2)
lines(c(-100,100),c(-100,100),col="black")
dev.off()
