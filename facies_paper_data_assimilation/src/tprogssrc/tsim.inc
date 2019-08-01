c     
c   Include file for 'tsim.f'
c
c   Declares array dimensions and common variables and arrays.
c
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
C
C  Portions of 'tsim.inc' have incorporated or been modified from      
C  the Geostatistical Software Library (GSLIB).  Therefore, ALL         
C  COPIES AND MODIFICATIONS OF 'tsim.inc' SHOULD ALSO HONOR THE GSLIB  
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
c-----------------------------------------------------------------------
c
c Parameters controlling static dimensioning of TSIM:
c
c   MXYZ      maximum number of nodes in simulation
c   MCAT      maximum number of categories 
c   MLAG      maximum number of lags in 3-D transition probability model
C   MND       maximum number of data used in cokriging estimates
c   MQ        maximum number of quenching lags
c
c-----------------------------------------------------------------------
c
c User adjustable array dimensions:
c
      parameter(MXYZ=3500000,
     +          MCAT=4,   
     +          MLAG=8000000,
     +          MND=12,
     +          MQ=200)
c
c Fix other array dimensions:
c
      parameter(MEQ=MND*MCAT, 
     +          MLAGTP=MLAG*MCAT*MCAT,
     +          MEQQ=MQ*MCAT)
c
c  Variables:
c
c --- Changed by Ming Ye on 7/26/2007 ---
c      integer*4 seed
      integer seed
c --- End of modification ---      
      character*40 datfl,outfl,dbgfl,tpfl,detfl,azfl,dipfl
      logical testfl,testfldip,testflaz
c
c  Arrays:
c
      integer ilucnd(MND),ivcnd(MND),
     +        ixcnd(MND),iycnd(MND),izcnd(MND),
     +        nt(5),ns(3),iordr(MLAG),
     +        ixl(0:MQ),iyl(0:MQ),izl(0:MQ),
     +        ntry(MCAT,MCAT,MCAT,0:MQ),ntp(MCAT,MCAT,0:MQ),num(0:MQ)
      real rdat(MCAT),
     +     v(MCAT),p(MCAT),
     +     tpxyz(MLAGTP),det(MLAG),
     +     A(MEQ,MEQ),r(MEQ),indx(MEQ),b(MCAT,MCAT),Acopy(MEQ,MEQ),
     +     w(MEQ),vv(MEQ,MEQ),xx(MEQ),
     +     ptal(MCAT,-151:251),
     +     tp(MCAT,MCAT,MQ),
     +     aq(MEQQ,MEQQ),rq(MEQQ),xq(MEQQ),
     +     wq(MEQQ),vvq(MEQQ,MEQQ)
c
c  Large Integer Arrays
c
c  The use must modify the variable type to suit the computer system.
c
c  To save on RAM, disk space, and I/O time, try to use
c  a 1-byte integer variable type for the arrays sim, idip, and iaz.
C  However, 'integer*1' is not ANSI standard FORTRAN.
c  Use 'integer*1' on DEC or SGI systems.
c  Use 'logical*1' on SUN system.
c  Otherwise, be a hog and use 'integer*2' or 'integer*4.'
c      
c --- Changed by Ming Ye on 6/29/2006 ---
c      logical*1 sim(MXYZ),idip(MXYZ),iaz(MXYZ)
      integer sim(MXYZ),idip(MXYZ),iaz(MXYZ)
c
c Standard Common Blocks:
c
      common /output/ iform
      common /grid/   nx,ny,nz,nxy,nxyz,xsiz,ysiz,zsiz,xmn,ymn,zmn,
     &                nx1,ny1,nz1
      common /locate/ index,ix,iy,iz,xc,yc,zc 
      common /data/   ndat,ncat,rdat,dz,dp,nvarsq
      common /logic/  testfl,testfldip,testflaz
      common /simula/ nsim,seed,sim,isim
      common /filnum/ ldbg,lin,lout,idbg
      common /search/ ndmin,ndmax,det,iordr 
      common /closed/ ncnd,ilucnd,ixcnd,iycnd,izcnd,ivcnd
      common /probab/ p,v 
      common /tpdim/  nhx,nhy,nhz,nhx2,nhy2,nhz2,nhxy,nhxy2,nh
      common /tpmod/  tpxyz,nt,ns
      common /matrix/ A,r,indx,b,ibkgr,icoik,Acopy,w,vv,xx 
      common /files/  datfl,outfl,dbgfl,tpfl,detfl,azfl,dipfl
      common /orv/    iorv0,iorv1,iorvs,orv0,orv1,orvs
      common /estat/  phard,psimple,pstd,ptrad,ptal
      common /svd/    wratio
      common /texe/   tsearch,tcokrig,tsvdcmp,tquench
      common /quen/   maxit,tol,iquench,nq,ql,ixl,iyl,izl,
     +                np,num,ntry,ntp,tp,aq,rq,xq,wq,vvq
      common /angle/  azc,dipc,az,dip,iaz,idip
      common /trig/   azcos,azsin,dipcos,dipsin
      common /trigc/  azccos,azcsin,dipccos,dipcsin
