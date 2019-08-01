rm(list=ls())
datafile = "data/DA1_Thermistors_13Sept2017.csv"

coordfile = "data/JonData.csv"
instrument.coord = read.csv(coordfile,stringsAsFactors=FALSE)
rownames(instrument.coord) = instrument.coord[,1]
instrument.coord = as.matrix(instrument.coord[,2:4])
#therm.coord = therm.coord[grep("T",rownames(therm.coord)),]


header = read.csv(datafile,
                  skip=2,nrow=1,header=FALSE,
                  stringsAsFactors=FALSE)
data = read.csv(datafile,skip=4,header=FALSE,stringsAsFactors=FALSE)

colnames(data) = header
obs.time = as.POSIXct(data[,1],format="%m/%d/%Y %H:%M",tz="GMT")
data = data[,!is.na(header)]
header = header[!is.na(header)]

transect.index = gsub("_.*","",header)
therm.depth = as.numeric(gsub("cm","",gsub(".*_","",header)))
transect.row = as.numeric(gsub(".*\\_(.*)\\_.*","\\1",header))
ntherm = length(header)

row.types = as.numeric(names(table(transect.row)))
row.types = sort(row.types)
transect.names = names(table(transect.index[-1]))
transect.names = transect.names[order(as.numeric(gsub("T","",transect.names)))]

therm.coord = array(NA,c(ntherm,3))

ntransect = length(names(table(transect.index)))
nrow.type = length(row.types)
targate.depth = c(50,100,200)
for (itransect in transect.names)
{

    for (irow in row.types)
        {
            temp1.index = which(transect.index == itransect &
                                transect.row == irow)
            temp1.index = temp1.index[order(therm.depth[temp1.index])]


            temp1.idepth = 0
            for (temp2.index in temp1.index)
            {
                temp1.idepth = temp1.idepth+1
                therm.coord[temp2.index,] = instrument.coord[
                    paste(itransect,"-",irow,"-",targate.depth[temp1.idepth],"cm",sep=""),]
            }

        }

}

save(list=ls(),file="results/dense_array_therm.r")


