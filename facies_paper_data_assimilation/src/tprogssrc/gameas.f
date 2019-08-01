      program gameas
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
C  Portions of 'gameas.f' have incorporated or been modified from
C  the Geostatistical Software Library (GSLIB).  Therefore, ALL
C  COPIES AND MODIFICATIONS OF 'gameas.f' SHOULD ALSO HONOR THE GSLIB
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
C
C#######################################################################
C
C  Revised 2/97 by S.F. Carle to enable calculation of
C  
C               11.  transition probability
C               12.  joint probability
C 
C  and to generate output file in GEOEAS format
C
C#######################################################################
c
c               Variogram of Irregularly Spaced 3-D Data
c               ****************************************
c
c This is a template driver program for GSLIB's "gamv3" subroutine. The
c input data must be entered with coordinates in a GEOEAS format file.
c The User's Guide can be referred to for more details.
c
c
c
c The program is executed with no command line arguments.  The user
c will be prompted for the name of a parameter file.  The parameter
c file is described in the documentation (see the example gamv3.par)
c and should contain the following information:
c
c   -  name of the data file (GEOEAS format)
c   -  column numbers for the x,y and z coordinates
c   -  number of variables, and the column number of each variable.
c   -  minimum acceptable value (used to flag missing values)
c   -  name of an output file (may be overwritten)
c   -  the number of lags
c   -  the unit lag separation distance
c   -  the number of directions to consider
c   -  the next ndir lines should contain six values: an azimuth, an
c        azimuth tolerance, a horizontal bandwidth, a dip, a dip
c        tolerance, and a vertical bandwidth.  For example, the line
c        0.0,22.5,20.0,-30.0,15.0,10.0  would specify a north-south
c        variogram, a horizontal half-window of 22.5 degrees, a maximum
c        horizontal bandwidth deviation of 20.0 units, a dip of 30
c        degrees down, a dip tolerance +/- 15 (i.e., between -5 degrees
c        and -45 degrees), and a maximum bandwidth deviation from the 
c        -30 degree dip of 10.0 units.
c   -  nvarg - the number of variograms to compute
c   -  the following nvarg lines should have three integer values:
c        a) the variable number for the tail of the variogram pair
c        b) the variable number for the head of the variogram pair
c        c) an integer code of the variogram type to calculate:
c                      1. semivariogram
c                      2. cross-semivariogram
c                      3. covariance
c                      4. correlogram
c                      5. general relative semivariogram
c                      6. pairwise relative semivariogram
c                      7. semivariogram of logarithms
c                      8. rodogram
c                      9. madogram
c                     10. indicator semivariogram
c                     11. transition probability
c                     12. joint probability
c        d) the cutoff if an indicator semivariogram is requested
c
c
c
c The output file will contain each directional variogram ordered by
c direction and then variogram (the directions cycle fastest then the
c variogram number).  For each variogram there will be a one line
c description and then "nlag" lines with the following:
c
c        a) lag number (increasing from 1 to nlag)
c        b) separation distance
c        c) the "variogram" value                                      
c        d) the number of pairs for the lag
c        e) the mean of the data contributing to the tail
c        f) the mean of the data contributing to the head
c
c
c
c Original: C.V. Deutsch                                 Date: July 1990
c-----------------------------------------------------------------------
      include  'gameas.inc'
      real      x(MAXDAT),y(MAXDAT),z(MAXDAT),vr(MAXDAT,MAXVAR),
     +          azm(MAXDIR),atol(MAXDIR),bandwh(MAXDIR),dip(MAXDIR),
     +          dtol(MAXDIR),bandwd(MAXDIR)
      real*8    dis(MXDLV),gam(MXDLV),hm(MXDLV),tm(MXDLV),hv(MXDLV),
     +          tv(MXDLV),np(MXDLV),avg(MAXVAR)
      integer   ivtail(MXVARG),ivhead(MXVARG),ivtype(MXVARG)
      character outfl*40,names(MAXVAR)*21
c
c Read the Parameter File:
c
      call readparm(nlag,xlag,xltol,ndir,azm,atol,bandwh,dip,dtol,
     +     bandwd,nd,x,y,z,vr,tmin,tmax,nvarg,ivtail,ivhead,ivtype,
     +     outfl,names,avg,nvar)
c
c Call gamv3 to compute the required variograms:
c
      call gamv3(nd,x,y,z,vr,tmin,tmax,nlag,xlag,xltol,ndir,azm,atol,
     +           bandwh,dip,dtol,bandwd,nvarg,ivtail,ivhead,
     +           ivtype,np,dis,gam,hm,tm,hv,tv)
c
c Write Results and stop:
c
      call writeout(nlag,ndir,nvarg,ivtail,ivhead,ivtype,np,dis,gam,
     +              hm,tm,hv,tv,outfl,names,avg,nvar)
      stop
      end
 
 
 
      subroutine readparm(nlag,xlag,xltol,ndir,azm,atol,bandwh,dip,
     +                   dtol,bandwd,nd,x,y,z,vr,tmin,tmax,nvarg,
     +                   ivtail,ivhead,ivtype,outfl,names,avg,nvar)
