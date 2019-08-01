rm(list=ls())


wells = c("1-2",
          "1-60",
          "1-21A",
          "3-22",
          "3-34",          
          "3-37",
          "1-7",
          "2-1",
          "2-2",
          "2-3",
          "3-18",                              
          "1-57",
          "1-16A"
          )

nwell = length(wells)
colors = rainbow(nwell)
names(colors) = wells

welldata = list()
for (iwell in wells)
{
    print(iwell)
    welldata[[iwell]] = read.csv(paste("data/399-",iwell,"_3var.csv",sep=""))
    welldata[[iwell]] = welldata[[iwell]][,c(1,2)]
    welldata[[iwell]][,1] = as.POSIXct(welldata[[iwell]][,1],tz="GMT",format="%d-%b-%Y %H:%M:%S")
    names(welldata[[iwell]]) = c("Time","Temp")
}




jpeg(paste("figures/Wells_temp.jpg",sep=''),width=12,height=10,units='in',res=300,quality=100)
plot(welldata[["1-2"]],
     type="l",
     col="white",
     ylim=c(9,21))
for (iwell in wells)
{
    lines(welldata[[iwell]],col=colors[iwell])
}
legend("topright",
       wells,
       lty=1,
       lwd=3,
       col=colors[wells],
       bty="n",
       )
dev.off()


wells = "1-21A"
jpeg(paste("figures/Well1_21A_temp.jpg",sep=''),width=6,height=5,units='in',res=300,quality=100)
plot(welldata[["1-2"]],
     type="l",
     col="white",
     ylim=c(0,30))
for (iwell in wells)
{
    lines(welldata[[iwell]],col=colors[iwell])
}
legend("topright",
       wells,
       lty=1,
       lwd=3,
       col=colors[wells],
       bty="n",
       )
dev.off()
