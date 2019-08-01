rm(list=ls())
library(xts)
library(hydroGOF)
source("codes/xuehang_R_functions.R")

rg3_ele = 104.224
piezos_ele = c(104.261,101.660,105.713,103.910)
names(piezos_ele) = c("LS","LD","US","UD")
piezos_riverbed = c(104.813,104.37,106.706,NA)
names(piezos_riverbed) = c("LS","LD","US","UD")


data_dir = "data/RG3-T3_station/Raw/2017-08/"

## themistor data
thermistor.depth = c(-0.64,-0.24,-0.04,0.16)
nthermistor = length(thermistor.depth)
fname = list.files(data_dir,"RG3_T3_T3_Temps",full.names=TRUE)
thermistor = read.csv(skip=4,head=F,fill=TRUE,fname,
                      na.strings=c(" ","NA","NaN"),stringsAsFactors=FALSE,)
thermistor[,1] = as.POSIXct(thermistor[,1],format = "%Y-%m-%d %H:%M:%S",tz="GMT")
thermistor = thermistor[,-c(2,7,8)]
colnames(thermistor) = c("Time",thermistor.depth)
thermistor_add  = read.csv(skip=1,head=F,fill=TRUE,
                           na.strings=c(" ","NA","NaN"),stringsAsFactors=FALSE,
                          "data/T3_thermistor_array.csv")                          
thermistor_add[,1] = as.POSIXct(thermistor_add[,1],format = "%m/%d/%Y %H:%M",tz="GMT")
thermistor_add = thermistor_add[,-c(6,7)]
colnames(thermistor_add) = colnames(thermistor) 
thermistor = rbind(thermistor_add,thermistor)
thermistor = thermistor[!duplicated(thermistor[,1]),]
thermistor[,2:ncol(thermistor)] = lapply(thermistor[,2:ncol(thermistor)],as.numeric)



## rg3 data
fname = list.files(data_dir,"RG3_T3_RG3",full.names=TRUE)
rg3 = read.csv(skip=4,head=F,fname,fill=TRUE,na.strings=c(" ","NA","NaN"))
rg3[,1] = as.POSIXct(rg3[,1],format = "%Y-%m-%d %H:%M:%S",tz="GMT")
rg3 = rg3[,-c(2,3,6)]
colnames(rg3) = c("Time","WL","Temp","SpC")

rg3_add = read.csv(skip=1,head=F,fill=TRUE,
                   na.strings=c(" ","NA","NaN"),stringsAsFactors=FALSE,
                   "data/RG3_from_amy_processed.csv")
rg3_add[,1] = as.POSIXct(rg3_add[,1],format = "%m/%d/%Y %H:%M",tz="GMT")
rg3_add = rg3_add[,-c(2,3,6)]
colnames(rg3_add) = c("Time","WL","Temp","SpC")
rg3 = rbind(rg3_add,rg3)
rg3 = rg3[!duplicated(rg3[,1]),]
rg3[,2:ncol(rg3)] = lapply(rg3[,2:ncol(rg3)],as.numeric)
rg3[,2] = rg3[,2]+rg3_ele



fname = list.files(data_dir,"RG3_T3_T3_Piezo",full.names=TRUE)
piezos = read.csv(skip=4,head=F,fill=TRUE,
                  na.strings=c(" ","NA","NaN",""),stringsAsFactors=FALSE,fname)
piezos[,1] = as.POSIXct(piezos[,1],format = "%Y-%m-%d %H:%M:%S",tz="GMT")
piezos = piezos[,-c(2,3,6,10,14,18)]
colnames(piezos) = c("Time",
                     "LS_WL","LS_Temp","LS_SpC",
                     "LD_WL","LD_Temp","LD_SpC",
                     "US_WL","US_Temp","US_SpC",                     
                     "UD_WL","UD_Temp","UD_SpC"
                     )
piezos_add = read.csv(skip=1,head=F,fill=TRUE,
                      na.strings=c(""," ","NA","NaN"),stringsAsFactors=FALSE,
                      "data/piezos_from_amy_processed.csv")
piezos_add[is.na(piezos_add)] = NA
piezos_add[,1] = as.POSIXct(piezos_add[,1],format = "%m/%d/%Y %H:%M",tz="GMT")
piezos_add = piezos_add[,-c(2,3,6,10,14,18,20)]
colnames(piezos_add) = c("Time",
                     "LS_WL","LS_Temp","LS_SpC",
                     "LD_WL","LD_Temp","LD_SpC",
                     "US_WL","US_Temp","US_SpC",                     
                     "UD_WL","UD_Temp","UD_SpC"
                     )