c-----------------------------------------------------------------------
c
c                  Initialization and Read Parameters
c                  **********************************
c
c The input parameters and data are read in from their files. Some quick
c error checking is performed and the statistics of all the variables
c being considered are written to standard output.
c
c
c
c Original: C.V. Deutsch                                 Date: July 1990
c-----------------------------------------------------------------------
      include  'gameas.inc'
      real      x(MAXDAT),y(MAXDAT),z(MAXDAT),vr(MAXDAT,MAXVAR),
     +          azm(MAXDIR),atol(MAXDIR),bandwh(MAXDIR),dip(MAXDIR),
     +          dtol(MAXDIR),bandwd(MAXDIR),var(MAXVARI),cut(MXVARG)
      real*8    avg(MAXVAR),ssq(MAXVAR)
      real      vrmin(MAXVAR),vrmax(MAXVAR)
      integer   ivtail(MXVARG),ivhead(MXVARG),ivtype(MXVARG),
     +          ivar(MAXVAR),num(MAXVAR),ivc(MXVARG)
      character datafl*40,outfl*40,str*40,names(MAXVAR)*21
      logical   testfl
      data      lin/1/,ncut/0/
c
c Note VERSION number:
c
comment      write(*,9999) VERSION
 9999 format(/' GAMV3M Version: ',f5.3/)
c
c Get the name of the parameter file - try the default name if no input:
c
c     Xuehang Song 03/01/2015
C$$$      write(*,*) 'Which parameter file do you want to use?'
C$$$      read (*,'(a40)') str
C$$$      if(str(1:1).eq.' ')str='gamv3.par                               '
C$$$      inquire(file=str,exist=testfl)
C$$$      if(.not.testfl) then
C$$$            write(*,*) 'ERROR - the parameter file does not exist,'
C$$$            write(*,*) '        check for the file and try again  '
C$$$            stop
C$$$      endif
c-------------------------------------------------
c      str='gameas_x.par'
      call getarg(1,str)

      inquire(file=str,exist=testfl)
      if(.not.testfl) then
            write(*,*) 'ERROR - the parameter file does not exist,'
            write(*,*) '        check for the file and try again  '
            stop
      endif
      open(lin,file=str,status='OLD')


c Find Start of Parameters:
c
 1    read(lin,'(a4)',end=98) str(1:4)
      if(str(1:4).ne.'STAR') go to 1
c
c Read Input Parameters:
c
      read(lin,'(a40)',err=98) datafl
      
c  xuehang song 03\01\2015
c-----------------------------------------------------------
c      datafl='true.eas'
      call getarg(2,datafl)

comment      write(*,*) ' data file:           ',datafl
      read(lin,*,err=98)       ixl,iyl,izl
comment      write(*,*) ' columns for X,Y,Z:   ',ixl,iyl,izl
      read(lin,*,err=98)       nvar
comment      write(*,*) ' number of variables: ',nvar
      backspace lin
      read(lin,*,err=98)       j,(ivar(i),i=1,nvar)
comment      write(*,*) ' columns:             ',(ivar(i),i=1,nvar)
      read(lin,*,err=98)       tmin,tmax
comment      write(*,*) ' trimming limits:     ',tmin,tmax
      read(lin,'(a40)',err=98) outfl
c xuehang song 03\01\2015
c-----------------------------------------------------------
c      outfl='tp_x.eas'
c      call getarg(3,outfl)


comment      write(*,*) ' output file:         ',outfl
      read(lin,*,err=98)       nlag
comment      write(*,*) ' number of lags:      ',nlag
      read(lin,*,err=98)       xlag
comment      write(*,*) ' lag distance:        ',xlag
      read(lin,*,err=98)       xltol
comment      write(*,*) ' lag tolerance:       ',xltol
      read(lin,*,err=98)       ndir
comment      write(*,*) ' number of directions:',ndir
      do 2 i=1,ndir
            read(lin,*,err=98)       azm(i),atol(i),bandwh(i),
     +                               dip(i),dtol(i),bandwd(i)
comment            write(*,*) ' azm, atol, bandwh:   ',azm(i),atol(i),bandwh(i)
comment            write(*,*) ' dip, dtol, bandwd:   ',dip(i),dtol(i),bandwd(i)
            if(bandwh(i).lt.0.0) then
                  write(*,*) ' Horizontal bandwidth is too small!'
                  stop
            endif
            if(bandwd(i).lt.0.0) then
                  write(*,*) ' Vertical bandwidth is too small!'
                  stop
            endif
 2    continue
      read(lin,*,err=98)       nvarg
comment      write(*,*) ' number of variograms:',nvarg
      do 3 i=1,nvarg
            read(lin,*,err=98) ivtail(i),ivhead(i),ivtype(i)
comment            write(*,*) ' tail,head,type:    ',
comment     +                   ivtail(i),ivhead(i),ivtype(i)
            if(ivtype(i).eq.10) then
                   ncut = ncut + 1
                   if((nvar+ncut).gt.MAXVAR) then
                         write(*,*) ' Too many indicator cutoffs!'
                         write(*,*) ' use fewer or increase MAXVAR'
                         stop
                   endif
                   backspace lin
                   read(lin,*,err=98) ii,jj,kk,cut(ncut)
                   ivc(ncut) = ivtail(i)
                   ivtail(i) = nvar + ncut
                   ivhead(i) = nvar + ncut
                   write(names(nvar+ncut),140) ncut
 140               format('Indicator ',i2)
comment                   write(*,*) ' indicator cutoff:  ',cut(ncut)
            endif
 3    continue
comment      write(*,*)
      close(lin)
