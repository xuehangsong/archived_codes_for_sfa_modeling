
#This file is used to analyze passive experimental data in 2010 and 2011 at Hanford IFRC 

rm(list=ls())
library(fields)
include_inj = TRUE

path_prefix = '../Mar2011/TrueData_Mar2011TT/'
data = read.table('Data_Passive_2009_2010_2011_2012.txt',skip=1) # the columns are: year, date,water level,specific conductance,U2-26,U3-30,azimuth,gradient
idx_2010 = which(data[,1] == 2010)
idx_2011 = which(data[,1] == 2011)
idx_2012 = which(data[,1] == 2012)
idx_2009 = which(data[,1] == 2009)

dates_2009 = as.Date(1:length(idx_2009),origin='2010-03-30')
dates_2010 = as.Date(1:length(idx_2010),origin='2010-04-30')
dates_2011 = as.Date(1:length(idx_2011),origin='2010-03-24')
dates_2012 = as.Date(1:length(idx_2012),origin='2010-03-26')
doy_2010 = seq(1,length(idx_2010)) + 120
doy_2011 = seq(1,length(idx_2011)) + 83
doy_2012 = seq(1,length(idx_2012)) + 86
doy_2009 = seq(1,length(idx_2009)) + 89

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

#plot U in 2-26 and 3-30 vs water level, specific conductance,azimuth, and gradient
if(TRUE)
{
plot_titles = rep(c('2-26','3-30','2-29'),each=2)
ids_xcol = c(3,4,3,5,3,6) #indices of columns used for x-axis
x_labels = rep(c('Water Level (m)', 'Specific Cond'),times=3)
ids_ycol = rep(c(7,8,9),each=2) #indices of columns used for y-axis
y_labels = rep(' U [ug/L]', times = length(ids_ycol))

plot_legends = c('2012','2011','2010','2009')
plot_cols = c('darkgreen','red','blue','black')
plot_pchs = c(1,2,3,4)

nplot_row = 3
nplot_col = 2
jpeg(paste('Data_plots_lines_4years',plot_ext,sep=''), width = nplot_col * 10, height = nplot_row * 10,units="in",res=200,quality=100)
par(mfrow=c(nplot_row,nplot_col),mar=c(4,4,4,4)+0.1)
for(iplot in 1:(nplot_row*nplot_col)){
	x_min = min(data[,ids_xcol[iplot]],na.rm=T)
	x_max = max(data[,ids_xcol[iplot]],na.rm=T)
	y_min = min(data[,ids_ycol[iplot]],na.rm=T)
	y_max = max(data[,ids_ycol[iplot]],na.rm=T)	
		
	irow = iplot %/% 2
	icol = iplot %% 2
	data_2010 = na.omit(data[idx_2010,c(ids_xcol[iplot],	ids_ycol[iplot])]) 
	data_2011 = na.omit(data[idx_2011,c(ids_xcol[iplot],	ids_ycol[iplot])]) 
	data_2012 = na.omit(data[idx_2012,c(ids_xcol[iplot],	ids_ycol[iplot])]) 
	data_2009 = na.omit(data[idx_2009,c(ids_xcol[iplot],	ids_ycol[iplot])]) 		
	plot(data_2012[,1],data_2012[,2],type='l',lty=1,col=plot_cols[1],main = plot_titles[iplot],xlim=c(x_min,x_max),ylim=c(y_min,y_max),xlab = x_labels[iplot],ylab=y_labels[iplot])
	points(data_2011[,1],data_2011[,2],type='l',lty=1,col=plot_cols[2])
	points(data_2010[,1],data_2010[,2],type='l',lty=1,col=plot_cols[3])
	points(data_2009[,1],data_2009[,2],type='l',lty=1,col=plot_cols[4])
	# show the beginning and end of data 
	if(icol<=2)
	{
		text(data_2012[1,1],data_2012[1,2],'2012start',col=plot_cols[1],cex=1.5)
		text(data_2012[nrow(data_2012),1],data_2012[nrow(data_2012),2],'2012end',col=plot_cols[1],cex=1.5)
		text(data_2011[1,1],data_2011[1,2],'2011start',col=plot_cols[2],cex=1.5)
		text(data_2011[nrow(data_2011),1],data_2011[nrow(data_2011),2],'2011end',col=plot_cols[2],cex=1.5)
		text(data_2010[1,1],data_2010[1,2],'2010start',col=plot_cols[3],cex=1.5)
		text(data_2010[nrow(data_2010),1],data_2010[nrow(data_2010),2],'2010end',col=plot_cols[3],cex=1.5)		
		text(data_2009[1,1],data_2009[1,2],'2009start',col=plot_cols[4],cex=1.5)
		text(data_2009[nrow(data_2009),1],data_2009[nrow(data_2011),2],'2009end',col=plot_cols[4],cex=1.5)
	}

	#for U vs water elevation plot, add in a second axis for BEU profiles 
	if(iplot%%2==0)
	{
		par(new=TRUE)
#			yticks2 = pretty(0:(max(y_BEU[,irow],na.rm=T)+0.5))
		y2_max = max(y_BEU,na.rm=T)
		yticks2 = pretty(0:(y2_max+0.5))
		plot(x_BEU[,irow], y_BEU[,irow], xlab="", ylab="",xlim=c(x_min,x_max),ylim=c(-0.5,y2_max+0.1),axes=FALSE, type="b",pch=3, col="chocolate")
		## a little farther out (line=4) to make room for labels
		mtext("BEU [ug/g]",side=4,col="chocolate",line=2.5) 
		axis(4, col="chocolate",col.axis="chocolate",las=1,at=yticks2)
	}
	#legend("bottomright",plot_legends, lty=c(1,1),col=plot_cols,cex=2.5, bty='n')
}
dev.off()
}

