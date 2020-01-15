program quick_and_dirty
!! QUICK PROTOTYPE: JUST THE BARE ESSENTIALS
use M_CLI,  only : get_commandline
implicit none
character(len=:),allocatable :: readme ! stores updated namelist
integer                      :: x, y, z
namelist /args/ x,y,z
   readme=get_commandline('-x 1 -y 10 -z 100')
   read(readme,nml=args)
   write(*,*)x,y,z, x+y+z
end program quick_and_dirty
