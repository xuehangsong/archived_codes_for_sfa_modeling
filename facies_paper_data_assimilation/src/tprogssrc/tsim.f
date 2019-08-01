       program tsim 
C
C           Conditional Simulation of a 3-D Rectangular Grid            
C           ************************************************            
C
C  Steven F. Carle 
C  Version 2.1  June, 1999
C    
C#####################################################################
C                                                                    #
C  The T-PROGS programs have been written for the benefit of earth   #
C  science interpretation and modeling applications.  However,       #
C  there is no guarantee that these programs will suit the user's    #
C  needs or goals, execute efficiently and without mishap on the     #
C  user's computer, exhibit no errors or bugs, or yield a            #
C  scientifically defensible result.  The T-PROGS programs           #
C  may be distributed freely, but the author assumes no liability    #
C  for any results attained from an application of a T-PROGS program.#
C  All questions on usage are referred to the user manual.           #
C  The user is welcome to make any modifications needed to suit      #
C  his/her interpretive and modeling needs.                          #
C                                                                    #
C#####################################################################
c
C  Portions of 'tsim.f' have incorporated or been modified from      #
C  the Geostatistical Software Library (GSLIB).  Therefore, ALL      #
C  COPIES AND MODIFICATIONS OF 'tsim.f' SHOULD ALSO HONOR THE GSLIB  # 
C  COPYRIGHT AGREEMENT SHOWN BELOW.
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C                                                                      %
C Copyright (C) 1992 Stanford Center for Reservoir Forecasting.  All   %
C rights reserved.  Distributed with: C.V. Deutsch and A.G. Journel.   %
C ``GSLIB: Geostatistical Software Library and User's Guide,'' Oxford  %
C University Press, New York, 1992.                                    %
C                                                                      %
C The programs in GSLIB are distributed in the hope that they will be  %
C useful, but WITHOUT ANY WARRANTY.  No author or distributor accepts  %
C responsibility to anyone for the consequences of using them or for   %
C whether they serve any particular purpose or work at all, unless he  %
C says so in writing.  Everyone is granted permission to copy, modify  %
C and redistribute the programs in GSLIB, but only under the condition %
C that this notice and the above copyright notice remain intact.       %
C                                                                      %
C%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c
C  This program was modified from GSLIB's sisim.f by:
C
C  SFC 6/99
C  System compatibility improvements 
C
C  SFC 12/97
C  Fix bugs related to azimuth and dip angles
C
C  SFC 10/97
C  Replace subroutines for solving singular value decomposition
C  and generating random numbers with public domain software 
C
C  SFC 7/97
C  Include option for default determinant limit
C  Allow for minimum or centered grid specification
C
C  SFC 5/97
C  Include binary/ascii output option
C
C  SFC 10/96
C  Make code compatible to PC w/o requiring hdf library
C
C  SFC 10/95
C  Fix bugs pertaining to 3-D simulations
C
C  SFC 9/95 
C  Make objective function for quenching depend on determinant. 
C  Decluster quenching lags for objective function
C
C  SFC 8/95     
C  Allow consideration for data with probabilities between
C  zero and unity. 
C
C  SFC 7/95
C  Permit centered geometry. 
C  Let negative values denote conditioning locations.  
C
C  SFC 5/95
C  Make geometry orthogonal to a fixed azimuth/dip
C
C  SFC 4/95
C  Include simulated quenching in the simulation process.
C
C  SFC 2/95
C   Modify search algorithm to search by prioritizing diagonal of
C      transition matrix
C         (1) Variable anisotropy directions.
C              (a) azimuthal (xy plane)
C              (b) dip (rotation about x' axis)
C         (2) Usage of Probability Cokriging for conditional
C             probability estimation
C  
C  SFC 8/93
C         (1) Tally order-relations violations
C         (2) Give option for covariance-based or transition 
C             probability-based cokriging. 
C         (3) Calculate estimation variance, tally dist betw -1 and 1.  
C
C
c-----------------------------------------------------------------------
c                                                                       
c                                                                       
c The output files are binary grid files containing 
c the simulated values.
c The file is ordered by x,y,z. and then simulation (i.e., x cycles     
c fastest, then y, then z, then simulation number).                     
c                                                                       
c                                                                       
c                                                                       
c Original: C.V. Deutsch                               Date: August 1990
C Modified: S.F. Carle                                 Date: June 1993
c-----------------------------------------------------------------------
      include  'tsim.inc'                                         
c                                                                       
c Fortran unit numbers needed:                                          
c                                                                       
      lin  = 1                                                          
      ldbg = 3                                                          
c
c Read the Parameter File and the Data:                                 
c                                                                       
      call readparm                                        
c
c Arrange search lookup order (by order of determinant)
c
comment      print 905, detfl 
      write(ldbg,905) detfl 
 905  format(' Determining lookup order using ',a40)
 105  format(a40)
      call indexa 
c
c Assign close nodes for quenching  
c   and make transition probability objective function
c
      if(maxit.ge.1.or.maxit.le.-1)then
        call qorder
        call tpmak
      endif
c                                                                       
c Call sis for the simulation:                                        
c                                                                       
comment      print*,'Simulating'
      call sistp                                             
c                                                                       
c Finished:                                                             
c                                                                       
comment      print *,'   Debugging output in  ',dbgfl     
      close(ldbg)                                                       
      stop                                                              
      end                                                               
                                                                        
                                                                        
                                                                        
      subroutine readparm                                  
c-----------------------------------------------------------------------
c                                                                       
c                  Initialization and Read Parameters                   
c                  **********************************                   
c                                                                       
c The input parameters and data are read in from their files. Some quick
c error checking is performed and the statistics of all the variables   
c being considered are written to standard output.                      
c                                                                       
c NOTE: 1. The variables and the data are allocated in common blocks    
c          (pcksim.inc)                                             
c                                                                       
c Original: C.V. Deutsch                Date: August 1990
C Modified: S.F. Carle                  Date: June 1993
c-----------------------------------------------------------------------
      include  'tsim.inc'                                         
      character parfil*40                                             
c     03/13/2015 xuehang song
      integer :: ixhs
      character*40 :: ForProportion
      character*100 :: temp_getarg
c                                                                       
c Read Input Parameters:                                                
c 
      d2rad=atan(1.0)/45.
c      print *,'Name of TSIM parameter file:'
c	read(5,'(a40)') parfil
c      parfil='tsim.par'
      call getarg(2,parfil)
      open(7,file=parfil,status='old')      
      do  ixhs=1,8
         read(7,*)
      enddo
         read(7,'(a40)') ForProportion
      close(7)
      

      call getarg(1,parfil)

      open(9,file=parfil,status='old')
      read(9,*) ncat
      read(9,*) (p(icat),icat=1,ncat) 
     
c     change proportion
      open(777,file=trim(ForProportion),status='old')
      read(777,*)(p(icat),icat=1,ncat) 
      close(777)



      read(9,'(a40)',err=98) outfl
      read(9,*) iform
      read(9,*,err=98)       idbg
      read(9,'(a40)',err=98) dbgfl
      read(9,*,err=98)       seed                                     


      if(seed.gt.0)seed=-seed
      read(9,*,err=98)       nsim
c     xuehang song, change nsim
      call getarg(4,temp_getarg)
      read(temp_getarg,*) nsim


      read(9,*,err=98)       xc,nx1,xsiz                              
      read(9,*,err=98)       yc,ny1,ysiz                              
      read(9,*,err=98)       zc,nz1,zsiz   
      if(nx1.le.0.and.ny1.le.0.and.nz1.le.0)then
        nx1=-nx1
        ny1=-ny1
        nz1=-nz1
        nx=2*nx1+1
        ny=2*ny1+1
        nz=2*nz1+1
        xmn=xc-(nx1*1.0+0.5)*xsiz
        ymn=yc-(ny1*1.0+0.5)*ysiz
        zmn=zc-(nz1*1.0+0.5)*zsiz
      else
        nx=nx1
        ny=ny1
        nz=nz1
        nx1=nx/2
        ny1=ny/2
        nz1=nz/2
        xmn=xc
        ymn=yc
        zmn=zc
        xc=xc+(nx*xsiz)/2.0
        yc=yc+(ny*ysiz)/2.0 
        zc=zc+(nz*zsiz)/2.0
      endif
      nxy  = nx * ny                                                    
      nxyz = nx * ny * nz                                               
      read(9,*,err=98)       ndmin,ndmax   
      read(9,*,err=98)       icoik
      read(9,*,err=98)       wratio
c                                                                       
c Open the debugging file:                                  
c                                    
      open(ldbg,file=dbgfl,status='UNKNOWN')                            
c
c Get transition probability model   
c
      read(9,'(a40)',err=98) tpfl
C     iret=dsgdims(tpfl,irank,nt,5) 
C     iret=dsgdata(tpfl,irank,nt,tpxyz)
      open(8,file=tpfl,status='old',form='unformatted')
      read(8) irank 
      read(8) (nt(i),i=1,irank)
comment      print*,'Dimensions of tr. pr. model file: ',(nt(i),i=1,irank)
      write(ldbg,*)
     & 'Dimensions of tr. pr. model file: ',(nt(i),i=1,irank)
      nhx2=nt(1)
      nhy2=nt(2)
      nhz2=nt(3)
      nhx=(nhx2-1)/2
      nhy=(nhy2-1)/2
      nhz=(nhz2-1)/2
      nhxy2=nhx2*nhy2
      nh=nhx2*nhy2*nhz2
      ntpxyz=nh*nt(4)*nt(5)
comment      print *,ntpxyz
      read(8) (tpxyz(i),i=1,ntpxyz)
      close(8)
      ncatsq=ncat*ncat
c
c Get Determinant File 
c
      read(9,'(a40)',err=98)detfl
      open(8,file=detfl,status='old',form='unformatted')
      read(8) irank 
      read(8) (ns(i),i=1,irank)
      nsxyz=ns(1)*ns(2)*ns(3)
      read(8) (det(i),i=1,nsxyz)
      close(8)
c
c
c Get data
c
      read(9,'(a40)',err=98) datfl

c     change input data xuehang song 03/18/2015
      call getarg(3,datfl)
      
c
c  if data exists, then read it and get azimuth and dip
c
      inquire(file=datfl,exist=testfl)                                 
      if(.not. testfl) then
comment        print*,'No data file'
comment        print*,'Hope you want an unconditional simulation'
      else
c
c  open data file
c
        open(7,file=datfl,status='old')
      endif                                              
C
C  get  azimuth 
C
      read(9,*) azc,az
      azccos=cos(azc*d2rad)
      azcsin=sin(azc*d2rad)
C
C  get  dip
C
      read(9,*) dipc,dip
      dipcsin=sin(dipc*d2rad)
      dipccos=cos(dipc*d2rad)
c
c Perform some quick error checking:                                    
c                                                                       
      nxyz=nx*ny*nz
      if(nxyz.gt.MXYZ) stop 'nxyz is too big - modify .inc file'     
c
c Get azimuth and dip files
c
c   Azimuth:
c
      read(9,'(a40)',err=98) azfl
      inquire(file=azfl,exist=testflaz)                                 
      if(.not. testflaz)then
comment        print*,'No Azimuth file'
        write(ldbg,*) 'No Azimuth file'
        do 905 ixyz=1,nxyz
 905      iaz(ixyz)=nint(az)
      else
C       iret=dsgdims(azfl,irank,ns,3)
C       iret=dsgdata(azfl,irank,ns,iaz)
comment        print 994,azfl
        write(ldbg,994) azfl
 994    format('Azimuth file= ',a40)
        open(8,file=azfl,status='old',form='unformatted')
        read(8) irank
        read(8) (ns(i),i=1,irank)
        nsxyz=ns(1)*ns(2)*ns(3)
        read(8) (iaz(i),i=1,nsxyz)
        close(8)
        if(ns(1).ne.nx.or.ns(2).ne.ny.or.ns(3).ne.nz)
     &    print*,'WARNING: Azimuth hdf dimensions wrong!'
      endif
c
c    Dip:
c
      read(9,'(a40)',err=98) dipfl
      inquire(file=dipfl,exist=testfldip)                              
      if(.not. testfldip)then
comment        print*,'No Dip file'
        do 906 ixyz=1,nxyz
 906      idip(ixyz)=nint(10.*dip)
      else
comment        print 995,dipfl
        write(ldbg,995) dipfl
 995    format('Dip file= ',a40)
        open(8,file=dipfl,status='old',form='unformatted')
        read(8) irank
        read(8) (ns(i),i=1,irank)
        nsxyz=ns(1)*ns(2)*ns(3)
        read(8) (idip(i),i=1,nsxyz)
        close(8)
        if(ns(1).ne.nx.or.ns(2).ne.ny.or.ns(3).ne.nz)
     &    print*,'WARNING: dip hdf dimensions wrong!'
      endif
c
c Get Quenching parameters
c
      read(9,*,err=98)     maxit,tol,iquench                          
      if(maxit.ge.1.or.maxit.le.-1) read(9,*,err=98) ql 
c
c Check 'ql' to make sure it encompasses principal directions.
c Readjust as necessary.
c
      ihcenter=(nh-1)/2+1
      ihx1=ihcenter+1
      ihy1=ihcenter+nhx2
      ihz1=ihcenter+nhx2*nhy2
      if(det(ihx1).lt.ql.and.nx.gt.1)then
        ql=det(ihx1)*0.9
        write(ldbg,*) 'Determinant limit lowered to ',ql,' for x dir.' 
comment        print*, 'Determinant limit lowered to ',ql,' for x dir.' 
      endif
      if(det(ihy1).lt.ql.and.ny.gt.1)then
        ql=det(ihy1)*0.9
        write(ldbg,*) 'Determinant limit lowered to ',ql,' for y dir.' 
comment        print*, 'Determinant limit lowered to ',ql,' for y dir.' 
      endif
      if(det(ihz1).lt.ql.and.nz.gt.1)then
        ql=det(ihz1)*0.9
        write(ldbg,*) 'Determinant limit lowered to ',ql,' for z dir.' 
comment        print*, 'Determinant limit lowered to ',ql,' for z dir.' 
      endif
c
c  Write assumed proportions
c
      write(ldbg,*) 'Probabilies for categories:'        
comment      print*, 'Probabilities for categories:'        
      do 940 j=1,ncat
comment        print 949, j,p(j)
 940    write(ldbg,949) j,p(j)
 949  format('  Category',i3,':',f6.3)
c                                                                       
c Error in parameter file somewhere:                                   
c                                                                       
      return
 98   stop 'ERROR in parameter file!'                                   
      end         
c****************************************************************************                                                            
      subroutine initgrid
      include 'tsim.inc'
      real*8 tttmp
c
c  initialize sim
c
      ixyz=0
      do 1 iz=1,nz
       do 1 iy=1,ny
        do 1 ix=1,nx
         ixyz=ixyz+1
         sim(ixyz)=0
 1    continue
c
c
c  read header
c
      read(7,'(a80)')title
      read(7,*) nv
      do 950 iv=1,nv
 950    read(7,'(a80)')title
c
c  read data
      ndat=0
      do 960 i=1,1000000
        read(7,*,end=969) xi,yi,zi,(rdat(icat),icat=1,ncat)
        dx=xi-xc
        dy=yi-yc
        dz=zi-zc
        x1=dx*azccos-dy*azcsin
        r1=dy*azccos+dx*azcsin
        y1=r1*dipccos+dz*dipcsin
        z1=dz*dipccos-r1*dipcsin
c --- Modified by Ming Ye on 7/26/2007 ---          
        ix=int((x1+xc-xmn)/xsiz)+1
c        ix=anint((x1+xc-xmn)/xsiz)+1
        if(ix.ge.1.and.ix.le.nx)then
c --- Modified by Ming Ye on 7/26/2007 ---          
          iy=int((y1+yc-ymn)/ysiz)+1
c          iy=anint((y1+yc-ymn)/ysiz)+1
          if(iy.ge.1.and.iy.le.ny)then
c --- Modified by Ming Ye on 7/26/2007 ---          
c            iz=int((z1+zc-zmn)/zsiz)+1
            iz=anint((z1+zc-zmn)/zsiz)+1
c --- End of modification ---
            if(iz.ge.1.and.iz.le.nz)then
              ixyz=ix+(iy-1)*nx+(iz-1)*nxy              
              if(sim(ixyz).lt.0)go to 99
              iflag=0
              do 965 icat=1,ncat
                if(rdat(icat).eq.1.)then
                  iflag=1
                  sim(ixyz)=-icat
                  ndat=ndat+1
                endif
 965          continue
              if(iflag.eq.0)then              
c --- Change the random number generator to ran3 by Ming Ye on 6/29/2006 ---               
c                randnu=urand(seed)
                randnu=ran3(seed)  !Ming Ye
                call vpick(rdat,ncat,randnu,sim(ixyz),p)
                ndat=ndat+1
              endif
 99           continue
            endif
          endif
        endif
 960  continue 
 969  continue
      rewind(7)
comment      print*, ' Number of acceptable data  = ',ndat                
      write(ldbg,*) ' Number of acceptable data  = ',ndat        
      return
      end
c*************************************************************************      
      subroutine sistp                                      
c-----------------------------------------------------------------------
c                                                                       
c           Conditional Simulation of a 3-D Rectangular Grid            
c           ************************************************            
c                                                                       
c This subroutine generates 3-D conditional simulations
C  (intial configuration)
c  with sequential indicator simulation (SIS). 
C
c                                                                       
c                                                                       
c INPUT VARIABLES:                                                      
c                                                                       
c   ndat             Number of data                  
c                                                                       
c   nx,ny,nz         Number of blocks in X,Y, and Z                     
c   xmn,ymn,zmn      Coordinate at lower left of first Block        
c   xsiz,ysiz,zsiz   spacing of the grid nodes (block size)             
c                                                                       
c   nsim             number of simulations                              
c   seed             starting random number seed                        
c   idbg             integer debugging level (0=none,2=normal,4=serious)
c   ldbg             unit number for the debugging output               
c                                                                       
c   ndmin            Minimum number of data required before simulation 
c   ndmax            Maximum number of samples for simulation           
c                                                                       
c OUTPUT VARIABLES:  Simulated Values are written in HDF 
c                                                                       
c   sim(nxyz)        one simulation                                     
c
c SUBROUTINES:
c
c   srchnd           Search for nearby simulated grid nodes             
c   sortem           sorts multiple arrays in ascending order           
c   cokrig           Sets up and solves either the SK or OK system      
c   svd89/svdbk89    Linear system solver using 
c                     singular value decomposition    
c                                                                       
c                                                                       
c Original:  C.V. Deutsch                            Dec. 1990
c Modified:  S.F. Carle                              March 1995
c-----------------------------------------------------------------------
      character*40 filnam
      integer idim(3)
      include  'tsim.inc'                                          
      idim(1)=nx
      idim(2)=ny
      idim(3)=nz
c                                                                       
c The random path generation procedure of Srivastava and Gomez has been 
c adopted in this subroutine.  A linear congruential generator of the   
c form: r(i) = 5*r(i-1)+1 mod(2**n) has a cycle length of 2**n.  By     
c choosing the smallest power of 2 that is still larger than the total  
c number of points to be simulated, the method ensures that all indices 
c will be generated once and only once:                                 
c                                                                       
      modlus = 1                                                        
 1    modlus = modlus * 2                                               
      if(modlus.lt.nxyz) go to 1                                        
      write(ldbg,*)                                                     
      write(ldbg,*) 'The random number generator to generate the path:' 
      write(ldbg,*) '        r(i) = 5*r(i-1)+1 mod ',modlus             
c
c --- Call ran3 to initialize it ---
c
      ttmp=ran3(-seed)
c                                                                       
c MAIN LOOP OVER ALL THE SIMULATIONS:                                  
c                                                                       
      do 2 isim=1,nsim                                               
comment            write(*,*)    ' Starting simulation ',isim                  
            write(ldbg,*) ' Starting simulation ',isim                  
c                                                                       
c Initialize the simulation:            
c                                                                       
comment            print*,' initializing simulation'
            write(ldbg,*) ' initializing simulation'
            if(maxit.ge.0)then
              do 3 i=1,nxyz                                   
 3              sim(i)=0
              if(testfl)call initgrid
            elseif(maxit.le.-1)then
              ifile=isim
              if(nsim.eq.1)ifile=0
              call namefile(outfl,ifile,filnam)
C             iret=dsgdata(filnam,3,idim,sim)
              open(8,file=filnam,status='unknown',form='unformatted')
              read(8) irank
              read(8) (idim(i),i=1,irank)
              nxyz=idim(1)*idim(2)*idim(3)
              read(8) (sim(i),i=1,nxyz)
              close(8)
            endif
c
c
c  Prepare to simulate using SIS
c
            irepo = max0(1,min0((nxyz/10),10000))                       
comment            print*,' Starting SIS'
            write(ldbg,*) ' Starting SIS'
c 
c Pick a random starting node
c                                
c --- Change the random number generator to ran3 by Ming Ye on 6/29/2006 ---               
c            randnu=urand(seed)
            randnu=ran3(seed) !Ming Ye                                  
            index = 1 + int(randnu*nxyz) 
            if(index .gt. nxyz)index=nxyz
c                                                                       
c MAIN LOOP OVER ALL THE NODES:                                         
c 
c  initialize estimation counts
            if(maxit.le.-1)go to 999
            do 4 ind=1,nxyz
c
c  Periodically print out current node
comment                  if((int(ind/irepo)*irepo).eq.ind)                  
comment     +            write(*,*) '   currently on node ',ind                
c                                                                       
c Make sure node has not been assigned a value already and figure out   
c the location:                                                         
c                 
                  if(sim(index).ne.0) go to 20                      
                  call ind2ixyz(index,nx,nxy,ix,iy,iz)
                  if(idbg.ge.3) write(ldbg,*) 'Working on grid index:', 
     +                          ix,iy,iz                                
c                                                                       
c Draw the random # which will be used to obtain the simulated value:  
c                                                                       
c --- Change the random number generator to ran3 by Ming Ye on 6/29/2006 ---               
c                  randnu=urand(seed)
                  randnu=ran3(seed) !Ming Ye
c                                                                       
c Estimate the local probabilities:                          
c                                                                       
c   Find statistically close data
                  call srchnd                      
c                                                                       
c   cokrige. 
                  call cokrig          
c
c Pick category from estimated probabilities
                  if(idbg.ge.4)write(ldbg,107)randnu
 107              format('rand#=',f6.3)
                  call vpick(v,ncat,randnu,sim(index),p)
                  if(idbg.ge.4)call vtally(randnu,ind,ldbg,p,ncat)
                  if(idbg.ge.3)write(ldbg,*)'sim',index,'=',sim(index)
c                                                                       
c Get a new node to simulate:                                           
c                                                                       
 20               index = mod(5*index+1,modlus)                         
                  if(index.gt.nxyz.or.index.lt.1) go to 20              
c                                                                       
c END MAIN LOOP OVER NODES:                                             
c                                                                       
 4          continue                                                    
c
c QUENCH
c 
 999        continue
            if(maxit.ge.1.or.maxit.le.-1)then
              call quench
            endif
c
c --- Change sign for the conditoning data. Addde by Ming Ye on 6/29/2006 ---
c            
        do i=1,nxyz
           if(sim(i).lt.0) sim(i)=abs(sim(i))
        enddo
c                                                                       
c Write this simulation to the output file:                             
c                
        ifile=isim
        if(nsim.eq.1)ifile=0
        call namefile(outfl,ifile,filnam)
c
c  write simulation array into binary or ascii file
c
        irank=3
        if(iform.eq.1)then
          open(8,file=filnam,status='unknown',form='unformatted')
          write(8) irank 
          write(8) (idim(i),i=1,3)
          write(8) (sim(i),i=1,nxyz)
          close(8)
        else
          open(8,file=filnam,status='unknown')
          write(8,'(i1)') irank 
          write(8,'(3i10)') (idim(i),i=1,3)
          do 973 i=1,nxyz
 973        write(8,'(i4)') sim(i)
          close(8)
        endif
c
c  done with simulation
c
comment      print 971, isim,filnam
      write(ldbg,971) isim,filnam
 971  format('Done with simulation',i4,' named ',a40)  
c
c write order relations violations info to ldbg
        write(ldbg,742) isim
 742    format('Order Relations Violations for Simulation',i3,':')
        write(ldbg,*) '            .lt.0:    .gt.1:   sum.ne.1:'
        write(ldbg,743) iorv0,iorv1,iorvs
 743    format('Number:   ',3i10)        
        write(ldbg,745) orv0,orv1,orvs
        if(iorv0.ne.0)orv0=orv0/real(iorv0)
        if(iorv1.ne.0)orv1=orv1/real(iorv1)
        if(iorvs.ne.0)orvs=orvs/real(iorvs)
        write(ldbg,744) orv0,orv1,orvs
 744    format('Average:',3f10.6)
 745    format('Total:    ',3f10.1)
c 
c  reset order relation violation parameters
        orv0=0.
        orv1=0.
        orvs=0.
        iorv0=0
        iorv1=0
        iorvs=0
c                                                                       
c END MAIN LOOP OVER SIMULATIONS:                                       
c                                                                       
 2    continue                                                          
c
c  write probability estimate frequency
c
        ftot=real(nsim*nxyz)
        write(ldbg,*) 'Probability Estimate Distribution'
        write(ldbg,*) 'Prob.              Freq.'
        do 931 ital=-151,251
           rtal=real(ital)/100.
 931       write(ldbg,932) rtal,(ptal(icat,ital)/ftot,icat=1,ncat)
 932    format(f5.2,10f7.4)
c                                                                       
c Return to the main program:                                           
c                                                                       
      return                                                            
      end                                                               
                                                                        
                                                                        
                                                                        
      subroutine srchnd                           
c-----------------------------------------------------------------------
c                                                                       
c               Search for nearby Simulated Grid nodes                  
c               **************************************                  
c                                                                       
c The idea is to spiral away from the node being simulated and note all 
c the nearby nodes that have been simulated.                            
c                                                                       
c                                                                       
c                                                                       
c INPUT VARIABLES:                                                      
c                                                                       
c   ix,iy,iz        3-D indices of the point currently being simulated
c   index           1-D index of the point currently being simulated
c   sim(nx,ny,nz)   the simulation so far                               
c   ndmax           the maximum number of nodes that we want            
c   nh              the number of nodes in the look up table            
c   iordr(ih)       the search lookup order.             
c   [x,y,z]mn       the origin of the global grid netwrok               
c   [x,y,z]siz      the spacing of the grid nodes.                      
c   ilux(icnd)      x offset for lookup 
c   iluy(icnd)      y offset for lookup 
c   iluz(icnd)      z offset for lookup 
c                                                                       
c                                                                       
c                                                                       
c OUTPUT VARIABLES:                                                     
c                                                                       
c   ncnd            the number of close nodes                           
c   ilcnd()         the number in the look up table                     
c   indcnd)         the location index of the close nodes               
c   vcnd()          the values of the simulation at the close nodes    
c                                                                       
c                                                                       
c                                                                       
c Author: C. Deutsch                     July 1990
c Modified: S. Carle                     March 1993
c-----------------------------------------------------------------------
      include  'tsim.inc'                                        
      d2rad=atan(1.0)/45.
