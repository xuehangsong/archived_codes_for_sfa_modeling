rm(list=ls())
# simu.dir="/Users/song884/remote/reach/Inputs/"
simu.dir="/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Inputs/river_bc/"

datum.file = list.files(paste(simu.dir,"bc_1w_smooth_032807/",sep=""),
                        "Datum")
fig.dir = "/Users/shua784/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/river_stage_1w_smooth/"
simu.start = as.POSIXct("2007-03-28 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")

start.time = as.POSIXct("2011-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
# time.ticks = c(as.POSIXct("2007-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2008-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2009-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2011-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2012-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2014-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
#                as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"))

time.ticks = c(as.POSIXct("2011-01-01 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2012-01-01 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2013-01-01 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2014-01-01 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2015-01-01 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2016-01-01 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"))

times = seq(start.time,end.time,3600*120)

mass.section = gsub(".txt","",gsub("DatumH_Mass1_","",datum.file))
mass.section = sort(as.numeric(mass.section))
mass.section = as.character(mass.section)

nsection = length(mass.section)


datum.data = list()
gradients.data = list()

mass.section = c(mass.section[1],
                 mass.section[floor(nsection/2)],
                 tail(mass.section,1)
                 )
nsection = length(mass.section)
colors=rainbow(nsection)
colors=rep("black",length(mass.section))
ltys = c(1,2,3)
names(ltys)=mass.section
names(colors)=mass.section

for (i.section in mass.section)
{
    print(i.section)
    datum.data[[i.section]] = read.table(paste(simu.dir,"bc_1w_smooth_032807//DatumH_Mass1_",
                                               i.section,".txt",
                                               sep=""))
    gradients.data[[i.section]] = read.table(paste(simu.dir,"bc_1w_smooth_032807//Gradients_Mass1_",
                                                   i.section,".txt",
                                                   sep=""))
}

## times = as.numeric(gsub(".png","",(list.files(fig.dir,"*png"))))
## times = sort(times)
## #times = times[times>(365*24*3)]

# times=start.time

for (i.index in 1:length(times))
{
    itime = times[i.index]
    fname = paste(fig.dir,format(itime,"%Y-%m-%d %H:%M:%S"),".jpg",sep="")
    jpeg(fname,units="in",
         quality=75,res=100,
         width=6.5,height=4)
    par(mgp=c(1.7,0.7,0),oma=c(0,0.5,0,0),
        mar=c(2.8,2.5,1.5,1))
    plot(datum.data[[i.section]][,1]+simu.start,
         datum.data[[i.section]][,4],
         col=colors[i.section],
         type="l",
         xlim=range(start.time,end.time),
         ylim=c(100,130),
         xlab="Time (year)",
         ylab="River Stage (m)",
         axe=FALSE,
         main=format(itime,"%Y-%m-%d %H:%M:%S")
         )
    box()
    axis(1,at=time.ticks,label=format(time.ticks,"%Y"),tck=-0.02)
    axis(2,at=seq(100,130,10))
    for (isection in mass.section)
    {
        lines(datum.data[[isection]][,1]+simu.start,
              datum.data[[isection]][,4],
#              col=colors[isection],
              lty=ltys[isection],
              type="l")
    }
    lines(rep(itime,2),c(0,200),lwd=2,col="red",lty=2)
    ## legend("topleft",c("Upstream","Middle","Downstream"),
    ##        col=colors,lty=1,lwd=1,horiz=TRUE,bty="n"
    ##        )
    dev.off()
}

