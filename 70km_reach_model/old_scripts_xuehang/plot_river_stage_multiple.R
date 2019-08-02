rm(list=ls())
simu.dir="/Users/song884/remote/reach/Inputs/"
datum.file = list.files(paste(simu.dir,"bc_smooth/",sep=""),
                        "Datum")
fig.dir = "/Users/song884/remote/reach/figures/river_flux/"
start.time = as.POSIXct("2007-03-28 12:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = c(as.POSIXct("2007-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2008-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2009-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2011-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2012-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2013-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2014-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
               as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"))
    
mass.section = gsub(".txt","",gsub("DatumH_Mass1_","",datum.file))
mass.section = sort(as.numeric(mass.section))
mass.section = as.character(mass.section)

nsection = length(mass.section)
colors=rainbow(nsection)
names(colors)=mass.section


datum.data = list()
gradients.data = list()

mass.section = c(mass.section[1],
                 mass.section[floor(nsection/2)],
                 tail(mass.section,1)
                 )
nsection = length(mass.section)
colors=rainbow(nsection)
ltys = c(1,2,3)
names(ltys)=mass.section
names(colors)=mass.section

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

times = as.numeric(gsub(".png","",(list.files(fig.dir,"*png"))))
times = sort(times)
#times = times[times>(365*24*3)]
for (itime in times)
{
    print(itime)
    fname = paste(fig.dir,sprintf("%6.5E",itime),"_stage.jpg",sep="")
    jpeg(fname,units="in",
         quality=100,res=600,
         width=6.5,height=4)
    par(mgp=c(1.7,0.7,0),oma=c(0,0.5,0,0),
        mar=c(2.8,2.5,1.5,1))
    plot(datum.data[[i.section]][,1]+start.time,
         datum.data[[i.section]][,4],
         col=colors[i.section],
         type="l",
         ylim=c(100,132),
         xlab="Time (year)",
         ylab="River Stage (m)",
#         axis=NA,
         main=itime*3600+start.time#"(a) River Stage",          
         )
    axis(1,at=time.ticks,labels=NA,tck=-0.02)
#    axis(2,at=seq(100,130,10))
    for (isection in mass.section)
    {
        lines(datum.data[[isection]][,1]+start.time,
              datum.data[[isection]][,4],
              col=colors[isection],
              lty=ltys[isection],
              type="l")
    }
    lines(rep(itime*3600+start.time,2),c(0,128),lwd=2)
    legend("topleft",c("Upstream","Middle","Downstream"),
           col=colors,lty=1,lwd=1,horiz=TRUE,bty="n"
           )
    dev.off()
    stop()
}

