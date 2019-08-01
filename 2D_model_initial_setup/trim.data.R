rm(list=ls())

load("results/spc.data.r")
start.time = min(obs.time[["S10"]],obs.time[["S40"]])-3600
end.time = max(obs.time[["S10"]],obs.time[["S40"]])+3600


spc.value = list()
spc.time = list()
load("results/spc.data.r")
for (i.obs in names(obs.time))
{
    spc.value[[i.obs]] = obs.value[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
    spc.time[[i.obs]] = obs.time[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
}

spc.temp.value = list()
spc.temp.time = list()
load("results/spc.temp.data.r")
for (i.obs in names(obs.time))
{
    spc.temp.value[[i.obs]] = obs.value[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
    spc.temp.time[[i.obs]] = obs.time[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
}


do.value = list()
do.time = list()
load("results/do.data.r")
for (i.obs in names(obs.time))
{
    do.value[[i.obs]] = obs.value[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
    do.time[[i.obs]] = obs.time[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
}


do.temp.value = list()
do.temp.time = list()
load("results/do.temp.data.r")
for (i.obs in names(obs.time))
{
    do.temp.value[[i.obs]] = obs.value[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
    do.temp.time[[i.obs]] = obs.time[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
}


level.value = list()
level.time = list()
load("results/level.data.r")
for (i.obs in names(obs.time))
{
    level.value[[i.obs]] = obs.value[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
    level.time[[i.obs]] = obs.time[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
}

trimed.data=c("spc.value","spc.time",
              "do.value","do.time",
              "level.value","level.time",
              "spc.temp.value","spc.temp.time",
              "do.temp.value","do.temp.time",
              "start.time","end.time"
              )
save(list=trimed.data,file="results/trimed.data.r")
