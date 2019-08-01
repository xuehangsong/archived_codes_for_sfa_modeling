rm(list=ls())

file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()

obs.list = c("S10",
             "S40",
             "T2",
             "T3",
             "T4",
             "T5",
             "NRG",
             "1-10A",
             "2-2",
             "2-3",
             "4-9"
             )

for (i.obs in obs.list[1:7])
{
    file.name[[i.obs]] = list.files("data/shared.drive",pattern=i.obs)
    file.name[[i.obs]] = paste("data/shared.drive/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "DateTimeGMT08"
    obs.col.name[[i.obs]] = "DOtemp.deg.C"
    time.format[[i.obs]] = "%Y-%m-%d %H:%M:%S"
}
file.name[["NRG"]] = "data/shared.drive/River_gauge_DO_EC_withWL.csv"

for (i.obs in obs.list[8:11])
{
    file.name[[i.obs]] = list.files("data/velo.do",pattern=i.obs)
    file.name[[i.obs]] = paste("data/velo.do/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "Date.Time"
    obs.col.name[[i.obs]] = "DO.Temp.degC."
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
save(list=c("obs.value","obs.time"),file = paste("results/","do.temp.data.r",sep=''))
