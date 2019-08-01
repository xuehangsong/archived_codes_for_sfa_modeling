c     
c     "include" file for MCMOD.F
c
c      Sets array dimensions and common variables.
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
c
c        Parameters:
c
c             MCAT = maximum # of categories
c             MLAG = maximum # of lags for 3-D Markov chain model
c             MDAT = maximum # of elements in 3-D Markov chain model
c             MW   = 1/2 maximum # of off-diagonal elements in a 
c                    transition matrix; used for maximum entropy model
c             MW2, MW3 = other array settings for maximum entropy model 
c 
c        NOTE: 3-D Markov chain model array will contain 
c              MDAT=MCAT*MCAT*MLAG real*4 values.  All other arrays
c              are fairly small. 
c
      parameter (MCAT=5,MLAG=270000)
      parameter (MDAT=MCAT*MCAT*MLAG)
      parameter (MW=(MCAT*MCAT-MCAT)/2,MW2=MW-MCAT,MW3=MW2+1)
      parameter (ldbg=9)
      real p(MCAT),rd(3,MCAT,MCAT)
      common /lags/  dhx,dhy,dhz,nhx,nhy,nhz
      common /pars/  p,ncat,ibkgr
      common /rates/ rd
