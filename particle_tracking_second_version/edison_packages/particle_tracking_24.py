import matplotlib as mpl
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import multiprocessing as mp
import h5py as h5
import numpy as np
import math
import sys
import os
import pickle
from scipy.interpolate import griddata
####import array


def def_locate_cell(iparticle):
    return ([np.argmin(abs(x-new_particles[iparticle][:,1])),
             np.argmin(abs(y-new_particles[iparticle][:,2])),
             np.argmin(abs(z-new_particles[iparticle][:,3]))])
##        print(coords)

def def_particle_tracking_steady(iparticle):
    current_t = times[itime]

    ### retrieve particle cell index               
    cell_x = particle_cells[iparticle][0]
    cell_y = particle_cells[iparticle][1]
    cell_z = particle_cells[iparticle][2]
    
    ### retrieve paricle coords
    coord_x = particles[iparticle][len(particles[iparticle])-1][1]
    coord_y = particles[iparticle][len(particles[iparticle])-1][2]
    coord_z = particles[iparticle][len(particles[iparticle])-1][3]

    ### counting time left
    rest_dt = times[itime+1]-current_t

    coord_update = []
    while rest_dt>0:   

        ## west/south/bottom face of the cell         
        x1 = x[cell_x]-1/2*dx[cell_x]
        y1 = y[cell_y]-1/2*dy[cell_y]
        z1 = z[cell_z]-1/2*dz[cell_z]

        ## east/north/top face of the cell        
        x2 = x[cell_x]+1/2*dx[cell_x]
        y2 = y[cell_y]+1/2*dy[cell_y]
        z2 = z[cell_z]+1/2*dz[cell_z]   

    
        ## darcy accross faces
        vx1 = x_darcy[cell_x][cell_y][cell_z]
        vx2 = x_darcy[cell_x+1][cell_y][cell_z]
        vy1 = y_darcy[cell_x][cell_y][cell_z]
        vy2 = y_darcy[cell_x][cell_y+1][cell_z]
        vz1 = z_darcy[cell_x][cell_y][cell_z]
        vz2 = z_darcy[cell_x][cell_y][cell_z+1]

        ## velocity accross faces
        vx1 = vx1/porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vx2 = vx2/porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vy1 = vy1/porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vy2 = vy2/porosity[str(material_ids[cell_x][cell_y][cell_z])]        
        vz1 = vz1/porosity[str(material_ids[cell_x][cell_y][cell_z])]
        vz2 = vz2/porosity[str(material_ids[cell_x][cell_y][cell_z])]         
    
        ## weighted parameter
        Ax = (vx2-vx1)/dx[cell_x]
        Ay = (vy2-vy1)/dy[cell_y]
        Az = (vz2-vz1)/dz[cell_z]
        
        ## caculate velocity in the particulal location
        vx = Ax*(coord_x-x1)+vx1
        vy = Ay*(coord_y-y1)+vy1           
        vz = Az*(coord_z-z1)+vz1   
        
        
        ## find time for particle reaching east or west face        
        if vx > 0:
            if vx1 == vx2 :
                dtx = (x2-coord_x)/vx        
            elif vx2 > 0 :
                dtx = 1/Ax*math.log(vx2/vx)
            else:
                dtx = rest_dt
        elif vx == 0:
            dtx = rest_dt
        else:
            if vx1 == vx2 :
                dtx = (x1-coord_x)/vx     
            elif vx1 < 0 : 
                dtx = 1/Ax*math.log(vx1/vx)                           
            else:
                dtx = rest_dt


        ## find time for particle reaching south or north face                   
        if vy > 0:
            if vy1 == vy2 :
                dty = (y2-coord_y)/vy
            elif vy2 > 0 :
                dty = 1/Ay*math.log(vy2/vy)
            else:
                dty = rest_dt
        elif vy == 0:
            dty = rest_dt
        else:
            if vy1 == vy2 :
                dty = (y1-coord_y)/vy     
            elif vy1 < 0 : 
                dty = 1/Ay*math.log(vy1/vy)                           
            else:
                dty = rest_dt          
 
        ## find time for particle reaching top or bottom face       
        if vz > 0:
            if vz1 == vz2 :
                dtz = (z2-coord_z)/vz
            elif vz2 > 0 :
                dtz = 1/Az*math.log(vz2/vz)
            else:
                dtz = rest_dt
        elif vz == 0:
            dtz = rest_dt
        else:
            if vz1 == vz2 :
                dtz = (z1-coord_z)/vz     
            elif vz1 < 0 : 
                dtz = 1/Az*math.log(vz1/vz)                           
            else:
                dtz = rest_dt  
                
   
    
        ### the 0.001,screen out the small dt caused by particles on cell edges             
        if dtx < min_dtstep : dtx = min_dtstep
        if dty < min_dtstep : dty = min_dtstep
        if dtz < min_dtstep : dtz = min_dtstep
 
        ## add little increment,avoid particles stuck on edge
