rm(list=ls())
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

ireaz=4

load(paste(1,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)

ivari = "O2_Rate [mol_m^3-sec]"

base=c()
compare=c()
stage = c()

temp = read.table(paste(ireaz,"/DatumH_River_2010_2015_average_3.txt",sep=''))
level.river = temp[[4]]
level.river =level.river[ seq(1,length(level.river),3)]
years = c(365,365,366,365,365,365)

for (iyear in 2:6)
{
    print(iyear)
    load(paste(ireaz,"/",ivari,"_",iyear,".r",sep=""))
    material_array = replicate(dim(value)[3],material_ids)    
    compare = c(base,value[which(material_array==5)])

    load(paste(1,"/",ivari,"_",iyear,".r",sep=""))
    base = c(base,value[which(material_array==5)])

    times = 0:(years[iyear]*8)+(sum(years[0:(iyear-1)])*8)
    stage = c(stage,
    (t(replicate(nx*nz,level.river[times+1])))[which(material_array==5)])

}




jpg.name = paste("download.figure/alluvium",ivari,"_",ireaz,"_.jpg",sep = "")
jpeg(jpg.name,width = 2.56,height = 2.56,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(stage,log10(base)-log10(compare),
              ylab="",
              axe=FALSE,
              xlab="",              
              asp=1,
              ylim=c(-1,4),xlim=c(104,109),              
              colramp=colorRampPalette(c("white","blue")))
box()
axis(1)
axis(2,las=2)
mtext("River stage (m)",1,1.5)
mtext(expression(paste("Diff. of RR (log10, mol/m"^"3","S)"),sep=""),2,1.5)
dev.off()

