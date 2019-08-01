rm(list=ls())

load("statistics/parameters.r")
load("statistics/boundary.r")

fname="2duniform"

args=(commandArgs(TRUE))
if(length(args)==0) {
    print("no realization id supplied,use default 1")
    ireaz=1
    ivari=22
}else{
    for(i in 1:length(args)) {
        eval(parse(text=args[[i]]))
    }
}

temp=c()
for (icase in 1:6)
{
    load(paste(icase,"/","range.r",sep=""))
    temp=range(temp,range[ivari,])
}
range=temp


load(paste(ireaz,"/","h5data0.r",sep=""))
load(paste(ireaz,"/","h5data1000.r",sep=""))
nvari = length(h5data)
vari.names = names(h5data)
ivari = vari.names[ivari]

x.ori = x
z.ori = z
x[c(which.min(x),which.max(x))] = c(0,143.2)
z[c(which.min(z),which.max(z))] = round(range(z))

##this is for collect data 
#times = 0:7000+365*8
#times = c(0,1000)
times = 0:17528
ntime = length(times)

level.river.interp = approx((level.river[[ireaz]][[1]]-start.time),level.river[[ireaz]][[2]],
                           times*3*3600)[[2]]
level.inland.interp = approx((level.inland[[ireaz]][[1]]-start.time),level.inland[[ireaz]][[2]],
                           times*3*3600)[[2]]



for (itime in 1:ntime)
{
    load(paste(ireaz,"/","h5data0.r",sep=""))        
    water.mark = x[alluvium.river[which.min(abs(z[alluvium.river[,2]]-level.river.interp[itime])),1]]
    jpg.name = paste(ireaz,"/",ivari,"_",times[itime],".jpg",sep = "")
    jpeg(jpg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)    
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x,z,h5data[[ivari]],
                   xlab = "Rotated east-west direction (m)",
                   ylab = ivari,
                   zlim = range[ivari,],
                   asp=1,
                   main = paste(ivari,"   ",format(output.time[times[itime]+1],"%Y-%m-%d %H:%M")),
                   color = function(x)rev(heat.colors(x)),                                      
                   plot.axes = {
                       axis(1)
                       axis(2)
                       lines(x[alluvium.river[,1]],z[alluvium.river[,2]],col="blue",lwd=2,lty=2)
                       lines(x[alluvium.hanford[,1]],z[alluvium.hanford[,2]],col="green",lwd=2,lty=2)                       
                       lines(x[hanford.ringold[,1]],z[hanford.ringold[,2]],col="black",lwd=2,lty=2)
                       lines(x[alluvium.ringold[,1]],z[alluvium.ringold[,2]],col="black",lwd=2,lty=2)
                       if(level.river.interp[itime]>=level.inland.interp[itime]) 
                       {rect.col="blue"} else {
                                          rect.col="red"}
                       rect(water.mark,level.river.interp[itime],max(x),level.inland.interp[itime],col=rect.col,border=rect.col)
                       ## lines(c(water.mark,max(x)),rep(level.river.interp[itime],2),col="blue",lwd=2,lty=1)
                       ## lines(c(water.mark,max(x)),rep(level.inland.interp[itime],2),col="red",lwd=2,lty=1)                                              
                       
                   }
                   )
    
    dev.off()

}
x = x.ori
z = z.ori
