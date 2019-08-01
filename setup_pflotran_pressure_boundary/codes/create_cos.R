rm(list=ls())
fname = "./default/east_sin.txt"


time = seq(0,1,0.01)
ntime = length(time)
head = sin(8*pi*time/max(time))
min = 1.8
max = 2.2

head = head*(max-min)/2
head = head+(min-min(head))




data = cbind(time*3600,
             rep(0,ntime),
             rep(0,ntime),
             head
             )
write.table(data,file=fname,col.names=FALSE,row.names=FALSE)




colors = rainbow(200)
jpeg(paste("figures/reference_pressure.jpg",sep=''),width=6,height=5,units='in',res=300,quality=100)
plot(time,head,,xlim=c(0,1),xlab="Time (h)",
     ylab = "Pressure head (m)",
     ylim=c(1.75,2.25))

legend("topright",
       c("Reference pressure"),
       pch=1,bty="n",
       col=c("black"))
dev.off()

