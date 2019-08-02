rm(list=ls())
library(fields)
library(AtmRay)
library(rhdf5) 

source("./codes/xuehang_R_functions.R")
source("./codes/ifrc_120m_3d.R")


##------------to extract known ringold surface
west_x = 592000
east_x = 596000
south_y = 114000
north_y = 118000

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
cells_unit = array(cells_unit,c(nx,ny))

known.ringold = c()
grids = expand.grid(x,y,z)
for (iy in 1:ny)
{
    print(iy)
    for (ix in 1:nx)
    {
        cells.temp = which(grids[,1]==x[ix] & grids[,2]==y[iy])
        known.ringold = c(known.ringold,
                          cells.temp[which((grids[cells.temp,3]+dz*0.5)<cells_unit[ix,iy])])
    }
}
known.ringold = sort(known.ringold)

upper.satu = max(h5read("pflotran_mc/BC_UK1_Oct2011_Starting0_exponential.h5","BC_East/Data"))
grids = expand.grid(x,y,z)
remove.deep.ringold = c(1:c(nx*ny*nz))[-known.ringold]
cells.to.update = remove.deep.ringold[which(grids[remove.deep.ringold,3]<=upper.satu)]
save(cells.to.update,file="results/cells_to_update.r")
save(known.ringold,file="results/known_ringold.r")


well.elevation = read.csv("data/well_elevation.csv")
rownames(well.elevation) = well.elevation[,1]

lithodata = read.table("data/lithofacies.txt",skip=1,stringsAsFactors=FALSE)

for (irow in 1:nrow(lithodata))
{
    wells_proj = lithodata[,2:3]
    wells_ringold = interp.surface(list(x=unit_x,y=unit_y,z=unit_z),wells_proj)    
}    

tprogs.prob = array(NA,c(nrow(lithodata),3))
colnames(tprogs.prob) = c("G","S","M")

for (irow in 1:nrow(lithodata))
{
    if (nchar(lithodata[irow,6])==1) {
        main.prob = 0.9
        secondary.prob = 0.05
        thirdary.prob = secondary.prob
    } else if (nchar(lithodata[irow,6])==2) {
        main.prob = 0.8
        secondary.prob = 0.15
        thirdary.prob = 0.05
    } else {
        main.prob = 0.7
        secondary.prob = 0.15
        thirdary.prob = secondary.prob
    }
    facies.all.temp = unlist(strsplit(lithodata[irow,6],""))
    main.temp = facies.all.temp[unlist(gregexpr("[A-Z]",lithodata[irow,6]))]
    other.temp = toupper(facies.all.temp[unlist(gregexpr("[a-z]",lithodata[irow,6]))]    )
    tprogs.prob[irow,main.temp] = main.prob    
    if(length(other.temp)==0){
        tprogs.prob[irow,is.na(tprogs.prob[irow,])] = secondary.prob
    } else if(length(other.temp)==1){
        tprogs.prob[irow,other.temp] = secondary.prob
        tprogs.prob[irow,is.na(tprogs.prob[irow,])] = thirdary.prob
    } else {
        tprogs.prob[irow,other.temp] = secondary.prob
    }
}

for (irow in 1:nrow(lithodata))
{

    if (unlist(gregexpr("[A-Z]",lithodata[irow,6]))=="S")
    {
        tprogs.prob[irow,"G"] = 1
        tprogs.prob[irow,"S"] = 0
        tprogs.prob[irow,"M"] = 0        
    }

}


lithodata = cbind(lithodata[,1:5],tprogs.prob)
lithodata[,2:3] = proj_to_model(model_origin,angle,lithodata[,2:3])
lithodata[,4:5] = lithodata[,4:5]*0.3048
lithodata[,1] = gsub("-0","-",lithodata[,1])
lithodata[,4] = well.elevation[lithodata[,1],"Elevation"]-lithodata[,4]
lithodata[,5] = well.elevation[lithodata[,1],"Elevation"]-lithodata[,5]

remote.hard = which(lithodata[,5]<wells_ringold)
lithodata[remote.hard,5] = wells_ringold[remote.hard]

ndata = nrow(lithodata)
hard.data = c()
hard.data = rbind(hard.data,"IFRC facies data")
hard.data = rbind(hard.data,"6")
hard.data = rbind(hard.data,"x = easting (m)")
hard.data = rbind(hard.data,"y = northing (m)")
hard.data = rbind(hard.data,"z = elevation above mean sea level (m)")
hard.data = rbind(hard.data,"1 = hanford")
hard.data = rbind(hard.data,"2 = ringold")
hard.data = rbind(hard.data,"3 = ringold_gravel")

borehole.loc = c()
for (idata in 1:ndata)
{
    data.z = z[which(z<=lithodata[idata,4] & z>=lithodata[idata,5])]
    npoint = length(data.z)
    data.x = x[which.min(abs(lithodata[idata,2]-x))]
    data.y = y[which.min(abs(lithodata[idata,3]-y))]
    ## data.x = lithodata[idata,2]
    ## data.y = lithodata[idata,3]    
    
    if (npoint>0)
        {
            for (ipoint in 1:npoint)
            {
                hard.data = rbind(hard.data,
                                  paste(c(data.x,data.y,(data.z[ipoint]),lithodata[idata,6:8]),collapse=" "))
                borehole.loc = c(borehole.loc,
                                 which(grids[,1]==data.x & grids[,2]==data.y & grids[,3]==data.z[ipoint]))
            }
        }

}
file = paste("dainput/prior_data.eas",sep="")

writeLines(hard.data,file)


save(borehole.loc,file="results/borehole_loc.r")
