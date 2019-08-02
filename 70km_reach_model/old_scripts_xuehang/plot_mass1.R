## plot all MASS 1 water levels


setwd("/Users/shua784/Dropbox/PNNL/People/Velo/MASS1_Simulation_Output/transient_1976_2016/")

rm(list=ls())

##------------------INPUT------------------##
path = "/Users/shua784/Dropbox/PNNL/People/Velo/MASS1_Simulation_Output/transient_1976_2016/"

##------------------OUTPUT----------------##
fig.wl = "/Users/shua784/Dropbox/PNNL/Projects/Columbia_Basin/figures/MASS1_All_WL.jpg"


files = list.files(path)

# files = c(files[1:2], "mass1_333.csv")

start.time = as.POSIXct("2010-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")
end.time = as.POSIXct("2016-01-01 00:00:00",format="%Y-%m-%d %H:%M:%S",tz="GMT")

colors = rainbow(10)

jpeg(file=fig.wl, width=12, height=16, units="in", res=300)
par(mar =c(4,4,1,1))
plot(0,0,xlim = c(start.time, end.time),ylim = c(102, 128),type = "n", xlab = "Date", ylab = "Water Level (m)",
     axes = F)
box()

for (ifile in files) {
  
  riverdata = read.csv(ifile)
  riverdata[,1] = as.POSIXct(riverdata[,1],format="%Y-%m-%d %H:%M:%S",tz="GMT")
  riverdata[,4] = riverdata[,4]+1.039
  
  selected.time = which(riverdata[,1]>start.time &
                          riverdata[,1]<end.time)  
  
  lines(riverdata[selected.time, 1], riverdata[selected.time, 4], col= sample(colors), lwd = 0.5)
  
  axis.POSIXct(1,at=seq(as.Date("2010-01-01 00:00:00",tz="GMT"),
                        to=as.Date("2016-01-01 00:00:00",tz="GMT"),by="quarter"),
               format="%m/%Y",mgp=c(5,1.7,0),cex.axis=1)
  axis(2,at=seq(102, 128, 1),mgp=c(5,0.7,0),cex.axis=1)
  # mtext("Water level (m)",2,line=2,cex=1)
   
}

dev.off()
                  

