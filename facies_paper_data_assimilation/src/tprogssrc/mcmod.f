       program mcmod 
c
c    Develops 1- and 3-D Markov chain models of spatial variability
c    for categorical variables (e.g., geologic units)
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
c
c    SFC 1/98  
c    eliminate options 6 and 7, unless requested 
c
c    SFC 10/97
c    change all subroutines to public domain software
c
c    SFC 6/97
c    eliminate 'maximum entropy' option  (equivalent to IPF)
c    
c    SFC 5/97
c    add 'independent transition' frequency model 
c
c    SFC 2/97
c    update & streamline, add 'maximum entropy' model
c
c    SFC 11/96
c    modify MCMOD for PC compatibility
c
c    SFC  7/95
c    builds transition probability models by 
c    various means of specifying transition rates 
c
c    1 = actual rates 
c    2 = from transition probability data 
c    3 = in terms of embedded Markov chain transition probabilities
c    4 = in terms of embedded Markov chain transition frequencies
c    5 = w.r.t. independent or maximum entropy transition frequencies
c    6 = w.r.t. volumetric proportions
c    7 = w.r.t. frequencies of embedded occurrences
c
      include 'mcmod.inc'
      real r(MCAT,MCAT),t(MCAT,MCAT),r0(MCAT,MCAT),rcopy(MCAT,MCAT)
      real rconc(MCAT,MCAT),f(MCAT,MCAT)
      real wr(MCAT),wi(MCAT),detdir(3),dhdir(3)
      real a(MCAT,MCAT),b(MCAT,MCAT)
      integer nhdir(3)
      complex tc(MCAT,MCAT),spec(MCAT,MCAT,MCAT),cc,detc
      character*40 filtxyz,fildet,filnam,txt,parfil,dbgfil
      character*1 dir(3)
      logical diff
c     03/13/2015 xuehang song
      integer :: ixhs
      character*100 :: ForProportion
      
      dir(1)='X'
      dir(2)='Y'
      dir(3)='Z'
c
c  get parameters 
c
c      print*,'Name of MCMOD parameter file:'
c     read(5,'(a40)') parfil
c      parfil='mcmod.par'
      call getarg(1,parfil)
      call getarg(2,forproportion)

      parfil="dainput/mcmod.par"
      forproportion="tprogs/tp_x.eas"

      open(7,file=parfil,status='old')
comment      print*,'Number of categories:'
      read(7,*) ncat
comment      print*,'proportions:'
      read(7,*) (p(icat),icat=1,ncat) 


c     change proportion
      open(777,file=trim(ForProportion),status='old')
      read(777,*)(p(icat),icat=1,ncat) 
      close(777)




comment      print*,'Background category:'
      read(7,*) ibkgr
comment      print*,'Name of debugging file:'
      read(7,105) dbgfil
c
c  write some debugging information
c
      open(ldbg,file=dbgfil,status='unknown')
      write(ldbg,*) 'MCMOD debugging file'
      write(ldbg,*) ' '
      write(ldbg,300) parfil
 300  format('Parameter file: ',a40)
      write(ldbg,301) ncat
 301  format('Number of categories:',i2)
      write(ldbg,302) (p(icat),icat=1,ncat) 
 302  format('Proportions:',10f8.4)
      write(ldbg,303) ibkgr
 303  format('Background category:',i2)
c
c  get 3-D model parameters
c
comment      print*,'Name of 3-D transition probability model file:'
      read(7,105) filtxyz
comment      print*,'Name of determinant file:'
      read(7,105) fildet
 105  format(a40)
comment      print*,'Determinant limits for 3-D model; x,y,z direction:'
      read(7,*) (detdir(id),id=1,3) 
comment      print*,'nhx,nhy,nhz:'
      read(7,*) (dhdir(id),id=1,3) 
      dhx=dhdir(1)
      dhy=dhdir(2)
      dhz=dhdir(3)
c
c build Markov chain models in each coordinate direction
c
      do 9 id=1,3
        if(detdir(id).gt.1.0)detdir(id)=1.0
        if(detdir(id).le.0.0)detdir(id)=0.01 
c
c  for each direction, convert r into rates 
c
c     for conceptual models (3-6): 
c         diaganol rates are expressed in terms of mean length 
c         off-diagonal rates are expressed relative to the 
c            reference state, i.e. the model of disorder ("random"). 
c            (-1.) denotes symmetry
c
c     open files 
c
c        print 604, dir(id)
        read(7,105) filnam
 604    format('Name of output file for ',a1,' direction:')
        open(id,file=filnam,status='unknown')
comment        print 605, dir(id)
c
c     establish # of lags and lag spacing  
c               and
c     options for establishing rate matrix
c
 605    format(' # of lags, lag spacing ',a1,' direction:')
        read(7,*) nh,dh
        nhdir(id)=nh
        if(nh.gt.0)then
comment          print *,'Rate matrix option: (1-5)'
          read(7,*) iopt
          write(ldbg,*) ' '
          write(ldbg,*) ' '
          write(ldbg,805) dir(id)
 805      format('------- 'a1,'-DIRECTION: -------')
c
c  read data
c
          if(iopt.ne.2)then
            do 1 j=1,ncat
 1            read(7,*) (r0(j,k),k=1,ncat)
          endif
c
c  write option and model filename to debugging file 
c
          if(iopt.eq.1)then
            txt='  option 1: specified transition rates' 
          elseif(iopt.eq.2)then
            txt='option 2: trans. prob. at specified lag' 
          elseif(iopt.eq.3)then
            txt='option 3: embedded Markov chain tr. pr.'
          elseif(iopt.eq.4)then
            txt='option 4: embedded Markov chain tr. fr.'
          elseif(iopt.eq.5)then
            txt='option 5: w.r.t. indep/max entropy tr. fr.'
          elseif(iopt.eq.6)then
            txt='option 6: w.r.t. volumetric proportions' 
          elseif(iopt.eq.7)then
            txt='option 7: w.r.t. fr. of embed. occurrences' 
          endif
          write(ldbg,310) txt
 310      format('Method - ',a40)
          write(ldbg,311) filnam
 311      format('1-D model output file: ',a40)
c
c  calculate transition rates according to data given
c
          if(iopt.eq.1)then
            do 101 j=1,ncat
              do 101 k=1,ncat
                if(j.ne.k.and.r0(j,k).eq.-1.)r0(j,k)=p(k)*r0(k,j)/p(j)
 101            r(j,k)=r0(j,k)
          elseif(iopt.eq.2)then
            call t2r(r)
          elseif(iopt.eq.3)then
            call emctp(r0,r)
          elseif(iopt.eq.4)then
            call emctf(r0,r)
          elseif(iopt.eq.5)then
            call indep(r0,rconc,entmax)
          elseif(iopt.eq.6)then
            call vprop(r0,rconc)
          elseif(iopt.eq.7)then
            call nprop(r0,rconc)
          endif
