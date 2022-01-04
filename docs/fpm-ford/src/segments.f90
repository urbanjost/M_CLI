program testit
integer :: red,green,blue ; namelist/nml_color/red,green,blue
real :: width,height,depth; namelist/nml_size/width,height,depth
namelist/nml_all/ red,green,blue,width,height,depth
character(len=:),allocatable :: file(:)
   file=[character(len=80) :: &
   & ' The values specifying the color of the model',       &
   & '&NML_COLOR',                                          &
   & ' RED=255,',                                           &
   & ' GREEN=255,',                                         &
   & ' BLUE=0,',                                            &
   & ' /',                                                  &
   & ' The values specifying the geometry ',                &
   & ' of the model',                                       &
   & '&NML_SIZE',                                           &
   & ' WIDTH=  10.0000000,',                                &
   & ' HEIGHT=  20.0000000,',                               &
   & ' DEPTH=  30.0000000,',                                &
   & ' /',                                                  &
   & '']
read(file,nml=nml_color) ! can just read colors
read(file,nml=nml_size)
write(*,nml=nml_all)
end program testit
