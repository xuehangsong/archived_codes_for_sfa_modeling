## rm(list=ls())
## load("chemical.r")

for (ichemical in chemical_name)
{
    
    fname = paste("chemistry/",gsub("/", "_", ichemical),".jpg",sep="")
    sample_date = as.Date(data[which(data[,"STD_CON_LONG_NAME"]==ichemical),"SAMP_DATE_TIME"])
    jpeg(fname,units="in",width=6,height=5,quality=100,res=600)
    hist(sample_date,#breaks="years",
         breaks = seq(as.Date("1970-01-01"),
                  as.Date("2020-01-01"),
                  by = "5 years"
         ),
         freq=TRUE,
         ylim=c(0,2000),
         main = ichemical,
         xlab="year",format="%Y")
    dev.off()
}


count_data= rep(NA,length(chemical_name))
names(count_data) = chemical_name
for (ichemical in 1:length(chemical_name))
{
    count_data[ichemical] = length(which(data[,"STD_CON_LONG_NAME"]==chemical_name[ichemical]))
}

fname = paste("chemistry.jpg",sep="")
jpeg(fname,units="in",width=10,height=15,quality=100,res=600)
par(mar = c(5,15,1,2))
barplot(sort(count_data),horiz=T,las=2,xlab="Number of samples")
dev.off()



total_sample_date = c()
for (ichemical in chemical_name)
{
    sample_date = as.Date(data[which(data[,"STD_CON_LONG_NAME"]==ichemical),"SAMP_DATE_TIME"])
    total_sample_date = c(total_sample_date,as.character(sample_date))
}

total_sample_date = as.Date(total_sample_date)

fname = paste("chemistry2.jpg",sep="")
jpeg(fname,units="in",width=6,height=5,quality=100,res=600)
hist(total_sample_date,#breaks="years",
     breaks = seq(as.Date("1970-01-01"),
                  as.Date("2020-01-01"),
                  by = "5 years"
                  ),
     freq=TRUE,
     ylim=c(0,70000),
     main = "All Major Chemicals",
     xlab="year",format="%Y")
dev.off()
