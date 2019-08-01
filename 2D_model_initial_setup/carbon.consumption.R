rm(list=ls())

obs.time = seq(0,336,1)
ntime = length(obs.time)


file.name = "rate.doc/102/2duniform-mas.dat"

header = read.table(file.name,nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
mas.data = read.table(file.name,skip=1,header=FALSE)
colnames(mas.data) = header

obs.type=c("Global CH2O(aq) [mol]",
           "river CH2O(aq) [mol]",
           "river CH2O(aq) [mol/h]",
           "west CH2O(aq) [mol]",
           "west CH2O(aq) [mol/h]")           

nobs = length(obs.type)
simu.value=array(rep(0,ntime*nobs),c(ntime,nobs))
colnames(simu.value)= obs.type
for (iobs in obs.type)
{    
    for (itime in 1:ntime)
    {
        print(itime)
        simu.col = grep(iobs,colnames(mas.data),fixed=TRUE)        
        simu.row = which.min(abs(obs.time[itime]-mas.data[,1]))
        simu.value[itime,iobs] = mas.data[simu.row,simu.col]
    }

}


level.inland = read.table(paste("rate.doc","/1","/DatumH_Inland_Heat.txt",sep=''))[,4]
level.river = read.table(paste("rate.doc","/1","/DatumH_River_Heat.txt",sep=''))[,4]



load("results/interp.data.r")
compare.time = seq(1,337)
time.ticks = seq(min(interp.time[compare.time]),max(interp.time[compare.time]+3600*24),3600*2*24)
time.ticks.minor = seq(min(interp.time[compare.time]),max(interp.time[compare.time]+3600*24),3600*1*24)
time.range = range(interp.time[compare.time])

jpeg(paste("figures/","mas.jpg",sep=''),width=16.8,height=8.4,units='in',res=200,quality=100)
par(mar=c(5,8,4,8),mgp=c(4,1.5,0))
plot(interp.time,level.value[["2-2"]],
     col='white',
     ylim=c(102,106),
     xlim=time.range,
     type='l',
     lty=2,
     lwd=2,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )

lines(interp.time[compare.time],level.value[["2-2"]][compare.time],col='black',lty=2,lwd=2)
lines(interp.time[compare.time],level.value[["4-9"]][compare.time],col='black',lty=3,lwd=2)
lines(interp.time[compare.time],level.inland[compare.time],col='black',lty=1,lwd=2)


lines(interp.time[compare.time],level.value[["NRG"]][compare.time],col='blue',lty=2,lwd=2)
lines(interp.time[compare.time],level.value[["SWS-1"]][compare.time],col='blue',lty=3,lwd=2)
lines(interp.time[compare.time],level.river[compare.time],col='blue',lty=1,lwd=2)


axis(side = 1,at = time.ticks.minor,label=rep("",length(time.ticks.minor)),cex.axis=1.8,tck=-0.015)
axis(side = 1,at = time.ticks,labels = format(time.ticks,format="%m/%d/%y"),tck=-0.02,cex.axis=1.8)
mtext(side = 1,text='Time (day)',line=3,cex=1.8)
axis(side = 4,at = c(104.5,105,105.5,106),col.axis='black',col='black',las=2,line=0,cex.axis=1.8)
mtext(side = 4,at=105.3,text='Water level (m)',line=6.5,col='black',cex=1.8)



par(mar=c(5,8,4,8),mgp=c(4,1.5,0),new=T,xpd=TRUE)
plot(interp.time[compare.time],12*1000*simu.value[,2][compare.time],
     col='white',
     xlim=time.range,
     ylim=c(-1e5,3e6),
     type='p',
     pch=16,
     axes= FALSE,
     xlab=NA,
     ylab=NA,     
     )


lines(interp.time[compare.time],12*1000*simu.value[,1][compare.time],col="grey",lwd=3)
lines(interp.time[compare.time],12*1000*simu.value[,2][compare.time],col="pink",lwd=3)
lines(interp.time[compare.time],12*1000*simu.value[,4][compare.time],col="green",lwd=3)
lines(interp.time[compare.time],12*1000*((simu.value[,2]+simu.value[,4]-simu.value[,1])[compare.time]+simu.value[1,1]),col="red",lwd=3)


axis(side = 2,at=seq(0,1.8e6,0.6e6),labels=format(seq(0,1.8e6,0.6e6),scientific=TRUE),col.axis='black',col='black',line=-1,las=2,cex.axis=1.8)
mtext(side = 2,at=1e6,text='OC (mg)',col='black',line=6.5,cex=1.8)


legend(x=start.time+1*3600*24,y= 3.2e6,c("Total OC","River OC","West OC","Cumsumpted OC"),
       cex=1.5,
       lty=c(1,1,1,1,1,1),
       pch=c(NA,NA,NA,NA,NA,NA),       
       col=c("grey","pink","green","red"),
       lwd=c(3,3,3,3,3,3),
       bty="n",horiz=TRUE)

legend(x=start.time-0*3600*24,y= 3.4e6,c("Inland WL","RiverWL","2-2 WL","4-9 WL","NRG WL","SWS-1 WL"),
       cex=1.5,
       lty=c(1,1,2,3,2,3),
       col=c("black","blue","black","black","blue","blue"),
       lwd=c(3,3,3,3,3,3),
       bty="n",horiz=TRUE)

dev.off()

    

    

