c
c    gameas.inc
c
c    Sets array dimensions and common variables.
c
C
C  Steven F. Carle
C  Version 2.1 June, 1999 
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
C  Portions of 'gameas.inc' have incorporated or been modified from
C  the Geostatistical Software Library (GSLIB).  Therefore, ALL
C  COPIES AND MODIFICATIONS OF 'gameas.inc' SHOULD ALSO HONOR THE GSLIB
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
c-----------------------------------------------------------------------
c
c      Bivariate Spatial Statistics of Irregularly Spaced 3-D Data
c      ***********************************************************
c
c The following Parameters control static dimensioning within gamv3:
c
c   MAXDAT    maximum number of data points
c   MAXVAR    maximum number of variables
c   MAXVARI   maximum number of variables + 3
c
c   MAXDIR    maximum number of directions possible at one time
c   MAXLAG    maximum number of lags at one time
c   MXVARG    maximum number of variograms possible at one time
c
c   MXDLV     MAXDIR*MAXLAG*MXVARG - used for dimensioning
c   EPSLON    a small number to avoid dividing by zero
c
c-----------------------------------------------------------------------
c
c User Adjustable:
c
      parameter(MAXDAT = 20000,
     +          MAXVAR =    11,
     +          MAXDIR =    1,
     +          MAXLAG =   1000,
     +          MXVARG =   100  )
c
c Fixed:
c
      parameter(MAXLG=MAXLAG+2,MXDLV=MAXDIR*MAXLG*MXVARG,
     +          MAXVARI=MAXVAR+3,
     +          EPSLON=0.00001, VERSION=10.97)
