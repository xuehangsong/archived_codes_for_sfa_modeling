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


load(paste("highlight.data/",ireaz,"_vec.r",sep=""))


jpg.name = paste("download.figure/",ireaz,"/vec.jpg",sep = "")
jpeg(jpg.name,width = 3.4,height = 3.4,units = "in",res = 300, quality = 100)
par(mgp=c(2,0.6,0),mar=c(3.1,3.1,2.1,2.1))    
smoothScatter(log10(vec[which(material_ids==5)]),
              log10(mass[which(material_ids==5)]),
              ylab="",
              axe=FALSE,
              xlab="",              
              xlim=c(-7,-2),
              ylim=c(-6,2),              
              )
box()
mtext(expression(paste("Velocity (m/h)")),1,1.7)
mtext(expression(paste("Carbon consumption (log10,mol/m"^3,")")),2,1.5)
axis(1)
axis(2,las=2)
dev.off()
