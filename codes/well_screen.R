rm(list=ls())
source("./codes/xuehang_R_functions.R")
source("./codes/ifrc_120m_3d.R")

fname = "./data/Top_Elevation_Well_List_all_XUEHANG.csv"
well.screens = read.csv(fname)
rownames(well.screens) = well.screens[,2]
well.screens = well.screens[,c(5,4,6,7)]

data.file  = "./data/TracerData_Oct2011_new.csv"
data = read.csv(data.file,stringsAsFactors=FALSE)
wells = paste("399-",names(table(data[,1])),sep="")

well.screens = well.screens[wells,]
well.screens = as.matrix(well.screens)

well.screens[,1:2] = proj_to_model(model_origin,angle,well.screens[,1:2])
well.screens = well.screens[which(well.screens[,1]>=range_x[1] &
                                  well.screens[,1]<=range_x[2]),]

well.screens = well.screens[which(well.screens[,2]>=range_y[1] &
                                  well.screens[,2]<=range_y[2]),]

wells = rownames(well.screens)

    
nwell = nrow(well.screens)
obs.loc = list()
for (iwell in wells)
{
    x.index = which.min(abs(x-well.screens[iwell,1]))
    y.index = which.min(abs(y-well.screens[iwell,2]))                   
    z.index = which(z<=well.screens[iwell,3] & z>=well.screens[iwell,4])
    
    if (length(z.index)==0)
    {
        z.index = which.min(abs(z-mean(well.screens[iwell,3:4])))
    }

    ##    obs.loc[[iwell]] = (z.index-1)*nx*ny+(y.index-1)*nx+x.index
    obs.loc[[iwell]] = cbind(rep(x.index,length(z.index)),
                             rep(y.index,length(z.index)),
                             z.index)
}

obs.region = c()
obs.card = c()
for (iwell in wells)
{
    for (ipoint in 1:nrow(obs.loc[[iwell]]))
    {
        obs.region = c(obs.region,
                       paste("REGION Well_",iwell,"_",ipoint,sep=""))
        obs.region = c(obs.region,
                       paste("  COORDINATE",
                             paste(round(well.screens[iwell,1:2],2),collapse=" "),
                             z[obs.loc[[iwell]][ipoint,3]],collapse=""))
        obs.region = c(obs.region,"END")
        obs.region = c(obs.region,"")        

        obs.card = c(obs.card,"OBSERVATION")
        obs.card = c(obs.card,
                     paste("  REGION Well_",iwell,"_",ipoint,sep=""))
        obs.card = c(obs.card,"  VELOCITY")
        obs.card = c(obs.card,"END")
        obs.card = c(obs.card,"")        
    }

}
writeLines(obs.region,"results/obs_region.txt")
writeLines(obs.card,"results/obs_card.txt")

obs.name = list()
for (iwell in wells)
{
    obs.name[[iwell]] = paste(paste("Well_",iwell,"_",sep=""),
                              1:nrow(obs.loc[[iwell]]),sep="")
}

save(obs.loc,file="results/obs_loc.r")
save(obs.name,file="results/obs_name.r")