c
c  convert from conceptual parameters to transition rates. 
c
          if(iopt.ge.5)then
            do 2 j=1,ncat
              if(j.ne.ibkgr)then
                r(j,j)=-1.0/r0(j,j)
                do 3 k=1,ncat
                  if(k.ne.ibkgr.and.k.ne.j)then
                    if(r0(j,k).eq.-1.)then
                      r(j,k)=p(k)*r0(k,j)*rconc(k,j)/p(j)
                    else
                      r(j,k)=r0(j,k)*rconc(j,k)
                    endif
                  endif
 3              continue
              endif
 2          continue
          endif
c
c  check 'r' for consistency with proportions if background
c     category not used 
c
          if(ibkgr.le.0.or.ibkgr.gt.ncat)then
            call checkr(r,diff)
          else 
c
c  calculate background transition rates that are consistent
c  with proportions
c
c     for background column             
c
            do 4 j=1,ncat
              if(j.ne.ibkgr)then
                r(j,ibkgr)=0.
                do 5 k=1,ncat
                  if(k.ne.ibkgr)r(j,ibkgr)=r(j,ibkgr)-r(j,k)
 5              continue
              endif
 4          continue
c
c     for background row
c
            do 6 k=1,ncat
              r(ibkgr,k)=0.0
              do 7 j=1,ncat
                if(j.ne.ibkgr)r(ibkgr,k)=r(ibkgr,k)-p(j)*r(j,k)
 7            continue
              r(ibkgr,k)=r(ibkgr,k)/p(ibkgr)
 6          continue
          endif