c
c Perform some quick error checking:
c
      if(ndir.lt.1)       stop 'ndir is too small: check parameters'
      if(ndir.gt.MAXDIR)  stop 'ndir is too big: check gameas.inc'
      if(nvar.lt.1)       stop 'nvar is too small: check parameters'
      if(nvar.gt.MAXVAR)  stop 'nvar is too big: check gameas.inc'
      if(nlag.lt.1)       stop 'nlag is too small: check parameters'
      if(nlag.gt.MAXLAG)  stop 'nlag is too big: check gameas.inc'
      if(nvarg.lt.1)      stop 'nvarg is too small: check parameters'
      if(nvarg.gt.MXVARG) stop 'nvarg is too big: check gameas.inc'
      if(ncut.ge.1) then
            if(tmin.gt.0.0) stop 'tmin interferes with indicators!'
            if(tmax.le.1.0) stop 'tmax interferes with indicators!'
      endif
      if(xlag.le.0.0) stop 'xlag is too small: check parameter file'
      if(xltol.le.0.0) then
            write(*,*) 'xltol is too small: resetting to xlag/2'
            xltol = 0.5*xlag
      endif
c
c Check to make sure the data file exists, then either read in the
c data or write an error message and stop:
c
      inquire(file=datafl,exist=testfl)
      if(testfl) then
c
c The data file exists so open the file and read in the header
c information. Initialize the storage that will be used to summarize
c the data found in the file:
c
            open(lin,file=datafl,status='OLD')
            read(lin,'(a40)',err=99) str
            read(lin,*,err=99)       nvari
            do 6 i=1,nvari
                  read(lin,'(a40)',err=99) str
                  do 6  iv=1,nvar
                        j=ivar(iv)
                        if(i.eq.j) names(iv) = str(1:21)
 6          continue
            do 60 i=1,nvar
              num(i) = 0
              avg(i) = 0.0
              ssq(i) = 0.0
 60         continue
c
c Read all the data until the end of the file:
c
            nd = 0
            do 7 i=1,MAXDAT
                  read(lin,*,end=9,err=99) (var(j),j=1,nvari)
                  nd   = nd + 1
                  x(i) = var(ixl)
                  y(i) = var(iyl)
                  if(izl.le.0) then
                        z(i) = 0.0
                  else
                        z(i) = var(izl)
                  endif
                  do 8 iv=1,nvar
                        j=ivar(iv)
                        vr(i,iv) = var(j)
                        if(var(j).ge.tmin.and.var(j).lt.tmax) then
                              num(iv) = num(iv) + 1
                              avg(iv) = avg(iv) + dble(var(j))
                              ssq(iv) = ssq(iv) + dble(var(j)*var(j))
                        endif
 8                continue
 7          continue
            write(*,*) 'WARNING: Exceeded available memory for data'
 9          close(lin)
c
c Compute the averages and variances as an error check for the user:
c
            do 10 iv=1,nvar
                  if(num(iv).gt.0) then
                        avg(iv) = avg(iv) / dble(num(iv))
                        ssq(iv) =(ssq(iv) / dble(num(iv)))
     +                          - avg(iv) * avg(iv)
comment                        write(*,*) 'Variable number ',iv
comment                        write(*,*) '  Number   = ',num(iv)
comment                        write(*,*) '  Mean     = ',real(avg(iv))
comment                        write(*,*) '  Variance = ',real(ssq(iv))
                  endif
 10         continue
      else
            write(*,*) 'ERROR data file ',datafl,' does not exist!'
            stop
      endif
c
c Construct Indicator Variables if necessary:
c
      do 11 ic=1,ncut
            iv = ivc(ic)
            jv = nvar + ic
            do 12 id=1,nd
                  if(vr(id,iv).le.tmin.or.vr(id,iv).gt.tmax) then
                        vr(id,jv) = tmin - EPSLON
                  else if(vr(id,iv).lt.cut(ic)) then
                        vr(id,jv) = 0.0
                  else
                        vr(id,jv) = 1.0
                  endif
 12         continue
 11   continue
c
c Establish minimums and maximums:
c
      do 50 i=1,MAXVAR
            vrmin(i) =  1.0e21
            vrmax(i) = -1.0e21
 50   continue
      do 51 id=1,nd
      do 51 iv=1,nvar+ncut
            if(vr(id,iv).lt.tmin.or.
     +         vr(id,iv).ge.tmax)      go to 51
            if(vr(id,iv).lt.vrmin(iv)) vrmin(iv) = vr(id,iv)
            if(vr(id,iv).gt.vrmax(iv)) vrmax(iv) = vr(id,iv)
 51   continue
c
c Check on the variogams that were requested:
c
      call check(nvarg,ivtail,ivhead,ivtype,vrmin,vrmax,names,MAXVAR)
      return
c
c Error in an Input File Somewhere:
c
 98   stop 'ERROR in parameter file!'
 99   stop 'ERROR in data file!'
      end
 
 
 
      subroutine writeout(nlag,ndir,nvarg,ivtail,ivhead,ivtype,np,dis,
     +                    gam,hm,tm,hv,tv,outfl,names,avg,nvar)
c-----------------------------------------------------------------------
c
c                  Write Out the Results of GAMV3
c                  ******************************
c
c An output file will be written which contains each directional
c variogram ordered by direction and then variogram (the directions
c cycle fastest then the variogram number).  For each variogram there
c will be a one line description and then "nlag" lines with:
c
c        a) lag number (increasing from 1 to nlag)
c        b) separation distance
c        c) the "variogram" value
c        d) the number of pairs for the lag
c        e) the mean of the data contributing to the tail
c        f) the mean of the data contributing to the head
c        g) IF the correlogram - variance of tail values
c        h) IF the correlogram - variance of head values
c
c
c
c
c
c Original: C.V. Deutsch                                 Date: July 1990
c Revised:  S.F.  Carle                         Feb 1997
c-----------------------------------------------------------------------
      include  'gameas.inc'
      real*8    dis(MXDLV),gam(MXDLV),hm(MXDLV),tm(MXDLV),hv(MXDLV),
     +          tv(MXDLV),np(MXDLV),avg(MAXVAR)
      integer   ivtail(MXVARG),ivhead(MXVARG),ivtype(MXVARG)
      character outfl*40,title*132,names(MAXVAR)*21
      data      lout/1/
