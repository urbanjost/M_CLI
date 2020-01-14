program show_get_commandline_unix_prototype
use M_CLI,  only : unnamed, get_commandline, print_dictionary, debug
implicit none
integer                      :: i
character(len=255) :: message ! use for I/O error messages
character(len=:),allocatable :: readme ! stores updated namelist
integer                      :: ios

! declare a namelist
real               :: x, y, z, point(3)
character(len=80)  :: title
logical            :: help, version, l, l_, v, h
equivalence       (help,h),(version,v)
namelist /args/ x,y,z,point,title,help,h,version,v,l,l_

   ! Define the prototype
   !  o All parameters must be listed with a default value
   !  o string values  must be double-quoted
   !  o numeric lists must be comma-delimited. No spaces are allowed
   !  o a short uppercase name -L maps to a variable in the NAMELIST of name L_
   !  o long keynames must be all lowercase

   readme=get_commandline('&
    & -x 1 -y 2 -z 3     &
    & --point -1,-2,-3   &
    & --title "my title" &
    & -h --help          &
    & -v --version       &
    & -l -L              &
   ')
   read(readme,nml=args,iostat=ios,iomsg=message)
   if(ios.ne.0)then
      write(*,'("ERROR:",i0,1x,a)')ios, trim(message)
      call print_dictionary('OPTIONS:')
      stop 1
   endif
   ! all done cracking the command line

   ! use the values in your program.
   write(*,nml=args)

   ! the optional unnamed values on the command line are
   ! accumulated in the character array "UNNAMED"
   if(size(unnamed).gt.0)then
      write(*,'(a)')'files:'
      write(*,'(i6.6,3a)')(i,'[',unnamed(i),']',i=1,size(unnamed))
   endif

end program show_get_commandline_unix_prototype
