rm(list=ls())

setwd("/Users/song884/pin")

rotate <- function(x) t(apply(x,2,rev))
data = scan("TOP.array",what="",sep="\n")
data = strsplit(data,"[ \t]+")

nsub = 6
new.data = list()
for (iseg in 1:(length(data)/6))
{
    new.data[[iseg]] = c("")
    for (isub in 1:nsub)
        {
            new.data[[iseg]] = c(new.data[[iseg]],unlist(data[[isub+nsub*(iseg-1)]]))
        }
}

new.data = lapply(new.data,as.numeric)
new.data = as.data.frame(new.data)
new.data = as.matrix(new.data)
new.data = new.data[!is.na(new.data[,1]),]
new.data = new.data

x=1:87
y=1:105


y=1:87*1000
x=1:105*1000

value = new.data*0.3048
value = value[nrow(value):1,]
value = rotate(value)
value = rotate(value)
value[value==0] = NA


filled.contour(x,y,value,
               asp=1,
               color.palette = terrain.colors)
