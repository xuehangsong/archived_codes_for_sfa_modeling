rm(list=ls())

file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()

obs.list = c("SWS-1",
              "2-3")

for (i.obs in obs.list)
{
    file.name[[i.obs]] = list.files("data/fuji/",pattern=paste(i.obs,".csv",sep=''))
    file.name[[i.obs]] = paste("data/fuji/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "time"
    obs.col.name[[i.obs]] = "WL_m"
    time.format[[i.obs]] = "%Y-%m-%d %H:%M:%S"
}


obs.data = list()
obs.time = list()
obs.value = list()

for (i.obs in obs.list)
{
    print(file.name[[i.obs]])
    obs.data[[i.obs]] = read.csv(file.name[[i.obs]],stringsAsFactors=FALSE)
    obs.time[[i.obs]] = obs.data[[i.obs]][, grep(pattern=time.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
    obs.time[[i.obs]] = as.POSIXct(obs.time[[i.obs]],format=time.format[[i.obs]],tz='GMT')
    obs.value[[i.obs]] = obs.data[[i.obs]][,obs.col.name[[i.obs]]]
}

save(list=c("obs.value","obs.time"),file = paste("results/","level.data.r",sep=''))