piezos = rbind(piezos_add,piezos)
piezos = piezos[!duplicated(piezos[,1]),]
piezos[,2:ncol(piezos)] = lapply(piezos[,2:ncol(piezos)],as.numeric)
piezos[,"LS_WL"] = piezos[,"LS_WL"] + piezos_ele["LS"]
piezos[,"LD_WL"] = piezos[,"LD_WL"] + piezos_ele["LD"]
piezos[,"US_WL"] = piezos[,"US_WL"] + piezos_ele["US"]
piezos[,"UD_WL"] = piezos[,"UD_WL"] + piezos_ele["UD"]
piezos[which(piezos[,"LS_WL"]>110 | piezos[,"LS_WL"]<104.1),"LS_WL"] = NA
piezos[which(piezos[,"LD_WL"]>110 | piezos[,"LD_WL"]<104.1),"LD_WL"] = NA
piezos[which(piezos[,"US_WL"]>110 | piezos[,"US_WL"]<104.1),"US_WL"] = NA
piezos[which(piezos[,"UD_WL"]>110 | piezos[,"UD_WL"]<104.1),"UD_WL"] = NA       


#SWS1
sws1  = read.csv(skip=1,head=F,fill=TRUE,
                 na.strings=c(" ","NA","NaN"),stringsAsFactors=FALSE,
                 "data/wells/SWS-1_3var.csv")
sws1[,1] = as.POSIXct(sws1[,1],format = "%d-%b-%Y %H:%M:%S",tz="GMT")
colnames(sws1) = c("Time","Temp","SpC","WL")
sws1[,2:ncol(sws1)] = lapply(sws1[,2:ncol(sws1)],as.numeric)

##well2_3
well2_3  = read.csv(skip=1,head=F,fill=TRUE,
                 na.strings=c(" ","NA","NaN"),stringsAsFactors=FALSE,
                 "data/wells/399-2-3_3var.csv")
well2_3[,1] = as.POSIXct(well2_3[,1],format = "%d-%b-%Y %H:%M:%S",tz="GMT")
colnames(well2_3) = c("Time","Temp","SpC","WL")
well2_3[,2:ncol(well2_3)] = lapply(well2_3[,2:ncol(well2_3)],as.numeric)



start.time = as.POSIXct("2016-04-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2017-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
every_min = 5
start_min = 0
time.index = seq(from=start.time,to=end.time,by=paste(every_min,"min"))    
thermistor.xts = regulate_data(thermistor,start.time,end.time,every_min,start_min)
rg3.xts = regulate_data(rg3,start.time,end.time,every_min,start_min)
piezos.xts = regulate_data(piezos,start.time,end.time,every_min,start_min)
well2_3.xts = regulate_data(well2_3,start.time,end.time,every_min,start_min)
sws1.xts = regulate_data(sws1,start.time,end.time,every_min,start_min)


thermistor_threshold = 104.9
thermistor_threshold = 104.8
head = as.numeric(rg3.xts[,"WL"])
head[which(is.na(head))] = as.numeric(sws1.xts[which(is.na(head)),"WL"])+0
#    mean(rg3.xts[,"WL"]-sws1.xts[,"WL"],na.rm=TRUE)
head = na.approx(head,time.index)
thermistor.xts[which(head<=thermistor_threshold),] = NA
colnames(thermistor.xts) = thermistor.depth


save(list=ls(),file="results/thermal_data.r")


stop()
print(rmse(thermistor.xts[,4],sws1.xts[,"Temp"]))

jpeg(paste("figures/test.jpg",sep=''),width=4,height=3,units='in',res=300,quality=100)
plot(time.index,thermistor.xts[,4],type="l")
lines(sws1[,"Time"],sws1[,"Temp"],col="red")
dev.off()



y = thermistor.xts[,4];plot(time.index[!is.na(y)],y[!is.na(y)],type="l")
y = sws1.xts[,"Temp"];lines(time.index[!is.na(y)],y[!is.na(y)],col="red")
y = thermistor.xts[,4]-sws1.xts[,"Temp"];plot(time.index[!is.na(y)],y[!is.na(y)],type="l")

x = thermistor.xts[,4]-sws1.xts[,"Temp"]
y = thermistor.xts[,4];y[which(abs(x)>0)]=NA;plot(time.index[!is.na(y)],y[!is.na(y)],type="l")
y = sws1.xts[,"Temp"];lines(time.index[!is.na(y)],y[!is.na(y)],col="red")


plot(as.numeric(rg3.xts[,"WL"]),as.numeric(sws1.xts[,"WL"]),pch=16,cex=0.5)
y = rg3.xts[,"WL"];plot(time.index[!is.na(y)],y[!is.na(y)],type="l")
y = sws1.xts[,"WL"];lines(time.index[!is.na(y)],y[!is.na(y)],col="red")
y = rg3.xts[,"WL"]-sws1.xts[,"WL"];plot(time.index[!is.na(y)],y[!is.na(y)],type="l")



time.ticks = seq(from=start.time,to=end.time,by="4 month")
time.mini.ticks = seq(from=start.time,to=end.time,by="1 month")
interp.time = seq(start.time,end.time,3600)



#simu.start = as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