c
c  check for invalid transition rates
c
          do 801 j=1,ncat
            if(r(j,j).ge.0.) write(ldbg,810) j
            do 802 k=1,ncat
              if(k.ne.j)then
                if(r(j,k).lt.0.) write(ldbg,820) j,k
                if(r(j,k).gt.-r(j,j)) write (ldbg,821) j,k,j
                colr=-p(k)*r(k,k)/p(j)
                if(r(j,k).gt.colr) write (ldbg,822) j,k,k
              endif
 802        continue
 801      continue
 810      format('WARNING: Diagonal Transition Rate ',i2,' 
     &is nonnegative.')
 820      format('WARNING: Off-diagonal Transition Rate ',2i3,' 
     &is negative.')
 821      format('WARNING: Off-diagonal Transition Rate ',2i3,' 
     &is too large for row ',i2)
 822      format('WARNING: Off-diagonal Transition Rate ',2i3,' 
     &is too large for column ',i2)
c
c  print rate matrix
c
          if(id.eq.1)txt='Rate Matrix for X-Direction:'
          if(id.eq.2)txt='Rate Matrix for Y-Direction:'
          if(id.eq.3)txt='Rate Matrix for Z-Direction:'
          call mprint(txt,MCAT,ncat,r,ldbg,'f10.6',0)
c
c  calculate embedded transition probabilities
c
          call r2etp(r,f)
          txt='embedded transition probabilities:'
          call mprint(txt,MCAT,ncat,f,ldbg,'f10.6',0)
c
c  calculate embedded transition frequencies and entropy
c
          call r2etf(r,f,entropy)
          txt='embedded transition frequencies:'
          call mprint(txt,MCAT,ncat,f,ldbg,'f10.6',0)
          write(ldbg,*) 'entropy=',entropy 
c
c  calculate rates with respect to independent transition frequencies
c
          call r2i(r,f)
          txt='w.r.t. independent transition freqs:'
          call mprint(txt,MCAT,ncat,f,ldbg,'f10.4',1)
c
c  calculate rates with respect to volumetric proportions
c
          if(iopt.eq.6)then
            call r2p(r,f)
            txt='w.r.t. volumetric proportions:'
            call mprint(txt,MCAT,ncat,f,ldbg,'f10.4',1)
          endif
c
c  calculate rates with respect to numbers of embedded occurrences
c
          if(iopt.eq.7)then
            call r2n(r,f)
            txt='w.r.t. # of embedded occurrences'
            call mprint(txt,MCAT,ncat,f,ldbg,'f10.4',1)
          endif
c
c    write header for t file
c
          write(id,205) (p(l),l=1,ncat)
 205      format(10f7.4)
          ncat2=ncat*ncat
          write(id,305) ncat2+1
 305      format(i2)
          write(id,*) 'lag'
          do 50 k=1,ncat
            do 50 l=1,ncat
 50           write(id,405) k,l 
 405      format(i1,'-',i1)
c
c  write rate matrix for later use in 3-D model
c
          do 947 k=1,ncat
            do 947 l=1,ncat
              rcopy(k,l)=r(k,l)
 947          rd(id,k,l)=r(k,l)
c
c    spectrally decompose r  
c
          call spectral(r,wr,wi,spec) 
c
c    print eigenvalues and spectral component matrices
c
          do 370 i=1,ncat
            write(ldbg,*) ' '
            do 375 k=1,ncat
              do 375 l=1,ncat
                b(k,l)=aimag(spec(i,k,l))
 375            a(k,l)=real(spec(i,k,l))
            write(ldbg,379) i,wr(i),wi(i) 
            write(ldbg,*) 'spectral component matrix:'
            txt='real'
            call mprint(txt,MCAT,ncat,a,ldbg,'f10.5',0)
            txt='imag'
            if(wi(i).ne.0.0)
     &        call mprint(txt,MCAT,ncat,b,ldbg,'f10.5',0)
 370      continue
 379      format('eigenvalue',i2,' real:',f8.4, '  imag:',f8.4) 
c
c    calculate t at nh lags for spacing dh
c
          iflag=0
          pwr=1./(1.*(ncat-1))
          ih=0
          do while(ih.le.nh.or.iflag.eq.0)
            h=ih*dh
c
c      initialize tc (complex transition probability matrix)
c
            do 110 k=1,ncat
              do 110 l=1,ncat
 110            tc(k,l)=cmplx(0.0,0.0)
c
c      compute t from explicit form (Agterberg, p. 422)
c
            detc=cmplx(1.,0.)
            do 130 i=1,ncat
              cc=cmplx(h*wr(i),h*wi(i))
              cc=cexp(cc)
              detc=detc*cc
              do 130 k=1,ncat
                do 130 l=1,ncat 
 130              tc(k,l)=tc(k,l)+cc*spec(i,k,l)
            detr=(real(detc))**pwr
            if(detr.le.detdir(id).and.iflag.eq.0)then
              iflag=1
              nhdir(id)=nint(h/dhdir(id))
            endif
            do 210 k=1,ncat
              do 210 l=1,ncat
 210            t(k,l)=real(tc(k,l))
            write(id,905) h,((t(k,l),l=1,ncat),k=1,ncat)
 905        format(f10.3,100f8.4)
            ih=ih+1
 100      end do 
        endif
 9    continue      
c
c   construct 3-D model 
c
      nhx=nhdir(1)
      nhy=nhdir(2)
      nhz=nhdir(3)
comment      print*,' '
      write(ldbg,*) ' '
comment      print*,'Constructing 3-D transition probability model'
      write(ldbg,*)'Constructing 3-D transition probability model'
comment      print*,'# of lags in +x,+y,+z direction =',nhx,nhy,nhz
      write(ldbg,*) '# of lags in +x,+y,+z direction =',nhx,nhy,nhz
      if(nhx.ge.1.or.nhy.ge.1.or.nhz.ge.1)then
        if(ibkgr.gt.0.and.ibkgr.le.ncat)then
          call tp3d(filtxyz,fildet)
comment          print*,' '
comment          print*,'total # of lags =',(2*nhx+1)*(2*nhy+1)*(2*nhz+1)
         write(ldbg,*) 'total # of lags =',(2*nhx+1)*(2*nhy+1)*(2*nhz+1)
        else
comment          print*,'No 3-D Markov chain model generated'
comment          print*,'      - no background category.'
          write(ldbg,*) 'No 3-D Markov chain model generated'
          write(ldbg,*) '      - no background category.'
        endif
      endif
 999  continue
      end
      subroutine r2etf(r,f,entropy)
c
c  Calculates the Embedded Transition Frequency matrix and its
c  entropy from a transition rate matrix.
c
      include 'mcmod.inc'
      real r(MCAT,MCAT),f(MCAT,MCAT),s(MCAT)
c
c  calculate 'tot' and row totals
c
      tot=0.
      do 10 j=1,ncat
        s(j)=-p(j)*r(j,j)
 10     tot=tot+s(j)
c
c  calculate 'frequencies'
c
      entropy=0.0
      do 20 j=1,ncat
        f(j,j)=0.
        do 20 k=1,ncat
          if(k.ne.j)then
            f(j,k)=p(j)*r(j,k)/tot
            f(j,j)=f(j,j)+f(j,k)
            if(f(j,k).gt.0.)entropy=entropy-f(j,k)*alog(f(j,k))
            if(f(j,k).lt.0.)entropy=entropy+10000.*f(j,k)
          endif
 20   continue
      return
      end
      subroutine r2etp(r,etp)
c
c   calculate embedded transition probabilities from
c   transition rate matrix 
c      
      include 'mcmod.inc'
      real r(MCAT,MCAT),etp(MCAT,MCAT)
      do 10 j=1,ncat
        etp(j,j)=1.0
        do 10 k=1,ncat
          if(j.ne.k)etp(j,k)=-r(j,k)/r(j,j)
 10   continue
      return
      end
      subroutine r2p(r,rp)
c
c   calculate transition rates with respect to volumetric proportions
c
      include 'mcmod.inc'
      real r(MCAT,MCAT),rp(MCAT,MCAT)
      do 10 j=1,ncat
        do 10 k=1,ncat
          if(k.ne.j)rp(j,k)=-r(j,j)*p(k)/(1.0-p(j)) 
 10   continue
      do 20 j=1,ncat
        rp(j,j)=-1.0/r(j,j)
        do 20 k=1,ncat
          if(k.ne.j)rp(j,k)=r(j,k)/rp(j,k)
 20   continue
      return
      end
      subroutine r2n(r,rn)
c
c   calculate transition rates with respect to
c   # of embedded occurrences
c
      include 'mcmod.inc'
      real r(MCAT,MCAT),rn(MCAT,MCAT)
      tot=0.0
      do 1 j=1,ncat
 1      tot=tot-p(j)*r(j,j)
      do 10 j=1,ncat
        do 10 k=1,ncat
          if(k.ne.j)rn(j,k)=r(j,j)*p(k)*r(k,k)/(tot+p(j)*r(j,j)) 
 10   continue
      do 20 j=1,ncat
        rn(j,j)=-1.0/r(j,j)
        do 20 k=1,ncat
          if(k.ne.j)rn(j,k)=r(j,k)/rn(j,k)
 20   continue
      return
      end
      subroutine r2i(r,ri)
      include 'mcmod.inc'
      real r(MCAT,MCAT),ri(MCAT,MCAT),r0(MCAT,MCAT)
      do 10 j=1,ncat
        r0(j,j)=-1.0/r(j,j)
        do 10 k=1,ncat
          if(k.ne.j)r0(j,k)=1.0
 10   continue
      call indep(r0,ri,entmax)
      do 20 j=1,ncat
        ri(j,j)=-1.0/r(j,j)
        do 20 k=1,ncat
          if(k.ne.j)ri(j,k)=r(j,k)/ri(j,k)
 20   continue
      return
      end
      
      subroutine emctp(r0,r)
c
c  calculates transition rates in terms of embedded Markov chain
c  transition probabilities and mean lengths
c
      include 'mcmod.inc'
      real r0(MCAT,MCAT),r(MCAT,MCAT)
c
c     check for symmetry assumptions
c
      do 180 j=1,ncat
        if(j.ne.ibkgr)then
          do 181 k=1,ncat
            if(k.ne.j.and.k.ne.ibkgr.and.r0(j,k).eq.-1.)then
              r0(j,k)=r0(k,j)*p(k)*r0(j,j)/(p(j)*r0(k,k))
            endif
 181      continue         
        endif
 180  continue
c
c  convert to transition rates
c
      do 10 j=1,ncat
        if(j.ne.ibkgr)then
          do 11 k=1,ncat
            if(k.ne.ibkgr)then
              if(k.eq.j)then
                r(j,j)=-1.0/r0(j,j)
              else
                r(j,k)=r0(j,k)/r0(j,j)
              endif
            endif
 11       continue  
        endif
 10   continue
      return
      end
 
      subroutine checkr(r,diff)
c
c  check proportions intrinsic to r compared to proportions given
c
      include 'mcmod.inc'
      real r(MCAT,MCAT), A(MCAT,MCAT)
      real wr(MCAT),wi(MCAT)
      complex spec(MCAT,MCAT,MCAT)
      logical diff
      diff=.false.
c
c  copy 'r' to 'A'
c
      do 10 j=1,ncat
        do 10 k=1,ncat
 10       A(j,k)=r(j,k)
c
c  perform spectral decomposition of A
c
      call spectral(A,wr,wi,spec)
c
c  check if column entries of spectral component matrix associated
c  with eigenvalue=1 are consistent with proportions given 
c
      do 20 i=1,ncat
        if(abs(wr(i)).lt.0.00001.and.abs(wi(i)).lt.0.00001)then
          iprop=i
          do 30 k=1,ncat
            do 30 j=1,ncat
              dif=abs(real(spec(i,j,k))-p(k))
              if(dif.gt.0.005)diff=.true.
 30       continue
        endif
 20   continue
      if(diff)then
comment        print *,' '
        print *,'WARNING: Proportions intrinsic to rate matrix'
        write(ldbg,*) 'WARNING: Proportions intrinsic to rate matrix'
        write(ldbg,*) (real(spec(iprop,1,k)),k=1,ncat)
        print 100, (real(spec(iprop,1,k)),k=1,ncat)
 100    format(10f7.4)
        print *,'are different than input proportions.'
        print *,'Check column sums for consistency with:'  
        write(ldbg,*) 'are different than input proportions.' 
        write(ldbg,*) 'Check column sums for consistency with:'  
        print 100, (p(i),i=1,ncat)
        write(ldbg,*) (p(i),i=1,ncat)
      endif
      return
      end
            
      subroutine emctf(r0,r)
c
c  calculates transition rates in terms of embedded Markov chain
c  transition frequencies, proportions, and mean lengths
c
      include 'mcmod.inc'
      real r0(MCAT,MCAT),r(MCAT,MCAT),fmarg(MCAT),x(MCAT)
      logical diff
c
c  calculate total of proportions/mean length to establish
c  marginal frequencies
c
      tot=0.
      do 10 j=1,ncat
        if(r0(j,j).gt.0.)then
          tot=tot+p(j)/r0(j,j)
        else
          write(ldbg,101) j
        endif
 10   continue
 101  format('Mean length for category',i3,' must be greater than zero')
c
c  calculate transition rates
c
      do 20 j=1,ncat
        if(j.ne.ibkgr)then
          fmarg(j)=p(j)/(r0(j,j)*tot)
          do 21 k=1,ncat
            if(k.ne.ibkgr)then
              if(j.eq.k)then
                r(j,j)=-1.0/r0(j,j)
              else
                if(r0(j,k).eq.-1.)r0(j,k)=r0(k,j)
                r(j,k)=(1.0/r0(j,j))*(r0(j,k)/fmarg(j))
              endif
            endif
 21       continue
        endif
 20   continue
c
c  check if proportions intrinsic to transition frequencies 
c  are consistent with proportions given
c
      if(ibkgr.le.0.or.ibkgr.gt.ncat)then
        totx=0.
        do 50 j=1,ncat
          x(j)=0.
          do 51 k=1,ncat
            if(k.ne.j)x(j)=x(j)+r0(j,k)
 51       continue
          totx=totx+x(j)
 50     continue 
c
c   convert 'x' to equivalent proportions
c
        do 55 j=1,ncat
 55       x(j)=x(j)*totx*r0(j,j)
c
c   check if 'x' and 'p' are different
c 
        diff=.false. 
        do 60 j=1,ncat
          if(fmarg(j).ne.x(j))diff=.true.
 60     continue
        if(diff)then
          print 200, (x(j),j=1,ncat)
          write(ldbg,200) (x(j),j=1,ncat)
          print*,'WARNING: Proportions intrinsic to rate matrix'
          write(ldbg,*) 'WARNING: Proportions intrinsic to rate matrix'
 200      format(10f7.4)
          write(ldbg,*) 'are different than input proportions.'  
        endif
      endif
      return
      end
      subroutine vprop(r0,rconc)
      include 'mcmod.inc'
      real r0(MCAT,MCAT),rconc(MCAT,MCAT)
      do 10 j=1,ncat
        if(j.ne.ibkgr)then
          rconc(j,j)=-1.0/r0(j,j)
          do 11 k=1,ncat
            if(k.ne.ibkgr .and. k.ne.j)
     &            rconc(j,k)=p(k)/(r0(j,j)*(1.0-p(j)))     
 11       continue
        endif
 10   continue
      return
      end
      subroutine nprop(r0,rconc)
c
c   Miall's embedded "random" rates:
c   conditional w.r.t. proportions (numbers) of embedded occurrences
c
      include 'mcmod.inc'
      real r0(MCAT,MCAT),rconc(MCAT,MCAT)
      if(ibkgr.eq.0)then
        do 10 j=1,ncat
          rconc(j,j)=-1.0/r0(j,j)
          denom=0.0
          do 20 k=1,ncat
            if(k.ne.j)denom=denom+p(k)/r0(k,k)
 20       continue
          do 30 k=1,ncat
            if(k.ne.j)rconc(j,k)=-rconc(j,j)*p(k)/(r0(k,k)*denom)
 30       continue
 10     continue
      elseif(ibkgr.ge.1)then
c
c   check for positive mean lengths
c
        do 40 k=1,ncat
          if(r0(k,k).le.0.) then
            print 916, k
 916        format('Need a mean length for category',i2,'!')
            r0(k,k)=1. 
          endif
c
c  assign diagonal transition rates
c
 40     rconc(k,k)=-1.0/r0(k,k)
c
c  iterate on background mean length 
c
        do 217 iloop=1,20
          do 117 j=1,ncat
            denom=0.0
            do 118 k=1,ncat
              if(k.ne.j)denom=denom-p(k)*rconc(k,k)
 118        continue
            if(j.ne.ibkgr)then
              rconc(j,ibkgr)=-rconc(j,j)
              do 119 k=1,ncat
                if(k.ne.j.and.k.ne.ibkgr)then
                  rconc(j,k)=rconc(j,j)*p(k)*rconc(k,k)/denom
                  rconc(j,ibkgr)=rconc(j,ibkgr)-rconc(j,k)
                endif
 119          continue
            endif
 117      continue
c
c  calculate new background category mean length 
c
          rconc(ibkgr,ibkgr)=0.0
          do 120 j=1,ncat
            if(j.ne.ibkgr)rconc(ibkgr,ibkgr)=
     &                      rconc(ibkgr,ibkgr)-p(j)*rconc(j,ibkgr) 
 120      continue
          rconc(ibkgr,ibkgr)=rconc(ibkgr,ibkgr)/p(ibkgr)
 217    continue
c
c  calculate remaining background category row rates 
c
        do 227 k=1,ncat
          if(k.ne.ibkgr)then
            rconc(ibkgr,k)=0.0
            do 228 j=1,ncat
              if(j.ne.ibkgr)rconc(ibkgr,k)=
     &                      rconc(ibkgr,k)-p(j)*rconc(j,k)
 228        continue
          endif
 227    rconc(ibkgr,k)=rconc(ibkgr,k)/p(ibkgr)
      endif
      return
      end
      subroutine indep(r0,rconc,entmax)
c
c  "Independent" juxtapositional tendencies
c  calibrated for 'unobservable' transitions to same category. 
c  Calculated using method of iterative proportional fitting.
c  Corresponds to "maximum entropy" transition frequencies.
c
      include 'mcmod.inc'
      real r0(MCAT,MCAT),rconc(MCAT,MCAT)
      real s(MCAT),f(MCAT),rtot(MCAT)
c
c  calculate off-diagonal row/column transition frequency totals
c
      tot=0.
      do 10 i=1,ncat
        s(i)=p(i)/r0(i,i)
 10     tot=tot+s(i)
      do 20 i=1,ncat
 20     s(i)=s(i)/tot
c
c  initialize marginal frequencies compensated for unobservable
c
      do 30 i=1,ncat
 30     f(i)=s(i)
c
c  iteratively adjust marginal frequencies to obtain 
c  'independent' transition frequencies
c      
      do 40 i=1,30
        do 50 j=1,ncat
          rtot(j)=0.
          do 60 k=1,ncat
            if(k.ne.j)rtot(j)=rtot(j)+f(j)*f(k)
 60       continue
          f(j)=f(j)*s(j)/rtot(j)
 50     continue
 40   continue
c
c  convert independent transition frequencies to transition rate 
c
      do 100 j=1,ncat
        rconc(j,j)=-1.0/r0(j,j)
        rtot(j)=0.
        do 110 k=1,ncat
          if(k.ne.j)rtot(j)=rtot(j)+f(j)*f(k)
 110    continue
        do 120 k=1,ncat
          if(k.ne.j)rconc(j,k)=-rconc(j,j)*f(j)*f(k)/rtot(j)
 120    continue
 100  continue
c
c  calculate maximum entropy
c
      entmax=0.
      i=0
      do 970 j=1,ncat-1
        do 970 k=j+1,ncat 
          freq=f(j)*f(k) 
          if(freq.gt.0.)entmax=entmax-2.*freq*alog(freq)
          if(freq.lt.0.)entmax=entmax-20000.*freq
 970  continue
      return
      end
      subroutine t2r(r)
c
c   establish rates from transition probability data
c
      include 'mcmod.inc' 
      real r(MCAT,MCAT),t(MCAT,MCAT)
      real wr(MCAT),wi(MCAT)
      complex cc,rc(MCAT,MCAT),spec(MCAT,MCAT,MCAT)
      character*40 txt
      read(7,105) txt
 105  format(a40)
      read(7,*) lag
      open(8,file=txt,status='old')
      read(8,105) txt
      read(8,*) nvar
      do 808 ivar=1,nvar+lag
 808    read(8,*)  
c
c  read measured transition probabilities
c
      read(8,*) dlag,((t(j,k),k=1,ncat),j=1,ncat)
      close (8)
c
c   adjust transition probability matrix for probabilities 
c
c
c      set row totals to one
c
      if(ibkgr.gt.0)then
        do 781 j=1,ncat
          if(j.ne.ibkgr)then
            rtot=0.0
            do 782 k=1,ncat
              if(k.ne.ibkgr)rtot=rtot+t(j,k)
 782        continue 
            t(j,ibkgr)=1.0-rtot
          endif
 781    continue
c
c      adjust background row by column totals
c
        do 783 k=1,ncat
          ctot=0.0
          do 784 j=1,ncat
            if(j.ne.ibkgr)ctot=ctot+p(j)*t(j,k)
 784      continue
          t(ibkgr,k)=(p(k)-ctot)/p(ibkgr)
 783    continue
      endif
c
c    spectrally decompose t
c
      call spectral(t,wr,wi,spec)
c
c    change transition probability eigenvalues
c    to rate eigenvalues
c
      do 369 i=1,ncat
        cc=cmplx(wr(i),wi(i))
        cc=clog(cc)/cmplx(dlag,0.0)
        wr(i)=real(cc)
        wi(i)=aimag(cc)
 369  continue
      do 371 k=1,ncat
         do 371 l=1,ncat
 371       rc(k,l)=cmplx(0.0,0.0)
c
c  compute r from explicit form (Agterberg,1974,p. 422)
c
      do 372 i=1,ncat
        cc=cmplx(wr(i),wi(i))
        do 372 k=1,ncat
          do 372 l=1,ncat
 372        rc(k,l)=rc(k,l)+cc*spec(i,k,l)
      do 373 k=1,ncat
        do 373 l=1,ncat
 373      r(k,l)=real(rc(k,l))
      return
      end
      subroutine tp3d(filtxyz,fildet)
c
c   Builds a 3-D transition probability model from 
c   three 1-D transition probability models.
c 
      include 'mcmod.inc'
      real t(MCAT,MCAT),txyz(MDAT)
      real det(MLAG)
      integer idim(5),idimdet(3)
      character*40 fildet,filtxyz
      complex s
c
c   define parameters
c
      ncat2=ncat*ncat
      idim(4)=ncat
      idim(5)=ncat
      idim(1)=2*nhx+1
      idim(2)=2*nhy+1
      idim(3)=2*nhz+1
      idimdet(1)=idim(1)
      idimdet(2)=idim(2)
      idimdet(3)=idim(3)
c
c   for each lag, calculate txyz
c
      ia=0
      pwr=1./(1.*(ncat-1))
      nxyz=idim(1)*idim(2)*idim(3)
      do 100 ihz=-nhz,nhz
        do 100 ihy=-nhy,nhy
comment          print*,'ihz=',ihz
          do 100 ihx=-nhx,nhx
            ia=ia+1
            call r2txyz(ihx,ihy,ihz,t,s)
c
c   assign (K-1) root of determinant to 'det'
c
            det(ia)=(real(s))**pwr
c
c   add txyz to each data file
c
            ikl=0
            do 100 k=1,ncat
              do 100 l=1,ncat 
                ikl=ikl+1
                idat=ia+(ikl-1)*nxyz
                txyz(idat)=t(k,l)
 100  continue
C     iret=dspdata(filtxyz,5,idim,txyz)
C     iret=dssdims(3,idimdet)
C     iret=dspdata(fildet,3,idimdet,det)
      open(8,file=filtxyz,status='unknown',form='unformatted')
      irank=5
      write(8) irank 
      write(8) (idim(i),i=1,5)
      ntxyz=idim(1)*idim(2)*idim(3)*idim(4)*idim(5)
      write(8) (txyz(i),i=1,ntxyz)
      close(8)
      open(8,file=fildet,status='unknown',form='unformatted')
      irank=3
      write(8) irank 
      write(8) (idimdet(i),i=1,3)
      ndetxyz=idimdet(1)*idimdet(2)*idimdet(3)
      write(8) (det(i),i=1,ndetxyz)
      close(8)
      end
             
      subroutine r2txyz(ihx,ihy,ihz,t,s)
c
c  Interpolates a 3-D transition probability
c  given transition rates in x,y, and z directions.
c
      include 'mcmod.inc'
      real r(MCAT,MCAT),t(MCAT,MCAT)
      real wr(MCAT),wi(MCAT)
      complex tc(MCAT,MCAT),spec(MCAT,MCAT,MCAT),cc,s
c
c  compute distances, slopes
c
      x=ihx*dhx
      y=ihy*dhy
      z=ihz*dhz
      r2=x**2+y**2+z**2
      d=sqrt(r2)
      s=cmplx(1.,0.)
      if(r2.ne.0.0)then
c
c  compute rates, 1 row at a time 
c
      do 10 k=1,ncat
       if(k.ne.ibkgr)then
        tadd=0.0
        do 20 l=1,ncat
         if(l.ne.ibkgr)then
          rx=rd(1,k,l)
          if(x.lt.0.)rx=rd(1,l,k)*p(l)/p(k)
          ry=rd(2,k,l)
          if(y.lt.0.)ry=rd(2,l,k)*p(l)/p(k)
          rz=rd(3,k,l)
          if(z.lt.0.)rz=rd(3,l,k)*p(l)/p(k)
          a2=(x*rx)**2+(y*ry)**2+(z*rz)**2
          r(k,l)=sqrt(a2/r2)
          if(k.ne.l.and.rx.lt.0..and.ry.lt.0..and.rz.lt.0.)
     &       r(k,l)=-r(k,l)
          if(k.eq.l)r(k,l)=-r(k,l)
          tadd=tadd+r(k,l)
         endif
 20     continue
        r(k,ibkgr)=-tadd 
       endif
 10   continue
c
c   compute background row     
c
      do 100 l=1,ncat
        r(ibkgr,l)=0.0
        do 110 k=1,ncat
          if(k.ne.ibkgr)then
            r(ibkgr,l)=r(ibkgr,l)-p(k)*r(k,l) 
          endif
 110    continue
        r(ibkgr,l)=r(ibkgr,l)/p(ibkgr)
 100  continue
c
c   spectrally decompose r (transition rate matrix)
c
      call spectral(r,wr,wi,spec) 
c
c      initialize tc  (transition rate matrix in complex form)
c
      do 510 k=1,ncat
        do 510 l=1,ncat
 510      tc(k,l)=cmplx(0.0,0.0)
c
c      compute t from explicit form (Agterberg, p. 422)
c
      do 530 i=1,ncat
        cc=cmplx(d*wr(i),d*wi(i))
        cc=cexp(cc)
        s=s*cc
        do 530 k=1,ncat
          do 530 l=1,ncat 
 530        tc(k,l)=tc(k,l)+cc*spec(i,k,l)
      do 610 k=1,ncat
        do 610 l=1,ncat
 610      t(k,l)=real(tc(k,l))
      elseif(r2.eq.0.0)then
        do 690 k=1,ncat
          do 695 l=1,ncat
 695        t(k,l)=0.0
 690      t(k,k)=1.0
      endif 
      return
      end
      subroutine spectral(A,wr,wi,spec) 
      include 'mcmod.inc'
c  Given a matrix A, find the eigenvalues w and associated
c  spectral component matrices. 
      real A(MCAT,MCAT)
      real r(MCAT,MCAT)
      real wr(MCAT),wi(MCAT)
      complex spec(MCAT,MCAT,MCAT),w(MCAT),denom(MCAT)
      complex cc,s(MCAT,MCAT)
c
c   copy A to r
c
      do 10 l=1,ncat
        do 10 k=1,ncat
 10       r(k,l)=A(k,l) 
c
c  find eigenvalues
c
      call balanc(MCAT,ncat,A,low,igh)
      call elmhes(MCAT,ncat,low,igh,A)
      call hqr(MCAT,ncat,low,igh,A,wr,wi,ierr)
c
c  find the spectrum
c
c   convert wr and wi to complex
c
      do 20 i=1,ncat
 20     w(i)=cmplx(wr(i),wi(i))
c
c   calculate spectrum
c
      do 30 i=1,ncat
        denom(i)=cmplx(1.0,0.0)
c
c   initialize spec
c
        do 35 k=1,ncat
          do 36 l=1,ncat
 36         spec(i,k,l)=cmplx(0.0,0.0)
 35       spec(i,k,k)=cmplx(1.0,0.0)
c
c   calculate denominator and numerator
c
        do 40 j=1,ncat
          if(j.ne.i)then
            denom(i)=denom(i)*(w(j)-w(i))
c
c   assign spec to s
c 
            do 60 k=1,ncat
              do 60 l=1,ncat
                s(k,l)=spec(i,k,l)
 60             spec(i,k,l)=cmplx(0.0,0.0)  
c
c   update spec
c
            do 50 k=1,ncat
              do 50 l=1,ncat
                do 50 m=1,ncat
                  cc=cmplx(0.0,0.0)
                  if(m.eq.l)cc=w(j)
 50               spec(i,k,l)=spec(i,k,l)+s(k,m)*(cc-r(m,l))
          endif
 40     continue
c
c   divide spec by denom  
c
        do 70 k=1,ncat
         do 70 l=1,ncat
 70        spec(i,k,l)=spec(i,k,l)/denom(i)
 30   continue
      return
      end
      subroutine mprint(txt,MCAT,ncat,a,ldbg,fmt,iparen)
      real a(MCAT,MCAT)
      character*40 txt
      character*5 fmt
      character*27 fmt2
      character*11 fmt3
      character*1 btwl(99),btwr(99)
      fmt2(1:7)='(99(a1,'
      fmt2(8:12)=fmt
      fmt2(13:27)=',a1))'
      fmt3(1:4)='(99('
      fmt3(5:9)=fmt
      fmt3(10:11)='))'
      write(ldbg,*) ' '
      write(ldbg,10) txt
      do 20 i=1,ncat
        if(iparen.eq.1)then
          do 25 j=1,ncat
            btwl(j)=' '
            btwr(j)=' '
 25       continue
          btwl(i)='('
          btwr(i)=')'
          write(ldbg,fmt2) (btwl(j),a(i,j),btwr(j),j=1,ncat)
        else
          write(ldbg,fmt3) (a(i,j),j=1,ncat)
        endif
 20   continue
 10   format(a40)
      return
      end
      subroutine balanc(nm,n,a,low,igh)
c
      integer i,j,k,l,m,n,nm,igh,low,iexc
      real a(nm,n)
      real c,f,g,r,s,b2,radix
      logical noconv
c
c     this subroutine is a translation of the algol procedure balance,
c     num. math. 13, 293-304(1969) by parlett and reinsch.
c     handbook for auto. comp., vol.ii-linear algebra, 315-326(1971).
c
c     this subroutine balances a real matrix and isolates
c     eigenvalues whenever possible.
c
c     on input
c
c        nm must be set to the row dimension of two-dimensional
c          array parameters as declared in the calling program
c          dimension statement.
c
c        n is the order of the matrix.
c
c        a contains the input matrix to be balanced.
c
c     on output
c
c        a contains the balanced matrix.
c
c        low and igh are two integers such that a(i,j)
c          is equal to zero if
c           (1) i is greater than j and
c           (2) j=1,...,low-1 or i=igh+1,...,n.
c
c
c     note that 1 is returned for igh if igh is zero formally.
c
c     the algol procedure exc contained in balance appears in
c     balanc  in line.  (note that the algol roles of identifiers
c     k,l have been reversed.)
c
c     Questions and comments should be directed to Alan K. Cline,
c     Pleasant Valley Software, 8603 Altus Cove, Austin, TX 78759.
c     Electronic mail to cline@cs.utexas.edu.
c
c     this version dated january 1989. (for the IBM 3090vf)
c
c     ------------------------------------------------------------------
c
      radix = 16.0e0
c
      b2 = radix * radix
      k = 1
      l = n
      go to 100
c     .......... in-line procedure for row and
c                column exchange ..........
   20 continue 
      if (j .eq. m) go to 50
c
      do 30 i = 1, l
         f = a(i,j)
         a(i,j) = a(i,m)
         a(i,m) = f
   30 continue
c
      do 40 i = k, n
         f = a(j,i)
         a(j,i) = a(m,i)
         a(m,i) = f
   40 continue
c
   50 go to (80,130), iexc
c     .......... search for rows isolating an eigenvalue
c                and push them down ..........
   80 if (l .eq. 1) go to 280
      l = l - 1
c     .......... for j=l step -1 until 1 do -- ..........
  100 do 120 j = l, 1, -1
c
         do 110 i = 1, l
            if (i .eq. j) go to 110
            if (a(j,i) .ne. 0.0e0) go to 120
  110    continue
c
         m = l
         iexc = 1
         go to 20
  120 continue
c
      go to 140
c     .......... search for columns isolating an eigenvalue
c                and push them left ..........
  130 k = k + 1
c
  140 do 170 j = k, l
c
         do 150 i = k, l
            if (i .eq. j) go to 150
            if (a(i,j) .ne. 0.0e0) go to 170
  150    continue
c
         m = k
         iexc = 2
         go to 20
  170 continue
c     .......... iterative loop for norm reduction ..........
  190 noconv = .false.
c
      do 270 i = k, l
         c = 0.0e0
         r = 0.0e0
c
         do 200 j = k, l
            if (j .eq. i) go to 200
            c = c + abs(a(j,i))
            r = r + abs(a(i,j))
  200    continue
c     .......... guard against zero c or r due to underflow ..........
         if (c .eq. 0.0e0 .or. r .eq. 0.0e0) go to 270
         g = r / radix
         f = 1.0e0
         s = c + r
  210    if (c .ge. g) go to 220
         f = f * radix
         c = c * b2
         go to 210
  220    g = r * radix
  230    if (c .lt. g) go to 240
         f = f / radix
         c = c / b2
         go to 230
c     .......... now balance ..........
  240    if ((c + r) / f .ge. 0.95e0 * s) go to 270
         g = 1.0e0 / f
         noconv = .true.
c
         do 250 j = k, n
  250    a(i,j) = a(i,j) * g
c
         do 260 j = 1, l
  260    a(j,i) = a(j,i) * f
c
  270 continue
c
      if (noconv) go to 190
c
  280 low = k
      igh = l
      return
      end
      subroutine elmhes(nm,n,low,igh,a)
c
      integer i,j,m,n,nm,igh,low,mm1,mp1,ip
      real a(nm,n)
      real x,y
c
c     this subroutine is a translation of the algol procedure elmhes,
c     num. math. 12, 349-368(1968) by martin and wilkinson.
c     handbook for auto. comp., vol.ii-linear algebra, 339-358(1971).
c
c     given a real general matrix, this subroutine
c     reduces a submatrix situated in rows and columns
c     low through igh to upper hessenberg form by
c     stabilized elementary similarity transformations.
c
c     on input
c
c        nm must be set to the row dimension of two-dimensional
c          array parameters as declared in the calling program
c          dimension statement.
c
c        n is the order of the matrix.
c
c        low and igh are integers determined by the balancing
c          subroutine  balanc.  if  balanc  has not been used,
c          set low=1, igh=n.
c
c        a contains the input matrix.
c
c     on output
c
c        a contains the hessenberg matrix.  the multipliers
c          which were used in the reduction are stored in the
c          remaining triangle under the hessenberg matrix.
c
c        int contains information on the rows and columns
c          interchanged in the reduction.
c          only elements low through igh are used.
c
c     Questions and comments should be directed to Alan K. Cline,
c     Pleasant Valley Software, 8603 Altus Cove, Austin, TX 78759.
c     Electronic mail to cline@cs.utexas.edu.
c
c     this version dated january 1989. (for the IBM 3090vf)
c
c     ------------------------------------------------------------------
c
      do 180 m = low+1, igh-1
         mm1 = m - 1
         x = 0.0e0
         ip = m
c
         do 100 j = m, igh
            if (abs(a(j,mm1)) .le. abs(x)) go to 100
            x = a(j,mm1)
            ip = j
  100    continue
c
         if (x .eq. 0.0e0) goto 180
c
c     .......... interchange columns of a ..........
         do 120 j = 1, igh
            y = a(j,ip)
            a(j,ip) = a(j,m)
            a(j,m) = y
  120    continue
c
         y = a(ip,mm1)
         a(ip,mm1) = a(m,mm1)
         a(m,mm1) = y
c
         mp1 = m + 1
c
         do 135 i=mp1,igh
  135       a(i,mm1) = a(i,mm1)/x
c
c To avoid passing through the address space of  a  two times
c (as would be done if the LHS and RHS updates were performed
c one after the other) these updates are interleaved.
c Note that the inner loop, with label 138, must be executed
c for j=m,n, while the other iner loop, 139, is executed only
c for j=m+1,igh.)  To accomplish this, the outer loop (on j=m,n below)
c must be broken into three separate cases: j=m | j=m+1,igh | j=igh+1,n.
c
         y = a(ip,m)
         a(ip,m) = a(m,m)
         a(m,m) = y
         y = -y
         do 137 i = mp1, igh
  137       a(i,m) = a(i,m) + y * a(i,mm1)
c
         do 140 j = mp1, igh
            y = a(ip,j)
            a(ip,j) = a(m,j)
            a(m,j) = y
            y = -y
            do 138 i = mp1, igh
  138          a(i,j) = a(i,j) + y * a(i,mm1)
c"    ( ignore recrdeps
            do 139 i = 1, igh
  139          a(i,m) = a(i,m) + a(j,mm1)*a(i,j)
  140    continue
c
         do 150 j = igh+1, n
            y = a(ip,j)
            a(ip,j) = a(m,j)
            a(m,j) = y
            y = -y
            do 145 i = mp1, igh
  145          a(i,j) = a(i,j) + y * a(i,mm1)
  150    continue
c
  180 continue
c
      return
      end
      subroutine hqr(nm,n,low,igh,h,wr,wi,ierr)
c
      integer i,j,k,l,m,n,en,na,nm,igh,itn,its,low,enm2,ierr
      real h(nm,n),wr(n),wi(n)
      real p,q,r,s,t,w,x,y,zz,norm,tst1,tst2,foo
      logical notlas
c
c     this subroutine is a translation of the algol procedure hqr,
c     num. math. 14, 219-231(1970) by martin, peters, and wilkinson.
c     handbook for auto. comp., vol.ii-linear algebra, 359-371(1971).
c
c     this subroutine finds the eigenvalues of a real
c     upper hessenberg matrix by the qr method.
c
c     on input
c
c        nm must be set to the row dimension of two-dimensional
c          array parameters as declared in the calling program
c          dimension statement.
c
c        n is the order of the matrix.
c
c        low and igh are integers determined by the balancing
c          subroutine  balanc.  if  balanc  has not been used,
c          set low=1, igh=n.
c
c        h contains the upper hessenberg matrix.  information about
c          the transformations used in the reduction to hessenberg
c          form by  elmhes  or  orthes, if performed, is stored
c          in the remaining triangle under the hessenberg matrix.
c
c     on output
c
c        h has been destroyed.  therefore, it must be saved
c          before calling  hqr  if subsequent calculation and
c          back transformation of eigenvectors is to be performed.
c
c        wr and wi contain the real and imaginary parts,
c          respectively, of the eigenvalues.  the eigenvalues
c          are unordered except that complex conjugate pairs
c          of values appear consecutively with the eigenvalue
c          having the positive imaginary part first.  if an
c          error exit is made, the eigenvalues should be correct
c          for indices ierr+1,...,n.
c
c        ierr is set to
c          zero       for normal return,
c          j          if the limit of 30*n iterations is exhausted
c                     while the j-th eigenvalue is being sought.
c
c     Questions and comments should be directed to Alan K. Cline,
c     Pleasant Valley Software, 8603 Altus Cove, Austin, TX 78759.
c     Electronic mail to cline@cs.utexas.edu.
c
c     this version dated january 1989. (for the IBM 3090vf)
c
c     ------------------------------------------------------------------
c
      ierr = 0
      norm = 0.0e0
c     .......... store roots isolated by balanc
c                and compute matrix norm ..........
      do 50 j = 1, n
         do 50 i = 1,min0(n,j+1)
   50       norm = norm + abs(h(i,j))
c
c"    ( prefer vector
      do 52 i = 1, low-1
         wr(i) = h(i,i)
         wi(i) = 0.0e0
   52 continue
c
c"    ( prefer vector
      do 54 i = igh+1,n
         wr(i) = h(i,i)
         wi(i) = 0.0e0
   54 continue
c
      en = igh
      t = 0.0e0
      itn = 30*n
c     .......... search for next eigenvalues ..........
   60 if (en .lt. low) go to 1001
      its = 0
      na = en - 1
      enm2 = na - 1
c     .......... look for single small sub-diagonal element
c                for l=en step -1 until low do -- ..........
c     .......... changed lower bound to "low+1" and removed
c                test "if (l.eq.low) goto 100" [JMM] -- ..........
   70 do 80 l = en, low+1, -1
         s = abs(h(l-1,l-1)) + abs(h(l,l))
         if (s .eq. 0.0e0) s = norm
         tst1 = s
         tst2 = tst1 + abs(h(l,l-1))
         if (tst2 .eq. tst1) go to 100
   80 continue
c     .......... form shift ..........
  100 x = h(en,en)
      if (l .eq. en) go to 270
      y = h(na,na)
      w = h(en,na) * h(na,en)
      if (l .eq. na) go to 280
      if (itn .eq. 0) go to 1000
      if (its .ne. 10 .and. its .ne. 20) go to 130
c     .......... form exceptional shift ..........
      t = t + x
c
c"    ( prefer vector
      do 120 i = low, en
  120 h(i,i) = h(i,i) - x
c
      s = abs(h(en,na)) + abs(h(na,enm2))
      x = 0.75e0 * s
      y = x
      w = -0.4375e0 * s * s
  130 its = its + 1
      itn = itn - 1
c     .......... look for two consecutive small
c                sub-diagonal elements.
c                for m=en-2 step -1 until l do -- ..........
      do 140 m = en-2, l, -1
         zz = h(m,m)
         r = x - zz
         s = y - zz
         p = (r * s - w) / h(m+1,m) + h(m,m+1)
         q = h(m+1,m+1) - zz - r - s
         r = h(m+2,m+1)
         s = abs(p) + abs(q) + abs(r)
         p = p / s
         q = q / s
         r = r / s
         if (m .eq. l) go to 150
         tst1 = abs(p)*(abs(h(m-1,m-1)) + abs(zz) + abs(h(m+1,m+1)))
         tst2 = tst1 + abs(h(m,m-1))*(abs(q) + abs(r))
         if (tst2 .eq. tst1) go to 150
  140 continue
c
  150 h(m+2,m) = 0.0e0
c"    ( prefer vector
      do 160 i = m+3, en
         h(i,i-2) = 0.0e0
         h(i,i-3) = 0.0e0
  160 continue
c     .......... double qr step involving rows l to en and
c                columns m to en ..........
      do 260 k = m, na
         notlas = k .ne. na
         if (k .eq. m) go to 170
         p = h(k,k-1)
         q = h(k+1,k-1)
         r = 0.0e0
         if (notlas) r = h(k+2,k-1)
         x = abs(p) + abs(q) + abs(r)
         if (x .eq. 0.0e0) go to 260
         p = p / x
         q = q / x
         r = r / x
  170    s = sign(sqrt(p*p+q*q+r*r),p)
         if (k .eq. m) go to 180
         h(k,k-1) = -s * x
         go to 190
  180    if (l .ne. m) h(k,k-1) = -h(k,k-1)
  190    p = p + s
         x = p / s
         y = q / s
         zz = r / s
         q = q / p
         r = r / p
         if (notlas) go to 225
c     .......... row modification ..........
c"    ( prefer vector
         do 200 j = k, en
            foo = h(k,j) + q * h(k+1,j)
            h(k,j) = h(k,j) - foo * x
            h(k+1,j) = h(k+1,j) - foo * y
  200    continue
c
         j = min0(en,k+3)
c     .......... column modification ..........
         do 210 i = l, j
            foo = x * h(i,k) + y * h(i,k+1)
            h(i,k) = h(i,k) - foo
            h(i,k+1) = h(i,k+1) - foo * q
  210    continue
         go to 255
  225    continue
c     .......... row modification ..........
c"    ( prefer vector
         do 230 j = k, en
            foo = h(k,j) + q * h(k+1,j) + r * h(k+2,j)
            h(k,j) = h(k,j) - foo * x
            h(k+1,j) = h(k+1,j) - foo * y
            h(k+2,j) = h(k+2,j) - foo * zz
  230    continue
c
         j = min0(en,k+3)
c     .......... column modification ..........
         do 240 i = l, j
            foo = x * h(i,k) + y * h(i,k+1) + zz * h(i,k+2)
            h(i,k) = h(i,k) - foo
            h(i,k+1) = h(i,k+1) - foo * q
            h(i,k+2) = h(i,k+2) - foo * r
  240    continue
  255    continue
c
  260 continue
c
      go to 70
c     .......... one root found ..........
  270 wr(en) = x + t
      wi(en) = 0.0e0
      en = na
      go to 60
c     .......... two roots found ..........
  280 p = (y - x) / 2.0e0
      q = p * p + w
      zz = sqrt(abs(q))
      x = x + t
      if (q .lt. 0.0e0) go to 320
c     .......... real pair ..........
      zz = p + sign(zz,p)
      wr(na) = x + zz
      wr(en) = wr(na)
      if (zz .ne. 0.0e0) wr(en) = x - w / zz
      wi(na) = 0.0e0
      wi(en) = 0.0e0
      go to 330
c     .......... complex pair ..........
  320 wr(na) = x + p
      wr(en) = x + p
      wi(na) = zz
      wi(en) = -zz
  330 en = enm2
      go to 60
c     .......... set error -- all eigenvalues have not
c                converged after 30*n iterations ..........
 1000 ierr = en
 1001 return
      end
