rm(list=ls())
data = read.table('data/proj.coord.dat')
rownames(data) = data[,3]

mass = read.csv('data/mass/coordinates.csv')
rownames(mass) = mass[,1]

                  
jpeg(paste("figures/domain.jpg",sep=''),width=8,height=12,units='in',res=200,quality=100)
plot(data[,1],data[,2],asp=1,
     xlim=c(594200,594600),
     ylim=c(115500,117000)     

     )

well.list = c("1-10A","SWS-1","4-7","3-18","1-16A","2-3")

well.list = c("1-10A","1-1","1-16A","1-57","2-2","2-3","2-1","3-9","3-10","4-9","4-7","3-18","2-32","1-21A","2-23",
              "2-7","2-5"

              )

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


iwell="T3"
text(data[iwell,1],data[iwell,2]+30,iwell,col="black")
points(data[iwell,1],data[iwell,2],col="black",pch=16)        



## for (islice in as.character(seq(318,326))) {
##     text(mass[islice,2],mass[islice,3]+30,islice,col="blue")  
##     points(mass[islice,2],mass[islice,3],col="blue",pch=1)
## }


dev.off()
