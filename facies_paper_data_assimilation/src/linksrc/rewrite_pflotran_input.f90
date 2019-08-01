program rewrite_pflotran_input
  implicit none
  character*100 :: temp_a
  character*100 :: pflotran_mc_file_in
  character*100 :: pflotran_mc_file_out
  character*100 :: par_file
  character*100 :: temp_getarg
  integer :: i, ntime,jtime,iofile
  character*100 :: test_a
  real*8,allocatable,dimension(:) :: da_time


  call getarg(1,pflotran_mc_file_in)
  call getarg(2,pflotran_mc_file_out)
  call getarg(3,par_file)
  call getarg(4,temp_getarg)
  read(temp_getarg,*) jtime

  open(100,file=trim(par_file),status='old')   
  read(100,*) Ntime
  allocate(da_time(Ntime))
  read(100,*) (da_time(i),i=1,Ntime)
  close(100)   


  open (100,file=trim(pflotran_mc_file_in),status='old')
  open(200,file=trim(pflotran_mc_file_out),status='unknown')

  do while(.true.)
     read(100,"(a100)",IOSTAT=iofile) temp_a

     if (iofile.ne.0) then
        exit
     endif
     if (trim(temp_a).eq."") then
        write (200,"(a100)") temp_a
     else
        BACKSPACE 100
        read(100,*) test_a
        if (trim(test_a).eq.'TIMES') then
           write(200,*) "TIMES d ",da_time(jtime)
        elseif (trim(test_a).eq.'FINAL_TIME') then
           write(200,*) "FINAL_TIME ",da_time(jtime)," d"
        else
           write (200,"(a100)") temp_a

        endif
     endif
  enddo

  close(100)
  close(200)

  deallocate(da_time)

end program rewrite_pflotran_input
