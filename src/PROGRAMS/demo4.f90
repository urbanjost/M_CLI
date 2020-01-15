program show_get_commandline_unix_prototype
!! QUICK PROTOTYPE WITH IMPLICIT TYPING
use M_CLI,  only : get_commandline, print_dictionary
character(len=:),allocatable :: readme ! stores updated namelist
character(len=*),parameter   :: cmd='-x 1 -y 2 -z 3'
character(len=256)           :: message
namelist /args/ x,y,z
   readme=get_commandline(cmd)
   read(readme,nml=args,iostat=ios,iomsg=message)
   if(ios.ne.0)then
      write(*,'("ERROR IN COMMAND ARGUMENTS:",i0,1x,a)')ios,message
      call print_dictionary()
      stop 2
   endif
   !! ALL DONE CRACKING THE COMMAND LINE.  USE THE VALUES IN YOUR PROGRAM.
   write(*,nml=args)
end program show_get_commandline_unix_prototype
