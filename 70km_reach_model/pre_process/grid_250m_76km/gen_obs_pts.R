
setwd("/Users/shua784/Dropbox/PNNL/Projects/300A/")

##generate well obs input deck in Pflotran
# grid.n_pts = c(475, 825, 40)
grid.n_pts = c(475, 825, 44)
grid.d_pts = c(4.0,  4.0,  0.5)

x0 = 593000
y0 = 114500
# z0 = 90
z0 = 88

# tkness = 20
tkness = 22

a = 0 #rotation

#----------------INPUT--------------------------#
fname_WellScreen = "data/Monitoring_Well_Screen_bigdomain.csv"

#-----------------OUTPUT--------------------------#
fname_well_obs_region = "data/well_obs_region.txt"
#-----------------------------------------------------
# Well locations in the model field
#-----------------------------------------------------
# [wells x y elev screen_top screen_bot] = textread('input_files_anchor/obs_wells_mar2011.txt','%s %f %f %f %f %f');
# [Coord,~,~] = xlsread('C:\Users\shua784\Desktop\PNNL project\assign well screen\Monitoring_Well_Screen_bigdomain.xlsx');
# [~,~,ID] = xlsread('C:\Users\shua784\Desktop\PNNL project\assign well screen\Monitoring_Well_Screen_bigdomain.xlsx');

#read well screen info
Well = read.csv(fname_WellScreen, header = TRUE, stringsAsFactors=FALSE)
rownames(Well) = Well[,1]
Well = as.matrix(Well[,2:6])

x=Well[,1]
y=Well[,2]
elev=Well[,3]
screen_top=Well[,4]
screen_bot=Well[,5]


x = x-x0
y = y-y0
xx=x*cos(a)+y*sin(a)
yy=y*cos(a)-x*sin(a)
data=c(xx,yy)

nwell = length(x);
# screen_top = elev - screen_top;
# screen_bot = elev - screen_bot;
#%%%%------------------------------------------------------
# %Indices of cells in each well
# %%%%------------------------------------------------------
# cells_z = ((z0+0.5*grid.d_pts[3]):grid.d_pts[3]:(z0+grid.n_pts[3]*grid.d_pts[3]))
cells_z = seq((z0+0.5*grid.d_pts[3]), (z0+grid.n_pts[3]*grid.d_pts[3]), grid.d_pts[3])

n_obs = nwell;
# % the coordinates of the observation points
# %put observation wells in "regions" of input deck

sink(fname_well_obs_region)


for (i in 1:n_obs) {
  
  if (screen_top[i] >= z0 & screen_bot[i] <= z0+tkness) {
  z = cells_z[which((cells_z >= screen_bot[i]) & (cells_z <= screen_top[i]))]
  nz = length(z)
  wellname = rownames(Well)[i]
    for (j in 1:nz) {
      cat(paste('REGION Well_', wellname, '_', j, sep = ''))
      cat('\n')
      cat('  COORDINATE ');
      cat(xx[i],yy[i], z[j])
      cat('\n')
      cat('/')
      cat('\n')
      cat('\n')
    }
  }
}

# % putting in "observation points" in input deck


for (i in 1:n_obs){
  
  if (screen_top[i] >= z0 & screen_bot[i] <= z0+tkness) {
  z = cells_z[which(cells_z >= screen_bot[i] & (cells_z <= screen_top[i]))]
  nz = length(z);
  wellname = rownames(Well)[i]
    for (j in 1:nz){
 
      cat('OBSERVATION')
      cat('\n')
      cat(paste('  REGION Well_', wellname, '_', j, sep = ''))
      cat('\n')
      cat('  VELOCITY ')
      cat('\n')
      cat('/')
      cat('\n')
      cat('\n')
    }
  }
}

sink()