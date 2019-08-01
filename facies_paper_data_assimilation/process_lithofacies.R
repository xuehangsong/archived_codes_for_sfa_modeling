rm(list=ls())
source("/Users/song884/repos/sbr-river-corridor-sfa/xuehang_R_functions.R")
source("/Users/song884/repos/sbr-river-corridor-sfa/ifrc_120m_3d.R")


output.dir = "./"

well.elevation = read.csv("data/well_elevation.csv")
rownames(well.elevation) = well.elevation[,1]

lithodata = read.table("data/lithofacies.txt",skip=1,stringsAsFactors=FALSE)
## G:Gravel---------------------1
## gM:gravel mud----------------9
## gmS:gravely mudy Sand--------9
## gS:gravely sand--------------9
## M:Mud (Silt and/or gGlay)----4
## mG:mudy Gravel---------------9
## mS: mudy Sand----------------4
## msG: mudy sandy Gravel-------9
## S:sand-----------------------4
## sG:sandy Gravel--------------9
## sM:--------------------------4
lithodata[which(
    lithodata[,6]=="G"   |
    lithodata[,6]=="mG"  |
    lithodata[,6]=="msG" |
    lithodata[,6]=="sG"
),6]="1 0 0"

lithodata[which(
    lithodata[,6]=="mS"  |
    lithodata[,6]=="S"   |
    lithodata[,6]=="gmS" |
    lithodata[,6]=="gS"
),6]="0 1 0"

lithodata[which(
    lithodata[,6]=="gM"  |            
    lithodata[,6]=="M"   |
    lithodata[,6]=="sM"
),6]="0 0 1"

lithodata[,2:3] = proj_to_model(model_origin,angle,lithodata[,2:3])
lithodata[,4:5] = lithodata[,4:5]*0.3048
lithodata[,1] = gsub("-0","-",lithodata[,1])
lithodata[,4] = well.elevation[lithodata[,1],"Elevation"]-lithodata[,4]
lithodata[,5] = well.elevation[lithodata[,1],"Elevation"]-lithodata[,5]


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

for (idata in 1:ndata)
{
    data.z = z[which(z<=lithodata[idata,4] & z>=lithodata[idata,5])]
    npoint = length(data.z)
    data.x = x[which.min(abs(lithodata[idata,2]-x))]
    data.y = y[which.min(abs(lithodata[idata,3]-y))]
    data.x = lithodata[idata,2]
    data.y = lithodata[idata,3]    
    
    
    if (npoint>0)
        {
            for (ipoint in 1:npoint)
            {
                hard.data = rbind(hard.data,paste(data.x,data.y,data.z[ipoint],lithodata[idata,6],collapse=" "))
            }
        }

}

file = paste(output.dir,"dainput/prior_data.eas",sep="")

writeLines(hard.data,file)



## if(length(grep('M',all_data_interp[i,6]))>0)
##     material_id[i] = 4
## if('S' %in% all_data_interp[i,6])
##     material_id[i] = 4
## if('sG' %in% all_data_interp[i,6])
##     material_id[i] = 2
## if('G' %in% all_data_interp[i,6])
##     material_id[i] = 1
## if('msG' %in% all_data_interp[i,6])
##     material_id[i] = 3
## if('gS' %in% all_data_interp[i,6])
##     material_id[i] = 2

hard.data = hard.data[-c(1:8),]

hard.data  = t(array(as.double(unlist(strsplit(hard.data," "))),
                   c(6,length(hard.data))))

data.index = which(hard.data[,4]==1)
plot(hard.data[data.index,1],hard.data[data.index,3],pch=16)
data.index = which(hard.data[,5]==1)
points(hard.data[data.index,1],hard.data[data.index,3],pch=16,col="green")
data.index = which(hard.data[,6]==1)
points(hard.data[data.index,1],hard.data[data.index,3],pch=16,col="red")



data.index = which(hard.data[,4]==1)
plot(hard.data[data.index,2],hard.data[data.index,3],pch=16)
data.index = which(hard.data[,5]==1)
points(hard.data[data.index,2],hard.data[data.index,3],pch=16,col="green")
data.index = which(hard.data[,6]==1)
points(hard.data[data.index,2],hard.data[data.index,3],pch=16,col="red")
