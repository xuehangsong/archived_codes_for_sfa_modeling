rm(list=ls())
coord.data = read.table("data/proj.coord.dat")
nonuniform.x = c(594186,594572.4,594468.9,594082.5)
nonuniform.y = c(115943,116046.5,116432.9,116329.4)
slice.x = c(594386.8,594525.1)
slice.y = c(116186,116223)

slice.new.x = c(594377.5,(594377.5+594525.1-594386.8))
slice.new.y = c(116220.4,(116220.4+116223-116186))

## x.new[river.bank.x[which.min(abs(z.new[river.bank.z]-105))]]
## x.new[river.bank.x[which.min(abs(z.new[river.bank.z]-106))]]
## x.new[river.bank.x[which.min(abs(z.new[river.bank.z]-107))]]

water.mark.x=c(594481.1,594484.3,594492.1)
water.mark.y=c(116211.3,116212.1,116214.2)

thermistor.x = c(594509.2,594502.3,594383.5,594347.3,594347.3)
thermistor.y = c(116153,116179.5,116784.4,117046.4,117140.6)

jpeg(paste("figures/","domain.jpg",sep=''),width=8,height=10,units='in',res=200,quality=100)
plot(coord.data[,1],coord.data[,2],
     xlim = c(594000,594700),
     ylim = c(115700,116800),          
     xlab = "Easting (m)",
     ylab = "Northing (m)",     
     pch = 1,
     asp = TRUE,
     cex.lab=1.5,
     cex.axis=1.5
     )


lines(slice.x,slice.y,col='grey',lwd=3)
lines(slice.new.x,slice.new.y,col='orange',lwd=3)

###points(slice.x,slice.y,col=c("red","blue"),pch=1)

###points(slice.new.x[1],slice.new.y[1],col=c("red","blue"),pch=1)
####points(water.mark.x,water.mark.y,pch=8,col='black')
points(rep(nonuniform.x,2),rep(nonuniform.y,2),type="l",col='pink',lwd=2,lty=2)








well.name = c("T2","T3","T4","T5")
#well.name = coord.data[,3]

name.index = which(coord.data[,3] %in% well.name)
text((coord.data[name.index,1]+30),coord.data[name.index,2],
     coord.data[name.index,3],col='black',cex=1.5)
points(coord.data[name.index,1],coord.data[name.index,2],pch=16,col='black')

points(thermistor.x,thermistor.y,pch=16,col='red')

###well with names
well.name = c("1-1",
              "1-10A",
              "1-16A",
              "1-57",
              "2-2",
              "2-1",
              "3-18",
              "3-9",
              "3-20",
              "3-10",
              "1-7",
              "2-32",
              "2-33",
              "3-37"
              )
name.index = which(coord.data[,3] %in% well.name)
text(coord.data[name.index,1],(coord.data[name.index,2]+20),
     coord.data[name.index,3],col='black',cex=1.5)
points(coord.data[name.index,1],coord.data[name.index,2],pch=1,col='black')



well.name = c("3-21")
name.index = which(coord.data[,3] %in% well.name)
text(coord.data[name.index,1],(coord.data[name.index,2]-20),
     coord.data[name.index,3],col='black',cex=1.5)
points(coord.data[name.index,1],coord.data[name.index,2],pch=1,col='black')


well.name = c("S")
name.index = which(coord.data[,3] %in% well.name)
text(coord.data[name.index,1]-20,(coord.data[name.index,2])+10,
     coord.data[name.index,3],col='black',cex=1.5)
points(coord.data[name.index,1],coord.data[name.index,2],pch=16,col='black')



###DO wells
well.name = c("4-9","2-2","1-10A","2-3",
              "NRG","T2","T3","T4","T5",
              "S"
              )
name.index = which(coord.data[,3] %in% well.name)
points(coord.data[name.index,1],coord.data[name.index,2],pch=3,cex=2,col='black')


###real time wells
well.name = c("1-2",
              "8-5A",
              "3-19",
              "1-16A",
              "3-18",
              "1-21A",
              "SWS-1",
              "1-7",
              "NRG",
              "2-3"
              )
name.index = which(coord.data[,3] %in% well.name)
text(coord.data[name.index,1],(coord.data[name.index,2]+20),
     coord.data[name.index,3],col='black',cex=1.5)
points(coord.data[name.index,1],coord.data[name.index,2],pch=4,cex=2,col='black')





well.name = c("2-3","4-9")
name.index = which(coord.data[,3] %in% well.name)
text(coord.data[name.index,1],(coord.data[name.index,2]+20),
     coord.data[name.index,3],col='red',cex=1.5)
points(coord.data[name.index,1],coord.data[name.index,2],pch=1,col='red')



well.name = c("SWS-1","NRG")
name.index = which(coord.data[,3] %in% well.name)
text(coord.data[name.index,1],(coord.data[name.index,2]+20),
     coord.data[name.index,3],col='blue',cex=1.5)
points(coord.data[name.index,1],coord.data[name.index,2],pch=16,col='blue')




coord.data = read.table("data/proj.coord.dat")
rownames(coord.data) = coord.data[,3]
proj.xlim = c(594000,594700)
proj.ylim = c(115700,116800)
coord.data = coord.data[which(coord.data[,1]>proj.xlim[1] & coord.data[,1]<proj.xlim[2]),]
coord.data = coord.data[which(coord.data[,2]>proj.ylim[1] & coord.data[,2]<proj.ylim[2]),]
coord.data = coord.data[which(coord.data[,2]>proj.ylim[1] & coord.data[,2]<proj.ylim[2]),]
coord.data =  coord.data[!rownames(coord.data) %in% c("T2","T3","T4","T5","S1","S","S3",
                                                      "N1","N2","N3","SWS-1","NRG",
                                                      "2-7","2-8","2-9","2-11","2-12",
                                                      "2-13","2-14","2-15","2-16","2-17",
                                                      "2-18","2-19","2-20","2-21","2-22",
                                                      "2-23","2-24","2-26","2-27","2-28",
                                                      "2-29","2-30","2-31","2-34","2-37",
                                                      "3-9","3-12","3-23","3-24","3-25",
                                                      "3-27","3-28","3-30","3-31","3-32","3-35",
                                                      "1-2","1-17A","1-21B","1-32","1-57",
                                                      "1-60","2-1","2-5","2-10","2-25",
                                                      "2-33","3-10","3-20","3-21",
                                                      "3-22","3-26","3-29","3-34","3-37"),]

well.name = c(rownames(coord.data))
name.index = which(coord.data[,3] %in% well.name)
text(coord.data[name.index,1],(coord.data[name.index,2]+20),
     coord.data[name.index,3],col='green',cex=1.5)





legend("topright",c("River gauge","Piezometers","Wells","DO observation","Realtime EC"),
       pch=c(16,16,1,3,4),
       col=c("blue","black","black","black","black"),
       bty="n",
       cex=1.5
       )


dev.off()

