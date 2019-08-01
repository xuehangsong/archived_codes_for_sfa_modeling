rm(list=ls())

file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()

obs.list = c( "SWS-1",
              "2-3")


file.name[[obs.list[[1]]]] = "data/fuji/River_300A.csv"
file.name[[obs.list[[2]]]] = "data/fuji/Well_2_3.csv"

for (i.obs in obs.list)
{
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

save(list=c("obs.value","obs.time"),file = paste("results/","thermistor.level.data.r",sep=''))

rm(list=ls())



file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()

obs.list = c( "SWS-1",
             "2-3",
             "-64cm",
             "-24cm",
             "-4cm",
             "+16cm",
             "+26cm",
             "+46cm"                                                      
             )

file.name[[obs.list[[1]]]] = "data/fuji/River_300A.csv"
file.name[[obs.list[[2]]]] = "data/fuji/Well_2_3.csv"

for (i.obs in obs.list[1:2])
{
    time.col.name[[i.obs]] = "time"
    obs.col.name[[i.obs]] = "Temp_degC"
    time.format[[i.obs]] = "%Y-%m-%d %H:%M:%S"
}

for (i.obs in obs.list[3:8])
{
    file.name[[i.obs]] = "data/thermistor20160308.csv"
    time.col.name[[i.obs]] = "Date.Time..PST"
    time.format[[i.obs]] = "%m/%d/%Y %H:%M"
}

obs.col.name[[obs.list[3]]] = "X64.cm.temp_C"
obs.col.name[[obs.list[4]]] = "X24.cm.temp_C"
obs.col.name[[obs.list[5]]] = "X4.cm.temp_C"
obs.col.name[[obs.list[6]]] = "X.16.cm.temp_C"
obs.col.name[[obs.list[7]]] = "X.26.cm.temp_C"
obs.col.name[[obs.list[8]]] = "X.46.cm.temp_C"


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

save(list=c("obs.value","obs.time"),file = paste("results/","thermistor.temp.data.r",sep=''))


rm(list=ls())
load("results/thermistor.temp.data.r")
start.time = min(obs.time[["-64cm"]])-3600
end.time = max(obs.time[["-64cm"]])+3600

temp.value = list()
temp.time = list() 
load("results/thermistor.temp.data.r")
for (i.obs in names(obs.time))
{
    temp.value[[i.obs]] = obs.value[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
    temp.time[[i.obs]] = obs.time[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
}


level.value = list()
level.time = list() 
load("results/thermistor.level.data.r")
for (i.obs in names(obs.time))
{
    level.value[[i.obs]] = obs.value[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
    level.time[[i.obs]] = obs.time[[i.obs]][which(obs.time[[i.obs]]>=start.time & obs.time[[i.obs]]<=end.time)]
}

trimed.data=c("level.value","level.time",
              "temp.value","temp.time",
              "start.time","end.time"
              )
save(list=trimed.data,file="results/thermistor.trimed.data.r")

rm(list=ls())
load("results/thermistor.trimed.data.r")
start.time = as.POSIXct("2016-03-02 12:59:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-03-08 10:02:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
interp.time = seq(start.time,end.time,60)


for (i.obs in names(level.value))
{
    if(sum(!is.na(level.value[[i.obs]]))<2)
    {
        level.value[[i.obs]] = rep(NA,length(interp.time))
    }else{
        level.value[[i.obs]] = approx(x=level.time[[i.obs]],y=level.value[[i.obs]],interp.time,rule=1)[["y"]]
    }
}

for (i.obs in names(temp.value))
{
    if(sum(!is.na(temp.value[[i.obs]]))<2)
    {
        temp.value[[i.obs]] = rep(NA,length(interp.time))
    }else{
        temp.value[[i.obs]] = approx(x=temp.time[[i.obs]],y=temp.value[[i.obs]],interp.time,rule=1)[["y"]]
    }
}

interp.data=c("level.value","temp.value",
              "start.time","end.time",
              "interp.time"
              )
save(list=interp.data,file="results/thermistor.interp.data.r")
