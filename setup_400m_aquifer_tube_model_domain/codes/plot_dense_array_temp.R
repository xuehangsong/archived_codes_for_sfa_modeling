rm(list=ls())
load("results/dense_array_therm.r")

stop()

## obs.time = obs.time[1:10]
## data = data[1:10,]
time.ticks = seq(from=as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
#                ,to=as.POSIXct("2017-12-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),by="1 hour")
                ,to=as.POSIXct("2017-12-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S"),by="1 month")         

## par(mfrow=c(ntransect,nrow.type))
## par(mfrow=c(4,5))

colors = c("green","orange","red")

jpeg("figures/dense_array_temp.jpg",width=8,height=15,units="in",quality=100,res=300)
par(mfrow=c(ntransect,nrow.type),
    mar=c(1,2,0.5,0),
    oma=c(3,2,1,1)
    )

for (itransect in transect.names[ntransect:1])
{

    for (irow in row.types[nrow.type:1])
        {
            temp1.index = which(transect.index == itransect &
                                transect.row == irow)
            temp1.index = temp1.index[order(therm.depth[temp1.index])]
            plot(obs.time,data[,temp1.index[1]],type="l",axes=FALSE,
                 col=colors[1],
                 ylim =c(0,25))
            box()
            axis(1,at = time.ticks,label=FALSE)
            axis(2,label=FALSE)            
            for (iline in 2:length(temp1.index))
            {
                lines(obs.time,data[,temp1.index[iline]],col=colors[iline])
            }

            if(itransect==transect.names[1])
            {
                axis(1,at = time.ticks,labels = format(time.ticks,format="%b"))
            }

            if(itransect==transect.names[ntransect])
            {
                mtext(paste(irow,"m"),3)                
            }

            if(irow==row.types[[nrow.type]])
            {
                axis(2,tick=FALSE)
                mtext(paste(itransect,"     "),2,line=2)                
                mtext(expression(paste("        ("^o,"C)")),2,line=2)
            }
            

            legend("topleft",as.character(paste(therm.depth[temp1.index],"cm")),
                       col=colors,lty=1,
                       bty="n")


            
        }


}
dev.off()





jpeg("figures/dense_array_temp_shallow.jpg",width=8,height=15,units="in",quality=100,res=300)
par(mfrow=c(ntransect,nrow.type),
    mar=c(1,2,0.5,0),
    oma=c(3,2,1,1)
    )

for (itransect in transect.names[ntransect:1])
{

    for (irow in row.types[nrow.type:1])
        {
            temp1.index = which(transect.index == itransect &
                                transect.row == irow)
            temp1.index = temp1.index[order(therm.depth[temp1.index])]
            plot(obs.time,data[,temp1.index[1]],type="l",axes=FALSE,
                 col=colors[1],
                 ylim =c(0,25))
            box()
            axis(1,at = time.ticks,label=FALSE)
            axis(2,label=FALSE)            
            ## for (iline in 2:length(temp1.index))
            ## {
            ##     lines(obs.time,data[,temp1.index[iline]],col=colors[iline])
            ## }

            if(itransect==transect.names[1])
            {
                axis(1,at = time.ticks,labels = format(time.ticks,format="%b"))
            }

            if(itransect==transect.names[ntransect])
            {
                mtext(paste(irow,"m"),3)
            }

            if(irow==row.types[[nrow.type]])
            {
                axis(2,tick=FALSE)
                mtext(paste(itransect,"     "),2,line=2)                
                mtext(expression(paste("        ("^o,"C)")),2,line=2)
            }
            

            legend("topleft",as.character(paste(therm.depth[temp1.index[1]],"cm")),                   
                       col=colors,lty=1,
                       bty="n")


            
        }


}
dev.off()




