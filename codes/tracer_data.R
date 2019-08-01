###this program is used to preprocess tracer data

rm(list=ls())

obs.sd.ratio = 0.1


###data.file  = "~/repos/sbr-river-corridor-sfa/data/TracerData_Oct2011_new.csv"
data.file  = "./data/TracerData_Oct2011_new.csv"
data = read.csv(data.file,stringsAsFactors=FALSE)

data[,1] = paste("399-",data[,1],sep="")

data[,2] = as.POSIXct(data[,2],tz="GMT",format="%m/%d/%y %H:%M")
colnames(data) = gsub("\\.\\.","-",gsub("ug.L.","ugL",gsub("mg.L.","mgL",colnames(data))))
data = data[,c("Well.Name","Sample.Time.PDT","Cl-mgL")]
colnames(data) = c("well","time","tracer")

wells = names(table(data[,1]))
nwell = length(wells)

inject.time = as.POSIXct("10/19/11 11:00",tz="GMT",format="%m/%d/%y %H:%M")
start.time = inject.time
end.time = start.time+192*3600


well.min = rep(NA,nwell)
names(well.min) = wells

data = data[which(data[,"time"]<=end.time),]
for (iwell in wells)
{
    well.min[iwell] = min(data[which(data[,"well"]==iwell),"tracer"],na.rm=TRUE)
}
well.max = max(data[,"tracer"],na.rm=TRUE)

data = data[which(data[,2]>=start.time),]
data = data[which(!is.na(data[,3])),]

for (iwell in wells)
{
    data.temp = data[which(data[,"well"]==iwell),"tracer"]
    data[which(data[,"well"]==iwell),"tracer"] = (data.temp-well.min[iwell])/(
        well.max-well.min[iwell])
}
data[,"time"] = as.numeric(difftime(data[,"time"],start.time,units="hour"))
data[,"time"] = round(data[,"time"],3)
data[,"tracer"] = round(data[,"tracer"],3)

##screen some wells out
da.wells = c()
for (iwell in wells)
{
#    print(iwell)
     if(max(c(data[which(data[,"well"]==iwell),"tracer"]),0)>0.03)
    {
        da.wells = c(da.wells,iwell)
    }

}

all.time = c()
for (iwell in da.wells)
{
    all.time = c(all.time,data[data[,"well"]==iwell,"time"])
}

collect.times = sort(unique(all.time))
ncollect = length(collect.times)

obs.card = paste("   TIMES sec  \\")
npl = 3 ##ntime per line
nline = ncollect %/% npl
if (nline == 0 | nline==1) {
    obs.card = c(obs.card,paste(collect.times,collapse=" "))
} else {
    for (iline in 1:(nline-1))
    {
        obs.card = c(obs.card,
                     paste(paste(collect.times[((iline-1)*npl+1):(iline*npl)],
                                 collapse=" "),"\\"))
    }
    obs.card = c(obs.card,
                 paste(collect.times[(iline*npl+1):ncollect],
                       collapse=" "))
}
writeLines(obs.card,"results/obs_card.in")

da.list = list()
obs.data = c()
for (iwell in da.wells)
{
    da.list[[iwell]] = match(data[data[,"well"]==iwell,"time"],collect.times)
    obs.data = c(obs.data,data[data[,"well"]==iwell,"tracer"])
}

load("results/cells_to_update.r")
save(list=c("collect.times","data",
            "da.wells","obs.data","cells.to.update",
            "da.list"),file="results/obs_info.r")

jpg.name = paste("figures/tracer_obs.jpg",sep="")
jpeg(jpg.name,width=10,heigh=6,units="in",quality=100,res=300)
par(mfrow=c(4,6),        
    mar=c(3,3,1,0),
    oma=c(3,2,1,1),
    mgp=c(1.5,0.7,0)
    )

for (iwell in da.wells)
{
    plot(data[data[,"well"]==iwell,"time"],
         data[data[,"well"]==iwell,"tracer"],
         pch=1,
         ##                 xlim=range(start.time,end.time),
         ylim=c(0,1.2),
         xlab="Time (h)",
         ylab="Scaled C(%)",
         col="red",
         main=iwell,
         )

}
dev.off()