c
c Open output file
c
      open(lout,file='gameas.dbg',status='unknown')
      open(2,file=trim(outfl),status='unknown')
c
c Write averages (proportions) on first line
c
      write(2,1000) (avg(ivar),ivar=1,nvar)
 1000 format(20e12.4) 
c
c Write # of columns and lag label
c
      write(2,1010) nvarg+1
      write(2,*) 'lag'
 1010 format(i3)
c
c Loop over all the variograms that have been computed:
c
      do 1 iv=1,nvarg
c
c Construct a title that reflects the variogram type and the variables
c that were used to calculate the variogram:
c
      it = ivtype(iv)
      if(it.eq. 1) title(1:16) = 'Semivariogram   '
      if(it.eq. 2) title(1:16) = 'Cross Semivario.'
      if(it.eq. 3) title(1:16) = 'Covariance      '
      if(it.eq. 4) title(1:16) = 'Correlogram     '
      if(it.eq. 5) title(1:16) = 'General Relative'
      if(it.eq. 6) title(1:16) = 'Pairwise Relat. '
      if(it.eq. 7) title(1:16) = 'Variogram of Log'
      if(it.eq. 8) title(1:16) = 'Rodogram (sqrt) '
      if(it.eq. 9) title(1:16) = 'Madogram (abs)  '
      if(it.eq.10) title(1:16) = 'Indicator Vario '
      if(it.eq.11) title(1:16) = 'Transition Prob '
      if(it.eq.12) title(1:16) = 'Joint Prob      '
      write(title(17:72),100) names(ivtail(iv)),names(ivhead(iv))
 100  format(' tail:',a21,'   head:',a21)
c
c Write tail and head variable and bivariate statistic 
c
      write(2,1020) ivtail(iv),ivhead(iv),title(1:16)
 1020 format(i2,'-',i2,5x,a16)
c
c Loop over all the directions (note the direction in the title):
c
      do 1 id=1,ndir
            write(title(73:80),101) id
 101        format('  dir ',i2)
            write(lout,'(a80)') title(1:80)
c
c Write out all the lags:
c
            do 1 il=1,nlag+1
                  i = (id-1)*nvarg*MAXLG+(iv-1)*MAXLG+il
                  nump = int(np(i))
                  if(it.eq.4) then
                        write(lout,102) il,dis(i),gam(i),nump,
     +                                  tm(i),hm(i),tv(i),hv(i)
                  else
                        write(lout,102) il,dis(i),gam(i),nump,
     +                                  tm(i),hm(i)
                  endif
 102              format(1x,i3,1x,f12.3,1x,f12.5,1x,i8,4(1x,f14.5))
 1    continue
      do 2 id=1,ndir
        do 2 il=1,nlag+1
          ilag = (id-1)*nvarg*MAXLG+il
          write(2,1030) 
     &      dis(ilag),(gam(ilag+(iv-1)*MAXLG),iv=1,nvarg)
 1030     format(1e11.4,100f8.4)
 2    continue
      close(lout)
      return
      end
 
 
 
      subroutine check(nvarg,ivtail,ivhead,ivtype,vrmin,vrmax,
     +                 names,MAXVAR)
c-----------------------------------------------------------------------
c
c                Error Check and Note Variogram Types
c                ************************************
c
c Go through each variogram type and note the type to the screen and
c report any possible errors.
c
c
c
c
c
c Original: C.V. Deutsch                             Date: February 1992
c-----------------------------------------------------------------------
      real      vrmin(*),vrmax(*)
      integer   ivtail(*),ivhead(*),ivtype(*)
      character title*80,names(MAXVAR)*21
c
c Loop over all the variograms to be computed:
c
comment      write(*,*)
      do 1 iv=1,nvarg
c
c Note the variogram type and the variables being used:
c
      it = ivtype(iv)
      if(it.eq. 1) title(1:16) = 'Semivariogram   :'
      if(it.eq. 2) title(1:16) = 'Cross Semivario.:'
      if(it.eq. 3) title(1:16) = 'Covariance      :'
      if(it.eq. 4) title(1:16) = 'Correlogram     :'
      if(it.eq. 5) title(1:16) = 'General Relative:'
      if(it.eq. 6) title(1:16) = 'Pairwise Relat. :'
      if(it.eq. 7) title(1:16) = 'Variogram of Log:'
      if(it.eq. 8) title(1:16) = 'Rodogram (sqrt)i:'
      if(it.eq. 9) title(1:16) = 'Madogram (abs)  :'
      if(it.eq.10) title(1:16) = 'Indicator Vario.:'
      if(it.eq.11) title(1:16) = 'Transition Prob.:'
      if(it.eq.12) title(1:16) = 'Joint Prob.     :'
      write(title(17:70),100) names(ivtail(iv)),names(ivhead(iv))
 100  format(' tail:',a21,' head:',a21)
comment      write(*,101) iv,title(1:70)
 101  format(i2,1x,a70)