c                                                                       
c Consider all the nearby nodes until enough have been found:           
c                                                                       
      ncnd = 0           
      il=1
      index=ix+(iy-1)*nx+(iz-1)*nxy
      azcos=cos(d2rad*iaz(index)-azc*d2rad)
      azsin=sin(d2rad*iaz(index)-azc*d2rad)
      dipsin=sin(0.1*d2rad*idip(index)-dipc*d2rad)
      do while(ncnd .lt. ndmax .and. il .lt. nh)                        
            il=il+1
            ih=iordr(il)
            if(idbg.ge.5)write(ldbg,*)'ih',il,'=',ih
            call ind2ixyz(ih,nhx2,nhxy2,ihx2,ihy2,ihz2)
            istep=ihx2-nhx-1
            jstep=ihy2-nhy-1
            kstep=ihz2-nhz-1
            if(idbg.ge.5)write(ldbg,*)'i,j,kstep=',istep,jstep,kstep
c
c  Adjust for azimuth and dip
c
            dxi=istep*xsiz
            dyj=jstep*ysiz
            dzk=kstep*zsiz
            dxi1=dxi*azcos+dyj*azsin
            dyj1=dyj*azcos-dxi*azsin
            dzk1=dzk+dyj*dipsin
            i=ix+nint(dxi1/xsiz)
            j=iy+nint(dyj1/ysiz)
            k=iz+nint(dzk1/zsiz) 
