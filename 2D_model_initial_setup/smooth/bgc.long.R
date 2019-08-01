#rm(list = ls())
library(rhdf5)
library(BurStFin) #for partial.rainbow
H5close()

#source("codes/create.material.grid.R")
load("results/material.grid.data")
obs.time = seq(1,113)
ntime = length(obs.time)


## prefix.h5file = "long.multi/2duniform-"
## h5.data=list()
## for (itime in obs.time)
## {
##     h5.file = paste(prefix.h5file,formatC((itime-1),width=3,flag='0'),".h5",sep='') #sprintf("%03d",x)
##     h5.data[[itime]] = h5dump(h5.file)
##     print(itime)
## }
## save(h5.data,file="results/h5.long.multi")
## H5close()


## stop()

## load("results/h5.long.multi")


river.gradients=as.matrix(read.table("reference/Gradients_River_Plume2013.txt"))
river.level=as.matrix(read.table("reference/DatumH_River_Plume2013.txt"))
east.level=array(2*dim(river.level)[1],dim=c(dim(river.level)[1],2))
east.level[,1]=river.level[,1]/3600/24
east.level[,2]=(y.new-river.level[,3])*river.gradients[,3]+river.level[,4]

well.level=as.matrix(read.table("reference/DatumH_West_Plume2013.txt"))
west.level=array(2*dim(well.level)[1],dim=c(dim(well.level)[1],2))
west.level[,1]=well.level[,1]/3600/24
west.level[,2]=well.level[,4]

#creat new material id
material_ids.new=h5read("reference/Plume_Slice_AdaptiveRes_material.h5","Materials/Material Ids")
material_ids.new=array(material_ids.new,c(nx.new,ny.new,nz.new))
material_ids.reverse=material_ids.new
#find river.bank
mud.hanford=NULL
for (iz in nz.new:2)
    {
        for (ix in nx.new:2)
            {
                if (((material_ids.new[ix,1,iz]-material_ids.new[ix,1,(iz-1)])==4) || 
                    ((material_ids.new[ix,1,iz]-material_ids.new[(ix-1),1,iz])==4))
                        
                    {
                        mud.hanford=rbind(mud.hanford,c(ix,iz))
                    }
            }
    }
mud.hanford = mud.hanford[order(mud.hanford[,1]),]

hanford.ringold=NULL
for (iz in nz.new:2)
    {
        for (ix in (nx.new-1):2)
            {
                if (((material_ids.new[ix,1,iz]-material_ids.new[ix,1,(iz-1)])==-3) ||
                    ((material_ids.new[ix,1,iz]-material_ids.new[(ix-1),1,iz])==-3) ||
                    ((material_ids.new[ix,1,iz]-material_ids.new[(ix+1),1,iz])==-3))                        

                    {
                        hanford.ringold=rbind(hanford.ringold,c(ix,iz))
                    }
            }
    }
hanford.ringold = hanford.ringold[order(hanford.ringold[,1]),]

header = names(h5.data[[obs.time[1]]][[3]])
simu.col=grep("Material_ID",header)
simu.results = h5.data[[obs.time[1]]][[3]][[simu.col]]
simu.results = aperm(simu.results,c(3,1,2))
simu.results = simu.results[,,]
elevation.field=t(replicate(nx.new,z.new))
elevation.field[simu.results==0]=0

obs.type = c("X-Velocity",
    "Y-Velocity",
    "Z-Velocity",
    "Liquid_Pressure",
    "Liquid_Saturation",
    "Material_ID",
    "Total_CH2O(aq)", #12.0107
    "Total_H+",       #1.00794
    "Total_HCO3-",    #12.0107
    "Total_N2(aq)",   #28.0134
    "Total_NO3- [M]", #62.005
    "Total_Total_O2(aq)", #31.9988
    "Tracer ")


x.veloctiy.all=array(rep(nx.new*nz.new*ntime))

for (itime in obs.time) {
    print(itime)
    simu.col=grep("X-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    simu.col=grep("Y-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]


    simu.col=grep("Z-Velocity",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]
    
}




stop()



