rm(list = ls())
library(rhdf5)
library(BurStFin) #for partial.rainbow
H5close()
load("results/general.r")
case.name='heat2.1'
obs.time = seq(1,960)
ntime = length(obs.time)

load(paste("results/",case.name,".x.velocity",sep=''))
load(paste("results/",case.name,".z.velocity",sep=''))
load(paste("results/",case.name,".hydraulic.head",sep=''))
#load(paste("results/",case.name,".ch2o.conc",sep=''))
#load(paste("results/",case.name,".h.conc",sep=''))
#load(paste("results/",case.name,".hco3.conc",sep=''))
#load(paste("results/",case.name,".n2.conc",sep=''))
#load(paste("results/",case.name,".no3.conc",sep=''))
#load(paste("results/",case.name,".o2.conc",sep=''))
load(paste("results/",case.name,".tracer.conc",sep=''))
tracer.conc = tracer.conc/35.453
load(paste("results/",case.name,".elevation.field",sep=''))


river.gradients=as.matrix(read.table(paste("field.5/",case.name,"/Gradients_River2015.txt",sep='')))
river.level=as.matrix(read.table(paste("field.5/",case.name,"/DatumH_River2015.txt",sep='')))
#river.gradients = river.gradients[(10*24+1):dim(river.gradients)[1],]
#river.level = river.level[(10*24+1):dim(river.level)[1],]


east.level=array(2*dim(river.level)[1],dim=c(dim(river.level)[1],2))
##east.level[,1]=river.level[,1]/3600/24-9
east.level[,1]=river.level[,1]/3600-240
east.level[,2]=(y.new-river.level[,3])*river.gradients[,3]+river.level[,4]

well.level=as.matrix(read.table(paste("field.5/",case.name,"/DatumH_West2015.txt",sep="")))
#well.level = well.level[(10*24+1):dim(river.level)[1],]

west.level=array(2*dim(well.level)[1],dim=c(dim(well.level)[1],2))
##west.level[,1]=well.level[,1]/3600/24-9
west.level[,1]=well.level[,1]/3600-240
west.level[,2]=well.level[,4]

#creat new material id
material_ids.new=h5read(paste("field.5/",case.name,"/Plume_Slice_AdaptiveRes_material.h5",sep=''),"Materials/Material Ids")
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

## header = names(h5.data[[obs.time[1]]][[3]])
## simu.col=grep("Material_ID",header)
## simu.results = h5.data[[obs.time[1]]][[3]][[simu.col]]
## simu.results = aperm(simu.results,c(3,1,2))
## simu.results = simu.results[,,]
#elevation.field=t(replicate(nx.new,z.new))
#elevation.field[simu.results==0]=0

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

for (itime in 1:ntime){

    print(itime)

    jpeg.name = paste("figures/",case.name,".",formatC((itime),width = 3,flag = "0"),
        "_hydraulic.head",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,hydraulic.head[,,itime],
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
                   zlim = range(hydraulic.head[hydraulic.head>100]),
                   color.palette = terrain.colors,
                   xlab = "Rotated east-west direction (m)",
                   ylab = "Elevation (m)",
                   main = paste("Hydraulic head : t =",itime,"hour"),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank.x]-0.5*0.1,z.new[river.bank.z]-0.5*0.05,
                             col = 'black',lwd = 0.5)
                       lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
                             col = "black", lwd = 0.5)
                       lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
                       x.index = rep(seq(1,nx.new),nz.new)
                       z.index = rep(seq(1,nz.new),each = nx.new)
                       ## x.index = x.index[hydraulic.head[,,itime]<0][which(elevation.field[hydraulic.head[,,itime]<0]>0)]
                       ## z.index = z.index[hydraulic.head[,,itime]<0][which(elevation.field[hydraulic.head[,,itime]<0]>0)]
                       x.index = x.index[intersect(which(hydraulic.head[,,itime]<elevation.field),which(elevation.field>0))]
                       z.index = z.index[intersect(which(hydraulic.head[,,itime]<elevation.field),which(elevation.field>0))]