C  Make sure node is within range. 
            if(i.ge.1 .and. j.ge.1 .and. k.ge.1 .and.           
     +         i.le.nx .and. j.le.ny .and. k.le.nz) then           
c                                                                       
c  Check this potentially informed grid node:                           
c                                                                       
                  ind = (k-1)*nxy + (j-1)*nx + i                 
                  if(sim(ind).ne.0) then                          
                    ncnd = ncnd + 1                             
      if(idbg .ge. 5)write(ldbg,*) 
     &              'sim(',ind,')=',sim(ind),'ncnd=',ncnd
                    ihlu=nhx+1-istep+(nhy-jstep)*nhx2+(nhz-kstep)*nhxy2
                    ixcnd(ncnd)=istep
                    iycnd(ncnd)=jstep
                    izcnd(ncnd)=kstep
                    ilucnd(ncnd)=ihlu                             
                    ival=sim(ind)
                    ivcnd(ncnd)=iabs(ival)
c     check for rededundant data
                    do 418 icnd=1,ncnd-1
                      if(ixcnd(ncnd).eq.ixcnd(icnd))then
                        if(iycnd(ncnd).eq.iycnd(icnd))then
                          if(izcnd(ncnd).eq.izcnd(icnd))ncnd=ncnd-1
                        endif
                      endif
 418                continue
                  endif                                                 
            endif                                                       
      enddo                                                          
