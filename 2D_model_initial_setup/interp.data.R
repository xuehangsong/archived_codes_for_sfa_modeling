rm(list=ls())
load("results/trimed.data.r")

start.time = as.POSIXct("2015-12-18 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-02-12 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-02-02 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

interp.time = seq(start.time,end.time,1800)
interp.time = seq(start.time,end.time,3600)


for (i.obs in names(level.value))
{
    if(sum(!is.na(level.value[[i.obs]]))<2)
    {
        level.value[[i.obs]] = rep(NA,length(interp.time))
    }else{
        level.value[[i.obs]] = approx(x=level.time[[i.obs]],y=level.value[[i.obs]],interp.time,rule=1)[["y"]]
    }
}


for (i.obs in names(spc.value))
{
    if(sum(!is.na(spc.value[[i.obs]]))<2)
    {
        spc.value[[i.obs]] = rep(NA,length(interp.time))
    }else{
        spc.value[[i.obs]] = approx(x=spc.time[[i.obs]],y=spc.value[[i.obs]],interp.time,rule=1)[["y"]]
    }
}


for (i.obs in names(spc.temp.value))
{
    if(sum(!is.na(spc.temp.value[[i.obs]]))<2)
    {
        spc.temp.value[[i.obs]] = rep(NA,length(interp.time))
    }else{
        spc.temp.value[[i.obs]] = approx(x=spc.temp.time[[i.obs]],y=spc.temp.value[[i.obs]],interp.time,rule=1)[["y"]]
    }
}

for (i.obs in names(do.value))
{
    if(sum(!is.na(do.value[[i.obs]]))<2)
    {
        do.value[[i.obs]] = rep(NA,length(interp.time))
    }else{
        do.value[[i.obs]] = approx(x=do.time[[i.obs]],y=do.value[[i.obs]],interp.time,rule=1)[["y"]]
    }
}


for (i.obs in names(do.temp.value))
{
    if(sum(!is.na(do.temp.value[[i.obs]]))<2)
    {
        do.temp.value[[i.obs]] = rep(NA,length(interp.time))
    }else{
        do.temp.value[[i.obs]] = approx(x=do.temp.time[[i.obs]],y=do.temp.value[[i.obs]],interp.time,rule=1)[["y"]]
    }
}




interp.data=c("spc.value",
              "do.value",
              "level.value",
              "spc.temp.value",
              "do.temp.value",
              "start.time","end.time",
              "interp.time"
              )
save(list=interp.data,file="results/interp.data.r")
