rm(list=ls())
library(akima)

all.file = list.files("results/","s10.temp.r")

for (i in 1:length(all.file)) {

    file.name = all.file[i]

    load(paste("results/",file.name,sep=''))

    data.mismatch = data.mismatch[which(state.vector[,1]>state.vector[,3])]
    state.vector = state.vector[which(state.vector[,1]>state.vector[,3]),]

    grid.mismatch=interp(x=state.vector[,1],
                         y=state.vector[,3],       
                         z=data.mismatch)
    jpeg(filename=paste("figures/",file.name,"coutour.jpg",sep=''),units='in',width=4.5,height=4,res=400,quality=100)
    filled.contour(grid.mismatch$x,
                   grid.mismatch$y,
                   grid.mismatch$z,
                   color.palette = heat.colors,
                   xlab='Hanford permeability (log scale)',
                   ylab='Alluvium permeability (log scale)',               
##                   zlim=c(0,200),
#1                   xlim = c(-11,-5),
                   asp = 1,
                   
                   
                   plot.axes={
                       axis(1)
                       axis(2)

                       points(state.vector[,1],
                              state.vector[,3],
                              pch =16,
                              cex = 0.3) 
                       
                       ## da.6
                       ## load("stochastic.6.0/assimilation/state.vector.r")
                       ## x = log10(exp(mean(state.vector[,1])))
                       ## y = log10(exp(mean(state.vector[,3])))
                       ## points(x,y,pch =16) 
                       ## text(x,y-0.2,"0")
                       
                       
                       ## load("da.6/state.vector.1")
                       ## x = log10(exp(mean(state.vector[,1])))
                       ## y = log10(exp(mean(state.vector[,3])))
                       ## points(x,y,pch =16) 
                       ## text(x,y-0.2,"1")
                       
                       
                       ## load("da.6/state.vector.2")
                       ## x = log10(exp(mean(state.vector[,1])))
                       ## y = log10(exp(mean(state.vector[,3])))
                       ## points(x,y,pch =16) 
                       ## text(x,y-0.2,"2")
                       
                       
                       ## load("da.6/state.vector.3")
                       ## x = log10(exp(mean(state.vector[,1])))
                       ## y = log10(exp(mean(state.vector[,3])))
                       ## points(x,y,pch =16) 
                       ## text(x,y-0.2,"3")
                       
                       ## load("da.6/state.vector.3")
                       
                       ## for (ireaz in 1:dim(state.vector)[1]) {
                       ##     points(log10(exp(state.vector[ireaz,1])),log10(exp(state.vector[ireaz,3])),pch = 16, cex=0.3)
                       ## }
                       
                       
                       ## points(log10(2.54e-8),log10(1.78e-10),pch=16)
                       ## points(log10(1.24e-8),log10(9.08e-11),pch=16)
                       ## points(log10(6.88e-9),log10(3.35e-11),pch=16)
                       ## points(log10(3.57e-9),log10(1.44e-11),pch=16)
                       ## text(-8,-8,"100")
                       
                       ## text(log10(2.54e-8),log10(1.78e-10)-0.2,"0")
                       ## text(log10(1.24e-8),log10(9.08e-11)-0.2,"1")
                       ## text(log10(6.88e-9),log10(3.35e-11)-0.2,"2")
                       
                       ##da.5
                       ## points(log10(3.54e-10),log10(4.64e-12),pch=16)
                       ## points(log10(2.01e-10),log10(3.43e-12),pch=16)
                   }
                   )
    legend("topleft",
           paste("Nobs =",length(obs.value),
                 ", Nreaz =",dim(state.vector)[1]),
           bty='n')
    
    dev.off()
}
