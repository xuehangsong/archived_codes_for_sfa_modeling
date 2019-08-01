rm(list=ls())

file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()

obs.list = c("-64cm",
             "-24cm",
             "-4cm",
             "+16cm",
             "+26cm",
             "+46cm")

for (i.obs in obs.list)
{
    file.name[[i.obs]] = "data/thermister.csv"
    time.col.name[[i.obs]] = "Date.Time..PST"
    time.format[[i.obs]] = "%m/%d/%Y %H:%M"
}

obs.col.name[[obs.list[1]]] = "X64.cm"
obs.col.name[[obs.list[2]]] = "X24.cm"
obs.col.name[[obs.list[3]]] = "X4.cm"
obs.col.name[[obs.list[4]]] = "X.16.cm"
obs.col.name[[obs.list[5]]] = "X.26.cm"
obs.col.name[[obs.list[6]]] = "X.46.cm"


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

save(list=c("obs.value","obs.time"),file = paste("results/","thermister.temp.data.r",sep=''))


rm(list=ls())
load("results/thermister.temp.data.r")

start.time = as.POSIXct("2016-03-18 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-04-06 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")


temp.value = list()
temp.time = list() 
load("results/thermister.temp.data.r")
for (i.obs in names(obs.time))
{
    temp.value[[i.obs]] = obs.value[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
    temp.time[[i.obs]] = obs.time[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
}

trimed.data=c( "temp.value","temp.time",
              "start.time","end.time"
              )
save(list=trimed.data,file="results/thermister.trimed.data.r")


rm(list=ls())
load("results/thermister.trimed.data.r")

start.time = as.POSIXct("2016-03-19 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-04-05 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

interp.time = seq(start.time,end.time,3600)

for (i.obs in names(temp.value))
{
    if(sum(!is.na(temp.value[[i.obs]]))<2)
    {
        temp.value[[i.obs]] = rep(NA,length(interp.time))
    }else{
        temp.value[[i.obs]] = approx(x=temp.time[[i.obs]],y=temp.value[[i.obs]],interp.time,rule=1)[["y"]]
    }
}

interp.data=c("temp.value","interp.time")

save(list=interp.data,file="results/thermister.interp.data.r")
