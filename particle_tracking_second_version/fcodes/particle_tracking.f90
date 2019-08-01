Program ParticleTracking

  use hdf5
  implicit none
  
  
  fname="ParticleTrackingInput/parameter.txt"
  open(100,file=trim(fname),status="old")
  read(100,*) nx,ny,nz
  close(100)

end module ParticleTracking
