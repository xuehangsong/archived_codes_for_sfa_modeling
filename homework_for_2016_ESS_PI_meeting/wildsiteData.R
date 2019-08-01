rm(list=ls(all=TRUE))

folder = c('C:/CHEN/SFA/wildsite_data/')
file=c('awln_all.txt')

data = read.table(paste(folder,file,sep=''),stringsAsFactors=F, sep=',',header=T)

wellname = unique(data$well_name)

for(i in 1:length(wellname)){
idx = which(data$well_name == wellname[i])

tt =strftime(data$hyd_date_time[idx],tz='GMT')

print(paste(wellname[i],sort(tt)[1],sort(tt)[length(tt)], length(tt)
	,range(data$hyd_head_m_navd88[idx])[1],range(data$hyd_head_m_navd88[idx])[2]))
}


#######################################################################
file=c('HydraulicHead.txt')

data = read.csv(paste(folder,file,sep=''),stringsAsFactors=F, sep=';',header=T); head(data)

wellname = unique(data$WELL_NAME);  length(wellname)
for(i in 1:length(wellname)){

idx = which(data$WELL_NAME == wellname[i])

tt =strftime(data$HYD_DATE_TIME_PST[idx],tz='GMT')

print(paste(sort(tt)[1],sort(tt)[length(tt)], length(tt)))

}
########################################################################################

file=c('HanfordGeologyWellLithologyConsolidated.csv')

data = read.csv(paste(folder,file,sep=''),stringsAsFactors=F, sep=',',header=T); head(data)
wellname = unique(data$well_name);  length(wellname)

#########################################################################################

file=c('HanfordGeologyWellLithology.csv')

data = read.csv(paste(folder,file,sep=''),stringsAsFactors=F, sep=',',header=T); head(data)

wellname = unique(data$Well.Name );  length(wellname)

###########################################################

file=c('WaterChemistryHanford.csv')

data = read.csv(paste(folder,file,sep=''),stringsAsFactors=F, sep=',',skip=1,header=F); head(data)

wellname = unique(data$Well.Name );  length(wellname)


######################################################################

file=c('wellAttributes.txt')

data = read.csv(paste(folder,file,sep=''),stringsAsFactors=F, sep=';',header=T); head(data)

wellname = unique(data$WELL_NAME);  length(wellname)
