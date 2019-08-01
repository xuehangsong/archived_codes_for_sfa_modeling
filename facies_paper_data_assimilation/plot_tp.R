rm(list=ls())

tp_x = read.table("tprogs/tp_x.eas",skip=12)
tp_x_m = read.table("tprogs/tp_x_m.eas",skip=12)

tp_y = read.table("tprogs/tp_y.eas",skip=12)
tp_y_m = read.table("tprogs/tp_y_m.eas",skip=12)

tp_z = read.table("tprogs/tp_z.eas",skip=12)
#tp_z_m = read.table("tprogs/tp_z_m.eas",skip=12)

## nplots = 9
## par(mfrow=c(3,3))
## for (iplot in 1:nplots)
## {
##     plot(tp_x[,1],tp_x[,1+iplot],ylim=c(0,1),xlim=c(1,120))
##     lines(tp_x_m[,1],tp_x_m[,1+iplot])
## }


nplots = 9
par(mfrow=c(3,3))
for (iplot in 1:nplots)
{
    plot(tp_z[,1],tp_z[,1+iplot],ylim=c(0,1))
#    lines(tp_z_m[,1],tp_z_m[,1+iplot])
}
