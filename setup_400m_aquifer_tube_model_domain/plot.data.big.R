rm(list=ls())
library(xts)
library(lubridate)

start.time = as.POSIXct("2016-08-18 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-08-25 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
time.ticks = seq(from=start.time,to=end.time,by="day")

data.file  = read.table("data/tom_data.csv",header=TRUE,sep=",",stringsAsFactors=FALSE)
date.and.time = paste(data.file[["Date"]])
date.and.time = as.POSIXct(date.and.time,format="%m/%d/%Y %H:%M",tz="GMT")
data.file = xts(data.file,order.by=date.and.time ,unique=T,tz="GMT")

obs.list = list()
obs.list[["N-M"]] = c("N-M-50","N-M-114")
obs.list[["S-M"]] = c("S-M-41","S-M-83")
obs.list[["N-U"]] = c("N-U-50","N-U-100")
obs.list[["S-U"]] = c("S-U-50","S-U-100","S-U-180")

location.name = c(as.character(unlist(obs.list)),"River")
tom.data = list()
for (iloc in location.name)
{
    row.index = grep(iloc,data.file[,1])
    obs.name = colnames(data.file)
    tom.obs = obs.name    
    for (iobs in obs.name)
    {
        temp = data.file[row.index,iobs]        
        temp = temp[!is.na(temp)]
        tom.data[[iloc]][[iobs]] = temp
    }
}



data.file  = read.table("data/field_data.csv",header=TRUE,sep=",",stringsAsFactors=FALSE)
date.and.time = paste(data.file[["Date"]],data.file[["Sampling.time"]])
no.data.point = grep("NA",date.and.time)
##data.file[!no.data.point,]
data.file = data.file[-c(no.data.point),]
date.and.time = date.and.time[-c(no.data.point)]
date.and.time = as.POSIXct(date.and.time,format="%m/%d/%Y %H:%M:%S",tz="GMT")
data.file = xts(data.file,order.by=date.and.time ,unique=T,tz="GMT")


field.data = list()
for (iloc in location.name)
{
    row.index = grep(iloc,data.file[,1])
    obs.name = colnames(data.file)
    field.obs = obs.name
    for (iobs in obs.name)
    {
        temp = data.file[row.index,iobs]
        temp = temp[!is.na(temp)]
        field.data[[iloc]][[iobs]] = temp
    }
}

## to correct tom's time stamp
for (iloc in location.name)
{
    temp = index(field.data[[iloc]][[1]])
    ntime = length(tom.data[[iloc]][[1]])
    correct.time = rep(start.time,ntime)
    for (itime in 1:ntime)
    {
        correct.time[itime]= temp[which.min(abs(as.numeric((difftime(temp,index(tom.data[[iloc]][[1]][itime]))))))]
    }
    for (iobs in 1:length(tom.data[[iloc]]))
    {
        tom.data[[iloc]][[iobs]] = xts(tom.data[[iloc]][[iobs]],order.by=correct.time ,unique=T,tz="GMT")
    }
    
}    




for (iloc in location.name)
{
    temp = index(field.data[[iloc]][[1]])
    ntime = length(tom.data[[iloc]][[1]])
    correct.time = rep(start.time,ntime)
    for (itime in 1:ntime)
    {
        correct.time[itime]= temp[which.min(abs(as.numeric((difftime(temp,index(tom.data[[iloc]][[1]][itime]))))))]

    }
    for (iobs in 1:length(tom.data[[iloc]]))
    {
        tom.data[[iloc]][[iobs]] = xts(tom.data[[iloc]][[iobs]],order.by=correct.time ,unique=T,tz="GMT")
    }
    
}    


color = c("green","red","black")
pchtype = c(0,1,2,3)

obstype = list()
ylim = list()
title = list()
at = list()
mtext = list()
mtextat = list()
jpegname = list()

obstype[[1]] = "pH"
ylim[[1]] = c(7,10)
title[[1]] = "ICP-OES pH vs. ICP-OES Cl"
at[[1]] = seq(7,10,1)
mtext[[1]] = "ICP-OES pH"
mtextat[[1]] = 8.5
jpegname[[1]] = "pH_big.jpeg"



obstype[[2]] = "Inorg.C.as.C"
ylim[[2]] = c(10,30)
title[[2]] = "ICP-OES Inorg C as C vs. ICP-OES Cl"
at[[2]] = seq(10,30,5)
mtext[[2]] = "ICP-OES Inorg C as C (mg/L)"
mtextat[[2]] = 20
jpegname[[2]] = "Inorg_big.jpeg"


obstype[[3]] = "NPOC.as.C"
ylim[[3]] = c(0,3)
title[[3]] = "ICP-OES NPOC C as C vs. ICP-OES Cl"
at[[3]] = seq(0,3,1)
mtext[[3]] = "ICP-OES NPOC C as C (mg/L)"
mtextat[[3]] = 1.5
jpegname[[3]] = "NPOC_big.jpeg"


obstype[[4]] = "F"
ylim[[4]] = c(0,0.4)
title[[4]] = "ICP-OES F vs. ICP-OES Cl"
at[[4]] = seq(0,0.4,0.1)
mtext[[4]] = "ICP-OES F (mg/L)"
mtextat[[4]] = 0.2
jpegname[[4]] = "F_big.jpeg"


obstype[[5]] = "Cl"
ylim[[5]] = c(0,10)
title[[5]] = "ICP-OES Cl vs. ICP-OES Cl"
at[[5]] = seq(0,10,2)
mtext[[5]] = "ICP-OES Cl (mg/L)"
mtextat[[5]] = 5
jpegname[[5]] = "Cl_big.jpeg"



obstype[[6]] = "SO4"
ylim[[6]] = c(0,40)
title[[6]] = "ICP-OES SO4 vs. ICP-OES Cl"
at[[6]] = seq(0,40,10)
mtext[[6]] = "ICP-OES SO4 (mg/L)"
mtextat[[6]] = 20
jpegname[[6]] = "SO4_big.jpeg"



obstype[[7]] = "NO3"
ylim[[7]] = c(0,15)
title[[7]] = "ICP-OES NO3 vs. ICP-OES Cl"
at[[7]] = seq(0,15,3)
mtext[[7]] = "ICP-OES NO3 (mg/L)"
mtextat[[7]] = 8
jpegname[[7]] = "NO3_big.jpeg"


obstype[[8]] = "U"
ylim[[8]] = c(0,60)
title[[8]] = "ICP-OES U vs. ICP-OES Cl"
at[[8]] = seq(0,60,20)
mtext[[8]] = "ICP-OES U (ug/L)"
mtextat[[8]] = 30
jpegname[[8]] = "U_big.jpeg"


obstype[[9]] = "Mg"
ylim[[9]] = c(2,10)
title[[9]] = "ICP-OES Mg vs. ICP-OES Cl"
at[[9]] = seq(2,10,2)
mtext[[9]] = "ICP-OES Mg (mg/L)"
mtextat[[9]] = 6
jpegname[[9]] = "Mg_big.jpeg"


obstype[[10]] = "Ca"
ylim[[10]] = c(15,40)
title[[10]] = "ICP-OES Ca vs. ICP-OES Cl"
at[[10]] = seq(15,40,5)
mtext[[10]] = "ICP-OES Ca (mg/L)"
mtextat[[10]] = 28
jpegname[[10]] = "Ca_big.jpeg"


obstype[[11]] = "Na"
ylim[[11]] = c(0,12)
title[[11]] = "ICP-OES Na vs. ICP-OES Cl"
at[[11]] = seq(0,12,3)
mtext[[11]] = "ICP-OES Na (mg/L)"
mtextat[[11]] = 6
jpegname[[11]] = "Na_big.jpeg"


obstype[[12]] = "K"
ylim[[12]] = c(0.5,2)
title[[12]] = "ICP-OES K vs. ICP-OES Cl"
at[[12]] = seq(0.5,2,0.5)
mtext[[12]] = "ICP-OES K (mg/L)"
mtextat[[12]] = 1.3
jpegname[[12]] = "K_big.jpeg"





nobs=12
for (iobs in 1:nobs)
{
    jpeg(paste("figures/windowSpC/",jpegname[[iobs]],sep=""),
         width =9, height=10,units="in",res=300,quality=100)
    par(mfrow=c(2,2))
    ipch=1
    for (isection in names(obs.list))
    {

    
        base.type = "Cond"
        tom.type = obstype[[iobs]]
        base.obs  = as.numeric(tom.data[["River"]][[base.type]])
        tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
        
    plot(base.obs,tom.obs,
         xlim=c(100,300),
         ylim=ylim[[iobs]],col='blue',
         xlab=NA,
         ylab=NA,
         pch=16,
         main=paste(isection,title[[iobs]]),
         axes=FALSE)
        box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=at[[iobs]],line=0)
    mtext("ICP-OES SpC (uS/cm)",1,at=200,line=2)
    mtext(mtext[[iobs]],2,at=mtextat[[iobs]],line=2)    

    for (idepth in 1:length(obs.list[[isection]]))
    {
        base.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[base.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(base.obs,tom.obs,col=color[idepth],pch=pchtype[ipch])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=c(16,rep(pchtype[ipch],length(obs.list[[isection]]))),
           ,col=c("blue",color))
        ipch = ipch+1

    }
    dev.off()

}






















nobs=12
for (iobs in 1:nobs)
{
    jpeg(paste("figures/windowCl/",jpegname[[iobs]],sep=""),
         width =9, height=10,units="in",res=300,quality=100)
    par(mfrow=c(2,2))
    ipch=1
    for (isection in names(obs.list))
    {

    
        base.type = "Cl"
        tom.type = obstype[[iobs]]
        base.obs  = as.numeric(tom.data[["River"]][[base.type]])
        tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
        
    plot(base.obs,tom.obs,
         xlim=c(0,10),
         ylim=ylim[[iobs]],col='blue',
         xlab=NA,
         ylab=NA,
         pch=16,
         main=paste(isection,title[[iobs]]),
         axes=FALSE)
        box()
    axis(1,at=seq(0,10,2),line=0)
    axis(2,at=at[[iobs]],line=0)
    mtext("ICP-OES Cl (mg/L)",1,at=5,line=2)
    mtext(mtext[[iobs]],2,at=mtextat[[iobs]],line=2)    

    for (idepth in 1:length(obs.list[[isection]]))
    {
        base.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[base.type]])
        tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
        points(base.obs,tom.obs,col=color[idepth],pch=pchtype[ipch])
    }
    legend("topleft",c("River",obs.list[[isection]]),bty="n",
           pch=c(16,rep(pchtype[ipch],length(obs.list[[isection]]))),
           ,col=c("blue",color))
        ipch = ipch+1

    }
    dev.off()

}












