angle = 15/180*pi

###400*400
td_origin = c(594186,115943)
##T3 slice
t3_origin = c(594378.6,116216.3)
##T4 slice
t4_origin = c(594386.880635513,116185.502270774)
model_origin = td_origin


dx = c(rev(round(0.5*1.09919838^seq(1,44),3)),rep(0.5,(400-350)/0.5))
dy = rep(2,400/2)
dz = c(rev(round(0.1*1.09505^seq(1,25),3)),rep(0.1,(108-100)/0.1),round(0.1*1.097^seq(1,11),3))


nx = length(dx)
ny = length(dy)
nz = length(dz)

x = cumsum(dx)-0.5*dx
y = cumsum(dy)-0.5*dy
z = 90+cumsum(dz)-0.5*dz



range_x = c(x[1]-0.5*dx[1],x[length(x)]+0.5*dx[length(x)])
range_y = c(y[1]-0.5*dy[1],y[length(y)]+0.5*dy[length(y)])
range_z = c(z[1]-0.5*dz[1],z[length(z)]+0.5*dz[length(z)])

at_model = rbind(c(range_x[1],range_y[1]),
                 c(range_x[1],range_y[2]),
                 c(range_x[2],range_y[2]),
                 c(range_x[2],range_y[1])         
                 )


at_project = model_to_proj(model_origin,angle,at_model)

bd_model = rbind(c(0,0),
                 c(0,400),
                 c(400,400),
                 c(400,0)         
                 )
bd_project = model_to_proj(model_origin,angle,bd_model)

sd_model = rbind(c(-450,-800),
                 c(-450,800),
                 c(450,800),
                 c(450,-800)         
                 )
sd_project = model_to_proj(model_origin,angle,sd_model)





## dx = c(rev(round(0.5*1.0999674^seq(1,31),3)),rep(0.5,(380-350)/0.5),round(0.5*1.08925^seq(1,17),3))
## dy = c(rev(round(1*1.0997085^seq(1,18),3)),rep(1,(300-200)/1),round(1*1.0997085^seq(1,18),3))
## dz = c(rev(round(0.1*1.09505^seq(1,25),3)),rep(0.1,(110-100)/0.1))
## sum(c(rev(round(0.5*1.0999674^seq(1,53),3)),rep(0.5,(380-350)/0.5),round(0.5*1.08925^seq(1,17),3)))
## c(rev(round(1*1.0975532^seq(1,41),3)),rev(round(1*1.09843667^seq(1,48),3)))
## dy = c(rev(round(1*1.0975532^seq(1,41),3)),rep(1,(300-200)/1),round(1*1.09843667^seq(1,48),3))
## dx = c(rev(round(0.5*1.09919838^seq(1,44),3)),rep(0.5,(380-350)/0.5),round(0.5*1.08925^seq(1,17),3))
## dy = rep(2,400/2)
## dz = c(rev(round(0.1*1.09505^seq(1,25),3)),rep(0.1,(110-100)/0.1))

