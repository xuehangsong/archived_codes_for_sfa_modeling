rm(list=ls())
load("results/interp.data.r")
coord.data = read.table("data/model.coord.dat")
rownames(coord.data) = coord.data[,3]
coord.data =  coord.data[rownames(coord.data) %in% c("1-10A","1-1","1-16A","1-57","2-2",
                                                      "2-3","2-1","3-9","3-10",
                                                      "4-9","4-7","SWS-1"),]
nwell = dim(coord.data)[1]-1
y = coord.data[1:nwell,2]

ntime = length(interp.time)
simu.time = c(1:ntime-1)*3600
gradient = rep(0,ntime)


##level.xts = t(mapply(c,level.xts))
temp = array(ntime*(nwell+1),c(nwell+1,ntime))
rownames(temp) = names(level.xts)
for (i in names(level.xts))
{
    temp[i,] = level.xts[[i]]
}
level.xts = temp    


available.date = which(colSums(level.xts,na.rm=TRUE)>200)


for (i in available.date) {
    no.na = which(!is.na(level.xts[1:nwell,i]))
    a= lm(level.xts[no.na,i]~y[no.na])   
    gradient[i] = a$coefficients[2]
}

###a = lm(level.xts[1:nwell,available.date]~y,na.action=na.omit)
##available.date = which(!is.na(colSums(level.xts)))

##gradient[available.date[1:10000]] = a$coefficients[2,]

## a = lm(level.xts[1:nwell,10001:20000]~y)
## gradient[10001:20000] = a$coefficients[2,]

## a = lm(level.xts[1:nwell,20001:28593]~y)
## gradient[20001:28593] = a$coefficients[2,]


Gradients_River = cbind(simu.time,
                        rep(0,ntime),
                        gradient,
                        rep(0,ntime))

DatumH_River = cbind(simu.time,
                     rep(coord.data["SWS-1",1],ntime),
                     rep(coord.data["SWS-1",2],ntime),
                     level.xts["SWS-1",])

save(gradient,file="results/inland.gradient.r.2013_2016.r")

write.table(DatumH_River,file=paste('DatumH_River_2013_2016.txt',sep=""),col.names=FALSE,row.names=FALSE)
write.table(Gradients_River,file=paste("Gradients_River_2013_2016.txt",sep=''),col.names=FALSE,row.names=FALSE)

