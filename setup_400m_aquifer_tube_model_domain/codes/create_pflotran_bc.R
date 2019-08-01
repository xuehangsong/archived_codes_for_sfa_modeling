rm(list=ls())
library(xts)
load("results/thermal_data.r")

output_dir = "vhg_case/"
k = 10^(-3:3)
top_depth = "0.16"
bottom_depth = "-0.64"



thermistor.temp = thermistor.xts[.indexmin(thermistor.xts) %in% c(0,15,30,45),]
rg3.wl = rg3.xts[.indexmin(rg3.xts) %in% c(0,15,30,45),"WL"]
ls.wl = piezos.xts[.indexmin(piezos.xts) %in% c(0,15,30,45),"LS_WL"]
selec.times = index(na.contiguous(cbind(thermistor.temp,rg3.wl,ls.wl)))
simu.start = range(selec.times)[1]
simu.end = range(selec.times)[2]

thermistor.output = thermistor.xts[which(index(thermistor.xts)>=simu.start &
                                      index(thermistor.xts)<=simu.end),]
rg3.wl = rg3.wl[which(index(rg3.wl)>=simu.start & index(rg3.wl)<=simu.end)]
ls.wl = ls.wl[which(index(ls.wl)>=simu.start & index(ls.wl)<=simu.end)]

head_diff = (rg3.wl -ls.wl)/(piezos_riverbed["LS"]-piezos_ele["LS"])

temp_top = cbind(difftime(index(thermistor.output[,top_depth]),simu.start,units=c("secs")),
                   thermistor.output[,top_depth])

temp_bottom = cbind(difftime(index(thermistor.output[,bottom_depth]),simu.start,units=c("secs")),
                   thermistor.output[,bottom_depth])
head_top = cbind(difftime(index(head_diff),simu.start,units=c("secs")),
                   rep(0,length(head_diff)),
                   rep(0,length(head_diff)),                   
                   head_diff)


write.table(temp_top,file=paste(output_dir,"temp_top.dat",sep=""),
            col.names=FALSE,row.names=FALSE)
write.table(temp_bottom,file=paste(output_dir,"temp_bottom.dat",sep=""),
            col.names=FALSE,row.names=FALSE)
write.table(head_top,file=paste(output_dir,"head_top.dat",sep=""),
            col.names=FALSE,row.names=FALSE)

save(list=ls(),file=paste(output_dir,"vhg_data.r",sep=""))