c                                                                       
c Return to calling program:                                            
c                                                                       
      if(idbg .ge. 4)write(ldbg,*) 'Lookup: #looked=',il,'found=',ncnd
      return                                                            
      end                                                               
                                                                        
                                                                        
                                                                        
      subroutine cokrig       
c-----------------------------------------------------------------------
c                                                                       
c     Builds and Solves the Transition Probability and 
c     Indicator Cross-Covariance Based Cokriging Systems 
c     *********************************************************         
c                                                                       
c INPUT VARIABLES:                                                      
c                                                                       
c   ix,iy,iz        index of the point currently being simulated        
c   icoik           type of cokriging
c
c INTERNAL VARIABLES:
c  
c   A(i,j)          left-hand side matrix
c   r(i)            right hand side, converted to 
c                   computed weights after solving leq's
c
c OUTPUT VARIABLE:
c
c   v(icat)         cokriged estimate for variable icat
c                                                                       
c SUBROUTINES: SVD89/SVDBK89   linear equations solver      
c                                                                       
c                                                                       
c                                                                       
c ORIGINAL: C.V. Deutsch                    August 1990
c MODIFIED: S.F. Carle                      March 1993
c-----------------------------------------------------------------------
      include 'tsim.inc'                                          
c  # of equations 
      if(ncnd .lt. ndmin)go to 99
c                                                                       
c Set up cokriging matrices:                                           
c                                                                       
c    set up lhs matrix
      do 2 icnd=1,ncnd                                                  
c  
c  write close node data, if debugging
c
        if(idbg.ge.4)write(ldbg,378) icnd,
     &  ivcnd(icnd),ixcnd(icnd),iycnd(icnd),izcnd(icnd)
 378    format('close node #',i2,' v=',i2,'  step xyz',3i3)
        do 3 jcnd=1,ncnd
c      get 3-D indices of j close data node
          itpx=ixcnd(jcnd)-ixcnd(icnd)+nhx+1
          itpy=iycnd(jcnd)-iycnd(icnd)+nhy+1
          itpz=izcnd(jcnd)-izcnd(icnd)+nhz+1
          itp=itpx+(itpy-1)*nhx2+(itpz-1)*nhxy2
          if(idbg.ge.5)write(ldbg,*)'itp,x,y,z',itp,itpx,itpy,itpz
c      assign transition probability values
          ia=ncat*(icnd-1)
          iflag=0
          if(itp.ge.1.and.itp.le.nh)iflag=1 
          ijcat=0
          do 4 icat=1,ncat
              ia=ia+1
              ja=ncat*(jcnd-1)
              do 4 jcat=1,ncat
                  ijcat=ijcat+1
                  itpxyz=itp+(ijcat-1)*nh
                  ja=ja+1
                  A(ja,ia)=p(jcat)
                  if(iflag.eq.1)A(ja,ia)=tpxyz(itpxyz) 
                  if(icoik.eq.0)A(ja,ia)=A(ja,ia)-p(jcat)
 4        continue
 3      continue
 2    continue
      neq=ncnd*ncat
c
c    write l.h.s. matrix if debugging
      if(idbg .ge.4) then 
        do 19 ieq=1,neq
 19       write(ldbg,391)(A(ieq,jeq),jeq=1,neq)
      endif
 391  format(52f6.3)
c
c Solve the Cokriging System:                         
c                                                                       
c    Singular value decompose lhs matrix
c
      call svd89(MEQ,neq,neq,w,A,vv,ierr)
      if(idbg.ge.4)write(ldbg,109) (w(ieq),ieq=1,neq)
 109  format('w=',100f6.3)
      wmax=0.0
      do 923 ieq=1,neq
        if(w(ieq).gt.wmax)wmax=w(ieq)
 923  continue
      wmin=wmax*wratio
      do 924 ieq=1,neq
        if(w(ieq).lt. wmin)w(ieq)=0.0
 924  continue 
c
c    set up right hand side 
      ir=0
      do 7 icnd=1,ncnd
         do 7 icat=1,ncat
           ir=ir+1
           r(ir)=0.0
           if(icoik.eq.0)r(ir)=-p(icat)
           if(icat .eq. ivcnd(icnd))r(ir)=r(ir)+1.0
 7    continue
c
c     write data if debugging
      if(idbg .ge. 4) write(ldbg,392) (ivcnd(i),i=1,ncnd)
 392  format(12i24)
c
c    write rhs if debugging
      if(idbg .ge.4) write(ldbg,391) (r(ieq),ieq=1,neq) 
c
c    solve linear equation by backsubstitution of rhs.       
      call svdbk89(A,w,vv,neq,MEQ,r,xx)
c
c    write rhs if debugging
      if(idbg .ge.4) write(ldbg,393) (xx(ieq),ieq=1,neq) 
 393  format(52f6.3)
c                                                                       
c Compute the estimates 
c                                                                       
      do 6 jcat=1,ncat
c
c   Simple Cokriging
        if(icoik.eq.0)then
          v(jcat)=p(jcat)
          ir=0
          do 9 icnd=1,ncnd                                           
            ix=-ixcnd(icnd)+nhx+1
            iy=-iycnd(icnd)+nhy+1
            iz=-izcnd(icnd)+nhz+1
            itp=ix+(iy-1)*nhx2+(iz-1)*nhxy2
            do 9 icat=1,ncat
              ir=ir+1
              itpxyz=itp+nh*(jcat+(icat-1)*ncat-1)
              v(jcat)=v(jcat)+xx(ir)*(tpxyz(itpxyz)-p(jcat)) 
 9        continue
c
c  Transition Probability-based Cokriging
        else
          v(jcat)=0.0
          ir=0
          do 10 icnd=1,ncnd                                           
            ix=-ixcnd(icnd)+nhx+1
            iy=-iycnd(icnd)+nhy+1
            iz=-izcnd(icnd)+nhz+1
            itp=ix+(iy-1)*nhx2+(iz-1)*nhxy2
            do 10 icat=1,ncat
              ir=ir+1
              itpxyz=itp+nh*(jcat+(icat-1)*ncat-1)
              v(jcat)=v(jcat)+xx(ir)*tpxyz(itpxyz) 
 10        continue
         endif
 6    continue
c
c  tally probability estimates from -1.5 to +2.5 in ptal
c  detect, count, and correct for order relation violations 
c  estimate v(ibkgr) from 1.- sum of other v's
c
      vsum=0.0
      do 11 icat=1,ncat
        ital=nint(v(icat)*100.)
        if(ital .gt. 250) ital=251
        if(ital .lt. -150) ital=-151 
        ptal(icat,ital)=ptal(icat,ital)+1.
        if(v(icat).lt.0.0)then
          iorv0=iorv0+1
          orv0=orv0-v(icat)
C         v(icat)=0.0
        elseif(v(icat).gt.1.)then
          iorv1=iorv1+1
          orv1=orv1+v(icat)-1.
C         v(icat)=1.0
        endif
        vsum=vsum+v(icat)
 11   continue
      go to 199
c
c  if ncnd is less than ndmin, assign p to v
 99   continue
      do 21 jcat=1,ncat
 21     v(jcat)=p(jcat)
 199  continue
c
c  write v
c
      if(idbg.ge.4)  write(ldbg,492) (v(icat),icat=1,ncat)
 492  format('v=',10f7.4)
      return                                                            
      end                                                               
                                                                        
                                                                        
      subroutine indexa
