rm(list=ls())
load("wells.r")
solute.name = "Total_Tracer [M]"
real.start.time = as.POSIXct("2010-01-01 00:00:00",tz="GMT")
dt = 3600
times = real.start.time+dt*(1:ntime-1)
years = c(2010)


well.solute = array(NA,c(ntime,length(well.list)))
colnames(well.solute) = well.list
rownames(well.solute) = as.character(times)

for (iwell in well.list)
{
    print(iwell)
    vec.xy = rep(0,ntime)
    vec.sum = rep(0,ntime)
    solute_vec.sum = rep(0,ntime)
    for (inode in 1:nrow(simu.node[[iwell]]))
    {
        vec.xy =  (simu.results[[iwell]][[inode]][,"Liquid X-Velocity [m_per_h]"]^2+
                                                                                  simu.results[[iwell]][[inode]][,"Liquid Y-Velocity [m_per_h]"]^2)^0.5
        vec.sum = vec.xy+vec.sum
        solute_vec.sum = vec.xy*simu.results[[iwell]][[inode]][,solute.name]+solute_vec.sum
    }

    well.solute[,iwell] = solute_vec.sum/vec.sum

}

for (iwell in well.list)
{
    for (iyear in years)
    {
        year.start = as.POSIXct(paste(iyear-1,"-10-01 00:00:00",sep=""),tz="GMT")
        year.end = as.POSIXct(paste(iyear,"-09-30 23:00:00",sep=""),tz="GMT")
        print.time = as.character(seq.POSIXt(year.start,year.end,by=3600))

        year.solute = array(NA,c(length(print.time),1))
        rownames(year.solute) = print.time

        avaible.data = intersect(print.time,as.character(times))
            
        year.solute[avaible.data,] = well.solute[avaible.data,iwell]


        write.csv(year.solute,file=paste("wells/",iyear,"/",iwell,".csv",sep=""))
    }
}
save(list=ls(),file="flux.average.r")
