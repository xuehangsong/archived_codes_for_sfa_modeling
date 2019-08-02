rm(list=ls())
library("xts")
library("signal")
setwd("/Users/shua784/Dropbox/PNNL/Projects/300A")
##----------INPUT---------------##
source("mass.data.R")
load("results/mass.data.xts.r")
fname_model_coord = "data/model_coord.dat"
##--------------OUTPUT----------------##
fname_DatumH = "300A_model/Inputs/DatumH_River_filtered_6h_"
fname_Gradients = "300A_model/Inputs/Gradients_River_filtered_6h_"

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

# start.time = as.POSIXct("2012-07-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
# end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
# 
# start.time = as.POSIXct("2008-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
# end.time = as.POSIXct("2015-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")



slice.list = names(mass.data.xts)
for (islice in slice.list)
{
    mass.data.xts[[islice]] = mass.data.xts[[islice]][index(mass.data.xts[[islice]])>=start.time,]
    mass.data.xts[[islice]] = mass.data.xts[[islice]][index(mass.data.xts[[islice]])<=end.time,]    
}


time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600
mass.gradient.y = rep(NA,ntime)

slice.list = as.character(seq(314,330))
nslice = length(slice.list)

coord.data = read.table(fname_model_coord)
rownames(coord.data) = coord.data[,1]
coord.data =  coord.data[rownames(coord.data) %in% slice.list,]
nwell = dim(coord.data)[1]
y = coord.data[slice.list,3]
names(y)=rownames(coord.data)
x = coord.data[slice.list,2]
names(x)=rownames(coord.data)

mass.level = array(NA,c(nslice,ntime))
rownames(mass.level) = slice.list
for (islice in slice.list) {
    mass.level[islice,] = mass.data.xts[[islice]][,"stage"]
}
available.date = which(colSums(mass.level,na.rm=TRUE)>200)

#-----------------------------smooth river stage-------------------------------##
nwindows = 6 #hour？
dt = 3600
filt = Ma(rep(1/nwindows,nwindows))
# new.mass.level = array(NA,c(nslice,(ntime+1)))
new.mass.level = array(NA,c(nslice,ntime+1)) #moving average (ma) add 1 extra time
for (islice in 1:nslice)
{
    print(islice)
    ori_time = simu.time
    ori_value = mass.level[islice,]

    ma_value = filter(filt,ori_value)
    ma_time = ori_time-dt*(nwindows-1)/2 # ma_time offset by dt/2
    ma_value = tail(ma_value,-nwindows)
    ma_time = tail(ma_time,-nwindows)
    ma_value = c(ori_value[ori_time<min(ma_time)],ma_value)
    ma_time = c(ori_time[ori_time<min(ma_time)],ma_time)
    ma_value = c(ma_value,ori_value[ori_time>max(ma_time)])
    ma_time = c(ma_time,ori_time[ori_time>max(ma_time)])

    new.mass.level[islice,] = ma_value
}

#generate moving aveage plots with original mass data
for (islice in 1:nslice) {
  jpeg(paste("figures/mass_original_vs_mvAve_", slice.list[islice], sep=''),width=8,height=3,units='in', res = 300)
  plot(ori_time, mass.level[islice,] ,type = "l", col= "red")
  lines(ma_time, new.mass.level[islice,],type="l", col= "black")
  
  legend("topright","original","mvAve")
  title(paste("mass_original_vs_ma_", slice.list[islice], sep=''))
  dev.off()
}



# plot(ma_time[1:100],ma_value[1:100],type="l")
mass.level = new.mass.level
simu.time = ma_time

##------------------------calculate gradient--------------------------------##
# mass.gradient = array(NA,c(nslice,(ntime+1)))
mass.gradient.x = array(NA,c(nslice,ntime+1))
mass.gradient.y = array(NA,c(nslice,ntime+1))
rownames(mass.gradient.y) = slice.list
rownames(mass.gradient.x) = slice.list

for (islice in 1:(nslice-1)) #from top to bottom. 
{
    distance = sqrt((y[islice+1]-y[islice])^2 + (x[islice+1]-x[islice])^2)
    mass.gradient.x[islice,] = (mass.level[islice+1,]-mass.level[islice,])/distance*(x[islice+1]-x[islice])/distance   # calculate grad based on x-direction
    mass.gradient.y[islice,] = (mass.level[islice+1,]-mass.level[islice,])/distance*(y[islice+1]-y[islice])/distance # calculate grad based on y-direction
}

# gradient_314 is calcuated based on 315 and 314
for (islice in 1:(nslice-1))
{
    Gradients = cbind(simu.time,
                      mass.gradient.x[islice,],
                      mass.gradient.y[islice,],
                      rep(0,(ntime)))
    
    DatumH = cbind(simu.time,
                   rep(coord.data[islice,2],ntime),
                   rep(coord.data[islice,3],ntime),                                         
                   mass.level[islice,])

    write.table(DatumH,file=paste(fname_DatumH, slice.list[islice],'.txt',sep=""),col.names=FALSE,row.names=FALSE) 
    write.table(Gradients,file=paste(fname_Gradients, slice.list[islice],".txt",sep=''),col.names=FALSE,row.names=FALSE)
    
    
}



