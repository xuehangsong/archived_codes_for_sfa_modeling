rm(list=ls())
library(rhdf5)

start.time = as.POSIXct("2015-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
input.dir = "ert_model/"

river.level = read.table(paste(input.dir,"/DatumH_River_ERT.txt",sep=""))
river.level = river.level[,c(1,4)]
inland.level = cbind(h5read(paste(input.dir,"/H_BC_ERT.h5",sep=""),"BC_West/Times")*3600,
                     h5read(paste(input.dir,"/H_BC_ERT.h5",sep=""),"BC_West/Data")[,1])

river.temp = read.table(paste(input.dir,"/Temp_River_ERT.txt",sep=""))
inland.temp = read.table(paste(input.dir,"/Temp_Inland_ERT.txt",sep=""))


jtime=0
for (itime in (8760/24):max(inland.level[,1]/24/3600))
{
    jtime=jtime+1
    fname = paste("bc_moving/",jtime,".jpg",sep="")
    jpeg(fname,width=12,height=4,units="in",quality=100,res=200)
    par(mar=c(4,4,2,4),
        mgp=c(1.8,0.8,0))
    plot(start.time+river.level[,1],river.level[,2],
         type="l",
         col="blue",
         xlab="Time",
         ylab="Water level (m)"
         )

    lines(start.time+inland.level[,1],inland.level[,2],
          col="black"
          )
    par(mar=c(4,4,2,4),new=T,
        mgp=c(1.8,0.7,0))

    plot(start.time+river.temp[,1],river.temp[,2],
         type="l",
         col="red",
         xlab="",
         ylab="",
         axes=FALSE)
    lines(start.time+inland.temp[,1],inland.temp[,2],col="purple")
    axis(4,col="red",col.ticks="red",col.lab="red")
    mtext(expression(paste("Temperature ("^o,"C)")),4,col="red",line=2)

    lines(rep(itime*24*3600+start.time,2),c(-1000,1000),col="green",lwd=5)
    
    legend("topright",c("Inland level","River level","Inland temperature","River temperature"),
           col=c("black","blue","purple","red"),lwd=1,horiz=TRUE,
           bty="n"
           )

    dev.off()
    print(jtime)
}
