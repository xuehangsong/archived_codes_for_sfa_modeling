rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list

setwd("/Users/shua784/Dropbox/PNNL/Projects/300A/John_case_optim_5/")
path = "Outputs/"
##----------INPUT----------------##
# source("post_process/assemble.simulation.R")
load(paste(path,"simu.all.r",sep=''))

##----------OUTPUT---------------##
fname.simu_well.r = "Outputs/simu_wells.r"



wells = c("1-10A", "1-21A", "2-1", "2-2","2-3", "2-32", "4-9")
wells = paste("Well_399-",wells,sep="")
nwell = length(wells)

obs.types = c(
              "Tracer_river_upstream",
              "Tracer_river_north",
              "Tracer_river_middle",
              "Tracer_river_south",
              "Tracer_northBC",
              "qlx",
              "qly"                            
              )



well.data = list()
for (iwell in wells)
{
    well.data[[iwell]] = list()
    
    ## !!BE CAREFUL when you do grep "Well_399-2-1", it will grep "Well_399-2-10" too...
    ## Instead, try grep "Well_399-2-1_"
    ## Similarly, do the same for "Well_399-2-2", "Well_399-2-3"
    well.name = paste(iwell,"_",sep="")
    for (iobs in obs.types)
    {

        simu.col=intersect(grep(well.name, names(simu.all)),grep(iobs,names(simu.all))) # find header contain both iwell and iobs
        well.data[[iwell]][[iobs]] = simu.all[,simu.col]
    }
}
simu.time = simu.all[,1]


for (iwell in wells)
{
    for (iobs in obs.types)
    {
        well.data[[iwell]][[iobs]] = well.data[[iwell]][[iobs]][order(simu.time),]  #order well.data
        print(dim(well.data[[iwell]][[iobs]]))
    }
}

simu.time = simu.time[order(simu.time)]


tracer.types = c(
                "Tracer_river_upstream",
                "Tracer_river_north",
                "Tracer_river_middle",
                "Tracer_river_south",
                "Tracer_northBC"
                )

tracer = list()
for (itracer in tracer.types)
{
    tracer[[itracer]] = list()
    for (iwell in wells)
    {
        abs.vec = (well.data[[iwell]][["qlx"]]^2+well.data[[iwell]][["qly"]]^2)^0.5 #calculate velocity = sqrt(x^2 + y^2), z-direction ignored?
        tracer[[itracer]][[iwell]] = rowSums(well.data[[iwell]][[itracer]]*abs.vec)/rowSums(abs.vec) #calculate average tracer conc.
    }
}


tracer.types = c("Tracer_river_m",
              "Tracer_river_n",              
              "Tracer_river_s",
              "Tracer_north",
              "Tracer_river_upstr",
              "Tracer_total"
              )

for (itracer in tracer.types)
{
    tracer[[itracer]]=list()
}


for (iwell in wells)
{
  tracer[["Tracer_river_upstr"]][[iwell]] = tracer[["Tracer_river_upstream"]][[iwell]]
  
  tracer[["Tracer_river_n"]][[iwell]] = tracer[["Tracer_river_north"]][[iwell]]
  
    tracer[["Tracer_river_m"]][[iwell]] = tracer[["Tracer_river_middle"]][[iwell]]
    
    tracer[["Tracer_river_s"]][[iwell]] = tracer[["Tracer_river_south"]][[iwell]] 
    
    tracer[["Tracer_total"]][[iwell]] = tracer[["Tracer_river_upstr"]][[iwell]] + tracer[["Tracer_river_n"]][[iwell]] + tracer[["Tracer_river_m"]][[iwell]] + 
      + tracer[["Tracer_river_s"]][[iwell]]
    
    tracer[["Tracer_north"]][[iwell]] = tracer[["Tracer_northBC"]][[iwell]]
}



save(list=c("well.data","simu.time","tracer"),file= fname.simu_well.r)


