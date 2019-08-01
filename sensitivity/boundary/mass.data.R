rm(list=ls())

data = read.table('data/proj.coord.dat')
rownames(data) = data[,3]

mass = read.csv('data/mass/coordinates.csv')
rownames(mass) = mass[,1]

slice.list = as.character(seq(318,327))
mass.data = list()
for (islice in slice.list) {
    mass.data[[islice]] = read.csv(paste("data/mass/mass1_",islice,".csv",sep=""))
}
names(mass.data) = slice.list

for (islice in slice.list) {
    mass.data[[islice]][["date"]] = as.POSIXct(mass.data[[islice]][["date"]],format="%Y-%m-%d %H:%M:%S",tz='GMT')
}
save(mass.data,file="results/mass.data.r")
