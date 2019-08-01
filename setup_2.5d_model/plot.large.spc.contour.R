rm(list=ls())
library(akima)
coord.data = read.table("data/proj.coord.dat")
rownames(coord.data) = coord.data[,3]
proj.xlim = c(594000,594700)
proj.ylim = c(115700,116800)

slice.x = c(594386.8,594525.1)
slice.y = c(116186,116223)

slice.new.x = c(594377.5,(594377.5+594525.1-594386.8))
slice.new.y = c(116220.4,(116220.4+116223-116186))


coord.data = coord.data[which(coord.data[,1]>proj.xlim[1] & coord.data[,1]<proj.xlim[2]),]
coord.data = coord.data[which(coord.data[,2]>proj.ylim[1] & coord.data[,2]<proj.ylim[2]),]
coord.data = coord.data[which(coord.data[,2]>proj.ylim[1] & coord.data[,2]<proj.ylim[2]),]
selected.coord.data =  coord.data[!rownames(coord.data) %in% c("T2","T3","T4","T5","S1","S","S3",
                                                      "N1","N2","N3","SWS-1","NRG",
                                                      "2-7","2-8","2-9","2-11","2-12",
                                                      "2-13","2-14","2-15","2-16","2-17",
                                                      "2-18","2-19","2-20","2-21","2-22",
                                                      "2-23","2-24","2-26","2-27","2-28",
                                                      "2-29","2-30","2-31","2-34","2-37",
                                                      "3-9","3-12","3-23","3-24","3-25",
                                                      "3-27","3-28","3-30","3-31","3-32","3-35",
                                                      "1-2","1-17A","1-21B","1-32","1-57",
                                                      "1-60","2-1","2-5","2-10","2-25",
                                                      "2-33","3-10","3-20","3-21",
                                                      "3-22","3-26","3-29","3-34","3-37"),]

nonuniform.x = c(594186,594572.4,594468.9,594082.5)
nonuniform.y = c(115943,116046.5,116432.9,116329.4)

load("results/interp.data.r")
spc.value = spc.value[!names(spc.value) %in% c("SWS-1","NRG","S10","S40","T2","T3","T4","T5")]


for (itime in seq(1,length(interp.time)))
##for (itime in seq(1,2))
{
    print(itime)
    jpeg(paste("figures/","spc",itime,".jpg",sep=''),width=6.5,height=6.0,units='in',res=200,quality=100)
    par(mar=c(5.1,6,4.1,10))
    spc.snap = unlist(lapply(spc.value,"[[",itime))
    grid.spc = interp(coord.data[names(spc.value),1][!is.na(spc.snap)],
                        coord.data[names(spc.value),2][!is.na(spc.snap)],
                        spc.snap[!is.na(spc.snap)],
##                        linear=FALSE,
##                        xo=seq(593950,594750,10),
##                        yo=seq(115700,116800,10),
##                        extrap=TRUE
                        )

    filled.contour(grid.spc$x,
                   grid.spc$y,
                   grid.spc$z,
                   xlim = c(594000,594700),
                   ylim = c(115700,116800),          
                   color.palette = cm.colors,
                   zlim=c(0.4,0.65),
                   asp = 1,
                   plot.axes={
                       axis(1)
                       axis(2)


                       well.name = c(rownames(selected.coord.data))
                       name.index = which(coord.data[,3] %in% well.name)
                       text(coord.data[name.index,1],(coord.data[name.index,2]+40),
                            coord.data[name.index,3],col='red')
                       points(coord.data[name.index,1],coord.data[name.index,2],pch=16,col='black')
                       points(rep(nonuniform.x,2),rep(nonuniform.y,2),type="l",col='pink',lwd=2,lty=2)                       
                       lines(slice.x,slice.y,col='grey',lwd=3)
                       lines(slice.new.x,slice.new.y,col='orange',lwd=3,lty=1)


                       well.name = c("SWS-1","NRG")
                       name.index = which(coord.data[,3] %in% well.name)
                       text(coord.data[name.index,1],(coord.data[name.index,2]+40),
                            coord.data[name.index,3],col='blue')
                       points(coord.data[name.index,1],coord.data[name.index,2],pch=16,col='blue')
                       

                       well.name = c("T2","T3","T4","T5")
                       name.index = which(coord.data[,3] %in% well.name)
                       text((coord.data[name.index,1]+40),coord.data[name.index,2],
                            coord.data[name.index,3],col='black')
                       points(coord.data[name.index,1],coord.data[name.index,2],pch=16,col='black')




                       well.name = c("S")
                       name.index = which(coord.data[,3] %in% well.name)
                       text(coord.data[name.index,1]-40,(coord.data[name.index,2]),
                            coord.data[name.index,3],col='black')
                       points(coord.data[name.index,1],coord.data[name.index,2],pch=16,col='black')

                   }
                   )
    mtext(side = 1,at=594120,text='Easting (m)',line=2)
    mtext(side = 2,text='Northing (m)',line=4.5)
##    mtext(side = 3,at=594250,format(interp.time[itime],format="%Y-%m-%d   %H:%M",tz="GMT"),line=1,cex=2)
    mtext(side = 3,at=594250,"SpC (uS/cm)",line=1,cex=2)
    ## legend("topleft",
    ##        paste("Nobs =",length(obs.value),
    ##              ", Nreaz =",dim(state.vector)[1]),
    ##        bty='n')
    
    dev.off()


}
