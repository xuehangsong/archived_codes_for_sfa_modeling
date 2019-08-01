rm(list=ls())

nsec = 15

coord = read.csv("data/coordinates.csv")
rownames(coord) = coord[,1]
coord = coord[,2:4]

length = diff(range(coord[,"rivermile"]))
dlength = length/nsec

start = array(NA,nsec)
for (isec in 1:nsec)
{
    start[isec] = which.min(abs(coord[1,"rivermile"]-coord[,"rivermile"]-
                            dlength*(isec-1)))
}

start.points = rownames(coord[start,])
save(start.points,file="start.r")

rect = array(NA,c(4,nsec))
for (i in 1:(nsec-1))
{
    rect[1,i] = min(coord[start[i]:start[i+1],"easting"])
    rect[2,i] = min(coord[start[i]:start[i+1],"northing"])
    rect[3,i] = max(coord[start[i]:start[i+1],"easting"])
    rect[4,i] = max(coord[start[i]:start[i+1],"northing"])
}    
rect[1,nsec] = min(coord[start[nsec]:dim(coord)[1],"easting"])
rect[2,nsec] = min(coord[start[nsec]:dim(coord)[1],"northing"])
rect[3,nsec] = max(coord[start[nsec]:dim(coord)[1],"easting"])
rect[4,nsec] = max(coord[start[nsec]:dim(coord)[1],"northing"])


plot(coord[,"easting"],coord[,"northing"],xlim=c(550000,600000),ylim=c(110000,160000))
##points(coord[start,"easting"],coord[start,"northing"],col="red",pch=16,cex=3)
for (i in 1:nsec)
{
    rect(rect[1,i],rect[2,i],rect[3,i],rect[4,i])
}

driver = 1500
mark = array(1,c(4,nsec))
for (imark in 1:length(mark))
{
    index = c((imark-1) %% 4 +1,(imark-1) %/% 4+1)
    if (mark[index[1],index[2]] == 0) {

        if((index[1] == 1) | (index[1]==2)) {
            rect[index[1],index[2]] = rect[index[1],index[2]]-driver
        } else {
            rect[index[1],index[2]] = rect[index[1],index[2]]+driver
        }
    }


    flag = c(0,0)
    for (isec in 2:nsec)
    {
        temp1 = rep(rect[c(1,3),isec],2)-rep(rect[c(1,3),isec-1],each=2)
        temp1 = temp1[which.min(abs(temp1))]
        temp2 = rep(rect[c(2,4),isec],2)-rep(rect[c(2,4),isec-1],each=2)
        temp2 = temp2[which.min(abs(temp2))]
        flag=rbind(flag,cbind(temp1,temp2))
    }    
    mark = array(0,c(4,nsec))
    mark[,1] = c(1,0,0,0)
    mark[,nsec] = c(0,1,0,1)    
    for (isec in 2:nsec)
    {
        if(flag[isec,1]!=0)
        {
            mark[4,isec-1] = 1
            mark[2,isec] = 1
        }

        if(flag[isec,2]!=0)
        {
            mark[3,isec-1] = 1
            mark[1,isec] = 1
        }
    }


}
for (i in 1:nsec)
{
    rect(rect[1,i],rect[2,i],rect[3,i],rect[4,i],col="green",density=0.01)
}
