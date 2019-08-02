rm(list=ls())

fig.dir = "/Users/song884/remote/reach/figures/river_flux/"
new.dir = "/Users/song884/remote/reach/figures/cflux/"

times = as.numeric(gsub("_stage.jpg","",(list.files(fig.dir,"_stage.jpg"))))
times = sort(times)

selected.times = c(238,
                  255,
                  308,
                  328,
                  386,
                  407,
                  450,
                  476,
                  527,
                  550,
                  580,
                  622)
for (itime in selected.times)
{

    i.fig = paste(fig.dir,"combined_",sprintf("%6.5E",times[itime]),".jpg",sep="")
    new.fig = paste(new.dir,"flux_level_",itime,".jpg",sep="")
    print(i.fig)
    system(paste("cp",i.fig,new.fig))

}