if(FALSE)
{

jpeg(paste('Data_plots_points_4years',plot_ext,sep=''), width = nplot_col * 10, height = nplot_row * 10,units="in",res=200,quality=100)
par(mfrow=c(nplot_row,nplot_col),mar=c(4,4,4,4)+0.1)
for(irow in 1:nplot_row){
	for(icol in 1:nplot_col){
		x_min = min(data[,ids_xcol[icol]],na.rm=T)
		x_max = max(data[,ids_xcol[icol]],na.rm=T)
		y_min = min(data[,ids_ycol[irow]],na.rm=T)
		y_max = max(data[,ids_ycol[irow]],na.rm=T)	
		data_2010 = na.omit(data[idx_2010,c(ids_xcol[icol],	ids_ycol[irow])]) 
		data_2011 = na.omit(data[idx_2011,c(ids_xcol[icol],	ids_ycol[irow])]) 
		data_2012 = na.omit(data[idx_2012,c(ids_xcol[icol],	ids_ycol[irow])]) 
		data_2009 = na.omit(data[idx_2009,c(ids_xcol[icol],	ids_ycol[irow])]) 		
		plot(data_2012[,1],data_2012[,2],pch=plot_pchs[1],col=plot_cols[1],main = plot_titles[irow],xlim=c(x_min,x_max),ylim=c(y_min,y_max),xlab = x_labels[icol],ylab=y_labels[irow])
		points(data_2011[,1],data_2011[,2],pch=plot_pchs[2],col=plot_cols[2])
		points(data_2010[,1],data_2010[,2],pch=plot_pchs[3],col=plot_cols[3])
		points(data_2009[,1],data_2009[,2],pch=plot_pchs[4],col=plot_cols[4])

		# show the start and end of data series
		if(icol<=2)
		{
			text(data_2012[1,1],data_2012[1,2],'2012start',col=plot_cols[1],cex=1.5)
			text(data_2012[nrow(data_2012),1],data_2012[nrow(data_2012),2],'2012end',col=plot_cols[1],cex=1.5)
			text(data_2011[1,1],data_2011[1,2],'2011start',col=plot_cols[2],cex=1.5)
			text(data_2011[nrow(data_2011),1],data_2011[nrow(data_2011),2],'2011end',col=plot_cols[2],cex=1.5)
			text(data_2010[1,1],data_2010[1,2],'2010start',col=plot_cols[3],cex=1.5)
			text(data_2010[nrow(data_2010),1],data_2010[nrow(data_2010),2],'2010end',col=plot_cols[3],cex=1.5)		
			text(data_2009[1,1],data_2009[1,2],'2009start',col=plot_cols[4],cex=1.5)
			text(data_2009[nrow(data_2009),1],data_2009[nrow(data_2011),2],'2009end',col=plot_cols[4],cex=1.5)
		}
		#for U vs water elevation plot, add in a second axis for BEU profiles 
		if(icol==1)
		{
			par(new=TRUE)
			y2_max = max(y_BEU,na.rm=T)
			yticks2 = pretty(0:(y2_max+0.5))
#			yticks2 = pretty(0:(max(y_BEU[,irow],na.rm=T)+0.5))
			plot(x_BEU[,irow], y_BEU[,irow], xlab="", ylab="",xlim=c(x_min,x_max),ylim=c(-0.5,y2_max+0.1),axes=FALSE, type="b",pch=3, col="chocolate")
			## a little farther out (line=4) to make room for labels
			mtext("BEU [ug/g]",side=4,col="chocolate",line=2.5) 
			axis(4, col="chocolate",col.axis="chocolate",las=1,at=yticks2)
		}

	}
	#legend("bottomright",plot_legends, pch = plot_pchs,col=plot_cols,cex=2.5, bty='n')
}
dev.off()
}