nobs=12
for (iobs in 1:nobs)
{
    jpeg(paste("figures/bigCl/",jpegname[[iobs]],sep=""),
         width =9, height=9.6,units="in",res=300,quality=100)
    base.type = "Cl"
    tom.type = obstype[[iobs]]
    isection = names(obs.list)[1]
    base.obs  = as.numeric(tom.data[["River"]][[base.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    plot(0,0,
         xlim=c(0,10),
         ylim=ylim[[iobs]],col='white',
         xlab=NA,
         ylab=NA,
         main=paste(title[[iobs]]),axes=FALSE)
    box()
    axis(1,at=seq(0,10,2),line=0)
    axis(2,at=at[[iobs]],line=0)
    mtext("ICP-OES Cl (mg/L)",1,at=5,line=2)
    mtext(mtext[[iobs]],2,at=mtextat[[iobs]],line=2)    
    points(base.obs,tom.obs,pch=16,col="blue")
    ipch=1
    for (isection in names(obs.list))
    {
        for (idepth in 1:length(obs.list[[isection]]))
        {
            base.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[base.type]])
            tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
            points(base.obs,tom.obs,col=color[idepth],pch=pchtype[ipch])
        }
        ipch = ipch+1
    }

    legend("topleft",c("River",unlist(obs.list)),bty="n",
           pch= c(16,rep(pchtype[1],length(obs.list[[1]])),rep(pchtype[2],length(obs.list[[2]])),
                  rep(pchtype[3],length(obs.list[[3]])),rep(pchtype[4],length(obs.list[[4]]))),
           col=c("blue",color[1:length(obs.list[[1]])],color[1:length(obs.list[[2]])],
                 color[1:length(obs.list[[3]])],color[1:length(obs.list[[4]])]))
    dev.off()

}










for (iobs in 1:nobs)
{
    jpeg(paste("figures/bigSpC/",jpegname[[iobs]],sep=""),
         width =9, height=9.6,units="in",res=300,quality=100)
    base.type = "Cond"
    tom.type = obstype[[iobs]]
    isection = names(obs.list)[1]
    base.obs  = as.numeric(tom.data[["River"]][[base.type]])
    tom.obs = as.numeric(tom.data[["River"]][[tom.type]])
    plot(0,0,
         xlim=c(100,300),
         ylim=ylim[[iobs]],col='white',
         xlab=NA,
         ylab=NA,
         main=paste(title[[iobs]]),axes=FALSE)
    box()
    axis(1,at=seq(100,300,50),line=0)
    axis(2,at=at[[iobs]],line=0)
    mtext("ICP-OES SpC (uS/cm)",1,at=200,line=2)
    mtext(mtext[[iobs]],2,at=mtextat[[iobs]],line=2)    
    points(base.obs,tom.obs,pch=16,col="blue")
    ipch=1
    for (isection in names(obs.list))
    {
        for (idepth in 1:length(obs.list[[isection]]))
        {
            base.obs  = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[base.type]])
            tom.obs = as.numeric(tom.data[[ obs.list[[isection]][idepth] ]][[tom.type]])
            points(base.obs,tom.obs,col=color[idepth],pch=pchtype[ipch])
        }
        ipch = ipch+1
    }

    legend("topleft",c("River",unlist(obs.list)),bty="n",
           pch= c(16,rep(pchtype[1],length(obs.list[[1]])),rep(pchtype[2],length(obs.list[[2]])),
                  rep(pchtype[3],length(obs.list[[3]])),rep(pchtype[4],length(obs.list[[4]]))),
           col=c("blue",color[1:length(obs.list[[1]])],color[1:length(obs.list[[2]])],
                 color[1:length(obs.list[[3]])],color[1:length(obs.list[[4]])]))
    dev.off()

}

