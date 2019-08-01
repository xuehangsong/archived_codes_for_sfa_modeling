rm(list=ls())
library(akima)
load("results/dense_array_therm.r")



toplayer.index = c()
for (itransect in transect.names)
{

    for (irow in row.types)
    {
        temp1.index = which(transect.index == itransect &
                            transect.row == irow)
        temp1.index = temp1.index[order(therm.depth[temp1.index])]
        toplayer.index = c(toplayer.index,temp1.index[1])
    }
}

toplayer.index = toplayer.index[which(therm.depth[toplayer.index]>45 &
                                      therm.depth[toplayer.index]<55)]



xo = seq(min(therm.coord[toplayer.index,1]),max(therm.coord[toplayer.index,1]),length.out=100)
yo = seq(min(therm.coord[toplayer.index,2]),max(therm.coord[toplayer.index,2]),length.out=100)



#for (itime in seq(1,length(obs.time),12*5*3))
for (itime in seq(1,37602,12*5*3))    
#for (itime in c(1,25))    
{
    if(all(!is.na(as.numeric(data[itime,toplayer.index]))))
    {
        print(itime)
        jpeg(paste("dense_array_figures/",sprintf("%.5i",itime),".jpg",sep=''),
             width=5,height=6,units='in',res=100,quality=100)
        value = interp(therm.coord[toplayer.index,1],
                       therm.coord[toplayer.index,2],
                       as.numeric(data[itime,toplayer.index]),
                       xo,
                       yo,
                       )[["z"]]
        value = value-mean(value,na.rm=TRUE)
        threhold = c(-max(abs(value),na.rm=TRUE),
                     max(abs(value),na.rm=TRUE))
        ## value[value>threhold[2]] = threhold[2]
        ## value[value<threhold[1]] = threhold[1]
        filled.contour(xo,
                       yo,
                       value,
                       xlim = c(594450,594490),
                       ylim = c(116250,116320),
                       asp=1,
                       zlim =threhold,
                       plot.axes = {
                           axis(1,mgp=c(0,0.6,0));
                           axis(2,mgp=c(0,0.8,0),las=0);
                           mtext("Easting (m)",1,line=1.5);
                           mtext("Northing (m)",2,line=2,las=0);
                           mtext(obs.time[itime],3,line=1,cex=2);                           
                           points(therm.coord[toplayer.index,1],
                                  therm.coord[toplayer.index,2],
                                  pch=16,
                                  cex=0.5
                                  )
                       }
                       )

        dev.off()
    }
}