if(FALSE)
{


#plot Specific cunductance vs water level

jpeg(paste('SpecCond_WL_U',plot_ext,sep=''), width = 15, height = 15,units="in",res=200,quality=100)
par(mfrow=c(3,4))
data_temp=na.omit(data[c(idx_2010,idx_2011),3:6])
temp<- as.image( data_temp[,3], x= data_temp[,c(1,2)],nrow=50, ncol=50)
image.plot(temp,main='2-26',xlab="Elevation[m]",ylab = "Specific Cond")

temp<- as.image( data_temp[,4], x= data_temp[,c(1,2)], nrow=50, ncol=50)
image.plot(temp,main='3-30',xlab="Elevation[m]",ylab = "Specific Cond")

x_min = min(data[,3],na.rm=T)
x_max = max(data[,3],na.rm=T)
y_min = min(data[,4],na.rm=T)
y_max = max(data[,4],na.rm=T)
plot(data[idx_2011,3],data[idx_2011,4],xlim=c(x_min,x_max),ylim=c(y_min,y_max),pch=plot_pchs[1],col=plot_cols[1],ylab = 'Specifc Conduc',xlab='Water Level (m)')
points(data[idx_2010,3],data[idx_2010,4],pch=plot_pchs[2],col=plot_cols[2])
legend("bottomleft",plot_legends, pch = plot_pchs,col=plot_cols,cex=1.5, bty='n')

dev.off()
}
#time series plots


####for U concentration over four years for three wells #############
Udata_2009 = data[idx_2009,7:9]
Udata_2010 = data[idx_2010,7:9] 
Udata_2011 = data[idx_2011,7:9]
Udata_2012 = data[idx_2012,7:9]

SpC_2009 = data[idx_2009,4:6]
SpC_2010 = data[idx_2010,4:6] 
SpC_2011 = data[idx_2011,4:6]
SpC_2012 = data[idx_2012,4:6]

Hdata_2009 = data[idx_2009,3]
Hdata_2010 = data[idx_2010,3]
Hdata_2011 = data[idx_2011,3] 
Hdata_2012 = data[idx_2012,3]
xmin = min(c(doy_2011,doy_2010,doy_2009,doy_2012))
xmax = max(c(doy_2011,doy_2010,doy_2009,doy_2012))
xticks = seq(xmin,xmax,10)
xlabs = as.Date(xticks+1,origin='2010-01-01')
	
jpeg(paste('TimeSeries_UH_4years',plot_ext,sep=''), width = 20, height = 20,units="in",res=200,quality=100)
split.screen(rbind(c(0.03, 0.8,0.1, 0.98), c(0.81,0.98, 0.1, 0.98)))

split.screen(c(3,1), screen = 1)
split.screen(c(3,1), screen = 2)

for(iplot in 1:3){
	screen(iplot+2)
	#####plot U concentrations over two years
	ymax1 = max(c(Udata_2011[,iplot],Udata_2010[,iplot],Udata_2012[,iplot],Udata_2009[,iplot]),na.rm=T)
	ymax2 = max(c(Hdata_2011,Hdata_2010,Hdata_2012,Hdata_2009),na.rm=T)
	ymin2 = min(c(Hdata_2011,Hdata_2010,Hdata_2012,Hdata_2009),na.rm=T)	
	ymin2 = 103
	ymax2 = 109
	WL_min = ymin2
	WL_max = ymax2
	nonna_2012 = which(is.na(Udata_2012[,iplot])==0)
	plot(doy_2012[nonna_2012],Udata_2012[nonna_2012,iplot],xlim=c(xmin,xmax),ylim=c(0,ymax1),xlab="", ylab="",main=well_names[iplot],type='b',pch=2,col=plot_cols[1],axes=FALSE)
	lines(doy_2011,Udata_2011[,iplot],type='b',pch=2,col=plot_cols[2])
	lines(doy_2010,Udata_2010[,iplot],type='b',pch=2,col=plot_cols[3])
	lines(doy_2009,Udata_2009[,iplot],type='b',pch=2,col=plot_cols[4])
	axis(side = 1, at = xticks, labels = format(xlabs,"%b-%d"),  cex.axis = 1.0)
	mtext("Dates",side=1,col="black",line=2.5)
	axis(side = 2, col = 'black',las=1,cex.axis = 1.0)
	mtext('U Conc [ug/L]',side=2,line=2.5)
	#add another axis for water levels

	par(new=TRUE)
	
	#yticks2 = pretty(0:max(max(true_UO2,na.rm=T)+1,50))
	plot(doy_2012, Hdata_2012, xlab="", ylab="",xlim=c(xmin,xmax),ylim=c(ymin2,ymax2),axes=FALSE, type="l",lty='dashed', col=plot_cols[1])
	lines(doy_2011, Hdata_2011,type='l',lty='dashed',pch=2,col = plot_cols[2])	
	lines(doy_2010, Hdata_2010,type='l',lty='dashed',pch=2,col = plot_cols[3])	
	lines(doy_2009, Hdata_2009,type='l',lty='dashed',pch=2,col = plot_cols[4])	
 
	axis(4, col="blue",col.axis="blue",line=-1)
	mtext("Elevations[m]",side=4,col="blue",line=1) 
	if(iplot==3)
		legend("topleft",c('U2012','U2011','U2010','U2009','WL2012','WL2011','WL2010','WL2009'), lty=c('solid','solid','solid','solid','dashed','dashed','dashed','dashed'),pch=c(2,2,2,2,-1,-1,-1,-1),col=rep(plot_cols,times=2),cex=1.2, bty='n')	
	screen(iplot+5)
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

	
}
close.screen(all.screens = TRUE)