c  Indexes an array a of length 'nh' such that a(iordr(j)) is arranged 
c  from highest to lowest for j=1,2,...n.
C
      include 'tsim.inc'
      do 11 j=1,nh
 11     iordr(j)=j
      if(nh.eq.1)return
      l=nh/2+1
      ir=nh
 10   continue
         if(l .gt. 1)then
           l=l-1
           indxt=iordr(l)
           q=det(indxt)
         else
           indxt=iordr(ir)
           q=det(indxt)
           iordr(ir)=iordr(1)
           ir=ir-1
           if(ir.eq.1)then
             iordr(1)=indxt
             return   
           endif
         endif
         i=l
         j=l+l
 20      if(j.le.ir)then
           if(j.lt.ir)then
             if(det(iordr(j)).gt.det(iordr(j+1)))j=j+1
           endif
           if(q.gt.det(iordr(j)))then
             iordr(i)=iordr(j)
             i=j
             j=j+j
           else
             j=ir+1
           endif
         go to 20
         endif
         iordr(i)=indxt
       go to 10
       end
              
      subroutine qorder
      include 'tsim.inc'
c
c  assign lags to be included in quenching procedure
c  ordered by statistical closeness (determinant)  
c
comment      print *,'Setting quenching lags (x,y,z):'
      write(ldbg,*)'Setting quenching lags (x,y,z):'
      nq=0
      do 10 il=2,2*MQ
        ih=iordr(il)
        if(det(ih).lt.ql) go to 99
        call ind2ixyz(ih,nhx2,nhxy2,ihx2,ihy2,ihz2)
        lx=ihx2-nhx-1
        ly=ihy2-nhy-1
        lz=ihz2-nhz-1
c
c  accept only upper lags 
c
        if(lz.lt.0)goto 10 
        if(lz.eq.0)then
          if(ly.lt.0)go to 10 
          if(ly.eq.0.and.lx.le.0)goto 10 
        endif
c
c  accept only lags of 1 step
c
        if(iquench.eq.1)then
          if(lz.ge.2)goto 10
          if(ly.ge.2.or.ly.le.-2)goto 10
          if(lx.le.-2.or.lx.ge.2)goto 10
        endif
c
c  remove quenching lags outside domain of simulation
c
        if(lx.lt.-nx1.or.lx.gt.nx1)goto 10
        if(ly.lt.-ny1.or.ly.gt.ny1)goto 10
        if(lz.gt.nz1)goto 10
c
c  accumulate acceptable quenching lags
c
        nq=nq+1
        ixl(nq)=lx
        iyl(nq)=ly
        izl(nq)=lz
comment        print 981,lx,ly,lz
        write(ldbg,981) lx,ly,lz
 981    format(3i5)
        if(nq.eq.MQ)go to 99
 10   continue
 99   continue
comment      print*,'Total # of quenching lags=',nq
      write(ldbg,*) 'Total # of quenching lags=',nq
      return
      end 
c*************************************************************                                                                        
      subroutine ind2ixyz(ind,nx,nxy,ix,iy,iz)
c  converts 1-D index to 3-D indices
      iz=int((ind-1)/nxy)+1
      iy=int((ind-(iz-1)*nxy-1)/nx)+1
      ix=ind-(iz-1)*nxy-(iy-1)*nx
      return
      end
c************************************************************* 
       subroutine vpick(v,ncat,r,ival,p)
c
c  Selects a value based on estimated probabilities (v)
c
       dimension v(*),p(*)
       vsum=0.
c
c  Check for negative v's
c   
       do 10 icat=1,ncat
         if(v(icat) .lt. 0.)v(icat)=0.
 10      vsum=vsum+v(icat)
c
c  Normalize estimated probabilities
c
       if(vsum .gt. 0.) then
         do 20 icat=1,ncat
 20        v(icat)=v(icat)/vsum
       else
         do 21 icat=1,ncat
 21        v(icat)=p(icat)
       endif
c
c  Pick value
c
       cdf=0.0
       do 30 icat=1,ncat
         ival=icat
         cdf=cdf+v(icat)
         if(r .lt. cdf)goto 99
 30    continue
 99    continue
       return
       end
c**********************************************************************
c     This subroutine is modified by Ming Ye on 6/29/2006 so that more than
c     100 realizations can be generated        
      subroutine namefile(outfl,ifile,filnam)
      character*40 outfl,filnam
      character*2 nfile(100)
c --- Modified by Ming Ye on 6/29/2006 ---
c      character*1 ch1
      character ch1*1,ch2*2,ch3*3,ch4*4
      data nfile/'1 ','2 ','3 ','4 ','5 ','6 ','7 ','8 ','9 ','10',
     &           '11','12','13','14','15','16','17','18','19','20',
     &           '21','22','23','24','25','26','27','28','29','30',
     &           '31','32','33','34','35','36','37','38','39','40',
     &           '41','42','43','44','45','46','47','48','49','50',
     &           '51','52','53','54','55','56','57','58','59','60',
     &           '61','62','63','64','65','66','67','68','69','70',
     &           '71','72','73','74','75','76','77','78','79','80',
     &           '81','82','83','84','85','86','87','88','89','90',
     &           '91','92','93','94','95','96','97','98','99','00'/
c
c  Make filename
      if(ifile .ne. 0)then
        do 951 i=1,40
          ch1=outfl(i:i)
          if(ch1 .eq. ' ')then
            nltrs=i-1
            go to 952
          endif
 951    continue
 952    continue
        filnam=outfl
c --- Added by Ming Ye on 6/29/2006 ----
c        filnam(nltrs+1:)=nfile(ifile) 
         if(ifile.lt.10) then
           write(ch1,'(i1.1)')ifile
           filnam(nltrs+1:nltrs+1)=ch1                     
         elseif(ifile.lt.100) then
           write(ch2,'(i2.2)')ifile
           filnam(nltrs+1:nltrs+2)=ch2
         elseif(ifile.lt.1000) then
           write(ch3,'(i3.3)')ifile
           filnam(nltrs+1:nltrs+3)=ch3
         else
           write(ch4,'(i4.4)')ifile
           filnam(nltrs+1:nltrs+4)=ch4
         endif          
      else
        filnam=outfl
      endif
      return
      end
c***********************************************************************      
      SUBROUTINE svbksb(u,w,v,m,n,mp,np,b,x)
      INTEGER m,mp,n,np,NMAX
      REAL b(mp),u(mp,np),v(np,np),w(np),x(np)
      PARAMETER (NMAX=500)
      INTEGER i,j,jj
      REAL s,tmp(NMAX)
      do 12 j=1,n
        s=0.
        if(w(j).ne.0.)then
          do 11 i=1,m
            s=s+u(i,j)*b(i)
11        continue
          s=s/w(j)
        endif
        tmp(j)=s
12    continue
      do 14 j=1,n
        s=0.
        do 13 jj=1,n
          s=s+v(j,jj)*tmp(jj)
13      continue
        x(j)=s
14    continue
      return
      END
      subroutine svdbk89(u,w,v,neq,MEQ,b,x)
      real b(MEQ),u(MEQ,MEQ),v(MEQ,MEQ),w(MEQ),x(MEQ)
      real tmp(500)
      do 10 j=1,neq
        tmp(j)=0.
        if(w(j).ne.0.)then
          do 20 i=1,neq
20          tmp(j)=tmp(j)+u(i,j)*b(i)
          tmp(j)=tmp(j)/w(j)
        endif
10    continue
      do 30 j=1,neq
        x(j)=0.
        do 30 jj=1,neq
30        x(j)=x(j)+v(j,jj)*tmp(jj)
      return
      END
  
        subroutine vtally(r,ixyz,ldbg,p,ncat)
c       tallys a distribution
        dimension p(*)
        integer rd(10)
        save rd
        if(ixyz.eq.1)then
          do 10 i=1,ncat
 10         rd(i)=0
        endif
        cut=0.0
        do 20 icut=1,ncat-1
          cut=cut+p(icut)
          if(cut.gt.r)then
            rd(icut)=rd(icut)+1
            go to 99
          endif
 20     continue
        rd(ncat)=rd(ncat)+1
 99     continue 
        write(ldbg,100) (rd(i),i=1,ncat)
 100    format('rand#count=',10i6)
        return
        end
c*************************************************************************   
       subroutine quench 
c-----------------------------------------------------------------------
c                          3-D Simulation                               
c                          **************                               
c                                                                       
c               MAIN ROUTINE TO QUENCH THE SIMULATION                  
c                                                                       
c                                                                       
c                                                                       
c                                                                       
c Author: C.V. Deutsch                      Date: October 1990
C Revised:  S.F. Carle                            April, 1995
c-----------------------------------------------------------------------
	include 'tsim.inc'                                         
comment        print*,' Starting simulated quenching'
        write(ldbg,*) ' Starting simulated quenching'
c                                                                       
c Initialize the starting two point histogram, 
c and objective function:   
c                                                                       
	call tphist                                             
	current = object(0)                                        
	objrsc  = 1.0/amax1(current,0.000001)                       
	current = objrsc*current                                     
c                                                                       
c The random path generation procedure of Srivastava:                   
c                                                                       
	modlus = 1                                               
 1	modlus = modlus * 2                                             
	if(modlus.lt.nxyz) go to 1                                
c                                                                       
c MAIN LOOP TO MAXIMUM NUMBER OF ITERATIONS:                            
c                                                                       
        nit=iabs(maxit)
	do 2 iloop=1,nit                                          
          currold=current
