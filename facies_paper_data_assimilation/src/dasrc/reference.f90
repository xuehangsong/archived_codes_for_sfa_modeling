! subroutine ref_idw
!   use DA_Data
!   implicit none
!   integer :: i,j
!   character*100 ::fname
!   real*8,allocatable,dimension(:,:) :: ref_obs_var
!   real*8,allocatable,dimension(:,:) :: ref_obs

!   allocate(ref_obs(Nobs,ntime),ref_obs_var(Nobs,ntime))

!   fname="reference/"

!   open(100,file=trim(trim(fname)//"ref_obs_var.dat"),status="unknown")
!   do jtime=1,Ntime
!      read(100,*) ref_obs_var(1:Nobs,jtime)
!   enddo
!   close(100)

!   Do jtime=1,Ntime
!      write(FNjtime(1:4),"(I4.4)") Jtime
!      call simulator_IDW(fname,power_idw_array(jtime),FNjtime) 
!   enddo



!   Do jtime=1,Ntime
!      write(FNjtime(1:4),"(I4.4)") Jtime
!      open(100,file=trim(fname)//'obs_idw_'//Fnjtime//'.dat')
!      read(100,*)
!      read(100,*)
!      read(100,*)
!      do i=1,Nobs
!         read (100,*) ref_obs(i,jtime),ref_obs(i,jtime),ref_obs(i,jtime),ref_obs(i,jtime)
!      enddo
!      close(100)  
!   Enddo



!   Do jtime=1,Ntime
!      write(FNjtime(1:4),"(I4.4)") Jtime
!      fname="obsdata/"//"obs_"//FNJtime//'.dat'
!      open(100,file=trim(fname),status='unknown')

!      do i=1,Nobs
!         write(100,'(2f32.8)') ref_obs(i,jtime),ref_obs_var(i,jtime)
!      enddo

!      close(100)
!   enddo




!   deallocate(ref_obs,ref_obs_var)
! end subroutine ref_idw
