rm(list=ls())


start_time = as.POSIXct("2010-01-01 00:00:00",tz="GMT")

plot_time = as.POSIXct("2013-07-04 00:00:00",tz="GMT")
#plot_time = as.POSIXct("2013-10-07 00:00:00",tz="GMT")

time_index = difftime(plot_time,start_time,units="secs")

path = "./"
bc_files = list.files(path,pattern=paste("Datum",sep=''))
nfiles = length(bc_files)
datum = array(NA,c(nfiles,4))
for (ifile in 1:nfiles)
{
    data = read.table(bc_files[ifile],header=FALSE,stringsAsFactors=FALSE)
    datum[ifile,1:4] = as.numeric(data[which(data[,1]==time_index),1:4])
}



fname = paste("figures/wl",plot_time,".jpg",sep="")
jpeg(file=fname,width=4,height=3,units="in",res=600)                
par(mar=c(4.8,4.8,1,1.2))
plot(datum[,3],datum[,4],
#     type="l",col="blue",ylim=c(104.4,105.2),
     type="l",col="blue",ylim=c(106.8,107.6),     
     axes=FALSE,xlab=NA,ylab=NA,lwd=1,
  )
main = plot_time
axis(1,at=seq(-800,800,200),mgp=c(5,0.3,0),cex.axis=1,las=1,tck=-0.03)
mtext("River level (m)",2,line=2.5,cex=1)
mtext("Northing (m)",1,line=1.2,cex=1)
axis(2,at=seq(104,107.8,0.2),mgp=c(5,0.3,0),cex.axis=1,las=1,tck=-0.03)
box()
dev.off()

