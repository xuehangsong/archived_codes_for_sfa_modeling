rm(list=ls())

file.name = list()
time.col.name = list()
obs.col.name = list()
time.format = list()


coord.data = read.table("data/proj.coord.dat")
rownames(coord.data) = coord.data[,3]
proj.xlim = c(594000,594700)
proj.ylim = c(115700,116800)
coord.data = coord.data[which(coord.data[,1]>proj.xlim[1] & coord.data[,1]<proj.xlim[2]),]
coord.data = coord.data[which(coord.data[,2]>proj.ylim[1] & coord.data[,2]<proj.ylim[2]),]
coord.data = coord.data[which(coord.data[,2]>proj.ylim[1] & coord.data[,2]<proj.ylim[2]),]
coord.data =  coord.data[!rownames(coord.data) %in% c("T2","T3","T4","T5","S1","S","S3",
                                                      "N1","N2","N3","SWS-1","NRG",
                                                      "2-7","2-8","2-9","2-11","2-12",
                                                      "2-13","2-14","2-15","2-16","2-17",
                                                      "2-18","2-19","2-20","2-21","2-22",
                                                      "2-23","2-24","2-26","2-27","2-28",
                                                      "2-29","2-30","2-31","2-34","2-37",
                                                      "3-9","3-12","3-23","3-24","3-25",
                                                      "3-27","3-28","3-30","3-31","3-32","3-35",
                                                      "1-2","1-17A","1-21B","1-32","1-57",
                                                      "1-60","2-1","2-5","2-10","2-25",
                                                      "2-33","3-10","3-20","3-21",
                                                      "3-22","3-26","3-29","3-34","3-37"),]


obs.list = c("S10",
             "S40",
             "T2",
             "T3",
             "T4",
             "T5",
             "NRG",
             rownames(coord.data),
             "SWS-1")

for (i.obs in obs.list[1:7])
{
    file.name[[i.obs]] = list.files("data/shared.drive",pattern=i.obs)
    file.name[[i.obs]] = paste("data/shared.drive/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "DateTimeGMT08"
    obs.col.name[[i.obs]] = "ECtemp_degC"
    time.format[[i.obs]] = "%Y-%m-%d %H:%M:%S"
}
file.name[["NRG"]] = "data/shared.drive/River_gauge_DO_EC_withWL.csv"

for (i.obs in obs.list[8:24])
{
    file.name[[i.obs]] = list.files("data/velo.head",pattern=paste(i.obs,"_3var.csv",sep=''))
    file.name[[i.obs]] = paste("data/velo.head/",file.name[[i.obs]],sep='')
    time.col.name[[i.obs]] = "Date.Time.PST"
    obs.col.name[[i.obs]] = "Temp.degC"
    time.format[[i.obs]] = "%d-%b-%Y %H:%M:%S"
}






obs.data = list()
obs.time = list()
obs.value = list()

for (i.obs in obs.list)
{
    print(file.name[[i.obs]])
    obs.data[[i.obs]] = read.csv(file.name[[i.obs]],stringsAsFactors=FALSE)
    obs.time[[i.obs]] = obs.data[[i.obs]][, grep(pattern=time.col.name[[i.obs]],colnames(obs.data[[i.obs]]))]
    obs.time[[i.obs]] = as.POSIXct(obs.time[[i.obs]],format=time.format[[i.obs]],tz='GMT')
    obs.value[[i.obs]] = obs.data[[i.obs]][,obs.col.name[[i.obs]]]
}
save(list=c("obs.value","obs.time"),file = paste("results/","spc.temp.data.r",sep=''))