c
c Check for possible errors or inconsistencies:
c
      if(it.eq.2) then
            if(ivtail(iv).eq.ivhead(iv)) write(*,201)
 201        format('  WARNING: cross variogram with the same variable!')
      else if(it.eq.5) then
            if(ivtail(iv).ne.ivhead(iv)) write(*,501)
            if(vrmin(ivtail(iv)).lt.0.0.and.vrmax(ivtail(iv)).gt.0.0)
     +            write(*,502)
            if(vrmin(ivhead(iv)).lt.0.0.and.vrmax(ivhead(iv)).gt.0.0)
     +            write(*,502)
 501        format('  WARNING: cross general relative variogram are',
     +             ' difficult to interpret!')
 502        format('  WARNING: there are both positive and negative',
     +             ' values - lag mean could be zero!')
      else if(it.eq.6) then
            if(ivtail(iv).ne.ivhead(iv)) write(*,601)
            if(vrmin(ivtail(iv)).lt.0.0.and.vrmax(ivtail(iv)).gt.0.0)
     +            write(*,602)
            if(vrmin(ivhead(iv)).lt.0.0.and.vrmax(ivhead(iv)).gt.0.0)
     +            write(*,602)
 601        format('  WARNING: cross pairwise relative variogram are',
     +             ' difficult to interpret!')
 602        format('  WARNING: there are both positive and negative',
     +             ' values - pair means could be zero!')
      else if(it.eq.7) then
            if(ivtail(iv).ne.ivhead(iv)) write(*,701)
            if(vrmin(ivtail(iv)).lt.0.0.or.vrmin(ivhead(iv)).lt.0.0)
     +      write(*,702)
 701        format('  WARNING: cross logarithmic variograms may be',
     +             ' difficult to interpret!')
 702        format('  WARNING: there are zero or negative',
     +             ' values - logarithm undefined!')
      else if(it.eq.8) then
            if(ivtail(iv).ne.ivhead(iv)) write(*,801)
 801        format('  WARNING: cross rodograms may be difficult to',
     +             ' interpret!')
      else if(it.eq.9) then
            if(ivtail(iv).ne.ivhead(iv)) write(*,901)
 901        format('  WARNING: cross madograms may be difficult to',
     +             ' interpret!')
      endif
c
c Loop over all variograms:
c
 1    continue
      return
      end
      subroutine gamv3(nd,x,y,z,vr,tmin,tmax,nlag,xlag,xltol,ndir,azm,
     +                 atol,bandwh,dip,dtol,bandwd,nvarg,ivtail,ivhead,
     +                 ivtype,np,dis,gam,hm,tm,hv,tv)
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
c              Variogram of 3-D Irregularly Spaced Data
c              ****************************************
c
c This subroutine computes a variety of spatial continuity measures of a
c set for irregularly spaced data.  The user can specify any combination
c of direct and cross variograms using any of eight "variogram" measures
c
c
c
c INPUT VARIABLES:
c
c   nd               Number of data (no missing values)
c   x(nd)            X coordinates of the data
c   y(nd)            Y coordinates of the data
c   z(nd)            Z coordinates of the data
c   nv               The number of variables
c   vr(nd,nv)        Data values
c   tmin,tmax        Trimming limits
c   nlag             Number of lags to calculate
c   xlag             Length of the unit lag
c   xltol            Distance tolerance (if <0 then set to xlag/2)
c   ndir             Number of directions to consider
c   azm(ndir)        Azimuth angle of direction (measured positive
c                      degrees clockwise from NS).
c   atol(ndir)       Azimuth (half window) tolerances
c   bandwh           Maximum Horizontal bandwidth (i.e., the deviation 
c                      perpendicular to the defined azimuth).
c   dip(ndir)        Dip angle of direction (measured in negative
c                      degrees down from horizontal).
c   dtol(ndir)       Dip (half window) tolerances
c   bandwd           Maximum "Vertical" bandwidth (i.e., the deviation
c                      perpendicular to the defined dip).
c   nvarg            Number of variograms to compute
c   ivtail(nvarg)    Variable for the tail of each variogram
c   ivhead(nvarg)    Variable for the head of each variogram
c   ivtype(nvarg)    Type of variogram to compute:
c                      1. semivariogram
c                      2. cross-semivariogram
c                      3. covariance
c                      4. correlogram
c                      5. general relative semivariogram
c                      6. pairwise relative semivariogram
c                      7. semivariogram of logarithms
c                      8. rodogram
c                      9. madogram
c                     10. indicator semivariogram: an indicator variable
c                         is constructed in the main program.
c                     11. transition probability
c                     12. joint probability
c
c
c
c OUTPUT VARIABLES:  The following arrays are ordered by direction,
c                    then variogram, and finally lag, i.e.,
c                      iloc = (id-1)*nvarg*MAXLG+(iv-1)*MAXLG+il
c
c   np()             Number of pairs
c   dis()            Distance of pairs falling into this lag
c   gam()            Semivariogram, covariance, correlogram,... value
c   hm()             Mean of the head data
c   tm()             Mean of the tail data
c   hv()             Variance of the head data
c   tv()             Variance of the tail data
c
c
c
c PROGRAM NOTES:
c
c   1. The file "gameas.inc" contains the dimensioning parameters.
c      These may have to be changed depending on the amount of data
c      and the requirements to compute different variograms.
c
c
c
c Original:  A.G. Journel                                           1978
c Revisions: K. Guertin                                             1980
c            C.V. Deutsch                                      July 1990
c            S.F. Carle                                 Feb 1997
c-----------------------------------------------------------------------
      include  'gameas.inc'
      parameter(PI=3.14159265)
      real      x(MAXDAT),y(MAXDAT),z(MAXDAT),vr(MAXDAT,MAXVAR),
     +          azm(MAXDIR),atol(MAXDIR),bandwh(MAXDIR),dip(MAXDIR),
     +          dtol(MAXDIR),bandwd(MAXDIR),uvxazm(MAXDIR),
     +          uvyazm(MAXDIR),uvzdec(MAXDIR),uvhdec(MAXDIR),
     +          csatol(MAXDIR),csdtol(MAXDIR)
      real*8    dis(MXDLV),gam(MXDLV),hm(MXDLV),tm(MXDLV),hv(MXDLV),
     +          tv(MXDLV),np(MXDLV)
      integer   ivtail(MXVARG),ivhead(MXVARG),ivtype(MXVARG)
      logical   omni
