program show_get_commandline_unix_prototype
!! SET_COMMANDLINE NOT NEEDED IF INITIALIZE ALL NAMELIST VALUES
use M_CLI,  only : unnamed, get_commandline, print_dictionary, debug
implicit none
integer                      :: i
character(len=255)           :: message ! use for I/O error messages
character(len=:),allocatable :: readme ! stores updated namelist
integer                      :: ios
!! DEFINE NAMELIST WITH DEFAULT VALUES SPECIFIED
real               :: x=1, y=2, z=3, point(3)=[-1,-2,-3]
character(len=80)  :: title="my title"
logical            :: help=.false., version=.false., l=.false., l_=.false., v=.false., h=.false.
equivalence       (help,h),(version,v)
namelist /args/ x,y,z,point,title,help,h,version,v,l,l_
!!  MAKE A MATCHING PROTOTYPE
character(len=*),parameter :: cmd='-x 1 -y 2 -z 3 --point -1,-2,-3 --title "my title" -h --help -v --version -l -L'

   !! CALL TO PROCESS COMMAND LINE ARGUMENTS
   readme=get_commandline(cmd)
   read(readme,nml=args,iostat=ios,iomsg=message)
   if(ios.ne.0)then
      write(*,'("ERROR IN COMMAND ARGUMENTS:",i0,1x,a)')ios, trim(message)
      call print_dictionary('OPTIONS:')
      stop 2
   endif
   !! ALL DONE CRACKING THE COMMAND LINE.  USE THE VALUES IN YOUR PROGRAM.
   write(*,nml=args)
   !! THE OPTIONAL UNNAMED VALUES ON THE COMMAND LINE ARE IN "UNNAMED"
   if(size(unnamed).gt.0)then
      write(*,'(a)')'files:'
      write(*,'(i6.6,3a)')(i,'[',unnamed(i),']',i=1,size(unnamed))
   endif
end program show_get_commandline_unix_prototype
