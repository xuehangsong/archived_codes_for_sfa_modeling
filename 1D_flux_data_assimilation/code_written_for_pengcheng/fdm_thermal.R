rm(list=ls())

### Thermal properities
para.p_w = 1000     # Density of water
para.c_w = 4180     # Mass heat capacity of water
para.p_s = 2650     # Density of sediments (solid)
para.c_s = 920      # Mass heat capacity of sediments (solid)
para.theta = 0.43   # Porosity
para.k_thermal = 0.9334 # Thermal conductivity of wet material

### Spatial and Temporal Discretization
para.zm = 0.64      # column length
para.tm = 90000   # maximum time
para.nz = 101       # node number
para.dt = 60       # output time step
para.dz = para.zm/(para.nz-1) # grid size

### Temperature observations
fname = "fdm_data/obs.csv"
flux_file = read.table(fname,sep=',',check.names=FALSE,header=TRUE)
ntime = nrow(flux_file)
nobs = ncol(flux_file)-1
obs.time = as.numeric(difftime(flux_file[,1],flux_file[1,1],units="secs"))
obs.value = flux_file[,1:nobs+1]
obs.loc = as.numeric(colnames(flux_file)[1:nobs+1])

### uniform Flux
flux.time = obs.time
flux.value = 0.1*rep(1,ntime)

### caculate bulk heat capacity
para.pwcw = para.p_w*para.c_w
para.pc = (1-para.theta)*para.p_s*para.c_s+para.theta*para.p_w*para.c_w

### caculate PDE coeffient
para.a = -flux.value*para.pwcw/para.pc
para.b = para.k_thermal/para.pc

### time and spatial discretization
z = seq(0,para.zm,length.out=para.nz)
t = seq(0,para.tm,para.dt)
nt = length(t)

y0= approx(obs.loc,obs.value[1,],z[2:(para.nz-1)],'linear',rule=2)[[2]];
y0 = seq(obs.value[1,1],obs.value[1,nobs],length.out=para.nz)[2:(para.nz-1)]

T_matrix = array(0,c(nt,para.nz))
T_matrix[,1] = approx(obs.time,obs.value[,1],t,'linear',rule=2)[[2]]
T_matrix[,para.nz] = approx(obs.time,obs.value[,nobs],t,'linear',rule=2)[[2]]
T_matrix[1,2:(para.nz-1)] = y0


y = y0
for (it in 2:nt)

{
    a_interp = approx(flux.time,para.a,t[it],'linear',rule=2)[[2]]
    f1 = approx(obs.time,obs.value[,1],t[it],'linear',rule=2)[[2]]
    f2 = approx(obs.time,obs.value[,nobs],t[it],'linear',rule=2)[[2]]

    A = diag(para.nz-2)*(-2*para.b/para.dz^2)
    A[seq(2,length(A),para.nz-1)] = para.b/para.dz^2-0.5*a_interp/para.dz
    A[seq(para.nz-1,length(A),para.nz-1)] = para.b/para.dz^2+0.5*a_interp/para.dz

    B = rep(0,para.nz-2)
    B[1] = (para.b/para.dz^2-0.5*a_interp/para.dz)*f1;
    B[para.nz-2] = (para.b/para.dz^2+0.5*a_interp/para.dz)*f2;

    y = y+para.dt*(A %*% y+B)

    T_matrix[it,2:(para.nz-1)] = y
}


