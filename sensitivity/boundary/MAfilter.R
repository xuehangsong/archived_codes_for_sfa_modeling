#########################################################
########Moveing Average for detect outlier###############
########H.Ren, 02/15#####################################

MAfilter = function(x,k,coef){
tmean = rep(NA,length(x))
tsd = rep(NA,length(x))
td = rep(NA,length(x))

for ( i in 1:length(x)) {

 if (i<(length(x)-k)) {
	tmean[i] = mean(x[(i+1):(i+k)],na.rm=T)
	tsd[i] = sd(x[(i+1):(i+k)],na.rm=T)
	check = (x[i] <= tmean[i]+coef*tsd[i])&(x[i] >= tmean[i]- coef*tsd[i])	
	if(is.na(check)){
	next
	}else if (check==FALSE){
	#print(paste(i,tmean[i]+coef*tsd[i],x[i],tmean[i]-coef*tsd[i]))

		td[i] = x[i]
		x[i]=NA
	}
			
 }else{
	tmean[i] = mean(x[(i+1):length(x)],na.rm=T)
	tsd[i] = sd(x[(i+1):length(x)],na.rm=T)
	tsd[length(x)] = x[length(x)]
 	check = (x[i] <= tmean[i]+coef*tsd[i])&(x[i] >= tmean[i]- coef*tsd[i])
	
	if(is.na(check)){
	next
	}else if (check==FALSE){
	#print(paste(i,tmean[i]+coef*tsd[i],x[i],tmean[i]-coef*tsd[i]))

		td[i] = x[i]
		x[i]=NA
	}

}
}
return(aa = list(rmd= td,x =x))
}