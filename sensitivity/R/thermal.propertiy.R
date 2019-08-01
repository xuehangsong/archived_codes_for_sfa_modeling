rm(list=ls())


ks = c(2.2,1.2,1.2)
kw = c(0.58,0.58,0.58)

theta.saturation = c(0.2,0.43,0.43)
residual.saturation = c(0.16,0.1299,0.1299)


k.wet = ks*(1-theta.saturation)+kw*(theta.saturation)
k.dry = ks*(1-theta.saturation)
##k.dry = ks*(1-theta.saturation)+kw*residual.saturation*(theta.saturation)
