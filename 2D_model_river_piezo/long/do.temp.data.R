rm(list=ls())

file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()




obs.list = c("S10",
             "S40",
             "NRG")

obs.data = list()
obs.time = list()
obs.value = list()



for (i.obs in obs.list[1:3])
{
    file.name[[i.obs]] = list.files("data/velo.do/",pattern=i.obs)
    file.name[[i.obs]] = paste("data/velo.do/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "Date.Time"
    obs.col.name[[i.obs]] = "Temp"
    time.format[[i.obs]] = "%m/%d/%y %I:%M:%S %p"


    print(file.name[[i.obs]])
    obs.data[[i.obs]] = read.csv(file.name[[i.obs]],stringsAsFactors=FALSE,skip=1)
    obs.time[[i.obs]] = obs.data[[i.obs]][, grep(pattern=time.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
    obs.time[[i.obs]] = as.POSIXct(obs.time[[i.obs]],format=time.format[[i.obs]],tz='GMT')
    obs.value[[i.obs]] = obs.data[[i.obs]][, grep(pattern=obs.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]


}


obs.value[[3]] = (obs.value[[3]]-32)*5/9
save(list=c("obs.value","obs.time"),file = paste("results/","do.temp.data.r",sep=''))
