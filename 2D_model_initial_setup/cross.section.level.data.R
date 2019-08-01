rm(list=ls())

well.list = c("NRG",
              "SWS-1",
              "2-3",
              "4-9",
              "2-1",
              "2-2")
n.well = length(well.list)

well.data = list()
well.time = list()
well.level = list()


for (i.well in 1:n.well)
{
    filename = list.files("data",pattern=paste(well.list[[i.well]],"_3var.csv",sep=''))
    if (length(filename)>1) {
        filename = filename[filename!=filename[grep("~",filename)]]
    }
    
    print(filename)
    well.data[[i.well]] = read.csv(paste("data/",filename,sep=''),stringsAsFactors=FALSE)


    well.time[[i.well]] = well.data[[i.well]][,
                                    grep(pattern='Time',colnames(well.data[[i.well]]))]

    if (grepl("-",well.time[[i.well]][1])) {
        well.time[[i.well]] =
            strptime(well.time[[i.well]],
                     format="%d-%b-%Y %H:%M:%S",tz='PST')} else{
                                                             well.time[[i.well]] = strptime(well.time[[i.well]],format="%m/%d/%Y %H:%M",tz='PST')}
    well.level[[i.well]] = well.data[[i.well]][,"WL.m"]
}

names(well.level) = well.list
names(well.data) = well.list
names(well.time) = well.list


obs.value = well.level
obs.time = well.time


##save(list=ls(),file = paste("results/","level.data.r",sep=''))
save(list=c("obs.value","obs.time"),file = paste("results/","level.data.r",sep=''))
