program show_get_commandline_unix_prototype
use M_CLI,  only : unnamed, set_commandline, get_commandline, print_dictionary, debug
implicit none
integer                      :: i
character(len=255)           :: message ! use for I/O error messages
character(len=:),allocatable :: readme  ! stores updated namelist
integer                      :: ios

!! DECLARE A NAMELIST
real               :: x           ;namelist /args/ x
real               :: y           ;namelist /args/ y
real               :: z           ;namelist /args/ z
real               :: point(3)    ;namelist /args/ point
character(len=80)  :: title       ;namelist /args/ title
logical            :: help, h     ;namelist /args/ help, h
logical            :: version, v  ;namelist /args/ version, v
logical            :: l           ;namelist /args/ l
logical            :: l_          ;namelist /args/ l_
equivalence       (help,h),(version,v)

!! DEFINE THE PROTOTYPE MATCHING THE NAMELIST
   !  o All parameters must be listed with a default value
   !  o string values  must be double-quoted
   !  o numeric lists must be comma-delimited. No spaces are allowed
   !  o a short uppercase name -L maps to a variable in the NAMELIST of name L_
   !  o long keynames must be all lowercase
character(len=*),parameter :: cmd='&

    & -x 1 -y 2 -z 3     &
    & --point -1,-2,-3   &
    & --title "my title" &
    & -h --help          &
    & -v --version       &
    & -l -L              &
    '
   !! MAKE SURE ALL DEFAULT VALUES ARE SET
   readme=set_commandline(cmd)
   read(readme,nml=args,iostat=ios,iomsg=message)
   if(ios.ne.0)then
      write(*,'("ERROR IN COMMAND DEFINITION:",i0,1x,a)')ios, trim(message)
      call print_dictionary('OPTIONS:')
      stop 1
   endif

   !! ADD IN COMMAND LINE VALUES
   readme=get_commandline(cmd)
   read(readme,nml=args,iostat=ios,iomsg=message)
   if(ios.ne.0)then
      write(*,'("ERROR IN COMMAND LINE VALUES:",i0,1x,a)')ios, trim(message)
      call print_dictionary('OPTIONS:')
      stop 1
   endif

   !! ALL DONE CRACKING THE COMMAND LINE

   !! USE THE VALUES IN YOUR PROGRAM.
   write(*,nml=args)

   ! the optional unnamed values on the command line are
   ! accumulated in the character array "UNNAMED"
   if(size(unnamed).gt.0)then
      write(*,'(a)')'files:'
      write(*,'(i6.6,3a)')(i,'[',unnamed(i),']',i=1,size(unnamed))
   endif

end program show_get_commandline_unix_prototype
