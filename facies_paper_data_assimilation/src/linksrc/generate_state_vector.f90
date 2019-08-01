program generate_state_vector
  implicit none
  integer :: i,j,ii
  character*100 fname,tprogsname
  integer :: nreaz,nx,ny,nz,ix,iy,iz,nfacies,nnode
  character*100 :: FNi
  integer :: FaciesType
  real*8 :: xmin,ymin,zmin,dx,dy,dz
  real*8 :: random_temp
  integer ::  hard_data_index
  integer ::  hard_data_value
  integer :: iofile
  character*100 :: tsim_in_file,norm_table_file,hard_data_file
  character*100 :: state_vector_file,perm_vector_file
  real*8,allocatable,dimension(:,:) :: Perm_vector
  character*100 :: temp_getarg
  real*8 :: prob_cdf,cdf_gauss,mean_gauss,std_gauss
  real*8 :: r8_normal_01_cdf_inverse  
 
  real*8,allocatable,dimension(:,:) :: stavec
  real*8,allocatable,dimension(:,:) :: indicator
  real*8,allocatable,dimension(:) :: ref_indicator
  real*8,allocatable,dimension(:) :: diffvec
  real*8,allocatable,dimension(:) :: rmse
  real*8,allocatable,dimension(:) :: mean_stavec
  real*8,allocatable,dimension(:) :: mean_indicator
  real*8,allocatable,dimension(:) :: var_stavec
  real*8,allocatable,dimension(:) :: var_indicator


  !-----  FOR NOISY OBSERVATION  ----
  !integer :: KORDEI,MAXOP1,IERR,MAXINT,IDUM
  !integer :: IXV
  !parameter (KORDEI=12,MAXOP1=KORDEI+1,MAXINT=2**30)
  real xp   !REAL HERE
  REAL*8 :: p   !acorni
  integer :: ierr
  !   COMMON/iaco/ ixv(MAXOP1)


  call getarg(1,tsim_in_file)
  call getarg(2,hard_data_file)
  call getarg(3,state_vector_file)
  call getarg(4,perm_vector_file)
  call getarg(5,temp_getarg)
  read(temp_getarg,*) nreaz

  open(100,file=trim(tsim_in_file),status='old')
  read(100,*)   nfacies
  read(100,*)
  read(100,'(a20)') tprogsname
  read(100,*)
  read(100,*)
  read(100,*)
  read(100,*)
  read(100,*) 
  read(100,*) xmin,nx,dx
  read(100,*) ymin,ny,dy
  read(100,*) zmin,nz,dz
  close(100)


  nnode=nx*ny*nz

  allocate(indicator(Nnode,Nreaz))
  allocate(stavec(nnode,nreaz))
  allocate(diffvec(Nnode))
  allocate(ref_indicator(Nnode))
  allocate(mean_stavec(Nnode))
  allocate(mean_indicator(Nnode))
  allocate(var_stavec(Nnode))
  allocate(var_indicator(Nnode))
  allocate(rmse(nnode))
  allocate(perm_vector(nfacies,nreaz))

  indicator=0.
  stavec=0.
  diffvec=0.
  ref_indicator=0.
  mean_stavec=0.
  mean_indicator=0.
  var_stavec=0.
  var_indicator=0.
  rmse=0.

  i=1
  do i=1,nreaz
     if (i.le.9) then
        write(FNi,'(I1)') i        
     elseif(i.le.99) then   
        write(FNi,'(I2)') i        
     elseif(i.le.999) then  
        write(FNi,'(I3)') i        
     else
        write(FNi,'(I4)') i        
     endif
     
     fname=trim(tprogsname)//trim(FNi)
     open(100,file=trim(fname),status='old')
     read(100,*)
     read(100,*)
     do ii=1,nnode
        read(100,*) FaciesType
        if (abs(faciestype).le.1) then 
        indicator(ii,i)=1
        else
        indicator(ii,i)=0
        endif
     enddo
     close(100)
  enddo
  mean_indicator=sum(indicator,dim=2)/real(nreaz)

  do ii=1,nnode
     std_gauss=1.0
     prob_cdf=mean_indicator(ii)
     prob_cdf=max(min(0.99995,prob_cdf),0.00005)
     cdf_gauss=0.+std_gauss*r8_normal_01_cdf_inverse(prob_cdf)
     mean_gauss=cdf_gauss

     do i=1,nreaz
        if (abs(indicator(ii,i)).eq.1) then
           random_temp=-0.1
           do while(random_temp.lt.0) 

              !            p = acorni(idum)
              call random_number(p)
              CALL gauinv(p,xp,ierr)  !!!?????????????????
              random_temp= mean_gauss+xp*std_gauss
           enddo

        else
           random_temp=0.1
           do while(random_temp.ge.0) 

              !            p = acorni(idum)
              call random_number(p)
              CALL gauinv(p,xp,ierr)  !!!?????????????????
              random_temp= mean_gauss+xp*std_gauss
           enddo
        endif
        stavec(ii,i)=random_temp
     enddo
  enddo
  mean_stavec=sum(stavec,dim=2)/real(nreaz)

  open(100,file=trim(hard_data_file),status='old')
  do while (.true.)
     read(100,*,IOSTAT=iofile) hard_data_index,hard_data_value
     if (iofile.ne.0) then
        exit
     endif
     if (hard_data_value.gt.0.5) then
        indicator(hard_data_index,:)=1
        mean_indicator(hard_data_index)=1
        stavec(hard_data_index,:)=10
        mean_stavec(hard_data_index)=10
     else
        indicator(hard_data_index,:)=0
        mean_indicator(hard_data_index)=0
        stavec(hard_data_index,:)=-10
        mean_stavec(hard_data_index)=-10
     endif
  enddo
  close(100)

  open(100,file=trim(perm_vector_file),status='old')
  do i=1,nreaz
     read(100,*) (perm_vector(j,i),j=1,nfacies)
  enddo
  close(100)

  open(100,file=trim(State_vector_file),status='unknown')
  do i=1,nreaz

     do iz=1,nz-1
        do iy=1,ny
           do ix=1,nx-1
              write(100,'(f16.8)',advance='no') stavec(ix+(iy-1+(iz-1)*nz)*ny,i)
           enddo
        enddo
     enddo

     do j=1,nfacies
        write(100,'(f16.8)',advance='no') perm_vector(j,i)
     enddo

     write(100,*)
  enddo
  close(100)

  fname='dainput/ref.dat'
  open (100,file=fname,status='old')
  do iz=1,nz-1
     do iy=1,ny
        do ix=1,nx-1
           i=ix+(iy-1+(iz-1)*nz)*ny
           read (100,*) ref_indicator(i)
           do J=1,Nreaz
              diffvec(i)=diffvec(i)+(indicator(i,j)-ref_indicator(i))**2
              var_stavec(i)=var_stavec(i)+(stavec(i,j)-mean_stavec(i))**2
              var_indicator(i)=var_indicator(i)+(indicator(i,j)-mean_indicator(i))**2
           enddo
           rmse(i)=(mean_indicator(i)-ref_indicator(i))**2
        enddo
     enddo
  enddo
  close(100)

  diffvec=diffvec/real(nreaz)
  var_indicator=var_indicator/real(nreaz-1)
  var_stavec=var_stavec/real(nreaz-1)


  fname=trim(trim('prob.dat'))
  open (100,file=trim(fname),status='unknown')
  do iz=1,nz-1
     do iy=1,ny
        do ix=1,nx-1
           i=ix+(iy-1+(iz-1)*nz)*ny
           write(100,'(6f16.6)') mean_indicator(i),   &
                                 & var_indicator(i),  &
                                 & rmse(i),           &
                                 & diffvec(i),        &
                                 & mean_stavec(i),    &
                                 & var_stavec(i)

        enddo
     enddo
  enddo
  close(100)

  deallocate(stavec)
  deallocate(indicator)
  deallocate(diffvec)
  deallocate(ref_indicator)
  deallocate(mean_stavec)
  deallocate(mean_indicator)
  deallocate(var_stavec)
  deallocate(var_indicator)
  deallocate(rmse)
   deallocate(perm_vector)
