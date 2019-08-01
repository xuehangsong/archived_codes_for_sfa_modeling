rm(list=ls())

river.level =  read.table("DatumH_River_2010_2015_average_3.txt")
hist(river.level[,4])
