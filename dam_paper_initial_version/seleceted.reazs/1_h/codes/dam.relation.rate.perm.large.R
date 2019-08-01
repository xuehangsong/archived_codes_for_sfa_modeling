rm(list=ls())
library(gplots)
library(rhdf5)
load("statistics/parameters.r")
load("statistics/boundary.r")

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

ivari=1  ##20
x.ori = x
z.ori = z
x[c(which.min(x),which.max(x))] = c(0,143.2)
z[c(which.min(z),which.max(z))] = round(range(z))

## level.river.interp = approx((level.river[[ireaz]][[1]]-start.time),level.river[[ireaz]][[2]],
##                            files*3*3600)[[2]]
## level.inland.interp = approx((level.inland[[ireaz]][[1]]-start.time),level.inland[[ireaz]][[2]],
##                            files*3*3600)[[2]]


load(paste(ireaz,"/","h5data0.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]


load(paste(ireaz,"/","h5data2920.r",sep=""))
base=h5data
load(paste(ireaz,"/","h5data17528.r",sep=""))
mass = h5data[[ivari]]-base[[ivari]]


hanford.perm = h5read("1/Hanford_perm_2d_adaptive.h5","Hanford_perm1") 
alluvium.perm = h5read("1/Alluvium_perm_2d_adaptive.h5","Alluvium_perm1")

perm = alluvium.perm
perm[which(material_ids==0)] = NA
perm[which(material_ids==1)] = hanford.perm[which(material_ids==1)]
perm[which(material_ids==4)] = 1e-15
perm = array(perm,c(nx,nz))

jpg.name = paste("download.figure/",ireaz,"/rate_perm.jpg",sep = "")
###jpeg(jpg.name,width = 4.7,height = 4.7,units = "in",res = 300, quality = 100)
jpeg(jpg.name,width = 3.3,height = 3.3,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(log10(perm[which(material_ids==5)]),
              log10(mass[which(material_ids==5)]),
              ylab="",
              axe=FALSE,
              xlab="",              
              xlim=c(-15,-11),
              ##              ylim=c(-5,2),
              ylim=c(-3,1),                            
              )
box()
mtext(expression(paste("Permeablity (log10, m"^2,")")),1,1.7)
mtext(expression(paste("Cum. carbon CONS (log10, mol/m"^2,")")),2,1.5)
axis(1)
axis(2,las=2)
dev.off()


## a = log10(perm[which(material_ids==5)])
## b = log10(mass[which(material_ids==5)]),
              