#put BEU plot 
dev.off()

jpeg(paste('TimeSeries_USpC_4years',plot_ext,sep=''), width = 15, height = 20,units="in",res=200,quality=100)
par(mfrow=c(3,1))

for(iplot in 1:3){
	#####plot U concentrations over two years
	ymax1 = max(c(Udata_2011[,iplot],Udata_2010[,iplot],Udata_2012[,iplot],Udata_2009[,iplot]),na.rm=T)
	ymax2 = max(c(SpC_2011[,iplot],SpC_2010[,iplot],SpC_2012[,iplot],SpC_2009[,iplot]),na.rm=T)
	ymin2 = min(c(SpC_2011[,iplot],SpC_2010[,iplot],SpC_2012[,iplot],SpC_2009[,iplot]),na.rm=T)	
	nonna_2012 = which(is.na(Udata_2012[,iplot])==0)
	plot(doy_2012[nonna_2012],Udata_2012[nonna_2012,iplot],xlim=c(xmin,xmax),ylim=c(0,ymax1),xlab="", ylab="",main=well_names[iplot],type='b',pch=2,col=plot_cols[1],axes=FALSE)
	lines(doy_2011,Udata_2011[,iplot],type='b',pch=2,col=plot_cols[2])
	lines(doy_2010,Udata_2010[,iplot],type='b',pch=2,col=plot_cols[3])
	lines(doy_2009,Udata_2009[,iplot],type='b',pch=2,col=plot_cols[4])
	axis(side = 1, at = xticks, labels = format(xlabs,"%b-%d"),  cex.axis = 1.0)
	mtext("Dates",side=1,col="black",line=2.5)
	axis(side = 2, col = 'black',las=1,cex.axis = 1.0)
	mtext('U Conc [ug/L]',side=2,line=2.5)
	
		
	#add another axis for specific conductance

	par(new=TRUE)
	
	#yticks2 = pretty(0:max(max(true_UO2,na.rm=T)+1,50))
	nonna_2012 = which(is.na(SpC_2012[,iplot])==0)
	plot(doy_2012[nonna_2012], SpC_2012[nonna_2012,iplot], xlab="", ylab="",xlim=c(xmin,xmax),ylim=c(ymin2,ymax2),axes=FALSE, type="l",lty='dashed', col=plot_cols[1])
	lines(doy_2011, SpC_2011[,iplot],type='l',lty='dashed',pch=2,col = plot_cols[2])	
	lines(doy_2010, SpC_2010[,iplot],type='l',lty='dashed',pch=2,col = plot_cols[3])	
	lines(doy_2009, SpC_2009[,iplot],type='l',lty='dashed',pch=2,col = plot_cols[4])	
 
	axis(4, col="blue",col.axis="blue",line=-1)
	mtext("SpC",side=4,col="blue",line=1) 
}

#put BEU plot 
legend("topleft",c('U2012','U2011','U2010','U2009','SpC2012','SpC2011','SpC2010','SpC2009'), lty=c('solid','solid','solid','solid','dashed','dashed','dashed','dashed'),pch=c(2,2,2,2,-1,-1,-1,-1),col=rep(plot_cols,times=2),cex=1.2, bty='n')
dev.off()


