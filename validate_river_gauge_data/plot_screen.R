rm(list=ls())


well.list = c("2-34","2-26","2-27","2-28")
ele = c(114.8960,114.915,114.986,114.855)
top = c(108.1904,105.771,98.22344,102.0534)
bottom = c(103.6184,104.247,97.6138,101.444)

pdf(file="screen.pdf",width=4,height=5)
barplot(ele,ylim=c(90,118),xpd=FALSE,col="white") ##names.arg=well.list,
mtext("Elevation (m)",2,line=2.5)
mtext(paste(well.list,collapse="      "),1,line=0.35)
par(new=T)
barplot(top,ylim=c(90,118),xpd=FALSE,col="blue",axes=FALSE)
par(new=T)
barplot(bottom,ylim=c(90,118),xpd=FALSE,axes=FALSE,col="white")
par(new=T)
barplot(c(90,90,90,90),ylim=c(90,118),xpd=FALSE,axes=FALSE)
dev.off()
