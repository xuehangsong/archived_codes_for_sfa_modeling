rm(list=ls(all=TRUE))

folder = c('./')

#well locations
file=c('wellAttributes.txt')
data = read.csv(paste(folder,file,sep=''),stringsAsFactors=F,quote="", sep=';',header=T) #; head(data)

for (i in 1:86)
{
    if (length(grep("C8201",data[,i]))>0)
        {
            print(i)
        }

}    


data_list = c("WELL_ID","WELL_NAME",
                "NORTHING",
                "EASTING"
                )
well_location  = NA
for (ilist in data_list)
{
    well_location = cbind(well_location,data[ilist])
}
well_location = well_location[-1]
#rownames(unique(well_location[,1]))


file=c('awln_all.txt')
data = read.table(paste(folder,file,sep=''),stringsAsFactors=F, quote="",sep=',',header=T)
data_list = c("well_id","well_name",
              "hyd_date_time",
              "hyd_head_m_navd88"
              )
head_data_1= NA
for (ilist in data_list)
{
    head_data_1 = cbind(head_data_1,data[ilist])
}
head_data_1 = head_data_1[-1]
colnames(head_data_1) = c("ID","NAME","TIME","HEAD")


file=c('HydraulicHead.txt')
data = read.csv(paste(folder,file,sep=''),stringsAsFactors=F, sep=';',quote="",header=T)
data_list = c("WELL_ID","WELL_NAME",
              "HYD_DATE_TIME_PST",
              "HYD_HEAD_METERS_NAVD88" 
              )
head_data_2= NA
for (ilist in data_list)
{
    head_data_2 = cbind(head_data_2,data[ilist])
}
head_data_2 = head_data_2[-1]
colnames(head_data_2) = c("ID","NAME","TIME","HEAD")

head_data = rbind(head_data_1,head_data_2)

avail_well_names = unique(c(head_data[,1][startsWith(head_data[,1],"A")],
                     head_data[,1][startsWith(head_data[,1],"B")],
                     head_data[,1][startsWith(head_data[,1],"C")]
                     ))
avail_well_names = avail_well_names[nchar(avail_well_names) == 5]
avail_well_names = sort(avail_well_names)



nwell = length(avail_well_names)
avail_wells = array(NA,c(nwell,8))
for (iwell in 1:nwell)
    {
        avail_wells[iwell,1] = avail_well_names[iwell]

        well_name_temp= well_location[well_location[,1]==avail_well_names[iwell],2]
        if (length(well_name_temp)>0)
            {
                avail_wells[iwell,2] =  tail(well_name_temp,1)
                avail_wells[iwell,3] =  tail(well_location[well_location[,1]==avail_well_names[iwell],3],1)
                avail_wells[iwell,4] =  tail(well_location[well_location[,1]==avail_well_names[iwell],4],1)
            }
        head_data_temp = head_data[head_data[,1]==avail_well_names[iwell],]
        head_data_temp[,3] = as.POSIXct(head_data_temp[,3],tz="GMT")
        avail_wells[iwell,5] =  as.character(min(head_data_temp[,3]))
        avail_wells[iwell,6] =  as.character(max(head_data_temp[,3]))
        avail_wells[iwell,7] =  min(head_data_temp[,4])
        avail_wells[iwell,8] =  max(head_data_temp[,4])
        
    }

avail_wells = avail_wells[which(as.numeric(avail_wells[,3])>100000),]
avail_wells = avail_wells[which(as.numeric(avail_wells[,4])>500000),]

colnames(avail_wells) = c("Well ID",
                          "Well Name",
                          "Northing",
                          "Easting",
                          "Time_start",
                          "Time_end",
                          "Min_head",
                          "Max_head")
save(avail_wells,file="head_data.r")




## avail_wells = array(NA,c(nwell,8))
## for (iwell in 1:nwell)
##     {
##         avail_wells[iwell,1] = avail_well_names[iwell]

##         well_name_temp= well_location[well_location[,1]==avail_well_names[iwell],2]
##         if (length(well_name_temp)>0)
##             {
##                 avail_wells[iwell,2] =  tail(well_name_temp,1)
##             }
##     }



## for(i in 1:length(wellname))
## {
##     idx = which(data$well_name == wellname[i])

##     tt =strftime(data$hyd_date_time[idx],tz='GMT')

##     print(paste(wellname[i],sort(tt)[1],sort(tt)[length(tt)], length(tt)
##                ,range(data$hyd_head_m_navd88[idx])[1],range(data$hyd_head_m_navd88[idx])[2]))
## }



#-----------------------------------------------------------------------



## wellname = unique(data$WELL_NAME)  #;  length(wellname)
## for(i in 1:length(wellname))
## {
##     idx = which(data$WELL_NAME == wellname[i])
##    tt =strftime(data$HYD_DATE_TIME_PST[idx],tz='GMT')
##    print(paste(sort(tt)[1],sort(tt)[length(tt)], length(tt)))
## }


#-----------------------------------------------------------


#wellname = unique(data$WELL_NAME)
