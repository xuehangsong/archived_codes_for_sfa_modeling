rm(list=ls())

file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()




obs.list = c("S10",
             "S40",
             "NRG",
             "SWS-1",
             "2-3",
             "RG3")



obs.data = list()
obs.time = list()
obs.value = list()



for (i.obs in obs.list[1:3])
{
    file.name[[i.obs]] = list.files("data/velo.ec/",pattern=i.obs)
    file.name[[i.obs]] = paste("data/velo.ec/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "Date.Time"
    obs.col.name[[i.obs]] = "Specific.Conductance"
    time.format[[i.obs]] = "%m/%d/%y %I:%M:%S %p"


    print(file.name[[i.obs]])
    obs.data[[i.obs]] = read.csv(file.name[[i.obs]],stringsAsFactors=FALSE,skip=1)
    obs.time[[i.obs]] = obs.data[[i.obs]][, grep(pattern=time.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
    obs.time[[i.obs]] = as.POSIXct(obs.time[[i.obs]],format=time.format[[i.obs]],tz='GMT')
    obs.value[[i.obs]] = obs.data[[i.obs]][, grep(pattern=obs.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]


}

for (i.obs in obs.list[4:5])
{
    file.name[[i.obs]] = list.files("data/fuji/",pattern=i.obs)
    file.name[[i.obs]] = paste("data/fuji/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "time"
    obs.col.name[[i.obs]] = "SpC_ms_cm"
    time.format[[i.obs]] = "%Y-%m-%d %H:%M:%S"


    print(file.name[[i.obs]])
    obs.data[[i.obs]] = read.csv(file.name[[i.obs]],stringsAsFactors=FALSE)
    obs.time[[i.obs]] = obs.data[[i.obs]][, grep(pattern=time.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
    obs.time[[i.obs]] = as.POSIXct(obs.time[[i.obs]],format=time.format[[i.obs]],tz='GMT')
    obs.value[[i.obs]] = obs.data[[i.obs]][, grep(pattern=obs.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]

}


for (i.obs in obs.list[6])
{
    file.name[[i.obs]] = list.files("data/",pattern=i.obs)
    file.name[[i.obs]] = paste("data/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "Time"
    obs.col.name[[i.obs]] = "Specific.Conductance"
    time.format[[i.obs]] = "%m/%d/%Y %H:%M"

    print(file.name[[i.obs]])
    obs.data[[i.obs]] = read.csv(file.name[[i.obs]],stringsAsFactors=FALSE)
    obs.time[[i.obs]] = obs.data[[i.obs]][, grep(pattern=time.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
    obs.time[[i.obs]] = as.POSIXct(obs.time[[i.obs]],format=time.format[[i.obs]],tz='GMT')
    obs.value[[i.obs]] = obs.data[[i.obs]][, grep(pattern=obs.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
}


save(list=c("obs.value","obs.time"),file = paste("results/","spc.data.r",sep=''))
