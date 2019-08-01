rm(list=ls())
load("statistics/parameters.r")
nreaz=6
level.inland = list()
level.river = list()

temp.inland = list()
temp.river = list()

xlim=c(as.POSIXct("2012-06-25 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
              as.POSIXct("2012-06-29 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"))

xlim=c(as.POSIXct("2010-01-1 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
              as.POSIXct("2016-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"))

xlim=c(as.POSIXct("2012-01-1 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"),
              as.POSIXct("2013-01-01 12:01:01",tz="GMT",format="%Y-%m-%d %H:%M:%S"))


time.ticks = seq(start.time,end.time,3600*24*30)
## time.ticks = seq(start.time,end.time,3600*24*5)
## time.ticks = seq(start.time,end.time,3600*24)
flag = start.time+7268*3*3600
##flag = start.time+7268*3*3600*1000

for (ireaz in 1:nreaz)
{
    temp = read.table(paste(ireaz,"/DatumH_Inland_2010_2015_average_3.txt",sep=''))
    level.inland[[ireaz]] = list(start.time+as.numeric(temp[,1]),temp[,4])
    
    temp = read.table(paste(ireaz,"/DatumH_River_2010_2015_average_3.txt",sep=''))
    level.river[[ireaz]] = list(start.time+as.numeric(temp[,1]),temp[,4])

    temp = read.table(paste(ireaz,"/Temp_Inland_2010_2015_average_3.txt",sep=''))
    temp.inland[[ireaz]] = list(start.time+as.numeric(temp[,1]),temp[,2])

    temp = read.table(paste(ireaz,"/Temp_River_2010_2015_average_3.txt",sep=''))
    temp.river[[ireaz]] = list(start.time+as.numeric(temp[,1]),temp[,2])
}

color = c("black","grey","blue","green","orange","red")

list=c("temp.river","temp.inland","level.inland","level.river")
save(list=list,file="statistics/boundary.r")

jpeg(paste("figures/level.inland.jpg"),width=10,height=3,units="in",res=200,quality=100)
plot(level.inland[[1]][[1]],level.inland[[1]][[2]],
     col="white",
     xlab="",
     ylab="",
     axes=FALSE,     
     xlim = xlim,      
##     ylim=c(104,108),     
     main = ("Inland water level")     
     )
box()
###mtext("Time (Year)",1,line=2)
mtext("Water level (m)",2,line=2)
axis.POSIXct(1,at=time.ticks,format="%Y-%m");
axis(2,seq(104,108,1));                        
lines(rep(flag,2),c(-100,1000),col="yellow",lwd=2,lty=2)
for (ireaz in 1:nreaz)
{
    lines(level.inland[[ireaz]][[1]],level.inland[[ireaz]][[2]],col=color[ireaz])
}
legend("topright",c("1 hour","3 hours","12 hours","24 hours","7 days","30 days"),lty=1,lwd=1,
       col=color,bty="n",horiz=TRUE,
       )
dev.off()







jpeg(paste("figures/level.diff.jpg"),width=10,height=6,units="in",res=200,quality=100)
plot(level.inland[[1]][[1]],level.river[[1]][[2]]-level.inland[[1]][[2]],
     col="black",type="l",
     xlab="",
     ylab="",
     axes=FALSE,     
     xlim = xlim,      
##     ylim=c(104,108),     
     )
box()
###mtext("Time (Year)",1,line=2)
mtext("Water level (m)",2,line=2)
axis.POSIXct(1,at=time.ticks,format="%Y-%m");
axis(2);                        
lines(rep(flag,2),c(-100,1000),col="yellow",lwd=2,lty=2)
for (ireaz in 1:1)
{
    lines(level.inland[[ireaz]][[1]],level.river[[ireaz]][[2]]-level.inland[[ireaz]][[2]],col=color[ireaz])
}
legend("topright",c("1 hour","3 hours","12 hours","24 hours","7 days","30 days"),lty=1,lwd=1,
       col=color,bty="n",horiz=TRUE,
       )
dev.off()


jpeg(paste("figures/level.river.jpg"),width=10,height=4,units="in",res=200,quality=100)
plot(level.river[[1]][[1]],level.river[[1]][[2]],
     col="white",
     xlab="",
     ylab="",
     axes=FALSE,     
     xlim = xlim,      
     ylim=c(105,107),
     main = ("River water level")     
     )
box()
###mtext("Time (Year)",1,line=2)
mtext("Water level (m)",2,line=2)
axis.POSIXct(1,at=time.ticks,format="%Y-%m");
axis(2,seq(104,108,1));
lines(rep(flag,2),c(-100,1000),col="yellow",lwd=2,lty=2)
for (ireaz in 1:nreaz)
{
    lines(level.river[[ireaz]][[1]],level.river[[ireaz]][[2]],col=color[ireaz])
}
legend("topright",c("1 hour","3 hours","12 hours","24 hours","7 days","30 days"),lty=1,lwd=1,
       col=color,bty="n",horiz=TRUE,
       )
dev.off()



jpeg(paste("figures/temp.river.jpg"),width=10,height=3,units="in",res=200,quality=100)
plot(temp.river[[1]][[1]],temp.river[[1]][[2]],
     col="white",
     xlab="",
     ylab="",
     axes=FALSE,     
     xlim = xlim,      
##     ylim=c(0,25),          
     main = ("River water temperature")     
     )
box()
###mtext("Time (Year)",1,line=2)
mtext("Water temperature (DegC)",2,line=2)
axis.POSIXct(1,at=time.ticks,format="%Y-%m");
axis(2,seq(0,20,5));                        
lines(rep(flag,2),c(-100,1000),col="yellow",lwd=2,lty=2)
for (ireaz in 1:nreaz)
{
    lines(temp.river[[ireaz]][[1]],temp.river[[ireaz]][[2]],col=color[ireaz])
}
legend("topright",c("1 hour","3 hours","12 hours","24 hours","7 days","30 days"),lty=1,lwd=1,
       col=color,bty="n",horiz=TRUE,
       )
dev.off()


jpeg(paste("figures/temp.inland.jpg"),width=10,height=3,units="in",res=200,quality=100)
plot(temp.inland[[1]][[1]],temp.inland[[1]][[2]],
     col="white",
     xlab="",
     ylab="",
     axes=FALSE,
     xlim = xlim, 

##     ylim=c(0,25),     
     main = ("Inland water temperature")     
     )
box()
###mtext("Time (Year)",1,line=2)
mtext("Water temperature (DegC)",2,line=2)
axis.POSIXct(1,at=time.ticks,format="%Y-%m");
axis(2,seq(12,17,1));
lines(rep(flag,2),c(-100,1000),col="yellow",lwd=2,lty=2)
for (ireaz in 1:nreaz)
{
    lines(temp.inland[[ireaz]][[1]],temp.inland[[ireaz]][[2]],col=color[ireaz])
}
legend("topright",c("1 hour","3 hours","12 hours","24 hours","7 days","30 days"),lty=1,lwd=1,
       col=color,bty="n",horiz=TRUE,
       )
dev.off()

