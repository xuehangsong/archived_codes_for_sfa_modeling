rm(list=ls())
load("head_data.r")
start_date = as.Date(avail_wells[,5])

fname = "start_date.jpg"
jpeg(fname,units="in",width=6,height=5,quality=100,res=600)
hist(start_date,#breaks="years",
     breaks = seq(as.Date("1945-01-01"),
                  as.Date("2020-01-01"),
                  by = "5 years"
         ),
     freq=TRUE,
     ylim=c(0,1200),
     main = "First Day with Data Collection",
     xlab="year",format="%Y")
dev.off()

fname = "end_date.jpg"
jpeg(fname,units="in",width=6,height=5,quality=100,res=600)
end_date = as.Date(avail_wells[,6])
hist(end_date,#breaks="years",
     breaks = seq(as.Date("1945-01-01"),
                  as.Date("2020-01-01"),
                  by = "5 years"
         ),
     freq=TRUE,
     ylim=c(0,1200),     
     main = "Last Day with Data Collection",     
     xlab="Year",format="%Y")
dev.off()