end program generate_state_vector




function r8_normal_01_cdf_inverse ( p )

  !*****************************************************************************80
  !
  !! R8_NORMAL_01_CDF_INVERSE inverts the standard normal CDF.
  !
  !  Discussion:
  !
  !    The result is accurate to about 1 part in 10**16.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    27 December 2004
  !
  !  Author:
  !
  !    Original FORTRAN77 version by Michael Wichura.
  !    FORTRAN90 version by John Burkardt.
  !
  !  Reference:
  !
  !    Michael Wichura,
  !    The Percentage Points of the Normal Distribution,
  !    Algorithm AS 241,
  !    Applied Statistics,
  !    Volume 37, Number 3, pages 477-484, 1988.
  !
  !  Parameters:
  !
  !    Input, real ( kind = 8 ) P, the value of the cumulative probability 
  !    densitity function.  0 < P < 1.  If P is outside this range,
  !    an "infinite" value will be returned.
  !
  !    Output, real ( kind = 8 ) D_NORMAL_01_CDF_INVERSE, the normal deviate 
  !    value with the property that the probability of a standard normal 
  !    deviate being less than or equal to the value is P.
  !
  implicit none

  real ( kind = 8 ), parameter, dimension ( 8 ) :: a = (/ &
       3.3871328727963666080D+00, &
       1.3314166789178437745D+02, &
       1.9715909503065514427D+03, &
       1.3731693765509461125D+04, &
       4.5921953931549871457D+04, &
       6.7265770927008700853D+04, &
       3.3430575583588128105D+04, &
       2.5090809287301226727D+03 /)
  real ( kind = 8 ), parameter, dimension ( 8 ) :: b = (/ &
       1.0D+00, &
       4.2313330701600911252D+01, &
       6.8718700749205790830D+02, &
       5.3941960214247511077D+03, &
       2.1213794301586595867D+04, &
       3.9307895800092710610D+04, &
       2.8729085735721942674D+04, &
       5.2264952788528545610D+03 /)
  real   ( kind = 8 ), parameter, dimension ( 8 ) :: c = (/ &
       1.42343711074968357734D+00, &
       4.63033784615654529590D+00, &
       5.76949722146069140550D+00, &
       3.64784832476320460504D+00, &
       1.27045825245236838258D+00, &
       2.41780725177450611770D-01, &
       2.27238449892691845833D-02, &
       7.74545014278341407640D-04 /)
  real ( kind = 8 ), parameter :: const1 = 0.180625D+00
  real ( kind = 8 ), parameter :: const2 = 1.6D+00
  real ( kind = 8 ), parameter, dimension ( 8 ) :: d = (/ &
       1.0D+00, &
       2.05319162663775882187D+00, &
       1.67638483018380384940D+00, &
       6.89767334985100004550D-01, &
       1.48103976427480074590D-01, &
       1.51986665636164571966D-02, &
       5.47593808499534494600D-04, &
       1.05075007164441684324D-09 /)
  real ( kind = 8 ), parameter, dimension ( 8 ) :: e = (/ &
       6.65790464350110377720D+00, &
       5.46378491116411436990D+00, &
       1.78482653991729133580D+00, &
       2.96560571828504891230D-01, &
       2.65321895265761230930D-02, &
       1.24266094738807843860D-03, &
       2.71155556874348757815D-05, &
       2.01033439929228813265D-07 /)
  real ( kind = 8 ), parameter, dimension ( 8 ) :: f = (/ &
       1.0D+00, &
       5.99832206555887937690D-01, &
       1.36929880922735805310D-01, &
       1.48753612908506148525D-02, &
       7.86869131145613259100D-04, &
       1.84631831751005468180D-05, &
       1.42151175831644588870D-07, &
       2.04426310338993978564D-15 /)
  real ( kind = 8 ) p
  real ( kind = 8 ) q
  real ( kind = 8 ) r
  real ( kind = 8 ) r8_normal_01_cdf_inverse 
  real ( kind = 8 ) r8poly_value
  real ( kind = 8 ), parameter :: split1 = 0.425D+00
  real ( kind = 8 ), parameter :: split2 = 5.0D+00

  if ( p <= 0.0D+00 ) then
     r8_normal_01_cdf_inverse = - huge ( p )
     return
  end if

  if ( 1.0D+00 <= p ) then
     r8_normal_01_cdf_inverse = huge ( p )
     return
  end if

  q = p - 0.5D+00

  if ( abs ( q ) <= split1 ) then

     r = const1 - q * q
     r8_normal_01_cdf_inverse = q * r8poly_value ( 8, a, r ) &
          / r8poly_value ( 8, b, r )

  else

     if ( q < 0.0D+00 ) then
        r = p
     else
        r = 1.0D+00 - p
     end if

     if ( r <= 0.0D+00 ) then
        r8_normal_01_cdf_inverse = - 1.0D+00
        stop
     end if

     r = sqrt ( -log ( r ) )

     if ( r <= split2 ) then

        r = r - const2
        r8_normal_01_cdf_inverse = r8poly_value ( 8, c, r ) &
             / r8poly_value ( 8, d, r )

     else

        r = r - split2
        r8_normal_01_cdf_inverse = r8poly_value ( 8, e, r ) &
             / r8poly_value ( 8, f, r )

     end if

     if ( q < 0.0D+00 ) then
        r8_normal_01_cdf_inverse = - r8_normal_01_cdf_inverse
     end if

  end if

  return
