
#This file is used to analyze passive experimental data in 2010 and 2011 at Hanford IFRC 

rm(list=ls())
library(fields)
include_inj = TRUE

path_prefix = '../Mar2011/TrueData_Mar2011TT/'
data = read.table('Data_Passive_2009_2010_2011_2012.txt',skip=1) # the columns are: year, date,water level,specific conductance,U2-26,U3-30,azimuth,gradient
idx_2010 = which(data[,1] == 2010)


dates_2010 = as.Date(1:length(idx_2010),origin='2010-04-30')
doy_2010 = seq(1,length(idx_2010)) + 120
plot_cols = c('red','darkgreen','blue','black')

if(!include_inj)
{
	plot_ext = '_ExcludeInj.jpg'
	dates_ = dates_2010[25:length(idx_2010)]
	doy_2010 = doy_2010[25:length(idx_2011)]
	idx_2010 = idx_2010[25:length(idx_2010)]
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

Udata_2010 = data[idx_2010,7:9]

SpC_2010 = data[idx_2010,4:6]

Hdata_2010 = data[idx_2010,3] 

xmin = min(c(doy_2010))
xmax = max(c(doy_2010))
xticks = seq(xmin,xmax,10)
xlabs = as.Date(xticks+1,origin='2010-01-01')
	

for(iplot in 1:3){
	jpeg(paste('TimeSeries_USpC_2010_',well_names[iplot],plot_ext,sep=''), width = 15, height = 10,units="in",res=200,quality=100)

#####plot U concentrations over two years
	ymax1 = max(c(Udata_2010[,iplot]),na.rm=T)
	ymax2 = max(c(SpC_2010[,iplot]),na.rm=T)
	ymin2 = min(c(SpC_2010[,iplot]),na.rm=T)	

	plot(doy_2010,Udata_2010[,iplot],xlim=c(xmin,xmax),ylim=c(0,ymax1),xlab="", ylab="",main=well_names[iplot],type='b',pch=2,col=plot_cols[1],axes=FALSE)
	axis(side = 1, at = xticks, labels = format(xlabs,"%b-%d"),  cex.axis = 1.0)
	mtext("Dates",side=1,col="black",line=2.5)
	axis(side = 2, col = 'black',las=1,cex.axis = 1.0)
	mtext('U Conc [ug/L]',side=2,line=2.5)
	
		
	#add another axis for specific conductance

	par(new=TRUE)
	
	#yticks2 = pretty(0:max(max(true_UO2,na.rm=T)+1,50))
	plot(doy_2010, SpC_2010[,iplot], xlab="", ylab="",xlim=c(xmin,xmax),ylim=c(ymin2,ymax2),axes=FALSE, type="l",lty='dashed', col=plot_cols[3])
 
	axis(4, col="blue",col.axis="blue",line=-1)
	mtext("SpC",side=4,col="blue",line=1) 
	legend("topleft",c('U2010','SpC2010'), lty=c('solid','dashed'),pch=c(2,-1),col=c(plot_cols[1],plot_cols[3]),cex=1.2, bty='n')

	dev.off()
	
	
	#U versus H 
	jpeg(paste('TimeSeries_UH_2010_',well_names[iplot],plot_ext,sep=''), width = 15, height = 10,units="in",res=200,quality=100)
    split.screen(rbind(c(0.03, 0.8,0.1, 0.98), c(0.81,0.98, 0.1, 0.98)))

	screen(1)
	#####plot U concentrations over two years
	ymax_H = max(c(Hdata_2010),na.rm=T)
	ymin_H = min(c(Hdata_2010),na.rm=T)	
	ymin_H = 103
	ymax_H = 109
	WL_min = ymin_H
	WL_max = ymax_H
	
	plot(doy_2010,Udata_2010[,iplot],xlim=c(xmin,xmax),ylim=c(0,ymax1),xlab="", ylab="",main=well_names[iplot],type='b',pch=2,col=plot_cols[1],axes=FALSE)
	axis(side = 1, at = xticks, labels = format(xlabs,"%b-%d"),  cex.axis = 1.0)
	mtext("Dates",side=1,col="black",line=2.5)
	axis(side = 2, col = 'black',las=1,cex.axis = 1.0)
	mtext('U Conc [ug/L]',side=2,line=2.5)
	#add another axis for water levels

	par(new=TRUE)
	
	#yticks2 = pretty(0:max(max(true_UO2,na.rm=T)+1,50))
	plot(doy_2010, Hdata_2010, xlab="", ylab="",xlim=c(xmin,xmax),ylim=c(ymin_H,ymax_H),axes=FALSE, type="l",lty='dashed', col=plot_cols[3])
	axis(4, col="blue",col.axis="blue",line=-1)
	mtext("Elevations[m]",side=4,col="blue",line=1) 
	legend("topleft",c('U2010','WL2010'), lty=c('solid','dashed'),pch=c(2,-1),col = c(plot_cols[1],plot_cols[3]),cex=1.2, bty='n')	
	
	screen(2)
	#plot BEU profiles when available
	
	#columns are wells,	y,x,TopDepth(ft),BotDepth(ft),Lithofacies
	lithodata = matrix(NA,1,3)
	ik.litho = grep(well_names[iplot],Litho_data[,1])
	if(length(ik.litho) > 0)
	{
		lithodata = matrix(0,length(ik.litho),3)
		lithodata[,1] = Litho_data[ik.litho,4]
		lithodata[,2] = Litho_data[ik.litho,5]
		lithodata[,3] = Litho_data[ik.litho,6]
		litho_loc = BEU_max - 1.5
		plot(y_BEU[,iplot],x_BEU[,iplot],xlim=c(0,BEU_max),ylim=c(WL_min,WL_max),type='b',pch=1,col="Chocolate",ylab = '',xlab='BEU[ug/g]',main=well_names[iplot],bty='n')
		for (kk in 1:length(ik.litho))
		{
			rect(litho_loc,lithodata[kk,2],litho_loc+1.5,lithodata[kk,1],border='DarkGreen')
			text(litho_loc+0.5,0.5*(lithodata[kk,1]+max(lithodata[kk,2],WL_min+0.5)),Litho_data[ik.litho[kk],6])
		}
		
	}
	else
		plot(y_BEU[,iplot],x_BEU[,iplot],xlim=c(0,BEU_max),ylim=c(WL_min,WL_max),type='b',pch=1,col="Chocolate",ylab = '',xlab='BEU[ug/g]',main=well_names[iplot])

	close.screen(all.screens = TRUE)
	dev.off()
}



