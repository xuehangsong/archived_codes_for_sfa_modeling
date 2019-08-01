rm(list=ls())

input_folder = 'data/kriging_data/headdata4krige_Plume_2009_2017/'

start.time = as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time =  as.POSIXct("2017-07-13 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

dt = 3600  ##secs
times = seq(start.time,end.time,dt)
ntime = length(times)
time.id = seq(0,ntime-1,dt/3600)  ##hourly boundary

origin.time = as.POSIXct("2008-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
for (itime in 1:ntime)
{
#    print(times[itime])
    index = paste(as.character(difftime(times[itime],origin.time,tz="GMT",units="hours")),
                  "_",format(times[itime],"%d_%b_%Y_%H_%M_%S"),sep="")
    data = read.table(paste(input_folder,'time',index,'.dat',sep=''),header=F,na.strings = "NaN")
    if (all(is.na(data[,3])))
    {
        print(times[itime])
    }
}


