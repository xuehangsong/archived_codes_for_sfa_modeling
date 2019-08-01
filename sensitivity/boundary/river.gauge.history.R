rm(list=ls())

obs.data = read.csv("data/300A_gapfilling.csv")
obs.time = as.POSIXct(obs.data[[1]],format="%m/%d/%Y %H:%M",tz='GMT')
obs.value = obs.data[[3]]

save(list=c("obs.value","obs.time"),file = paste("results/","river.data.r",sep=''))
