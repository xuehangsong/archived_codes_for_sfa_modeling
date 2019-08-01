rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list


wells = c("1-10A","2-1","2-32","1-21A","2-2","2-3")
wells = paste("Well_399-",wells,sep="")
nwell = length(wells)
path = "/files3/pin/simulations/reTest7_newRingold_2010_2015_6h/"
path = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/"
path = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation_13/"
path = "/files1/song884/bpt/new_simulation_13_5/"
path = "/files1/song884/bpt/new_simulation_13_25/"
##path = "/files3/pin/simulations/Test13_piecewiseGrad_2010_2015_6h/new_simulation_13_5/"
##path = "./"

obs.types = c("Tracer_river_m",
              "Tracer_river_n",              
              "Tracer_river_s",
              "Tracer_north",
              "qlx","qly"              
              )


load(paste(path,"simu.all.r",sep=''))

well.data = list()
for (iwell in wells)
{
    well.data[[iwell]] = list()
    obs.name = iwell
    for (iobs in obs.types)
    {
        simu.col=intersect(grep(iwell,names(simu.all)),grep(iobs,names(simu.all)))
        well.data[[iwell]][[iobs]] = simu.all[,simu.col]
    }
}

simu.time = simu.all[,1]


for (iwell in wells)
{
    for (iobs in obs.types)
    {
##        print(dim(well.data[[iwell]][[iobs]]))
        well.data[[iwell]][[iobs]] = well.data[[iwell]][[iobs]][order(simu.time),]
        print(dim(well.data[[iwell]][[iobs]]))
##        print("================")
    }
}

simu.time = simu.time[order(simu.time)]


tracer.types = c("Tracer_river_m",
              "Tracer_river_n",              
              "Tracer_river_s",
              "Tracer_north"
              )

tracer = list()
for (itracer in tracer.types)
{
    tracer[[itracer]] = list()
    for (iwell in wells)
    {
        abs.vec = (well.data[[iwell]][["qlx"]]^2+well.data[[iwell]][["qly"]]^2)^0.5
        tracer[[itracer]][[iwell]] = rowSums(well.data[[iwell]][[itracer]]*abs.vec)/rowSums(abs.vec)
    }
}



save(list=c("well.data","simu.time","tracer"),file=paste(path,"simu_wells.r",sep=""))
