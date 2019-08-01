rm(list=ls())

file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()

coord.data = read.table("data/proj.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% c("1-10A","1-1","1-16A","1-57","2-2",
                                                      "2-3","2-1","3-18","3-9","3-10",
                                                      "4-9","4-7","SWS-1","NRG"),]
obs.list = c(rownames(coord.data))

for (i.obs in obs.list)
{
    file.name[[i.obs]] = list.files("data/velo/",pattern=paste(i.obs,"_3var.csv",sep=''))
    file.name[[i.obs]] = paste("data/velo/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "Date.Time.PST+"
    obs.col.name[[i.obs]] = "Temp.degC"
    time.format[[i.obs]] = "%d-%b-%Y %H:%M:%S"
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

save(list=c("obs.value","obs.time"),file = paste("results/","temp.data.r",sep=''))
