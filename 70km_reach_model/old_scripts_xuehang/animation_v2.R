rm(list=ls())


fig.dir = paste("/Users/song884/remote/reach/figures/",
                "HFR_200x200x2_6h_bc/",sep="")


start.time = as.POSIXct("2011-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
end.time = as.POSIXct("2016-01-01 00:00:00",tz="GMT",format="%Y-%m-%d %H:%M:%S")
times = seq(start.time,end.time,3600*120)



dirs = c("wl",
         "mass_balance",
         "mass_block_north",
         "mass_block_south",
         "mass_block_middle")

## dirs = c(
##          "mass_balance",
##          "mass_block_north",
##          "mass_block_south",
##          "mass_block_middle")

#dirs = c("wl")


for (i.dir in dirs)
{
    all.fig = c()
    for (i.index in 1:length(times))        
    {
        itime = times[i.index]
        print(itime)
        ori.fig = paste(fig.dir,i.dir,"/",
                        format(itime,"%Y-%m-%d %H:%M:%S"),
                        ".png",sep="")
        if(!file.exists(ori.fig))
        {
            ori.fig = paste(fig.dir,i.dir,"/",
                            format(itime,"%Y-%m-%d %H:%M:%S"),                            
                            ".jpg",sep="")
        }
        
        small.fig = paste("'",fig.dir,i.dir,"/resize",
                            format(itime,"%Y-%m-%d %H:%M:%S"),                            
                          ".png'",sep="")
        ori.fig = paste("'",ori.fig,"'",sep="")
        
        system(paste("convert -resize 20%",ori.fig,small.fig))
        all.fig = c(all.fig, small.fig)

    }

    system(paste("convert -delay 1 -loop 0", paste(all.fig,collapse=" "),
                 paste(fig.dir,i.dir,"/animation.gif",sep="")))
}
