
#This file is used to analyze passive experimental data in 2011 at Hanford IFRC 

rm(list=ls())
#library(fields)
library(timeDate) # for time and date functions

#plot file extension
plot_ext = '.jpg'

# read in passive monitoring data
data_all = read.csv('../Data/300A-WL-data-thruOct2012/awln_2682_ext.csv',header=T,na.strings=" ")
# the columns are well_name[1],Date[2],Data Type [3],Elevation[4], MP Elevation(m) [5], DTW(ft)[6]

#convert the character strings
data_all[,1] = paste(data_all[,1]) # well name
data_all[,2] = paste(data_all[,2]) # dates

# total measurement points
n_meas = nrow(data_all)
# glue date and time together
meas_time = data_all[,2]
datetime_WL = timeDate(meas_time, format = '%Y-%m-%d  %H:%M:%s')
doy = dayOfYear(datetime_WL)

# Water level data
WL_data = data_all[,4]

#generate consective times in 1-hour interval from Jan-1 2012 00:00 to Sep-30 2012
dates_full = timeSequence(from = "2012-01-01 00:00:00", to = "2012-09-20 23:00:00", by = "hour")
n_full = length(dates_full)
#Initialize the output data matrix
data_output = matrix(NA,n_full,1)

#fill in the data 

#find the dates with measurements

idx_data = match(as.character(dates_full),as.character(datetime_WL))
idx_data_nonNA_1 = which(!is.na(idx_data))
idx_data_nonNA_2 = idx_data[idx_data_nonNA_1]
data_output[idx_data_nonNA_1,1] = WL_data[idx_data_nonNA_2]

data_output = data.frame(dates_full,data_output)
colnames(data_output) = c('Dates','H[m]')

write.table(data_output,file='RiverStage_Uncorrected_2012.txt',row.names=F)

# read in corrected data for Jan-June of 2012
data_corrected = read.table('../Data/SWS-1_Jan-Jun2012.txt',skip=1)
plot(data_output[1:4368,2],data_corrected[,3],xlab='Uncorrected',ylab='Corrected')
#regression model between corrected and uncorrected data
lin_mod1 = lm(data_corrected[,3] ~ data_output[1:4368,2])
summary(lin_mod1)

data_corrected_full = data_output
data_corrected_full[1:4368,2] = data_corrected[,3]
data_corrected_full[4369:n_full,2] = data_output[4369:n_full,2] - 0.03314

#for missing data due to over range, fill in some random values between the minimum of the cloest non-missing data
# and maximum of 108.6
idx_NA = which(is.na(data_corrected_full[,2]))

write.table(data_corrected_full,file='RiverStage_corrected_2012.txt',row.names=F)

# read in data measured at well 1-1
data_well1 = read.csv('../Data/1-1_WLData_2012.csv',header=T,na.strings=" ")
date_well = paste(data_well1[,1])
dates_well = timeDate(date_well, format = '%d-%b-%Y %H:%M:%S')

# find the well data between 1/1 00:00 and 9/30 23:00
data_well_select = matrix(NA,n_full,1)

idx_data = match(as.character(dates_full),as.character(dates_well))
idx_data_nonNA_1 = which(!is.na(idx_data))
idx_data_nonNA_2 = idx_data[idx_data_nonNA_1]
data_well_select[idx_data_nonNA_1,1] = data_well1[idx_data_nonNA_2,2]
if(FALSE)
{
	plot(data_well_select[1:4368,1],data_corrected[,3],xlab='Water level at well 1-1',ylab='Corrected river stage')

	plot(data_well_select[1:4368,1])
	lines(data_corrected[,3],col='red')
	plot(data_well_select[,1])
	lines(data_corrected_full[,2],col='red')	
	#lag plots
	par(mfrow=c(3,4))
	for (h in 0:11)
			plot(data_corrected[1:(4368-h),3],data_well_select[(1+h):4368,1],type='p',main = paste('Lag ',h,sep=''),ylab = 'well WL',xlab='River Stage',cex.lab=1.3,cex.axis=1.4)
}
data_filled = read.table('RiverStage_corrected_2012_filled.txt',skip=1)
plot(data_corrected_full[4900:5000,2],ylim = c(107,108.2),col='red')
lines(data_well_select[4900:5000,1])
lines(data_filled[4900:5000,3],col='blue')

#output the datum file from Apr-1 00:00 to Sep-20 23:00
idx_start = match('2012-04-01 00:00:00',as.character(dates_full))
data_output = data.frame(seq(0,14943600,3600),matrix(400.0,4152,1),matrix(400.0,4152,1),data_filled[idx_start:n_full,3])
write.table(data_output,file='DatumH_River_Plume2012.txt',row.names=F,col.names=F)
	
	

