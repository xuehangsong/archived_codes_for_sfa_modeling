rm(list=ls())
river.level = read.table("../boundary/DatumH_River_2010_2015.txt")
river.level = river.level[,4]
inland.level = read.table("../boundary/DatumH_Inland_2010_2015.txt")
inland.level = inland.level[,4]
inland.temp = read.table("../boundary/Temp_Inland_2010_2015.txt")
inland.temp = inland.temp[,2]
river.temp = read.table("../boundary/Temp_River_2010_2015.txt")
river.temp = river.temp[,2]

