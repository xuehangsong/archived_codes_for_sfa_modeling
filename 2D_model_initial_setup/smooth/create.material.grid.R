rm(list = ls())
library(rhdf5)
#grid of 2d slice,0.1*0.05m
#well_02-03,x=256.7615396,y=218.3865653
west.new=0
east.new=143.2
south.new=0
north.new=1
top.new=110.0
bottom.new=90.0
nx.new=round((east.new-west.new)/0.1,0.0)
ny.new=round((north.new-south.new)/1.0,0.0)
nz.new=round((top.new-bottom.new)/0.05,0.00)
dx.new=rep(0.10,nx.new)
dy.new=rep(1.00,ny.new)
dz.new=rep(0.05,nz.new)
x.new=west.new+cumsum(dx.new)-0.5*dx.new
y.new=south.new+cumsum(dy.new)-0.5*dy.new
z.new=bottom.new+cumsum(dz.new)-0.5*dz.new

#creat new material id
material_ids.new=h5read("seed/Plume_Slice_AdaptiveRes_material.h5","Materials/Material Ids")
material_ids.new=array(material_ids.new,c(nx.new,ny.new,nz.new))
material_ids.reverse=material_ids.new
#find river.bank
river.bank=NULL


#for (iz in nz.new:2)
for (iz in 370:2)
{
        for (ix in nx.new:2)
            {
                if (((material_ids.new[ix,1,iz]-material_ids.new[ix,1,(iz-1)])==-1)||
                    ((material_ids.new[ix,1,iz]-material_ids.new[(ix-1),1,iz])==-1))
                    {
                        river.bank=rbind(river.bank,c(ix,iz))
                    }
            }
    }


nbank=dim(river.bank)[1]
river.bank[,2] = river.bank[,2][order(river.bank[,1])]-1
river.bank[,1] = sort(river.bank[,1])
save(list=ls(),file="results/material.grid.data")
