rm(list=ls())
load('results/interpolated.data.r')

data = read.table('data/proj.coord.dat')
rownames(data) = data[,3]

mass = read.csv('data/mass/coordinates.csv')
rownames(mass) = mass[,1]

                  

jpeg(paste("figures/domain.jpg",sep=''),width=6,height=12,units='in',res=200,quality=100)
plot(data[,1],data[,2],asp=1,
     xlim = c(594000,595000),
     ylim = c(115000,117000)
     )

model.domain=read.table("data/model.domain.dat")
lines(model.domain[c(1,2,3,4,1),1],model.domain[c(1,2,3,4,1),2],lty=2,col="orange",lwd=2)
lines(model.domain[c(5,6,7,8,5),1],model.domain[c(5,6,7,8,5),2],lty=2,col="green",lwd=2)

well.list = c("1-10A","SWS-1","4-7","3-18","1-16A","2-3")
well.list = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","4-9","4-7","3-18")

for (iwell in well.list) {

    text(data[iwell,1],data[iwell,2]+30,iwell,col="red")
    points(data[iwell,1],data[iwell,2],col="red",pch=16)        

}

iwell="SWS-1"
text(data[iwell,1],data[iwell,2]+30,iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        

iwell="NRG"
text(data[iwell,1],data[iwell,2]+30,iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        

iwell="RG3"
text(data[iwell,1],data[iwell,2]+30,iwell,col="blue")
points(data[iwell,1],data[iwell,2],col="blue",pch=16)        


## iwell="T3"
## text(data[iwell,1],data[iwell,2]+30,iwell,col="black")
## points(data[iwell,1],data[iwell,2],col="black",pch=16)        

## for (islice in as.character(seq(318,326))) {
##     text(mass[islice,2],mass[islice,3]+30,islice,col="blue")  
##     points(mass[islice,2],mass[islice,3],col="blue",pch=1)
## }


#rect(c(model.domain[3,],model.domain[4,]))
dev.off()
