
#This file is used to analyze passive experimental data in 2010 and 2011 at Hanford IFRC 

rm(list=ls())
library(fields)
include_inj = TRUE

path_prefix = '../Mar2011/TrueData_Mar2011TT/'
data = read.table('Data_Passive_2009_2010_2011_2012.txt',skip=1) # the columns are: year, date,water level,specific conductance,U2-26,U3-30,azimuth,gradient
idx_2011 = which(data[,1] == 2011)

dates_2011 = as.Date(1:length(idx_2011),origin='2010-03-24')

doy_2011 = seq(1,length(idx_2011)) + 83

plot_cols = c('red','darkgreen','blue','black')

if(!include_inj)
{
	plot_ext = '_ExcludeInj.jpg'
	dates_2011 = dates_2011[25:length(idx_2011)]
	doy_2011 = doy_2011[25:length(idx_2011)]
	idx_2011 = idx_2011[25:length(idx_2011)]
}
if(include_inj)
	plot_ext = '.jpg'
	
#if(length(which(data[,8] > 0.02))>0)
#	data[which(data[,8] > 0.02),8] = NA

well_data = read.table(paste(path_prefix,'well_list_full.txt',sep=''),skip=1) #the columns are well_ID, x,y, elev(m),borehole IDs,top_screen_depth, bot_screen_depth, H/R contact detpth(ft, from Gamma log)
well_data[,1] = paste(well_data[,1]) #convert well IDs to string
wells = well_data[,1]
# to force the well IDs to have the same format, e.g., change 399-2-5 to 399-2-05 
idx = which(nchar(wells) < 8)
if(length(idx)>0)
{
	for (i in idx)
	{
		ctemp = substring(wells[i],nchar(wells[i]),nchar(wells[i]))
		wells[i] = paste(wells[i],'0',sep='')
		substring(wells[i],7,7)='0'
		substring(wells[i],8,8)=ctemp	
	}
}

	
#read in BEU data 
BEU_data = read.table('BEU_Data.txt',skip=1) #columns are name,x,y,z,BEU
BEU_data[,1] = paste(BEU_data[,1]) 
idx_2_26 = grep('399-2-26',BEU_data[,1])
idx_3_30 = grep('399-3-31',BEU_data[,1])
idx_2_29 = grep('399-2-30',BEU_data[,1])
x_BEU = array(NA, c(max(c(length(idx_2_26),length(idx_3_30),length(idx_2_29))),3))
y_BEU = x_BEU
x_BEU[1:length(idx_2_26),1] = BEU_data[idx_2_26,4]
x_BEU[1:length(idx_3_30),2] = BEU_data[idx_3_30,4]
x_BEU[1:length(idx_2_29),3] = BEU_data[idx_2_29,4]
y_BEU[1:length(idx_2_26),1] = BEU_data[idx_2_26,5]
y_BEU[1:length(idx_3_30),2] = BEU_data[idx_3_30,5]
y_BEU[1:length(idx_2_29),3] = BEU_data[idx_2_29,5]
BEU_max = max(y_BEU,na.rm=T)

####read in lithology data
#columns are wells,	y,x,TopDepth(ft),BotDepth(ft),Lithofacies
Litho_data = read.table('lithofacies.txt',skip = 1)
Litho_data[,1] = paste(Litho_data[,1])

#convert the depth to elevation
for (i in 1:length(Litho_data[,1]))
{
	elev = well_data[grep(Litho_data[i,1],wells),4]
	Litho_data[i,4] = elev - 0.3048 * Litho_data[i,4]
	Litho_data[i,5] = elev - 0.3048 * Litho_data[i,5]
}

well_names = c('399-2-26','399-3-30','399-2-29')

#time series plots

####for U concentration over four years for three wells #############

Udata_2011 = data[idx_2011,7:9]

SpC_2011 = data[idx_2011,4:6]

Hdata_2011 = data[idx_2011,3] 

xmin = min(c(doy_2011))
xmax = max(c(doy_2011))
xticks = seq(xmin,xmax,10)
xlabs = as.Date(xticks+1,origin='2010-01-01')
	

for(iplot in 1:3){
	jpeg(paste('TimeSeries_USpC_2011_',well_names[iplot],plot_ext,sep=''), width = 15, height = 10,units="in",res=200,quality=100)

#####plot U concentrations over two years
	ymax1 = max(c(Udata_2011[,iplot]),na.rm=T)
	ymax2 = max(c(SpC_2011[,iplot]),na.rm=T)
	ymin2 = min(c(SpC_2011[,iplot]),na.rm=T)	

	plot(doy_2011,Udata_2011[,iplot],xlim=c(xmin,xmax),ylim=c(0,ymax1),xlab="", ylab="",main=well_names[iplot],type='b',pch=2,col=plot_cols[1],axes=FALSE)
	axis(side = 1, at = xticks, labels = format(xlabs,"%b-%d"),  cex.axis = 1.0)
	mtext("Dates",side=1,col="black",line=2.5)
	axis(side = 2, col = 'black',las=1,cex.axis = 1.0)
	mtext('U Conc [ug/L]',side=2,line=2.5)
	
		
	#add another axis for specific conductance

	par(new=TRUE)
	
	#yticks2 = pretty(0:max(max(true_UO2,na.rm=T)+1,50))
	plot(doy_2011, SpC_2011[,iplot], xlab="", ylab="",xlim=c(xmin,xmax),ylim=c(ymin2,ymax2),axes=FALSE, type="l",lty='dashed', col=plot_cols[3])
 
	axis(4, col="blue",col.axis="blue",line=-1)
	mtext("SpC",side=4,col="blue",line=1) 
	legend("topleft",c('U2011','SpC2011'), lty=c('solid','dashed'),pch=c(2,-1),col=c(plot_cols[1],plot_cols[3]),cex=1.2, bty='n')

	dev.off()
}