#                       z.index = z.index[hydraulic.head[,,itime]<elevation.field]

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
                       current.west.level = west.level[which.min(abs(west.level[,1]-obs.time[itime])),2] 
                       current.east.level = east.level[which.min(abs(east.level[,1]-obs.time[itime])),2]
                       current.east.interface = x.new[river.bank.x[which.min(abs(z.new[river.bank.z]-
                                                                                   current.east.level))]]
                       lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
                       points(east.new,current.west.level,col = "black",pch = 16)
                       text((east.new-10),current.east.level+2,
                            paste("dh =",
                                  formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
                            col="black")

                       
                   }
                   )
    dev.off()

    ## jpeg.name = paste("figures/",case.name,formatC((itime),width = 3,flag = "0"),
    ##     "_CH2O",".jpg",sep = "")
    ## jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    ## par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    ## filled.contour(x.new,z.new,ch2o.conc[,,itime],
    ##                ylim = c(bottom.new,top.new),
    ##                xlim = c(west.new,east.new),
    ##                zlim= range(ch2o.conc),
    ##                color = function(x)rev(heat.colors(x)),
    ##                xlab = "Rotated east-west direction (m)",
    ##                ylab = expression("CH"[2]*"O (mg/L)"),
    ##                main = bquote("CH"[2]*"O : t =" ~.(obs.time[itime]) ~ "day" ),
    ##                asp = 1.0,
    ##                plot.axes = {
    ##                    axis(1,cex.axis = 1.)
    ##                    axis(2,cex.axis = 1.)
    ##                    lines(x.new[river.bank.x]-0.5*0.1,z.new[river.bank.z]-0.5*0.05,
    ##                          col = 'black',lwd = 0.5)
    ##                    lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
    ##                          col = "black", lwd = 0.5)
    ##                    lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
    ##                    lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

    ##                    lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
    ##                    points(east.new,current.west.level,col = "black",pch = 16)
    ##                    text((east.new-10),current.east.level+2,
    ##                         paste("dh =",
    ##                               formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
    ##                         col="black")
    ##                }
    ##                )
    ## dev.off()

    ## jpeg.name = paste("figures/",case.name,formatC((itime),width = 3,flag = "0"),
    ##     "_H+",".jpg",sep = "")
    ## jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    ## par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    ## filled.contour(x.new,z.new,h.conc[,,itime],
    ##                ylim = c(bottom.new,top.new),
    ##                xlim = c(west.new,east.new),
    ##                zlim = range(h.conc),
    ##                color = function(x)rev(heat.colors(x)),
    ##                xlab = "Rotated east-west direction (m)",
    ##                ylab = expression("H+ (mg/L)"),
    ##                main = bquote("H+ : t =" ~.(obs.time[itime]) ~ "day" ),
    ##                asp = 1.0,
    ##                plot.axes = {
    ##                    axis(1,cex.axis = 1.)
    ##                    axis(2,cex.axis = 1.)
    ##                    lines(x.new[river.bank.x]-0.5*0.1,z.new[river.bank.z]-0.5*0.05,
    ##                          col = 'black',lwd = 0.5)
    ##                    lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
    ##                          col = "black", lwd = 0.5)
    ##                    lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
    ##                    lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

    ##                    lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
    ##                    points(east.new,current.west.level,col = "black",pch = 16)
    ##                    text((east.new-10),current.east.level+2,
    ##                         paste("dh =",
    ##                               formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
    ##                         col="black")
    ##                }
    ##                )
    ## dev.off()
    
    ## jpeg.name = paste("figures/",case.name,formatC((itime),width = 3,flag = "0"),
    ##     "_HCO3-",".jpg",sep = "")
    ## jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    ## par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    ## filled.contour(x.new,z.new,hco3.conc[,,itime],
    ##                ylim = c(bottom.new,top.new),
    ##                xlim = c(west.new,east.new),
    ##                zlim = range(hco3.conc),
    ##                color = function(x)rev(heat.colors(x)),
    ##                xlab = "Rotated east-west direction (m)",
    ##                ylab = expression("HCO"[3]*"- (mg/L)"),
    ##                main = bquote("HCO"[3]*"- : t =" ~.(obs.time[itime]) ~ "day" ),
    ##                asp = 1.0,
    ##                plot.axes = {
    ##                    axis(1,cex.axis = 1.)
    ##                    axis(2,cex.axis = 1.)
    ##                    lines(x.new[river.bank.x]-0.5*0.1,z.new[river.bank.z]-0.5*0.05,
    ##                          col = 'black',lwd = 0.5)
    ##                    lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
    ##                          col = "black", lwd = 0.5)
    ##                    lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
    ##                    lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

    ##                    lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
    ##                    points(east.new,current.west.level,col = "black",pch = 16)
    ##                    text((east.new-10),current.east.level+2,
    ##                         paste("dh =",
    ##                               formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
    ##                         col="black")
    ##                }
    ##                )
    ## dev.off()


    ## jpeg.name = paste("figures/",case.name,formatC((itime),width = 3,flag = "0"),
    ##     "_N2",".jpg",sep = "")
    ## jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    ## par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    ## filled.contour(x.new,z.new,n2.conc[,,itime],
    ##                ylim = c(bottom.new,top.new),
    ##                xlim = c(west.new,east.new),
    ##                zlim = range(n2.conc),
    ##                color = function(x)rev(heat.colors(x)),
    ##                xlab = "Rotated east-west direction (m)",
    ##                ylab = expression("N"[2]*" (mg/L)"),
    ##                main = bquote("N"[2]*" concentration : t =" ~.(obs.time[itime]) ~ "day" ),
    ##                asp = 1.0,
    ##                plot.axes = {
    ##                    axis(1,cex.axis = 1.)
    ##                    axis(2,cex.axis = 1.)
    ##                    lines(x.new[river.bank.x]-0.5*0.1,z.new[river.bank.z]-0.5*0.05,
    ##                          col = 'black',lwd = 0.5)
    ##                    lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
    ##                          col = "black", lwd = 0.5)
    ##                    lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
    ##                    lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

    ##                    lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
    ##                    points(east.new,current.west.level,col = "black",pch = 16)
    ##                    text((east.new-10),current.east.level+2,
    ##                         paste("dh =",
    ##                               formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
    ##                         col="black")
    ##                }
    ##                )
    ## dev.off()

    
    ## jpeg.name = paste("figures/",case.name,formatC((itime),width = 3,flag = "0"),
    ##     "_NO3-",".jpg",sep = "")
    ## jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    ## par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    ## filled.contour(x.new,z.new,no3.conc[,,itime],
    ##                ylim = c(bottom.new,top.new),
    ##                xlim = c(west.new,east.new),
    ##                zlim = range(no3.conc),
    ##                color = function(x)rev(heat.colors(x)),
    ##                xlab = "Rotated east-west direction (m)",
    ##                ylab = expression("NO"[3]*"- (mg/L)"),
    ##                main = bquote("NO"[3]*"- : t =" ~.(obs.time[itime]) ~ "day" ),
    ##                asp = 1.0,
    ##                plot.axes = {
    ##                    axis(1,cex.axis = 1.)
    ##                    axis(2,cex.axis = 1.)
    ##                    lines(x.new[river.bank.x]-0.5*0.1,z.new[river.bank.z]-0.5*0.05,
    ##                          col = 'black',lwd = 0.5)
    ##                    lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
    ##                          col = "black", lwd = 0.5)
    ##                    lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
    ##                    lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

    ##                    lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
    ##                    points(east.new,current.west.level,col = "black",pch = 16)
    ##                    text((east.new-10),current.east.level+2,
    ##                         paste("dh =",
    ##                               formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
    ##                         col="black")
    ##                }
    ##                )
    ## dev.off()

    ## jpeg.name = paste("figures/",case.name,formatC((itime),width = 3,flag = "0"),
    ##     "_O2",".jpg",sep = "")
    ## jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    ## par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    ## filled.contour(x.new,z.new,o2.conc[,,itime],
    ##                ylim = c(bottom.new,top.new),
    ##                xlim = c(west.new,east.new),
    ##                zlim = range(o2.conc),
    ##                color = function(x)rev(heat.colors(x)),
    ##                xlab = "Rotated east-west direction (m)",
    ##                ylab = expression("O"[2]*" (mg/L)"),
    ##                main = bquote("O"[2]*" concentration : t =" ~.(obs.time[itime]) ~ "day" ),
    ##                asp = 1.0,
    ##                plot.axes = {
    ##                    axis(1,cex.axis = 1.)
    ##                    axis(2,cex.axis = 1.)
    ##                    lines(x.new[river.bank.x]-0.5*0.1,z.new[river.bank.z]-0.5*0.05,
    ##                          col = 'black',lwd = 0.5)
    ##                    lines(x.new[mud.hanford[,1]]-0.5*0.1,z.new[mud.hanford[,2]]-0.5*0.05,
    ##                          col = "black", lwd = 0.5)
    ##                    lines(x.new[hanford.ringold[,1]],z.new[hanford.ringold[,2]],lwd = 0.5)
    ##                    lines(x.new[x.vadose],z.new[z.vadose],lty = 2,lwd = 0.5)

    ##                    lines(c(current.east.interface,east.new),rep(current.east.level,2),col = "blue",lwd = 0.8)
    ##                    points(east.new,current.west.level,col = "black",pch = 16)
    ##                    text((east.new-10),current.east.level+2,
    ##                         paste("dh =",
    ##                               formatC(current.east.level-current.west.level,digits=2,format="e"),"m"),
    ##                         col="black")
    ##                }
    ##                )
    ## dev.off()

    jpeg.name = paste("figures/",case.name,".",formatC((itime),width = 3,flag = "0"),
        "_Tracer",".jpg",sep = "")
    jpeg(jpeg.name,width = 12,height = 2.58,units = "in",res = 300, quality = 100)
    par(xpd=TRUE,mgp=c(2.,0.6,0),mar=c(4.1,4.1,2.1,2.1))
    filled.contour(x.new,z.new,tracer.conc[,,itime],
                   ylim = c(bottom.new,top.new),
                   xlim = c(west.new,east.new),
                   zlim = range(tracer.conc),
                   color = function(x)rev(heat.colors(x)),
                   xlab = "Rotated east-west direction (m)",
                   ylab = expression("Tracer (mg/l)"),
                   main = bquote("Tracer : t =" ~.(obs.time[itime]) ~ "hour" ),
                   asp = 1.0,
                   plot.axes = {
                       axis(1,cex.axis = 1.)
                       axis(2,cex.axis = 1.)
                       lines(x.new[river.bank.x]-0.5*0.1,z.new[river.bank.z]-0.5*0.05,
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
