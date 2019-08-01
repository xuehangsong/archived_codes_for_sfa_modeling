rm(list=ls())
library(fields)
library(AtmRay) ##meshgrid

west.x = 594300
east.x = 594550
south.y = 116150
north.y = 116400

angle = 15/180*pi

###400*400
td.origin = c(594186,115943)

##T3 slice
t3.origin = c(594378.6,116216.3)

##T4 slice
t4.origin = c(594386.880635513,116185.502270774)




jon = read.csv('data/JonData.csv',stringsAsFactors=FALSE)
rownames(jon) = jon[,1]
jon = as.matrix(jon[,2:4])


data = read.table('data/proj.coord.dat',stringsAsFactors=FALSE)
rownames(data) = data[,3]
data = as.matrix(data[,1:2])


ele = read.csv('data/jon01152017.csv',stringsAsFactors=FALSE)
rownames(ele) = ele[,1]
ele = as.matrix(ele[,2:4])



ac = array(NA,c(4,2))
ac[3,1] = td.origin[1]+400*cos(angle)+350*cos(angle+0.5*pi)
ac[3,2] = td.origin[2]+400*sin(angle)+350*sin(angle+0.5*pi)
ac[2,1] = ac[3,1]-150*cos(angle)
ac[2,2] = ac[3,2]-150*sin(angle)
ac[1,1] = ac[2,1]-200*cos(angle+0.5*pi)
ac[1,2] = ac[2,2]-200*sin(angle+0.5*pi)
ac[4,1] = ac[3,1]-200*cos(angle+0.5*pi)
ac[4,2] = ac[3,2]-200*sin(angle+0.5*pi)



##jpeg(paste("figures/ERT.model.jpg",sep=''),width=8,height=8,units='in',res=300,quality=100)


west.x = 594450
east.x = 594500
south.y = 116200
north.y = 116350
jpeg(paste("figures/ERT.model.jpg",sep=''),width=6,height=8,units='in',res=300,quality=100)
par(mar=c(3,3.2,2.5,1))
plot(NA,NA,
     xlim=c(west.x,east.x),
     ylim=c(south.y,north.y),
     asp=1,axes=FALSE,
     )
box()            
axis(1,mgp=c(0,0.6,0));
axis(2,mgp=c(0,0.8,0),las=0);


mtext("Easting (m)",1,line=1.5)
mtext("Northing (m)",2,line=1.8,las=0)         


lines(c(ac[1,1],ac[2,1]),c(ac[1,2],ac[2,2]),col="cyan",lwd=2)
lines(c(ac[2,1],ac[3,1]),c(ac[2,2],ac[3,2]),col="cyan",lwd=2)
lines(c(ac[3,1],ac[4,1]),c(ac[3,2],ac[4,2]),col="cyan",lwd=2)
lines(c(ac[4,1],ac[1,1]),c(ac[4,2],ac[1,2]),col="cyan",lwd=2)                  


well.list = head(rownames(data),-14)


for (iwell in well.list) {

    text(data[iwell,1],data[iwell,2]+20,iwell,col="red")
    points(data[iwell,1],data[iwell,2],col="red",pch=16)        

}

points(jon[,1],jon[,2],pch=16)

lines(c(data["c1",1],data["c2",1]),c(data["c1",2],data["c2",2]),col="purple")
lines(c(data["c2",1],data["c3",1]),c(data["c2",2],data["c3",2]),col="purple")         
lines(c(data["c3",1],data["c4",1]),c(data["c3",2],data["c4",2]),col="purple")         
lines(c(data["c4",1],data["c1",1]),c(data["c4",2],data["c1",2]),col="purple")         


iwell="SWS-1"
text(data[iwell,1],data[iwell,2]+15,iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        


iwell="RG3"
text(data[iwell,1]+20,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        


iwell="T2"
text(data[iwell,1]+10,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

iwell="T3"
text(data[iwell,1]+10,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

iwell="T4"
text(data[iwell,1]+10,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

iwell="T5"
text(data[iwell,1]+10,data[iwell,2],iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=17)        

## iwell="array_north"
## text(data[iwell,1],data[iwell,2]+15,iwell,col="purple")
## points(data[iwell,1],data[iwell,2],col="purple",pch=16)        

## iwell="array_south"
## text(data[iwell,1],data[iwell,2]+15,iwell,col="purple")
## points(data[iwell,1],data[iwell,2],col="purple",pch=16)        


## elelist = c("N_WL-1","N_WL-2","N_WL-3","North_tran1")
## points(ele[elelist,1],ele[elelist,2],col="orange",pch=16,cex=1.5)        

## elelist = c("NM114","NM50")
## points(ele[elelist,1],ele[elelist,2],col="green",pch=16,cex=1.5)        

## elelist = c("NU100","NU50")
## points(ele[elelist,1],ele[elelist,2],col="purple",pch=16,cex=1.5)        




## elelist = c("SU100","SU180e","SU50")
## points(ele[elelist,1],ele[elelist,2],col="yellow",pch=16,cex=1.5)        

## elelist = c("N_trans_aq1","N_trans_aq2","N_trans_River")
## points(ele[elelist,1],ele[elelist,2],col="red",pch=16,cex=1.5)        
##legend("topright",c("N_tran*","N_WL*","NM*","NU*","SU*"),col=c("red","orange","green","purple","yellow"),pch=16)



elelist = c("NM114")
points(ele[elelist,1],ele[elelist,2],col="red",pch=16,cex=1.5)        

elelist = c("NM50")
points(ele[elelist,1],ele[elelist,2],col="orange",pch=16,cex=1.5)        


elelist = c("NU100")
points(ele[elelist,1],ele[elelist,2],col="green",pch=16,cex=1.5)        


elelist = c("NU50")
points(ele[elelist,1],ele[elelist,2],col="purple",pch=16,cex=1.5)        


legend("topright",c("NM114","NM50","NU100","NU50"),col=c("red","orange","green","purple"),pch=16)

dev.off()

