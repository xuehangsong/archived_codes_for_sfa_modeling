rm(list=ls())
load("results/well.data.xts.r")

start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-12-31 23:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.index = seq(from=start.time,to=end.time,by="1 hour")
ntime = length(time.index)
simu.time = c(1:ntime-1)*3600
inland.gradient = rep(NA,ntime)

well.name = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","3-18","4-9","4-7")

coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% well.name,]
nwell = dim(coord.data)[1]
y = coord.data[well.name,2]

inland.level = array(ntime*nwell,c(nwell,ntime))
rownames(inland.level) = well.name
for (iwell in well.name) {
    inland.level[iwell,] = well.data.xts[[iwell]][,"level"]
}

time.tick = seq(from=start.time,to=end.time,by="1 year")
jpeg(paste("figures/inland.avaiable.jpg",sep=''),width=16,height=5,units='in',res=200,quality=100)
plot(time.index,inland.level[1,],type="p",col="white",pch=16,cex=0.3,
     xlim=range(start.time,end.time),
     xlab=NA,
     ylab=NA,
     axes=FALSE,
     ylim=c(-800,800),
     main="Avaiable data"     
     )

for (iwell in well.name)
{
    points(time.index[which(!is.na(inland.level[iwell,]))],rep(coord.data[iwell,2],ntime)[which(!is.na(inland.level[iwell,]))],pch=16,cex=0.5)
    text(range(time.index)[2],coord.data[iwell,2],iwell)
}



mtext("Time (Year)",side=1,line=2)
mtext("Y (m)",side=2,line=2)
axis(side=1,label=time.tick,at=time.tick)
axis(side=2,at=seq(-800,800,400))    

dev.off()

