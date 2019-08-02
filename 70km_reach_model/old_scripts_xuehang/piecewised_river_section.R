rm(list=ls())
library(rhdf5)

load("/Users/song884/Dropbox/Reach_scale_model/results/geoframework.r")
results.dir = "/Users/song884/Dropbox/Reach_scale_model/results/"
data.dir = "/Users/song884/Dropbox/Reach_scale_model/data/"
river.cells  = read.csv(
    "/Users/song884/Dropbox/Reach_scale_model/results/river_cell_coord.csv")

material.file = "/Users/song884/Dropbox/Reach_scale_model/Inputs/HFR_material.h5"
material.file = "/Users/song884/Dropbox/Reach_scale_model/Inputs/HFR_material_riverID.h5"
model.dir = "/Users/song884/Dropbox/Reach_scale_model/Inputs/"

new.material.file = "HFR_material_river.h5"
new.material.file = "HFR_material_plot.h5"



river.material = paste(model.dir,new.material.file,sep="")
file.copy(material.file,river.material,overwrite=TRUE)


mass.coord = read.csv(paste(data.dir,"MASS1/coordinates.csv",sep=""))
mass.coord[,"easting"] = mass.coord[,"easting"]-model_origin[1]
mass.coord[,"northing"] = mass.coord[,"northing"]-model_origin[2]

n.mass = nrow(mass.coord)

nriver = nrow(river.cells)
river.section = rep(NA,nriver)
for (iriver in 1:nriver)
{
    mass.coord.index  =
        min(order((river.cells[iriver,"x"]-mass.coord[,"easting"])**2+
                  (river.cells[iriver,"y"]-mass.coord[,"northing"])**2)[1:2])
    river.section[iriver] = mass.coord[mass.coord.index,1]
}

mass.sections = sort(unique(river.section))
nsection = length(mass.sections)
colors = rainbow(nsection,start=0,end=0.7)
names(colors)=as.character(mass.sections)


## write river faces to material
h5createGroup(river.material,"Regions")
for (isection in sort(mass.sections))
{
    river.group = paste("Regions/Mass1_",isection,sep="")
    h5createGroup(river.material,river.group)
    cells.in.mass = river.cells[which(river.section==isection),
                                c("cell_id")]
    faces.in.mass = river.cells[which(river.section==isection),
                                c("face_id")]
    h5write(cells.in.mass,river.material,
            paste(river.group,"/Cell Ids",sep=""),level=0)
    h5write(faces.in.mass,river.material,
            paste(river.group,"/Face Ids",sep=""),level=0)
}
H5close()



# generate pflotran_section
in.region=c()
in.flow=c()
in.coupler=c()
for (isection in sort(mass.sections))
{
    in.region = c(in.region,
                   paste("REGION Mass1_",isection,sep=""))
    in.region = c(in.region,
                   paste("    FILE ",new.material.file,sep=""))
    in.region = c(in.region,"END")
    in.region = c(in.region,"")


    in.flow = c(in.flow,
                   paste("FLOW_CONDITION Flow_",isection,sep=""))
    in.flow = c(in.flow,
                   "    TYPE")                
    in.flow = c(in.flow,
                   "        PRESSURE conductance")                
    in.flow = c(in.flow,
                   "    END")                
    in.flow = c(in.flow,
                   "    CONDUCTANCE 2.5d-13")                
    in.flow = c(in.flow,
                paste("    DATUM FILE ./bc/DatumH_Mass1_2010_2017_",
                      isection,".txt",sep=""))
    in.flow = c(in.flow,
                "    PRESSURE 101325.d0")
    in.flow = c(in.flow,
                "    GRADIENT")
    in.flow = c(in.flow,
                paste("        PRESSURE FILE ./bc/Gradients_Mass1_2010_2017_",
                      isection,".txt",sep=""))
    in.flow = c(in.flow,
                   "    END")                
    in.flow = c(in.flow,
                   "END")                
    in.flow = c(in.flow,"")    


    in.coupler = c(in.coupler,
                   paste("BOUNDARY_CONDITION River_",isection,sep=""))
    in.coupler = c(in.coupler,
                   paste("    FLOW_CONDITION Flow_",isection,sep=""))
    in.coupler = c(in.coupler,
                   "    TRANSPORT_CONDITION River")
    in.coupler = c(in.coupler,
                   paste("    REGION Mass1_",isection,sep=""))
    in.coupler = c(in.coupler,"END")
    in.coupler = c(in.coupler,"")
}
fname=file(paste(model.dir,"coupler.in",sep=""))
writeLines(in.coupler,fname)

fname=file(paste(model.dir,"flow.in",sep=""))
writeLines(in.flow,fname)

in.flow = gsub("/bc/","/bc_smooth/",in.flow)
fname=file(paste(model.dir,"smooth_flow.in",sep=""))
writeLines(in.flow,fname)

fname=file(paste(model.dir,"region.in",sep=""))
writeLines(in.region,fname)




plot(mass.coord[,"easting"],
     mass.coord[,"northing"],
     asp=1,cex=0.5,col="white",
     xlim=c(10000,60000),
     ylim=c(0,60000),
     )
points(river.cells[,"x"],river.cells[,"y"],
       col=colors[as.character(river.section)],
       cex=0.5,pch=16)





## for (i.mass in 1:n.mass)
## {
##     lines(rep(mass.coord[i.mass,"easting"],2),
##           c(mass.coord[i.mass,"northing"]-block.length,
##             mass.coord[i.mass,"northing"]+block.length),
##           col="red"
##           )
##     lines(c(mass.coord[i.mass,"easting"]-block.length,
##             mass.coord[i.mass,"easting"]+block.length),
##           rep(mass.coord[i.mass,"northing"],2),
##           col="blue"
##           )
## }