c
c Define the distance tolerance if it isn't already:
c
      if(xltol.le.0.0) xltol = 0.5 * xlag
c
c Define the angles and tolerance for each direction:
c
      do 1 id=1,ndir
c
c The mathematical azimuth is measured counterclockwise from EW and
c not clockwise from NS as the conventional azimuth is:
c
            azmuth     = (90.0-azm(id))*PI/180.0
            uvxazm(id) = cos(azmuth)
            uvyazm(id) = sin(azmuth)
            if(atol(id).le.0.0) then
                  csatol(id) = cos(45.0*PI/180.0)
            else
                  csatol(id) = cos(atol(id)*PI/180.0)
            endif
c
c The declination is measured positive down from vertical (up) rather
c than negative down from horizontal:
c
            declin     = (90.0-dip(id))*PI/180.0
            uvzdec(id) = cos(declin)
            uvhdec(id) = sin(declin)
            if(dtol(id).le.0.0) then
                  csdtol(id) = cos(45.0*PI/180.0)
            else
                  csdtol(id) = cos(dtol(id)*PI/180.0)
            endif
 1    continue
c
c Initialize the arrays for each direction, variogram, and lag:
c
      nsiz = ndir*nvarg*MAXLG
      if(nsiz.gt.MXDLV) then
            write(*,*) 'ERROR: available storage in gamv3 = ',MXDLV
            write(*,*) '       requested storage          = ',nsiz
            stop
      endif
      do 2 i=1,nsiz
            np(i)  = 0.
            dis(i) = 0.0
            gam(i) = 0.0
            hm(i)  = 0.0
            tm(i)  = 0.0
            hv(i)  = 0.0
            tv(i)  = 0.0
 2    continue
      dismxs = ((real(nlag) + 0.5 - EPSLON) * xlag) ** 2
c
c MAIN LOOP OVER ALL PAIRS:
c
      do 3 i=1,nd
      do 4 j=i,nd
c
c Definition of the lag corresponding to the current pair:
c
            dx  = x(j) - x(i)
            dy  = y(j) - y(i)
            dz  = z(j) - z(i)
            dxs = dx*dx
            dys = dy*dy
            dzs = dz*dz
            hs  = dxs + dys + dzs
            if(hs.gt.dismxs) go to 4
            h   = sqrt(hs)
c
c Determine which lag this is and skip if outside the defined distance
c tolerance:
c
c           if(h.le.EPSLON) then
c                 il = 1
c           else
c                 il = int(h/xlag+0.5) + 2
                  il = nint(h/xlag)+1
c                 if(il.gt.(nlag+2)) go to 4
                  if(il.gt.(nlag+1)) go to 4
c                 if((abs(h-xlag*real(il-2))).gt.xltol) go to 4
                  if((abs(h-xlag*real(il-1))).gt.xltol) go to 4
c           endif
c
c Definition of the direction corresponding to the current pair. All
c directions are considered (overlapping of direction tolerance cones
c is allowed):
c
            do 5 id=1,ndir
c
c Check for an acceptable azimuth angle:
c
                  dxy = sqrt(dxs+dys)
                  if(dxy.lt.EPSLON) then
                        dcazm = 1.0
                  else
                        dcazm = (dx*uvxazm(id)+dy*uvyazm(id))/dxy
                  endif
                  if(abs(dcazm).lt.csatol(id)) go to 5
c
c Check the horizontal bandwidth criteria (maximum deviation 
c perpendicular to the specified direction azimuth):
c
                  band = uvxazm(id)*dy - uvyazm(id)*dx
                  if(abs(band).gt.bandwh(id)) go to 5
c
c Check for an acceptable dip angle:
c
                  if(dcazm.lt.0.0) dxy = -dxy
                  if(il.eq.1) then
                        dcdec = 0.0
                  else
                        dcdec = (dxy*uvhdec(id)+dz*uvzdec(id))/h
                        if(abs(dcdec).lt.csdtol(id)) go to 5
                  endif
c
c Check the vertical bandwidth criteria (maximum deviation perpendicular
c to the specified dip direction):
c
                  band = uvhdec(id)*dz - uvzdec(id)*dxy
                  if(abs(band).gt.bandwd(id)) go to 5
c
c Check whether or not an omni-directional variogram is being computed:
c
                  omni = .false.
                  if(atol(id).gt.90.0) omni = .true.
c
c This direction is acceptable - go ahead and compute all variograms:
c
                  do 6 iv=1,nvarg
c
c For this variogram, sort out which is the tail and the head value:
c
                      it = ivtype(iv)
                      if(dcazm.ge.0.0.and.dcdec.ge.0.0) then
                            ii = ivtail(iv)
                            vrt   = vr(i,ii)
                            vrtpr = vr(j,ii)
                            ii = ivhead(iv)
                            vrh   = vr(j,ii)
                            vrhpr = vr(i,ii)
                      else
                            ii = ivtail(iv)
                            vrt = vr(j,ii)
                            vrtpr = vr(i,ii)
                            ii = ivhead(iv)
                            vrh = vr(i,ii)
                            vrhpr = vr(j,ii)
                      endif