##        dtx = dtx+min_dtstep
##        dty = dty+min_dtstep
##        dtz = dtz+min_dtstep
        
        ### find the time particle need to leave the cell 
        min_dt = min(dtx,dty,dtz,rest_dt) 
        
        ## caculate particel locations
        if Ax == 0: 
            coord_x = coord_x+vx*min_dt
        else:
##            print(Ax,min_dt,vx,"x") ### math range error may happen here
            coord_x = x1+1/Ax*(vx*math.exp(Ax*min_dt)-vx1)
        if Ay == 0:
            coord_y = coord_y+vy*min_dt  
        else:            
##            print(Ay,min_dt,vy,"y")
            coord_y = y1+1/Ay*(vy*math.exp(Ay*min_dt)-vy1) 
        if Az == 0: 
            coord_z = coord_z+vz*min_dt  
        else:
##            print(Az,min_dt,vz,"z")
            coord_z = z1+1/Az*(vz*math.exp(Az*min_dt)-vz1)           
    
    
        ### locate new cells
        cell_x = np.argmin(abs(x-coord_x))
        cell_y = np.argmin(abs(y-coord_y))
        cell_z = np.argmin(abs(z-coord_z))   
  
        ## udpate t
        current_t = current_t+min_dt
        rest_dt = times[itime+1]-current_t
        
        ## store path
        coord_update.append([current_t,coord_x,coord_y,coord_z]) 
        
        ## judge if particle in water or out of domain,teminate if so.
        particle_lost = [material_ids[cell_x][cell_y][cell_z] == 0,
                         coord_x > ex,
                         coord_x < ox,
                         coord_y > ey,
                         coord_y < oy,                                   
                         coord_z > ez,
                         coord_z < oz,
                         saturation[cell_x][cell_y][cell_z] < 1
                ]
        ## particle is dead.
        if any(particle_lost):           
            return {"coord_update":coord_update,
                    "cell_update":[cell_x,cell_y,cell_z],
                    "particle_status":0} 

    ##healthy particle             
    return {"coord_update":coord_update,
            "cell_update":[cell_x,cell_y,cell_z],
            "particle_status":1}


