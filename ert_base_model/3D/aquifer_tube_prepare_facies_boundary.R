rm(list=ls())

library(fields)
library(AtmRay) 
source("~/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
source("~/repos/sbr-river-corridor-sfa/250m_3d_model.R")


west_x = 592000
east_x = 596000
south_y = 114000
north_y = 118000


bath_data = read.table("data/newbath_10mDEM_grid.ascii")
bath_data = t(bath_data)
bath_data = c(bath_data)
bath_x = seq(590999,595499,2)
bath_y = seq(118499,113499,-2)
bath_nx = length(bath_x)
bath_ny = length(bath_y)
bath_x = rep(bath_x,bath_ny)
bath_y = rep(bath_y,each = bath_nx)
bath_data = cbind(bath_x,bath_y,bath_data)
colnames(bath_data) = c("bathx","bathy","bath")
bath_data = bath_data[which(bath_data[,"bathx"]>west_x & bath_data[,"bathx"]<east_x),]
bath_data = bath_data[which(bath_data[,"bathy"]>south_y & bath_data[,"bathy"]<north_y),]
bath_data = bath_data[order(bath_data[,"bathy"],bath_data[,"bathx"]),]
bath_x=sort(as.numeric(names(table(bath_data[,"bathx"]))))
bath_y=sort(as.numeric(names(table(bath_data[,"bathy"]))))
bath_nx = length(bath_x)
bath_ny = length(bath_y)
bath_z = array(as.numeric(unlist(bath_data[,"bath"])),c(bath_nx,bath_ny))         

save(bath_data,file="results/bath_data.r")




units_data = read.table("data/300A_EV_surfaces_012612.dat",header=F,skip=21,stringsAsFactors=FALSE)
data_names = c("meshx","meshy","u1","u2","u3","u4","u5","u6","u7","u8","u9","ringold.surface")
n_data_columns = length(data_names)
names(units_data) = data_names
original_data = units_data
units_data = NULL
data_range = original_data[["meshx"]]
for (i_units in 1:n_data_columns)
{
    units_data[[i_units]] = original_data[[i_units]][which(data_range>west_x & data_range<east_x)]
}
names(units_data) = data_names
original_data = units_data
units_data = NULL
data_range = original_data[["meshy"]]
for (i_units in 1:n_data_columns)
{
    units_data[[i_units]] = original_data[[i_units]][which(data_range>south_y & data_range<north_y)]
}
names(units_data) = data_names
unit_x = sort(as.numeric(names(table(units_data[["meshx"]]))))
unit_y = sort(as.numeric(names(table(units_data[["meshy"]]))))
unit_nx = length(unit_x)
unit_ny = length(unit_y)
unit_z=array(as.numeric(unlist(units_data["ringold.surface"])),c(unit_nx,unit_ny))



cells_model = expand.grid(x,y)
cells_proj = model_to_proj(model_origin,angle,cells_model)

cells_unit = interp.surface(list(x=unit_x,y=unit_y,z=unit_z),cells_proj)
cells_bath = interp.surface(list(x=bath_x,y=bath_y,z=bath_z),cells_proj)
cells_unit = array(cells_unit,c(nx,ny))
cells_bath = array(cells_bath,c(nx,ny))



jon = read.csv('data/JonData.csv',stringsAsFactors=FALSE)
rownames(jon) = jon[,1]
jon = as.matrix(jon[,2:4])


data = read.table('data/proj_coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])


west_x = 593500
east_x = 594900
south_y = 115000
north_y = 117000

jpeg(paste("figures/HR_contact.jpg",sep=''),width=8,height=10,units='in',res=300,quality=100)
par(mar=c(3,3.2,2.5,0))
filled.contour(unit_x,unit_y,unit_z,##levels=seq(0,3,0.5),
        xlim=c(west_x,east_x),
        ylim=c(south_y,north_y),

        zlim=c(88,112),        
        color.palette=terrain.colors,
        asp=1,
        key.title=title("Ringold\nEL. (m)"),
        plot.axes = {
            
            axis(1,mgp=c(0,0.6,0));
            axis(2,mgp=c(0,0.8,0),las=0);

            mtext("Easting (m)",1,line=1.5)
            mtext("Northing (m)",2,line=1.8,las=0)         

         
lines(c(at_project[1,1],at_project[2,1]),c(at_project[1,2],at_project[2,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[2,1],at_project[3,1]),c(at_project[2,2],at_project[3,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[3,1],at_project[4,1]),c(at_project[3,2],at_project[4,2]),col="cyan",lwd=2,lty=2)
lines(c(at_project[4,1],at_project[1,1]),c(at_project[4,2],at_project[1,2]),col="cyan",lwd=2,lty=2)                  

      

lines(c(sd_project[1,1],sd_project[2,1]),c(sd_project[1,2],sd_project[2,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[2,1],sd_project[3,1]),c(sd_project[2,2],sd_project[3,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[3,1],sd_project[4,1]),c(sd_project[3,2],sd_project[4,2]),col="purple",lwd=2,lty=2)
lines(c(sd_project[4,1],sd_project[1,1]),c(sd_project[4,2],sd_project[1,2]),col="purple",lwd=2,lty=2)                  
points(jon[,1],jon[,2],pch=16)

for (iwell in head(rownames(data),-14)) {
#    text(data[iwell,1],data[iwell,2]+20,iwell,col="red")    
    points(data[iwell,1],data[iwell,2],col="red",pch=16)        
}


 well.list = c("1-1","1-16A","1-57","1-10A",
              "2-2","2-3","1-21A",
              "2-1","3-18","3-9",
              "3-10","4-9","4-7")
for (iwell in well.list) {
    text(data[iwell,1],data[iwell,2]+40,iwell,col="red")
}

iwell="SWS-1"
text(data[iwell,1]+100,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        



well.list = c("T2","T3","T4","T5")
for (iwell in well.list) {
    text(data[iwell,1]+70,data[iwell,2],iwell,col="blue")
    points(data[iwell,1],data[iwell,2],col="blue",pch=17)        
}
    




        })

legend("topleft",
       c("Wells","River Gauge","Piezos","Domain A","Domain B"),
       lty=c(NA,NA,NA,2,2,2),
       pch=c(16,16,17,NA,NA,NA),
       col=c("red","blue","blue","purple","cyan"),
       bty="n",
       )
dev.off()




x_plot = x
x_plot[1] = x[1]-dx[1]*0.5
x_plot[length(x_plot)] = x[length(x_plot)]+dx[length(x_plot)]*0.5
y_plot = y
y_plot[1] = y[1]-dy[1]*0.5
y_plot[length(y_plot)] = y[length(y_plot)]+dy[length(y_plot)]*0.5


jpeg(paste("figures/aquifer.model_hr.jpg",sep=''),width=8,height=7,units='in',res=600,quality=100)
par(mar=c(3,3.2,2.5,0))
filled.contour(x_plot,y_plot,cells_unit,
              xlim=range_x,
              ylim=range_y,
               zlim=c(88,112),
               asp=1,
               key.title=title("Hanford\nTHK (m)"),               
               color.palette=terrain.colors,
               plot.axes = {
                   axis(1,mgp=c(0,0.6,0));
                   axis(2,mgp=c(0,0.8,0),las=0);

                   mtext("Rotated easting (m)",1,line=1.5)
                   mtext("Rotated northing (m)",2,line=1.8,las=0)         
                   ## contour(x,y,cellsp.bath,levels=seq(104.2,108.9,4.7),drawlabels=FALSE,
                   ##         col="black",add=T)
#                   points(cells.model[,1],cells.model[,2],pch=16,cex=0.1)



data = proj_to_model(model_origin,angle,data)
jon = proj_to_model(model_origin,angle,jon)
                   
                   points(cells_model[,1],cells_model[,2],pch=16,cex=0.1)
                   
for (iwell in head(rownames(data),-14)) {
#    text(data[iwell,1],data[iwell,2]+20,iwell,col="red")    
    points(data[iwell,1],data[iwell,2],col="red",pch=16)        
}
                   points(jon[,1],jon[,2],pch=16)

 well.list = c("1-1","1-16A","1-57","1-10A",
              "2-2","2-3","1-21A",
              "2-1","3-18","3-9",
              "3-10","4-9","4-7")
for (iwell in well.list) {
    text(data[iwell,1],data[iwell,2]+15,iwell,col="red")
}

iwell="SWS-1"
text(data[iwell,1]+100,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        



well.list = c("T2","T3","T4","T5")
for (iwell in well.list) {
    text(data[iwell,1]+15,data[iwell,2],iwell,col="blue")
    points(data[iwell,1],data[iwell,2],col="blue",pch=17)        
}
    



                   
               }
)
dev.off()





jpeg(paste("figures/aquifer.model.jpg",sep=''),width=8,height=7,units='in',res=600,quality=100)
par(mar=c(3,3.2,2.5,0))
filled.contour(x_plot,y_plot,cells_bath,
              xlim=range_x,
              ylim=range_y,
               zlim=c(100,108),
               asp=1,
               key.title=title("Riverbed\nEL. (m)"),               
               color.palette=terrain.colors,
               plot.axes = {
                   axis(1,mgp=c(0,0.6,0));
                   axis(2,mgp=c(0,0.8,0),las=0);

                   mtext("Rotated easting (m)",1,line=1.5)
                   mtext("Rotated northing (m)",2,line=1.8,las=0)         
                   ## contour(x,y,cellsp.bath,levels=seq(104.2,108.9,4.7),drawlabels=FALSE,
                   ##         col="black",add=T)
#                   points(cells.model[,1],cells.model[,2],pch=16,cex=0.1)



data = proj_to_model(model_origin,angle,data)
jon = proj_to_model(model_origin,angle,jon)
                   
                   points(cells_model[,1],cells_model[,2],pch=16,cex=0.1)
                   
for (iwell in head(rownames(data),-14)) {
#    text(data[iwell,1],data[iwell,2]+20,iwell,col="red")    
    points(data[iwell,1],data[iwell,2],col="red",pch=16)        
}
                   points(jon[,1],jon[,2],pch=16)

 well.list = c("1-1","1-16A","1-57","1-10A",
              "2-2","2-3",
              "2-1","3-18","3-9",
              "3-10","4-9","4-7")
for (iwell in well.list) {
    text(data[iwell,1],data[iwell,2]+15,iwell,col="red")
}

iwell="SWS-1"
text(data[iwell,1]+100,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        



well.list = c("T2","T3","T4","T5")
for (iwell in well.list) {
    text(data[iwell,1]+15,data[iwell,2],iwell,col="blue")
    points(data[iwell,1],data[iwell,2],col="blue",pch=17)        
}
    

               }
)
dev.off()


save(list=c("cells_unit","cells_bath"),file="results/aquifer_tube_bath_unit.r")
