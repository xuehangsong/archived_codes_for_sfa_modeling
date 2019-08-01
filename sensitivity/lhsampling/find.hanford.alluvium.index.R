rm(list=ls())
order=array(NA,c(20,6))
colnames(order) = c("Hanford_1","Hanford_2","Hanford_3",
                    "Alluvium_1","Alluvium_2","Alluvium_3")

load("lhsampling.r")
load("../rank/shape1/results/rank.hanford.r")
order[,1] = order(rank.f)[index.hanford.hete[,1]]
load("../rank/shape2/results/rank.hanford.r")
order[,2] = order(rank.f)[index.hanford.hete[,2]]
load("../rank/shape3/results/rank.hanford.r")
order[,3] = order(rank.f)[index.hanford.hete[,3]]

load("../rank/shape1/results/rank.alluvium.r")
order[,4] = order(rank.f)[index.alluvium.hete[,1]]
load("../rank/shape2/results/rank.alluvium.r")
order[,5] = order(rank.f)[index.alluvium.hete[,2]]
load("../rank/shape3/results/rank.alluvium.r")
order[,6] = order(rank.f)[index.alluvium.hete[,3]]



save(order,file="order.r")

order = apply(order,2,order)

write.table(order,file="order.txt",row.name=F)