def def_release_particle_from_river_bed (river_particle_dy,river_particle_dz): 
    ##find y coords for release particles
    river_particle_ny = int((ey-oy)//river_particle_dy)
    river_particle_dy = [river_particle_dy]*river_particle_ny
    river_particle_y = np.cumsum(river_particle_dy)+oy-1/2*river_particle_dy[0]
    river_particle_y_index = [0]*river_particle_ny                                            
    for iy in range(river_particle_ny):
        river_particle_y_index[iy] = np.argmin(abs(y-river_particle_y[iy]))
 

    river_particle_nz = int((ez-oz)//river_particle_dz)
    river_particle_dz = [river_particle_dz]*river_particle_nz
    river_particle_z = np.cumsum(river_particle_dz)+oz-1/2*river_particle_dz[0]   
    river_particle_z_index = [0]*river_particle_nz                                            
    for iz in range(river_particle_nz):
        river_particle_z_index[iz] = np.argmin(abs(z-river_particle_z[iz]))

       
    ## find saturated zone to release particles
    ## saturation = datagroup["Liquid_Saturation"][:]
    new_particles = []
    for iy in range(river_particle_ny):
        pline_selected = unique_face_index[:,
                            unique_face_index[1,:]==river_particle_y_index[iy]]                   
        for icell in range(pline_selected.shape[1]):
            if (pline_selected[2,icell] in river_particle_z_index) and (
                     saturation[pline_selected[0,icell],pline_selected[1,icell]
                                                ,pline_selected[2,icell]]==1):
                    new_particles.append(np.array([times[itime],
                         x[pline_selected[0,icell]],y[pline_selected[1,icell]],
                         z[pline_selected[2,icell]]]).reshape((1,4)))

    return new_particles 


caculate_path = False
plot_surface = False
plot_path = True

caculate_path = True
plot_path = False
plot_surface = False



simu_file = "./flow_2008/pflotran_bigplume.h5"
material_file = "./flow_2008/BC_2008_2015/bigplume_4mx4mxhalfRes_material_mapped_newRingold_subRiver_17tracer.h5"
###pt_fname = "./results/path.pickle"
times = np.arange(8784,27172,1)


# pt_fname = "./results/path.pickle.240"
# release_times = np.r_[8784:27172:240]

pt_fname = "./results/path.pickle.24"
release_times = np.r_[8784:27172:24]



material_type = {"Hanford":1,"Ringold_Gravel":4,"Ringold_Fine":9} 
porosity = {"1":0.2,"4":0.25,"9":0.43} 

### minimum time step
min_dtstep = 0.001

ncore = 64

nx = 225
ny = 400
nz = 40

ox = -450
oy = -800
oz = 90


dx = [4]*nx
dy = [4]*ny
dz = [0.5]*nz

river_particle_dy = 100
river_particle_dz = 5     
         
ntime=len(times)    
     
ex = ox+np.sum(dx)
ey = oy+np.sum(dy)
ez = oz+np.sum(dz)   
     
x = np.cumsum(dx)+ox-1/2*dx[0]
y = np.cumsum(dy)+oy-1/2*dy[0]
z = np.cumsum(dz)+oz-1/2*dz[0]



datafile = h5.File(material_file,"r") 
material_ids = datafile['Materials']['Material Ids'][:].reshape(nz,ny,nx).swapaxes(0,2)
face_cells = datafile['Regions']['River']["Cell Ids"][:]
face_ids = datafile['Regions']['River']["Face Ids"][:]


cell_index = np.concatenate((
                            [np.r_[0:nx*ny*nz] % nx],
                            [np.r_[0:nx*ny*nz] % (nx*ny) // nx],                              
                            [np.r_[0:nx*ny*nz] // (nx*ny)],
                            ),axis=0)
face_index = cell_index[:,(face_cells-1)]
unique_face_index = cell_index[:,(np.unique(face_cells)-1)]  

if caculate_path :
    particles = []
    particle_status = []  
    particle_cells = []          
    for itime in range(0,ntime-1): 
        groupname = "Time:  "+"{0:.5E}".format(times[itime])+" h"
        ##print("",groupname)
        ##read velocity field             
        datafile = h5.File(simu_file,"r")   
        ##list(datafile.keys())
        datagroup = datafile[groupname]
        saturation = datagroup["Liquid_Saturation"][:]        
        
        ##time to add new particles
        if times[itime] in release_times:
        ##    define new particle locations    
        ##    new_particles = [np.array([times[itime],317,99,95]).reshape((1,4)),
        ##                     np.array([times[itime],317,99,100]).reshape((1,4)),
        ##                     np.array([times[itime],317,99,105]).reshape((1,4)),
        ##                     np.array([times[itime],317,99,110]).reshape((1,4))]       
    
            ##define new particle locations
            new_particles = def_release_particle_from_river_bed(river_particle_dy,
                                                            river_particle_dz) 
            ## find cell index of new particles
            pool = mp.Pool(processes=ncore)
            new_particle_cells = [pool.apply(def_locate_cell,args=(x,)) 
                                              for x in range(len(new_particles))]
            pool.close()
            pool.join()
            ##add new particles to database
            particles.extend(new_particles)
            particle_cells.extend(new_particle_cells)
            particle_status.extend([1]*len(new_particles))                                
                
        
        ##only run tracking for the alive particles
        active_particles = [i for i,j in enumerate(particle_status) if j == 1]
        print(groupname,"active particles:",len(active_particles))

        
        ##list(datagroup.keys())
        x_darcy = datagroup["Liquid X-Flux Velocities"][:]  #### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        y_darcy = datagroup["Liquid Y-Flux Velocities"][:]
        z_darcy = datagroup["Liquid Z-Flux Velocities"][:]
    
        ### assign face flux(may need fix)
        x_darcy = np.append(x_darcy[0:1,:,:],x_darcy,0)
        x_darcy = np.append(x_darcy,x_darcy[(nx-1):nx,:,:],0)
        y_darcy = np.append(y_darcy[:,0:1,:],y_darcy,1)
        y_darcy = np.append(y_darcy,y_darcy[:,(ny-1):ny,:],1)
        z_darcy = np.append(z_darcy[:,:,0:1],z_darcy,2)
        z_darcy = np.append(z_darcy,z_darcy[:,:,(nz-1):nz],2)
        
        ## let parallel cores execute particle tracking in one simulation step
        pool = mp.Pool(processes=ncore)
        results = [pool.apply(def_particle_tracking_steady,args=(iparticles,)) 
                                                for iparticles in active_particles]
        pool.close()
        pool.join()
        
        ## read particle tracking results
        for iparticles in range(len(active_particles)):
            particle_index = active_particles[iparticles]
            particle_cells[particle_index] = results[iparticles]["cell_update"]
            particles[particle_index] = np.append(particles[particle_index],
                                            results[iparticles]["coord_update"],0)
            particle_status[particle_index] = results[iparticles]["particle_status"]

        ## save particle tracking results            
        pt_results = {'particle_cells':particle_cells,
                  'particles':particles,
                  'particle_status':particle_status}                         
        if os.path.isfile(pt_fname):
            os.remove(pt_fname)  
        file = open(pt_fname,"wb")  
        pickle.dump(pt_results,file)
        file.close()
            
    ## save particle tracking results
    pt_results = {'particle_cells':particle_cells,
                  'particles':particles,
                  'particle_status':particle_status,
                  'itime':itime
    }                         
    
    if os.path.isfile(pt_fname):
        os.remove(pt_fname)  
    file = open(pt_fname,"wb")  
    pickle.dump(pt_results,file)
    file.close()

if plot_path :
    file = open(pt_fname,"rb")  
    pt_results = pickle.load(file)
    particle_cells = pt_results['particle_cells']
    particles = pt_results['particles']
    particle_status = pt_results['particle_status']
    file.close()


    fig = plt.figure(figsize=(20,8))
    ax = fig.add_subplot(111, projection='3d')
    ####plt.contour(river_surf_x,river_surf_y,river_surf_z,30,linewidths=1,color="k")



    if plot_surface :
        ### create data for plotting river bed        
        river_face_x = x[unique_face_index[0,:]]
        river_face_y = y[unique_face_index[1,:]]
        river_face_z = z[unique_face_index[2,:]]
        river_surf_x = np.linspace(river_face_x.min(),river_face_x.max(),100)
        river_surf_y = np.linspace(river_face_y.min(),river_face_y.max(),100)
        river_surf_z = griddata((river_face_x,river_face_y),river_face_z, 
                    (river_surf_x [None,:], river_surf_y[:,None]), method='cubic')               
        river_surf_x_grid,river_surf_y_grid = np.meshgrid(river_surf_x,river_surf_y)
                     
        ax.plot_surface(river_surf_x_grid,river_surf_y_grid,river_surf_z,
                        linewidths=0,antialiased=True,alpha=0.3,
                        rstride=1, cstride=1) ###cmap=cm.coolwarm,)  
    
    
    
    
    ##    for imaterial in range(9,10): ##material_type["Ringold_Fine"]:##,material_type["Ringold_Fine"]:
        imaterial = material_type["Hanford"]
        print(imaterial)
        surface_x = np.empty(nx*ny).reshape(nx,ny)
        surface_y = np.empty(nx*ny).reshape(nx,ny)
        surface_z = np.empty(nx*ny).reshape(nx,ny)
        surface_x[:] = np.NAN
        surface_y[:] = np.NAN
        surface_z[:] = np.NAN             
        for iy in range(ny):
            for ix in range(nx):
                surface_cells = np.where(material_ids[ix][iy]==imaterial)
                surface_x[ix,iy] = x[ix]
                surface_y[ix,iy] = y[iy]                             
                if len(surface_cells[0])>0 :
                        surface_z[ix,iy] = z[surface_cells[0][0]]
        ax.plot_surface(surface_x,surface_y,
                         surface_z,
                    linewidths=0,antialiased=True,alpha=0.3,
                    rstride=1, cstride=1) ###cmap=cm.coolwarm,) 
    
    
    for iparticle in range(len(particle_cells)):
        ax.scatter(particles[iparticle][:,1],
                   particles[iparticle][:,2],
                   particles[iparticle][:,3],
                   c="r",s=2,marker="o")
    for iparticle in range(len(particle_cells)):        
        ax.plot(particles[iparticle][:,1],
                   particles[iparticle][:,2],
                   particles[iparticle][:,3],
                   c="b",)    
    ax.set_xlim(ox,ex)  
    ax.set_ylim(oy,ey)  
    ax.set_zlim(oz,ez)     
    ax.set_xlabel('Easting (m)')
    ax.set_ylabel('Northing (m)')
    ax.set_zlabel('Elevation (m)')
    fig.savefig("../test.png")
    
    
    for ii in range(0,360,90):
        print(ii)
        ax.view_init(elev=110., azim=ii)
        fig.savefig("movie%d.png" % ii)



#fig = plt.figure()
#ax = fig.add_subplot(111, projection='3d')
#ax.scatter(face_index[0], face_index[1], face_index[2], c="r",s=1)
#ax.set_xlabel('X Label')
#ax.set_ylabel('Y Label')
#ax.set_zlabel('Z Label')
#for ii in range(0,360,30):
#    ax.view_init(elev=105., azim=ii)
#    fig.savefig("movie%d.png" % ii)
#plt.show()
