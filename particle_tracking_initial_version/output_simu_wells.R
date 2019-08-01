rm(list=ls())
load("data/model_well.r")
x.range = c(-450,450)
y.range = c(-800,800)
z.range = c(90,110)
dx = rep(4,225)
dy = rep(4,400)
dz = rep(0.5,40)

x = cumsum(dx) - dx/2 + x.range[1]
y = cumsum(dy) - dy/2 + y.range[1]
z = cumsum(dz) - dz/2 + z.range[1]

## read coord from well summary
well.list = read.csv("data/wellsummary.csv")
well.list = as.character(well.list[,2])

well.list = well.list[model.coord[well.list,1]>=x.range[1]]
well.list = well.list[model.coord[well.list,1]<=x.range[2]]

well.list = well.list[model.coord[well.list,2]>=y.range[1]]
well.list = well.list[model.coord[well.list,2]<=y.range[2]]

well.list = well.list[well.list!="699-S27-E14"]
well.list = well.list[well.list!="NRG"]
well.list = well.list[well.list!="SWS-1"]

well.data = model.coord[well.list,]
rownames(well.data) = well.list

## use huiying's screen information
huiying.screen = read.csv("data/huiying_screen.csv")
rownames(huiying.screen) = huiying.screen[,2]
huiying.screen = huiying.screen[,c(9,10)]

well.data = cbind(well.data,huiying.screen[well.list,])
no.screen.well = rownames(well.data[is.na(well.data[,4]),])

## use xuehang's screen information
xuehang.screen = read.csv("data/xuehang_screen.csv")
rownames(xuehang.screen) = xuehang.screen[,1]
xuehang.screen = xuehang.screen[,c(2,3)]

well.data[no.screen.well,c(3,4)] = xuehang.screen[no.screen.well,]

no.screen.well = rownames(well.data[is.na(well.data[,4]),])


## use phoenix screen information
phoenix.screen = read.csv("data/phoenix_screen.csv")
rownames(phoenix.screen) = phoenix.screen[,1]
phoenix.screen = phoenix.screen[,c(7,8)]

well.data[no.screen.well,c(3,4)] = phoenix.screen[no.screen.well,]

no.screen.well = rownames(well.data[is.na(well.data[,4]),])

well.list = well.list[well.list!=no.screen.well]


well.data = well.data[well.list,]

colnames(well.data) = c("x","y","Top","Bottom")

simu.node = list()
for (iwell in well.list) {

    tempx = which.min(abs(x - well.data[iwell,c("x")]))
    tempy = which.min(abs(y - well.data[iwell,c("y")]))    
    tempz = which( (z <= well.data[iwell,c("Top")]) & (z>=well.data[iwell,c("Bottom")]))

    print(iwell)
    if(length(tempz)>0)
    {
        simu.node[[iwell]] = data.matrix(expand.grid(x=tempx,y=tempy,z=tempz))
    }
}

save(simu.node,file="simu_node.r")