c                                                                       
c MAIN LOOP OVER ALL THE NODES (unless we're done?):              
c                                                                       
c --- Change the random number generator to ran3 by Ming Ye on 6/29/2006 ---               
c          randnu=urand(seed)                               
          randnu=ran3(seed) !Ming Ye
          index = 1 + int(randnu*nxyz)                        
          if(index .gt. nxyz)index=nxyz
          do 3 in=1,nxyz                                      
c
c   check if conditioning data is present at this location
c
            if(sim(index).lt.0)goto 20 
c                                                                       
c Figure out the location of this node:                                 
c                                                                       
            call ind2ixyz(index,nx,nxy,ix,iy,iz)
c                                                                      
c Compute the two point histogram and objective function for rock types:
c                                                                       
            call update                              
            best  = current                                
            ibest = sim(index)                               
            i0=ibest
            do 4 ir=1,ncat                                  
              if(ir.ne.i0) then                 
                objtry = objrsc*object(ir)         
                if(objtry.lt.best) then             
                  best  = objtry               
                  ibest = ir                  
                endif                             
              endif                                     
 4          continue                                        
c                                                                       
c Decide on the best and keep it:                                       
c		                                                    
            if(ibest.ne.i0) then                     
              sim(index) = ibest                       
	      current = best                              
              do 5 ir=1,ncat                           
                do 5 jr=1,ncat                            
                  do 5 id=1,nq                              
                    ntp(ir,jr,id) = ntry(ibest,ir,jr,id) 
 5            continue                                    
            endif                                             
c                                                                    
c Get a new node to consider:                                           
c                                                                       
 20         index = mod(5*index+1,modlus)                       
            if(index.gt.nxyz.or.index.lt.1) go to 20           
c                                                                       
c END MAIN LOOP OVER NODES:                                             
c                                                                       
 3	  continue                                           
c                                                                       
comment          print 100, iloop,current                        
          write(ldbg,100) iloop,current                        
 100      format('    Objective function at pass ',i2,': ',f12.9) 
	  if(current.lt.tol) return                   
          if(current.eq.currold)return
c                                                                       
c END MAIN LOOP OVER MAXIMUM ITERATIONS:                                
c                                                                       
 2	continue                                                  
	return                                                         
	end                                                         
                                                                        
	subroutine update                               
c-----------------------------------------------------------------------
c                                                                       
c       Considering a node - decide on the best value to keep           
c                                                                       
c                                                                       
c                                                                       
c                                                                       
c Author: C.V. Deutsch                                Date: October 1990
c Revised: S.F. Carle                                       April 1995
c-----------------------------------------------------------------------
       include   'tsim.inc'                                     
       ind=ix+(iy-1)*nx+(iz-1)*nxy
       inow = sim(ind)                                      
       d2rad=atan(1.0)/45.
c
c Consider local azimuth and dip
c
       azcos=cos(d2rad*iaz(ind)-azc*d2rad)
       azsin=sin(d2rad*iaz(ind)-azc*d2rad)
       dipsin=sin(d2rad*0.1*idip(ind)-dipc*d2rad)
c                                                                       
c Initialize:                                                           
c                                                             
       do 1 irtry=1,ncat                                            
         do 2 ir=1,ncat                                    
           do 2 jr=1,ncat                                    
             do 2 id=1,nq                                     
               ntry(irtry,ir,jr,id) = ntp(ir,jr,id)  
 2	 continue                                            
 1     continue                                                  
c
c                                                                       
c MAIN LOOP OVER ALL CATEGORIES:                                        
c                                                                       
c Consider the change to all lags and directions:                       
c                                                                       
       do 3 id=1,nq                                      
         dxi=ixl(id)*xsiz  
         dyj=iyl(id)*ysiz  
         dzk=izl(id)*zsiz  
         dxi1=dxi*azcos+dyj*azsin
         dyj1=dyj*azcos-dxi*azsin
         dzk1=dzk+dyj*dipsin
         ii=ix+nint(dxi1/xsiz)
         jj=iy+nint(dyj1/ysiz)
         kk=iz+nint(dzk1/zsiz)
c                                                                       
c      Update the positive lag:                                         
c                                                                       
         if(ii.ge.1.and.ii.le.nx)then
           if(jj.ge.1.and.jj.le.ny)then
             if(kk.ge.1.and.kk.le.nz)then
               ind2=ii+(jj-1)*nx+(kk-1)*nxy
               jval=sim(ind2)
               j=iabs(jval)
               do 10 ir=1,ncat
                 if(ir.ne.inow)then
                   ntry(ir,inow,j,id) = ntry(ir,inow,j,id) - 1        
                   ntry(ir,ir,  j,id) = ntry(ir,ir,  j,id) + 1       
                 endif
 10            continue
             endif
           endif
         endif
c                                                                       
c      Update the negative lag:                                         
c                                                                       
         ii=ix-nint(dxi1/xsiz)
         jj=iy-nint(dyj1/ysiz)
         kk=iz-nint(dzk1/zsiz)
         if(ii.ge.1.and.ii.le.nx)then
           if(jj.ge.1.and.jj.le.ny)then
             if(kk.ge.1.and.kk.le.nz)then
               ind2=ii+(jj-1)*nx+(kk-1)*nxy
               jval=sim(ind2)
               j=iabs(jval)
               do 11 ir=1,ncat
                 if(ir.ne.inow)then
                   ntry(ir,j,inow,id) = ntry(ir,j,inow,id) - 1        
                   ntry(ir,j,ir,  id) = ntry(ir,j,ir,  id) + 1        
                 endif
 11            continue
               endif
             endif
           endif
 3       continue                                           
       return                                                      
       end                                                        
                                                                       
                                                                        
       subroutine tphist                                      
c-----------------------------------------------------------------------
c                                                                       
c Compute a two point histogram of an array "sim" 
c that is nx by ny by nz
c (dimensioned for MAXX by MAXY by MAXZ), 
c for "ncat" rock types, "nq" lags,    
c specified by integer arrays "ixl", "iyl", "izl."    
c Put the result in the "ntp(ncat,ncat,nlag)" array 
c                                                                       
c                                                                       
c-----------------------------------------------------------------------
       include 'tsim.inc'                                          
       d2rad=atan(1.0)/45.
c                                                                       
c Initialize:                                                           
c                                                                       
       do 1 id=1,nq                                                 
  	 do 1 ir=1,ncat                                                
	   do 1 jr=1,ncat                                               
	     ntp(ir,jr,id) = 0                        
	     num(id) = 0                                         
 1     continue                                                       
c                                                                       
c Calculate the Experimental two point histogram:                       
c                                                                       
       ind=0
       do 2 iz=1,nz                                                 
         do 2 iy=1,ny                                                
           do 2 ix=1,nx                                                
             ind=ind+1
c
c Consider local azimuth and dip
c
             azcos=cos(d2rad*iaz(ind)-azc*d2rad)
             azsin=sin(d2rad*iaz(ind)-azc*d2rad)
             dipsin=sin(d2rad*0.1*idip(ind)-dipc*d2rad)
c                                                                       
c Consider the first value and all directions and lags:                 
c                                                                       
             ival=sim(ind)
             i = iabs(ival)                                     
             do 3 id=1,nq                                       
               dxi=ixl(id)*xsiz  
               dyj=iyl(id)*ysiz  
               dzk=izl(id)*zsiz  
               dxi1=dxi*azcos+dyj*azsin
               dyj1=dyj*azcos-dxi*azsin
               dzk1=dzk+dyj*dipsin
               ii=ix+nint(dxi1/xsiz)
               jj=iy+nint(dyj1/ysiz)
               kk=iz+nint(dzk1/zsiz)
               if(ii.ge.1.and.ii.le.nx)then
                 if(jj.ge.1.and.jj.le.ny)then
                   if(kk.ge.1.and.kk.le.nz)then
                     ind2=ii+(jj-1)*nx+(kk-1)*nxy
c                                                                       
c If the second point is within the grid then keep the sample:          
c                                                                       
                     jval=sim(ind2)
	             j = iabs(jval)                              
	             ntp(i,j,id) = ntp(i,j,id)+1  
	             num(id) = num(id) + 1                
                   endif
                 endif
               endif
 3	     continue                                                
 2     continue                                                      
c                                                                       
c Debugging output:                                                     
c                                                                       
       if(idbg.ge.10) then                                        
       do 10 ir=1,ncat                                         
         do 10 jr=1,ncat                                          
           do 10 id=1,nq                                         
c            write(ldbg,100) ir,jr,id,tp(ir,jr,id),
c    +                   float(ntp(ir,jr,id))/float(num(id)) 
 10    continue                                                
 100   format('ir jr ',2i3,' id ',1i3,' tp ',f7.4,' act ',f7.4)   
       endif                                                           
c                                                                       
c Return with the two point histogram:                                  
c                                                                       
       return                                                         
       end                                                             
                                                                        
                                                                        
       real function object(iflag)                                     
c-----------------------------------------------------------------------
c                                                                       
c Compute the objective function,
c    the squared difference betwwen the measured and modeled
c    transition probability     
c                                                                       
c                                                                       
c-----------------------------------------------------------------------
       include 'tsim.inc'                                       
       object = 0.0                                             
c                                                                       
c Loop over all direction vectors and rock codes:                       
c                                                                       
       do 1 id=1,nq                                            
         if(num(id).gt.0) then                         
           add=0.
           if(iflag.eq.0)then
	     do 2 ir=1,ncat                             
               rfac=p(ir)*num(id)
	       do 2 jr=1,ncat                              
                 rnum=ntp(ir,jr,id)/rfac-tp(ir,jr,id)
 2               add=add+rnum*rnum
 	   else                                          
	     do 3 ir=1,ncat                             
               rfac=p(ir)*num(id)
	       do 3 jr=1,ncat                              
                 rnum=ntry(iflag,ir,jr,id)/rfac-tp(ir,jr,id)
 3               add=add+rnum*rnum
           endif                                           
           if(iquench.eq.-1)add=add*det(iordr(id))**2
           object=object+add
         endif                                                   
 1     continue                                                     
c                                                                       
c Return with the objective function:                                   
c                                                                       
       return                                                       
       end                                                             
                                                                        
      subroutine tpmak
      include 'tsim.inc'
c
c  Transfers model tp's into "tp" array
c
      do 1 id=1,nq
        ix=ixl(id)+nhx+1
        iy=iyl(id)+nhy+1
        iz=izl(id)+nhz+1
        ind=ix+(iy-1)*nhx2+(iz-1)*nhxy2
        ij=0
        do 11 ir=1,ncat
          do 11 jr=1,ncat 
            ij=ij+1
            itpxyz=ind+(ij-1)*nh
 11         tp(ir,jr,id)=tpxyz(itpxyz)
 1    continue
c
c  print tp matrix for each quenching lag to debugging file
c
      do 92 iq=1,nq 
        write(ldbg,95)iq
 95     format('TP s for quenching lag ',i2,':')
        do 93 ir=1,ncat
 93       write(ldbg,94) (tp(ir,jr,iq),jr=1,ncat)
 92   continue
 94   format(10f6.3)
c
c  write tp model to debugging file
c
      if(idbg.ge.4)then
        do 2 id=1,nq
          write(ldbg,101) id
            do 2 ir=1,ncat
              write(ldbg,103) (tp(ir,jr,id),jr=1,ncat)
 2      continue
      endif
 101  format('direction=',i2)
 102  format('lag=',i2)
 103  format(16f7.4)
      return
      end
      real function pythag(a,b)
      real a,b
c
c     finds dsqrt(a**2+b**2) without overflow or destructive underflow
c
      real p,r,s,t,u
      p = amax1(abs(a),abs(b))
      if (p .eq. 0.0e0) go to 20
      r = (amin1(abs(a),abs(b))/p)**2
   10 continue
         t = 4.0e0 + r
         if (t .eq. 4.0e0) go to 20
         s = r/t
         u = 1.0e0 + 2.0e0*s
         p = u*p
         r = (s/u)**2 * r
      go to 10
   20 pythag = p
      return
      end
      subroutine svd89(nm,m,n,w,u,v,ierr)
c
      integer i,j,k,l,m,n,i1,k1,l1,mn,nm,its,ierr
      real w(n),u(nm,n),v(nm,n),rv1(500)
      real c,f,g,h,s,x,y,z,tst1,tst2,scale
c
c     this subroutine is a translation of the algol procedure svd,
c     num. math. 14, 403-420(1970) by golub and reinsch.
c     handbook for auto. comp., vol ii-linear algebra, 134-151(1971).
c
c     this subroutine determines the singular value decomposition
c          t
c     a=usv  of a real m by n rectangular matrix.  householder
c     bidiagonalization and a variant of the qr algorithm are used.
c
c     on input
c
c        nm must be set to the row dimension of two-dimensional
c          array parameters as declared in the calling program
c          dimension statement.  note that nm must be at least
c          as large as the maximum of m and n.
c
c        m is the number of rows of a (and u).
c
c        n is the number of columns of a (and u) and the order of v.
c
c        a contains the rectangular input matrix to be decomposed.
c
c     on output
c
c        a is unaltered (unless overwritten by u or v).
c
c        w contains the n (non-negative) singular values of a (the
c          diagonal elements of s).  they are unordered.  if an
c          error exit is made, the singular values should be correct
c          for indices ierr+1,ierr+2,...,n.
c
c        u contains the matrix u (orthogonal column vectors) of the
c          decomposition.
c          If an error exit is made, the columns of u corresponding
c          to indices of correct singular values should be correct.
c
c        v contains the matrix v (orthogonal) of the decomposition. 
c          If an error
c          exit is made, the columns of v corresponding to indices of
c          correct singular values should be correct.
c
c        ierr is set to
c          zero       for normal return,
c          k          if the k-th singular value has not been
c                     determined after 30 iterations.
c
c        rv1 is a temporary storage array.
c
c     Questions and comments should be directed to Alan K. Cline,
c     Pleasant Valley Software, 8603 Altus Cove, Austin, TX 78759.
c     Electronic mail to cline@cs.utexas.edu.
c
c     this version dated january 1989. (for the IBM 3090vf)
c
c     ------------------------------------------------------------------
c
c     call xuflow(0)
      ierr = 0
c
c     .......... householder reduction to bidiagonal form ..........
      g = 0.0e0
      scale = 0.0e0
      x = 0.0e0
c
      do 300 i = 1, n
         l = i + 1
         rv1(i) = scale * g
         g = 0.0e0
         s = 0.0e0
         scale = 0.0e0
         if (i .gt. m) go to 210
c
         do 120 k = i, m
  120    scale = scale + abs(u(k,i))
c
         if (scale .eq. 0.0e0) go to 210
c
         do 130 k = i, m
            u(k,i) = u(k,i) / scale
            s = s + u(k,i)**2
  130    continue
c
         f = u(i,i)
         g = -sign(sqrt(s),f)
         h = f * g - s
         u(i,i) = f - g
c
c"    ( ignore recrdeps
         do 150 j = l, n
            s = 0.0e0
c
            do 140 k = i, m
  140       s = s + u(k,i) * u(k,j)
c
            f = s / h
c
            do 150 k = i, m
               u(k,j) = u(k,j) + f * u(k,i)
  150    continue
c
         do 200 k = i, m
  200    u(k,i) = scale * u(k,i)
c
  210    w(i) = scale * g
         g = 0.0e0
         s = 0.0e0
         scale = 0.0e0
c
         if (i .gt. m .or. i .eq. n) go to 290
c"    ( prefer vector
         do 220 k = l, n
  220    scale = scale + abs(u(i,k))
c
         if (scale .eq. 0.0e0) go to 290
c
         do 230 k = l, n
            u(i,k) = u(i,k) / scale
            s = s + u(i,k)**2
  230    continue
c
         f = u(i,l)
         g = -sign(sqrt(s),f)
         h = f * g - s
         u(i,l) = f - g
c
         do 240 k = l, n
  240    rv1(k) = u(i,k) / h
c
c"    ( ignore recrdeps
         do 260 j = l, m
            s = 0.0e0
c
            do 250 k = l, n
  250       s = s + u(j,k) * u(i,k)
c
            do 260 k = l, n
               u(j,k) = u(j,k) + s * rv1(k)
  260    continue
c
c"    ( prefer vector
         do 280 k = l, n
  280    u(i,k) = scale * u(i,k)
c
  290    x = amax1(x,abs(w(i))+abs(rv1(i)))
  300 continue
c     .......... accumulation of right-hand transformations ..........
c     .......... for i=n step -1 until 1 do -- ..........
      do 400 i = n, 1, -1
         if (i .eq. n) go to 390
         if (g .eq. 0.0e0) go to 360
c
         do 320 j = l, n
c     .......... double division avoids possible underflow ..........
  320    v(j,i) = (u(i,j) / u(i,l)) / g
c
c"    ( ignore recrdeps
         do 350 j = l, n
            s = 0.0e0
c
            do 340 k = l, n
  340       s = s + u(i,k) * v(k,j)
c
            do 350 k = l, n
               v(k,j) = v(k,j) + s * v(k,i)
  350    continue
c
  360    do 380 j = l, n
            v(i,j) = 0.0e0
            v(j,i) = 0.0e0
  380    continue
c
  390    v(i,i) = 1.0e0
         g = rv1(i)
         l = i
  400 continue
c     .......... accumulation of left-hand transformations ..........
c     ..........for i=min(m,n) step -1 until 1 do -- ..........
      mn = n
      if (m .lt. n) mn = m
c
      do 500 i = mn, 1, -1
         l = i + 1
         g = w(i)
         if (i .eq. n) go to 430
c
c"    ( prefer vector
         do 420 j = l, n
  420    u(i,j) = 0.0e0
c
  430    if (g .eq. 0.0e0) go to 475
         if (i .eq. mn) go to 460
c
c"    ( ignore recrdeps
         do 450 j = l, n
            s = 0.0e0
c
            do 440 k = l, m
  440       s = s + u(k,i) * u(k,j)
c     .......... double division avoids possible underflow ..........
            f = (s / u(i,i)) / g
c
            do 450 k = i, m
               u(k,j) = u(k,j) + f * u(k,i)
  450    continue
c
  460    do 470 j = i, m
  470    u(j,i) = u(j,i) / g
c
         go to 490
c
  475    do 480 j = i, m
  480    u(j,i) = 0.0e0
c
  490    u(i,i) = u(i,i) + 1.0e0
  500 continue
c     .......... diagonalization of the bidiagonal form ..........
      tst1 = x
c     .......... for k=n step -1 until 1 do -- ..........
      do 700 k = n, 1, -1
         k1 = k - 1
         its = 0
c     .......... test for splitting.
c                for l=k step -1 until 1 do -- ..........
  520    do 530 l = k, 1, -1
            l1 = l - 1
            tst2 = tst1 + abs(rv1(l))
            if (tst2 .eq. tst1) go to 565
c     .......... rv1(1) is always zero, so there is no exit
c                through the bottom of the loop ..........
            tst2 = tst1 + abs(w(l1))
            if (tst2 .eq. tst1) go to 540
  530    continue
c     .......... cancellation of rv1(l) if l greater than 1 ..........
  540    c = 0.0e0
         s = 1.0e0
c
         do 560 i = l, k
            f = s * rv1(i)
            rv1(i) = c * rv1(i)
            tst2 = tst1 + abs(f)
            if (tst2 .eq. tst1) go to 565
            g = w(i)
c--            h = pythag(f,g)
            if (abs(f).gt.abs(g)) then
               h = abs(f)*sqrt(1e0+(g/f)**2)
            else if (g.ne.0e0) then
               h = abs(g)*sqrt((f/g)**2+1e0)
            else
               h = abs(f)
            endif
            w(i) = h
            c = g / h
            s = -f / h
            do 550 j = 1, m
               y = u(j,l1)
               z = u(j,i)
               u(j,l1) = y * c + z * s
               u(j,i) = -y * s + z * c
  550       continue
c
  560    continue
c     .......... test for convergence ..........
  565    z = w(k)
         if (l .eq. k) go to 650
c     .......... shift from bottom 2 by 2 minor ..........
         if (its .eq. 30) go to 1000
         its = its + 1
         x = w(l)
         y = w(k1)
         g = rv1(k1)
         h = rv1(k)
         f = 0.5e0 * (((g + z) / h) * ((g - z) / y) + y / h - h / y)
c**         g = pythag(f,1.0d0)
         if (abs(f).gt.1.0e0) then
            g = abs(f)*sqrt(1e0+(1.0e0/f)**2)
         else
            g = sqrt(f**2+1e0)
         endif
         f = x - (z / x) * z + (h / x) * (y / (f + sign(g,f)) - h)
c     .......... next qr transformation ..........
         c = 1.0e0
         s = 1.0e0
c
         do 600 i1 = l, k1
            i = i1 + 1
            g = rv1(i)
            y = w(i)
            h = s * g
            g = c * g
c--            z = pythag(f,h)
            if (abs(f).gt.abs(h)) then
               z = abs(f)*sqrt(1e0+(h/f)**2)
            else if (h.ne.0e0) then
               z = abs(h)*sqrt((f/h)**2+1e0)
            else
               z = abs(f)
            endif
            rv1(i1) = z
            c = f / z
            s = h / z
            f = x * c + g * s
            g = -x * s + g * c
            h = y * s
            y = y * c
c
            do 570 j = 1, n
               x = v(j,i1)
               z = v(j,i)
               v(j,i1) = x * c + z * s
               v(j,i) = -x * s + z * c
  570       continue
c
c--            z = pythag(f,h)
            if (abs(f).gt.abs(h)) then
               z = abs(f)*sqrt(1e0+(h/f)**2)
            else if (h.ne.0e0) then
               z = abs(h)*sqrt((f/h)**2+1e0)
            else
               z = abs(f)
            endif
            w(i1) = z
c     .......... rotation can be arbitrary if z is zero ..........
            if (z .eq. 0.0e0) go to 580
            c = f / z
            s = h / z
  580       f = c * g + s * y
            x = -s * g + c * y
            do 590 j = 1, m
               y = u(j,i1)
               z = u(j,i)
               u(j,i1) = y * c + z * s
               u(j,i) = -y * s + z * c
  590       continue
  600    continue
c
         rv1(l) = 0.0e0
         rv1(k) = f
         w(k) = x
         go to 520
c     .......... convergence ..........
  650    if (z .ge. 0.0e0) go to 700
c     .......... w(k) is made non-negative ..........
         w(k) = -z
c
         do 690 j = 1, n
  690    v(j,k) = -v(j,k)
c
  700 continue
c
      go to 1001
c     .......... set error -- no convergence to a
c                singular value after 30 iterations ..........
 1000 ierr = k
 1001 return
      end
c***************************************************************************      
      real function urand(iy)
      integer  iy
c
c      urand is a uniform random number generator based  on  theory  and
c  suggestions  given  in  d.e. knuth (1969),  vol  2.   the integer  iy
c  should be initialized to an arbitrary integer prior to the first call
c  to urand.  the calling program should  not  alter  the  value  of  iy
c  between  subsequent calls to urand.  values of urand will be returned
c  in the interval (0,1).
c
      integer  ia,ic,itwo,m2,m,mic
      double precision  halfm
      real  s
      double precision  datan,dsqrt
      data m2/0/,itwo/2/
      if (m2 .ne. 0) go to 20
c
c  if first entry, compute machine integer word length
c
      m = 1
   10 m2 = m
      m = itwo*m2
      if (m .gt. m2) go to 10
      halfm = m2
c
c  compute multiplier and increment for linear congruential method
c
      ia = 8*idint(halfm*datan(1.d0)/8.d0) + 5
      ic = 2*idint(halfm*(0.5d0-dsqrt(3.d0)/6.d0)) + 1
      mic = (m2 - ic) + m2
c
c  s is the scale factor for converting to floating point
c
      s = 0.5/halfm
c
c  compute next random number
c
   20 iy = iy*ia
c
c  the following statement is for computers which do not allow
c  integer overflow on addition
c
      if (iy .gt. mic) iy = (iy - m2) - m2
c
      iy = iy + ic
c
c  the following statement is for computers where the
c  word length for addition is greater than for multiplication
c
      if (iy/2 .gt. m2) iy = (iy - m2) - m2
c
c  the following statement is for computers where integer
c  overflow affects the sign bit
c
      if (iy .lt. 0) iy = (iy + m2) + m2
      urand = float(iy)*s
      return
      end
c******************************************************************************      
c     The subroutine is copied from numerical recipe
      FUNCTION ran3(idum)
c     Returns a uniform random deviate between 0.0 and 1.0. Set idum to any negative value
c     to initialize or reinitialize the sequence.
      INTEGER idum
      INTEGER MBIG,MSEED,MZ
C     REAL MBIG,MSEED,MZ
      REAL ran3,FAC
      PARAMETER (MBIG=1000000000,MSEED=161803398,MZ=0,FAC=1./MBIG)
C     PARAMETER (MBIG=4000000.,MSEED=1618033.,MZ=0.,FAC=1./MBIG)
c     According to Knuth, any large mbig, and any smaller (but still large) mseed can be substituted
c     for the above values.
      INTEGER i,iff,ii,inext,inextp,k
      INTEGER mj,mk,ma(55) !The value 55 is special and should not be modified; see Knuth.
C     REAL mj,mk,ma(55) 
      SAVE iff,inext,inextp,ma
      DATA iff /0/
      
      if(idum.lt.0.or.iff.eq.0)then !Initialization.
        iff=1
        mj=abs(MSEED-abs(idum)) !Initialize ma(55) using the seed idum and the large number mseed.
        mj=mod(mj,MBIG) 
        ma(55)=mj
        mk=1
        do i=1,54 !Now initialize the rest of the table,
           ii=mod(21*i,55) !in a slightly random order,
           ma(ii)=mk       !with numbers that are not especially random.
           mk=mj-mk
           if(mk.lt.MZ)mk=mk+MBIG
           mj=ma(ii)
        enddo
        do k=1,4 !We randomize them by “warming up the generator.”
           do i=1,55
              ma(i)=ma(i)-ma(1+mod(i+30,55))
              if(ma(i).lt.MZ)ma(i)=ma(i)+MBIG
           enddo
        enddo
        inext=0 !Prepare indices for our first generated number.
        inextp=31 !The constant 31 is special; see Knuth.
        idum=1
      endif
      inext=inext+1 !Here is where we start, except on initialization. Increment
      if(inext.eq.56)inext=1 !inext, wrapping around 56 to 1.
      inextp=inextp+1 !Ditto for inextp.
      if(inextp.eq.56)inextp=1
      mj=ma(inext)-ma(inextp) !Now generate a new random number subtractively.
      if(mj.lt.MZ)mj=mj+MBIG !Be sure that it is in range.
      ma(inext)=mj !Store it,
      ran3=mj*FAC !and output the derived uniform deviate.
      
      return
      END      
c**********************************************************************
c     The subroutine is copied from numerical recipe
      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,
     * NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
c     “Minimal” random number generator of Park and Miller with Bays-Durham shuffle and
c     added safeguards. Returns a uniform random deviate between 0.0 and 1.0 (exclusive of
c     the endpoint values). Call with idum a negative integer to initialize; thereafter, do not
c     alter idum between successive deviates in a sequence. RNMX should approximate the largest
c     floating value that is less than 1.
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then !Initialize.
         idum=max(-idum,1) !Be sure to prevent idum = 0.
         do j=NTAB+8,1,-1 !Load the shuffle table (after 8 warm-ups).
            k=idum/IQ
            idum=IA*(idum-k*IQ)-IR*k
            if (idum.lt.0) idum=idum+IM
            if (j.le.NTAB) iv(j)=idum
         enddo
         iy=iv(1)
      endif
      k=idum/IQ !Start here when not initializing.
      idum=IA*(idum-k*IQ)-IR*k !Compute idum=mod(IA*idum,IM) without overflows by
      if (idum.lt.0) idum=idum+IM !Schrage’s method.
      j=1+iy/NDIV !Will be in the range 1:NTAB.
      iy=iv(j) !Output previously stored value and refill the shuffle table.
      iv(j)=idum
      ran1=min(AM*iy,RNMX) !Because users don’t expect endpoint values.
      
      return
      END      
