program produce_condition_data
  implicit none
  integer :: i,j
  integer :: nx,ny,nz,ix,iy,iz,nfacies
  real*8 :: xmin,ymin,zmin,dx,dy,dz
  real*8,dimension(:,:) ::  Faciesprob(10000,2)
  real*8,dimension(:,:) ::  Faciesprob_pr(10000,2)
  character*100 :: temp_a
  character*100 :: tsim_in_file
  character*100 :: New_data_file
  character*100 :: All_data_file
  character*100 :: Basic_data_file
  integer :: iofile
  real*8 ::   threshold = 0.20

  call getarg(1,tsim_in_file)
  call getarg(2,Basic_data_file)
  call getarg(3,New_data_file)
  call getarg(4,All_data_file)


  open(100,file=trim(tsim_in_file),status='old')
  read(100,*)   nfacies
  read(100,*)
  read(100,*) 
  read(100,*)
  read(100,*)
  read(100,*)
  read(100,*)
  read(100,*) 
  read(100,*) xmin,nx,dx
  read(100,*) ymin,ny,dy
  read(100,*) zmin,nz,dz
  close(100)


  open(100,file=trim(New_data_file),status='old')
  do i=1,(nx-1)*ny*(nz-1)
     read(100,*) FaciesProb(i,1)
     faciesprob(i,2)=1-FaciesProb(i,1)
  enddo
  close(100)



  open(100,file="results/prob.0",status='old')
  do i=1,(nx-1)*ny*(nz-1)
     read(100,*) FaciesProb_pr(i,1)
     faciesprob_pr(i,2)=1-FaciesProb_pr(i,1)
  enddo
  close(100)

  

  open(100,file=trim(All_data_file),status='unknown')
!  open(200,file=trim(Basic_data_file),status='old')
  open(200,file="dainput/prior_data.eas",status='old')
  do while(.true.)
     read (200,'(a100)',IOSTAT=iofile) temp_a
     if (iofile.ne.0) then
        exit
     endif
     write(100,'(a100)') temp_a     
  enddo
  close(200)
  
  i=1
  do iz=1,nz-1
     do iy=1,ny
        do ix=1,nx-1

           if (abs(faciesprob_pr(i,1)-faciesprob(i,1))>threshold) then
              if (abs(max(faciesprob_pr(i,1),1-faciesprob_pr(i,1)))>0.7) then

                 write(100,'(3f10.5)',advance='no') xmin+dx*(ix-1),ymin+dy*(iy-1),zmin+dz*(iz-1)
                 do j=1,nfacies-1
                    write(100,'(f10.5)',advance='no') FaciesProb(i,j)
                 enddo
                 write(100,'(f10.5)') FaciesProb(i,nfacies)     

              endif
           endif

           i=i+1
        enddo
     enddo
  enddo
  close(100)




  ! open(100,file="conditional.dat",status='unknown')
  ! open(200,file="dainput/prior_data.eas",status='old')
  ! do while(.true.)
  !    read (200,'(a100)',IOSTAT=iofile) temp_a
  !    if (iofile.ne.0) then
  !       exit
  !    endif
  !    write(100,'(a100)') temp_a     
  ! enddo
  ! close(200)

  ! i=1
  ! do iz=1,nz-1
  !    do iy=1,ny
  !       do ix=1,nx-1

  !          if (abs(faciesprob_pr(i,1)-faciesprob(i,1))>threshold) then

  !             write(100,'(3f10.5)',advance='no') xmin+dx*(ix-1),ymin+dy*(iy-1),zmin+dz*(iz-1)
  !             do j=1,nfacies-1
  !                write(100,'(f10.5)',advance='no') FaciesProb(i,j)
  !             enddo
  !             write(100,'(f10.5)') FaciesProb(i,nfacies)     

  !          endif

  !          i=i+1
  !       enddo
  !    enddo
  ! enddo
  ! close(100)










end program produce_condition_data


