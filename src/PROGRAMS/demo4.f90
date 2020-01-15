program quick_and_dirty
!! QUICK PROTOTYPE: JUST THE BARE ESSENTIALS
use M_CLI,  only : get_commandline
implicit none
character(len=:),allocatable :: readme ! stores updated namelist
integer                      :: ios
complex                      :: x, y, z; namelist /args/ x,y,z
   write(*,*)'the values probably have to be quoted on input to escape the () characters'
   readme=get_commandline('-x (1,2) -y (10,20) -z (100,200)')
   read(readme,nml=args)
   write(*,*)x,y,z, x+y+z
end program quick_and_dirty