c
c Reject this pair on the basis of missing values:
c
                      if(vrt.lt.tmin.or.vrh.lt.tmin.or.
     +                   vrt.gt.tmax.or.vrh.gt.tmax) go to 6
c
c We have an acceptable pair:
c
                      ii = (id-1)*nvarg*MAXLG+(iv-1)*MAXLG+il
c
c             COMPUTE THE APPROPRIATE "VARIOGRAM" MEASURE
c
c
c The Semivariogram:
c
      if(it.eq.1.or.it.eq.5.or.it.eq.10) then
            np(ii)  = np(ii)  + 1.
            dis(ii) = dis(ii) + dble(h)
            tm(ii)  = tm(ii)  + dble(vrt)
            hm(ii)  = hm(ii)  + dble(vrh)
            gam(ii) = gam(ii) + dble((vrt-vrh)*(vrt-vrh))
            if(omni) then
                  if(vrtpr.ge.tmin.and.vrhpr.ge.tmin.and.
     +               vrtpr.lt.tmax.and.vrhpr.lt.tmax) then
                        np(ii)  = np(ii)  + 1.
                        dis(ii) = dis(ii) + dble(h)
                        tm(ii)  = tm(ii)  + dble(vrtpr)
                        hm(ii)  = hm(ii)  + dble(vrhpr)
                        gam(ii) = gam(ii) + dble((vrtpr-vrhpr)*
     +                                           (vrtpr-vrhpr))
                  endif
            endif
c
c The Traditional Cross Semivariogram:
c
      else if(it.eq.2) then
            np(ii)  = np(ii)  + 1.
            dis(ii) = dis(ii) + dble(h)
            tm(ii)  = tm(ii)  + dble(0.5*(vrt+vrtpr))
            hm(ii)  = hm(ii)  + dble(0.5*(vrh+vrhpr))
            gam(ii) = gam(ii) + dble((vrt-vrtpr)*(vrhpr-vrh))
c
c The Covariance, Transition Probability, and Joint Probability:
c
      else if(it.eq.3.or.it.eq.11.or.it.eq.12) then
            np(ii)  = np(ii)  + 1.
            dis(ii) = dis(ii) + dble(h)
            tm(ii)  = tm(ii)  + dble(vrt)
            hm(ii)  = hm(ii)  + dble(vrh)
            gam(ii) = gam(ii) + dble(vrh*vrt)
            if(omni) then
                  if(vrtpr.ge.tmin.and.vrhpr.ge.tmin.and.
     +               vrtpr.lt.tmax.and.vrhpr.lt.tmax) then
                        np(ii)  = np(ii)  + 1.
                        dis(ii) = dis(ii) + dble(h)
                        tm(ii)  = tm(ii)  + dble(vrtpr)
                        hm(ii)  = hm(ii)  + dble(vrhpr)
                        gam(ii) = gam(ii) + dble(vrhpr*vrtpr)
                  endif
            endif
c
c The Correlogram:
c
      else if(it.eq.4) then
            np(ii)  = np(ii)  + 1.
            dis(ii) = dis(ii) + dble(h)
            tm(ii)  = tm(ii)  + dble(vrt)
            hm(ii)  = hm(ii)  + dble(vrh)
            hv(ii)  = hv(ii)  + dble(vrh*vrh)
            tv(ii)  = tv(ii)  + dble(vrt*vrt)
            gam(ii) = gam(ii) + dble(vrh*vrt)
            if(omni) then
                  if(vrtpr.ge.tmin.and.vrhpr.ge.tmin.and.
     +               vrtpr.lt.tmax.and.vrhpr.lt.tmax) then
                        np(ii)  = np(ii)  + 1.
                        dis(ii) = dis(ii) + dble(h)
                        tm(ii)  = tm(ii)  + dble(vrtpr)
                        hm(ii)  = hm(ii)  + dble(vrhpr)
                        hv(ii)  = hv(ii)  + dble(vrhpr*vrhpr)
                        tv(ii)  = tv(ii)  + dble(vrtpr*vrtpr)
                        gam(ii) = gam(ii) + dble(vrhpr*vrtpr)
                  endif
            endif
c
c The Pairwise Relative:
c
      else if(it.eq.6) then
            if(abs(vrt+vrh).gt.EPSLON) then
                  np(ii)  = np(ii)  + 1.
                  dis(ii) = dis(ii) + dble(h)
                  tm(ii)  = tm(ii)  + dble(vrt)
                  hm(ii)  = hm(ii)  + dble(vrh)
                  gamma   = 2.0*(vrt-vrh)/(vrt+vrh)
                  gam(ii) = gam(ii) + dble(gamma*gamma)
            endif
            if(omni) then
                  if(vrtpr.ge.tmin.and.vrhpr.ge.tmin.and.
     +               vrtpr.lt.tmax.and.vrhpr.lt.tmax) then
                  if(abs(vrtpr+vrhpr).gt.EPSLON) then
                        np(ii)  = np(ii)  + 1.
                        dis(ii) = dis(ii) + dble(h)
                        tm(ii)  = tm(ii)  + dble(vrtpr)
                        hm(ii)  = hm(ii)  + dble(vrhpr)
                        gamma   = 2.0*(vrt-vrh)/(vrt+vrh)
                        gam(ii) = gam(ii) + dble(gamma*gamma)
                  endif
                  endif
            endif