for (itime in obs.time){

    print(itime)
    
    simu.col=grep("Liquid_Pressure",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    pressure.head = (simu.results-101325)/9.8068/1000
    hydraulic.head = pressure.head+elevation.field
    jpeg.name = paste("figures/long.",formatC((itime-1),width = 3,flag = "0"),
        "_hydraulic.head",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,hydraulic.head,
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
#                   zlim = c(105,107),
#                   zlim = range(hydraulic.head[elevation.field!=0]),
                   zlim = c(105,107),
                   color.palette = terrain.colors,
                   xlab = "Rotated east-west direction (m)",
                   ylab = "Elevation (m)",
                   main = paste("Hydraulic head : t =",itime-1,"day"),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank[,1]]-0.5*0.1,z.new[river.bank[,2]]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       x.index = rep(seq(1,nx.new),nz.new)
                       z.index = rep(seq(1,nz.new),each = nx.new)
                       x.index = x.index[pressure.head<0][which(elevation.field[pressure.head<0]>0)]
                       z.index = z.index[pressure.head<0][which(elevation.field[pressure.head<0]>0)]
                       x.vadose = unique(x.index)
                       x.vadose = sort(x.vadose)
                       z.vadose = rep(0,length(x.vadose))                       
                       j=1
                       for (i in 1:length(x.vadose))
                           {
                               z.vadose[i] = min(z.index[x.index==x.vadose[i]])
                               j=j+1
                           }
                       lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)
                       current.west.level = west.level[which.min(abs(west.level[,1]-itime)),2] 
                       current.east.level = east.level[which.min(abs(east.level[,1]-itime)),2]
                       current.east.interface = x.new[river.bank[which.min(abs(z.new[river.bank[,2]]-
                                                                                   current.east.level)),1]]
                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")

                       
                   }
                   )
    dev.off()

    simu.col=grep("Total_CH2O",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    tracer = simu.results*12.0107*1000
    tracer[elevation.field==0]=-10
    
    jpeg.name = paste("figures/long.",formatC((itime-1),width = 3,flag = "0"),"_CH2O",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,tracer,
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
#                   zlim= range(tracer[elevation.field!=0]),
                   zlim = c(0,1.5),
                   color = function(x)rev(heat.colors(x)),
                   xlab = "Rotated east-west direction (m)",
                   ylab = expression("CH"[2]*"O (mg/L)"),
                   main = bquote("CH"[2]*"O : t =" ~.(itime-1) ~ "day" ),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank[,1]]-0.5*0.1,z.new[river.bank[,2]]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")
                   }
                   )
    dev.off()



    simu.col=grep("Total_H+",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    tracer = simu.results*1.00794*1000
    tracer[elevation.field==0]=-10
    
    jpeg.name = paste("figures/long.",formatC((itime-1),width = 3,flag = "0"),"_H+",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,tracer,
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
                   zlim = range(tracer[elevation.field!=0]),
                   color = function(x)rev(heat.colors(x)),
                   xlab = "Rotated east-west direction (m)",
                   ylab = expression("H+ (mg/L)"),
                   main = bquote("H+ : t =" ~.(itime-1) ~ "day" ),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank[,1]]-0.5*0.1,z.new[river.bank[,2]]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")
                   }
                   )
    dev.off()
    


    simu.col=grep("Total_HCO3-",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    tracer = simu.results*12.0107*1000
    tracer[elevation.field==0]=-10
    
    jpeg.name = paste("figures/long.",formatC((itime-1),width = 3,flag = "0"),"_HCO3-",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,tracer,
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
#                   zlim = range(tracer[elevation.field!=0]),
                   zlim = c(15,30),                   
                   color = function(x)rev(heat.colors(x)),
                   xlab = "Rotated east-west direction (m)",
                   ylab = expression("HCO"[3]*"- (mg/L)"),
                   main = bquote("HCO"[3]*"- : t =" ~.(itime-1) ~ "day" ),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank[,1]]-0.5*0.1,z.new[river.bank[,2]]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")
                   }
                   )
    dev.off()



    simu.col=grep("Total_N2",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    tracer = simu.results*28.0134*1000
    tracer[elevation.field==0]=-10
    
    jpeg.name = paste("figures/long.",formatC((itime-1),width = 3,flag = "0"),"_N2",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,tracer,
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
#                   zlim = range(tracer[elevation.field!=0]),
                   zlim = c(0,0.03),
                   color = function(x)rev(heat.colors(x)),
                   xlab = "Rotated east-west direction (m)",
                   ylab = expression("N"[2]*" (mg/L)"),
                   main = bquote("N"[2]*" concentration : t =" ~.(itime-1) ~ "day" ),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank[,1]]-0.5*0.1,z.new[river.bank[,2]]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")
                   }
                   )
    dev.off()



    simu.col=grep("Total_NO3-",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    tracer = simu.results*62.005*1000
    tracer[elevation.field==0]=-10
    
    jpeg.name = paste("figures/long.",formatC((itime-1),width = 3,flag = "0"),"_NO3-",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,tracer,
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
#                   zlim = range(tracer[elevation.field!=0]),
                   zlim = c(0,25),
                   color = function(x)rev(heat.colors(x)),
                   xlab = "Rotated east-west direction (m)",
                   ylab = expression("NO"[3]*"- (mg/L)"),
                   main = bquote("NO"[3]*"- : t =" ~.(itime-1) ~ "day" ),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank[,1]]-0.5*0.1,z.new[river.bank[,2]]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")
                   }
                   )
    dev.off()


    simu.col=grep("Total_O2",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    tracer = simu.results*31.9988*1000
    tracer[elevation.field==0]=-10
    
    jpeg.name = paste("figures/long.",formatC((itime-1),width = 3,flag = "0"),"_O2",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,tracer,
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
#                   zlim = range(tracer[elevation.field!=0]),
                   zlim = c(5,10),
                   color = function(x)rev(heat.colors(x)),
                   xlab = "Rotated east-west direction (m)",
                   ylab = expression("O"[2]*" (mg/L)"),
                   main = bquote("O"[2]*" concentration : t =" ~.(itime-1) ~ "day" ),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank[,1]]-0.5*0.1,z.new[river.bank[,2]]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")
                   }
                   )
    dev.off()



    simu.col=grep("Total_Tracer",header,fixed = TRUE)
    simu.results = h5.data[[itime]][[3]][[simu.col]]
    simu.results = aperm(simu.results,c(3,1,2))
    simu.results = simu.results[,,]

    tracer = simu.results*35.453*1000
    tracer[elevation.field==0]=-10
    
    jpeg.name = paste("figures/long.",formatC((itime-1),width = 3,flag = "0"),"_CI",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,tracer,
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
#                   zlim = range(tracer[elevation.field!=0]),
                   zlim = c(0,40),
                   color = function(x)rev(heat.colors(x)),
                   xlab = "Rotated east-west direction (m)",
                   ylab = expression("Cl- (mg/L)"),
                   main = bquote("Cl- : t =" ~.(itime-1) ~ "day" ),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank[,1]]-0.5*0.1,z.new[river.bank[,2]]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)


                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,                       
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")
                   }
                   )
    dev.off()



    
}