end function r8_normal_01_cdf_inverse




function r8poly_value ( n, a, x )

  !*****************************************************************************80
  !
  !! R8POLY_VALUE evaluates an R8POLY
  !
  !  Discussion:
  !
  !    For sanity's sake, the value of N indicates the NUMBER of 
  !    coefficients, or more precisely, the ORDER of the polynomial,
  !    rather than the DEGREE of the polynomial.  The two quantities
  !    differ by 1, but cause a great deal of confusion.
  !
  !    Given N and A, the form of the polynomial is:
  !
  !      p(x) = a(1) + a(2) * x + ... + a(n-1) * x^(n-2) + a(n) * x^(n-1)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    13 August 2004
  !
  !  Author:
  !
  !    John Burkardt
  !
  !  Parameters:
  !
  !    Input, integer ( kind = 4 ) N, the order of the polynomial.
  !
  !    Input, real ( kind = 8 ) A(N), the coefficients of the polynomial.
  !    A(1) is the constant term.
  !
  !    Input, real ( kind = 8 ) X, the point at which the polynomial is 
  !    to be evaluated.
  !
  !    Output, real ( kind = 8 ) R8POLY_VALUE, the value of the polynomial at X.
  !
  implicit none

  integer ( kind = 4 ) n

  real ( kind = 8 ) a(n)
  integer ( kind = 4 ) i
  real ( kind = 8 ) r8poly_value
  real ( kind = 8 ) x

  r8poly_value = 0.0D+00
  do i = n, 1, -1
     r8poly_value = r8poly_value * x + a(i)
  end do

  return
end function r8poly_value