c
c Variogram of Logarithms:
c
      else if(it.eq.7) then
            if(vrt.gt.EPSLON.and.vrh.gt.EPSLON) then
                  np(ii)  = np(ii)  + 1.
                  dis(ii) = dis(ii) + dble(h)
                  tm(ii)  = tm(ii)  + dble(vrt)
                  hm(ii)  = hm(ii)  + dble(vrh)
                  gamma   = alog(vrt)-alog(vrh)
                  gam(ii) = gam(ii) + dble(gamma*gamma)
            endif
            if(omni) then
                  if(vrtpr.ge.tmin.and.vrhpr.ge.tmin.and.
     +               vrtpr.lt.tmax.and.vrhpr.lt.tmax) then
                  if(vrtpr.gt.EPSLON.and.vrhpr.gt.EPSLON) then
                        np(ii)  = np(ii)  + 1.
                        dis(ii) = dis(ii) + dble(h)
                        tm(ii)  = tm(ii)  + dble(vrtpr)
                        hm(ii)  = hm(ii)  + dble(vrhpr)
                        gamma   = alog(vrt)-alog(vrh)
                        gam(ii) = gam(ii) + dble(gamma*gamma)
                  endif
                  endif
            endif
c
c Rodogram:
c
      else if(it.eq.8) then
            np(ii)  = np(ii)  + 1.
            dis(ii) = dis(ii) + dble(h)
            tm(ii)  = tm(ii)  + dble(vrt)
            hm(ii)  = hm(ii)  + dble(vrh)
            gam(ii) = gam(ii) + dble(sqrt(abs(vrt-vrh)))
            if(omni) then
                  if(vrtpr.ge.tmin.and.vrhpr.ge.tmin.and.
     +               vrtpr.lt.tmax.and.vrhpr.lt.tmax) then
                        np(ii)  = np(ii)  + 1.
                        dis(ii) = dis(ii) + dble(h)
                        tm(ii)  = tm(ii)  + dble(vrtpr)
                        hm(ii)  = hm(ii)  + dble(vrhpr)
                        gam(ii) = gam(ii) +dble(sqrt(abs(vrtpr-vrhpr)))
                  endif
            endif
c
c Madogram:
c
      else if(it.eq.9) then
            np(ii)  = np(ii)  + 1.
            dis(ii) = dis(ii) + dble(h)
            tm(ii)  = tm(ii)  + dble(vrt)
            hm(ii)  = hm(ii)  + dble(vrh)
            gam(ii) = gam(ii) + dble(abs(vrt-vrh))
            if(omni) then
                  if(vrtpr.ge.tmin.and.vrhpr.ge.tmin.and.
     +               vrtpr.lt.tmax.and.vrhpr.lt.tmax) then
                        np(ii)  = np(ii)  + 1.
                        dis(ii) = dis(ii) + dble(h)
                        tm(ii)  = tm(ii)  + dble(vrtpr)
                        hm(ii)  = hm(ii)  + dble(vrhpr)
                        gam(ii) = gam(ii) + dble(abs(vrtpr-vrhpr))
                  endif
            endif
      endif
c
c Finish loops over variograms, directions, and the double data loops:
c
 6              continue
 5          continue
 4    continue
 3    continue
c
c Get average values for gam, hm, tm, hv, and tv, then compute
c the correct "variogram" measure:
c
      do 7 id=1,ndir
      do 7 iv=1,nvarg
      do 7 il=1,nlag+2
            i = (id-1)*nvarg*MAXLG+(iv-1)*MAXLG+il
            if(np(i).le.0.) go to 7
            rnum   = np(i)
            dis(i) = dis(i) / dble(rnum)
            gam(i) = gam(i) / dble(rnum)
            hm(i)  = hm(i)  / dble(rnum)
            tm(i)  = tm(i)  / dble(rnum)
            hv(i)  = hv(i)  / dble(rnum)
            tv(i)  = tv(i)  / dble(rnum)
c
c  1. report the semivariogram rather than variogram
c  2. report the cross-semivariogram rather than variogram
c  3. the covariance requires "centering"
c  4. the correlogram requires centering and normalizing
c  5. general relative requires division by lag mean
c  6. report the semi(pairwise relative variogram)
c  7. report the semi(log variogram)
c  8. report the semi(rodogram)
c  9. report the semi(madogram)
c  11. The transition probability is divided by the tail mean
            it = ivtype(iv)
            if(it.le.2) then
                  gam(i) = 0.5 * gam(i)
            else if(it.eq.3) then
                  gam(i) = gam(i) - hm(i)*tm(i)
            else if(it.eq.4) then
                  hv(i)  = dsqrt(hv(i)-hm(i)*hm(i))
                  tv(i)  = dsqrt(tv(i)-tm(i)*tm(i))
                  if((hv(i)*tv(i)).lt.EPSLON) then
                        gam(i) = 0.0
                  else
                        gam(i) =(gam(i)-hm(i)*tm(i))/(hv(i)*tv(i))
                  endif
c
c Square "hv" and "tv" so that we return the variance:
c
                  hv(i)  = hv(i)*hv(i)
                  tv(i)  = tv(i)*tv(i)
            else if(it.eq.5) then
                  htave  = 0.5*(hm(i)+tm(i))
                  htave  = htave   *   htave
                  if(htave.lt.EPSLON) then
                        gam(i) = 0.0
                  else
                        gam(i) = gam(i)/dble(htave)
                  endif
            else if(it.ge.6.and.it.le.10) then
                  gam(i) = 0.5 * gam(i)
            else if(it.eq.11) then
                  if(tm(i).gt.0.)gam(i)=gam(i)/tm(i)
            endif
 7    continue
      return
      end
