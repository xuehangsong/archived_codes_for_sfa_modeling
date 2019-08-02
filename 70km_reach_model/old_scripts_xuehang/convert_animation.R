rm(list=ls())

fig.dir = "/Users/song884/remote/reach/figures/mass_balance/"
fig.dir = "/Users/song884/remote/reach/figures/head/"

times = as.numeric(gsub("_stage.jpg","",(list.files(fig.dir,"*stage*"))))
#times = sort(times[times>(365*24*3)])

simu.start = as.POSIXct("2007-03-28 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
plot.start = as.POSIXct("2011-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
plot.start = as.numeric(difftime(plot.start,simu.start,units="hours"))

times = times[times>plot.start]

c.fig =c()
for (itime in times)
{
    print(itime)
    i.fig = paste(fig.dir,"combined_",sprintf("%6.5E",itime),".jpg",sep="")
    ## system(paste("convert -append",
    ##              paste(fig.dir,sprintf("%6.5E",itime),"_stage.jpg",sep=""),
    ##              ##                 paste(fig.dir,itime,".png",sep=""),
    ##              ##                 paste(fig.dir,"Time:  ",sprintf("%6.5E",itime)," h.png",sep=""),
    ##              paste(fig.dir,sprintf("%6.5E",itime),".png",sep=""),                 
    ##              i.fig))
    c.fig = c(c.fig, i.fig)
}

r.fig = c()
for (itime in times)
{
    print(itime)
    i.fig = paste(fig.dir,"combined_",sprintf("%6.5E",itime),".jpg",sep="")
    j.fig = paste(fig.dir,"resize_",sprintf("%6.5E",itime),".jpg",sep="")    
    ## system(paste("convert -resize 30%",i.fig,j.fig))
    r.fig = c(r.fig, j.fig)
}


system(paste("convert -delay 1 -loop 0", paste(r.fig,collapse=" "),
             paste(fig.dir,"flux_movie.gif",sep="")))
