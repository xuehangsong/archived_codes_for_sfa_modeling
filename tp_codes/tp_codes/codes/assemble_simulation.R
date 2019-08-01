rm(list = ls())
library(rhdf5)
library(RCurl) #for merage list

args=(commandArgs(TRUE))
if(length(args)==0){
    print("no arguments supplied, use default value")
    ireaz=1
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}
print(paste("ireaz =",ireaz))


out.dir = "pflotran_mc"
load("results/obs_info.r")
load("results/obs_name.r")

wells = da.wells
nwell = length(wells)

obs.time = collect.times
ntime = length(obs.time)


###read in all data
simu.all=list()

simu.all=list()
for (obs.file in list.files(paste("pflotran_mc/",sep=''),pattern=paste("RR",ireaz,"-obs-",sep='')))
{     
    header=read.table(paste("pflotran_mc/",obs.file,sep=''),nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
    simu.single=read.table(paste("pflotran_mc/",obs.file,sep=''),skip=1,header=FALSE)
    colnames(simu.single)=header
    simu.all=merge.list(simu.all,simu.single)
}

save(simu.all,file=paste("outputs/simu.all.",ireaz,".r",sep=''))




simu.tracer = list()
simu.tracer = array(NA,c(ntime,nwell))
colnames(simu.tracer) = wells

for (itime in 1:ntime)
{
    print(paste("itime =",itime))            
    simu.row=which.min(abs(obs.time[itime]-simu.all[1][,1]))        
    for (iwell in wells)
    {
        well.index = grep(paste(obs.name[[iwell]],collapse="|"),
                          names(simu.all))

        obs.type="Tracer1"
        simu.col=intersect(grep(obs.type,names(simu.all)),well.index)
        tracer.value = as.numeric(simu.all[simu.row,simu.col])


        obs.type="qlx"
        simu.col=intersect(grep(obs.type,names(simu.all)),well.index)
        vx.value = as.numeric(simu.all[simu.row,simu.col])

        obs.type="qly"
        simu.col=intersect(grep(obs.type,names(simu.all)),well.index)
        vy.value = as.numeric(simu.all[simu.row,simu.col])
        
        v.value = (vx.value^2+vy.value^2)^0.5
        simu.tracer[itime,iwell] =
            sum(tracer.value*v.value)/sum(v.value)
    }
}

save(simu.tracer,file=paste("outputs/simu_tracer_",ireaz,".r",sep=""))
