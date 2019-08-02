rm(list=ls())

simu.dir="/Users/song884/remote/reach/Inputs/"
datum.file = list.files(paste(simu.dir,"bc_smooth/",sep=""),
                        "Datum")
fig.dir = "/Users/song884/remote/reach/figures/river_stage/"
## start.time = as.POSIXct("2007-03-28 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = c(as.POSIXct("2011-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2012-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2014-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2016-05-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2015-10-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"))     



mass.section = gsub(".txt","",gsub("DatumH_Mass1_","",datum.file))
mass.section = sort(as.numeric(mass.section))
mass.section = as.character(mass.section)


datum.data = list()
gradients.data = list()

nsection = length(mass.section)
mass.section = c(mass.section[1],
                 mass.section[floor(nsection/2)],
                 tail(mass.section,1)
                 )
nsection = length(mass.section)
colors=rainbow(nsection)
names(colors)=mass.section
colors[mass.section] = "black"

for (i.section in mass.section)
{
    print(i.section)
    datum.data[[i.section]] = read.table(paste(simu.dir,"bc_smooth/DatumH_Mass1_",
                                               i.section,".txt",
                                               sep=""))
    gradients.data[[i.section]] = read.table(paste(simu.dir,"bc_smooth/Gradients_Mass1_",
                                                   i.section,".txt",
                                                   sep=""))
}


selected.times = c(238,
                   255,
                   308,
                   328,
                   386,
                   407,
                   450,
                   476,
                   527,
                   550,
                   580,
                   622)
simu.times = (selected.times-1)*120*3600
start.time = as.POSIXct("2007-03-28 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
real.times = start.time+simu.times


fname = paste(fig.dir,"river_stage.jpg",sep="")
jpeg(fname,units="in",
     quality=100,res=600,
     width=13,height=3)
par(mgp=c(1.7,0.7,0),oma=c(0,0.5,0,0),
    mar=c(2.8,2.5,1.5,1))
plot(datum.data[[i.section]][,1]+start.time,
     datum.data[[i.section]][,4],
     type="l",
     col="white",
     ylim=c(100,130),
     xlim=range(time.ticks),
     xlab="",
     ylab="River Stage (m)",
     )
axis(1,at=time.ticks[1:6],labels=c(2011,2012,2013,2014,2015,2016),tck=-0.02)
for (isection in mass.section)
{
    lines(datum.data[[isection]][,1]+start.time,
          datum.data[[isection]][,4],
          col=colors[isection],
          lwd=1,
          type="l")
}
#for (itime in real.times[seq(2,12,2)])
#for (itime in real.times[seq(1,12,2)])
for (itime in real.times[seq(1,12,1)])    
{
    lines(rep(itime,2),c(0,1323),lwd=2,col="red",lty=2)
}
legend(time.ticks[8],125,c("Upstream"),text.col="red",
       col=colors,lty=NA,lwd=1,horiz=TRUE,bty="n"
       )
legend(time.ticks[8],115,c("Middle"),text.col="red",
       col=colors,lty=NA,lwd=1,horiz=TRUE,bty="n"
       )
legend(time.ticks[8],108,c("Downstream"),text.col="red",
       col=colors,lty=NA,lwd=1,horiz=TRUE,bty="n"
       )

dev.off()


