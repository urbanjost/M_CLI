program show_get_commandline_unix_prototype
use M_CLI,  only : unnamed, get_commandline, check_commandline_status, print_dictionary
implicit none
integer            :: i

!! DECLARE A NAMELIST CALLED "ARGS"
real               :: x           ;namelist /args/ x
real               :: y           ;namelist /args/ y
real               :: z           ;namelist /args/ z
real               :: point(3)    ;namelist /args/ point
character(len=80)  :: title       ;namelist /args/ title
logical            :: help, h     ;namelist /args/ help, h
logical            :: version, v  ;namelist /args/ version, v
logical            :: usage, u    ;namelist /args/ usage, u
logical            :: l           ;namelist /args/ l
logical            :: l_          ;namelist /args/ l_
equivalence       (help,h),(version,v)

!! -x-x-x-x CUT HERE  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
   COMMANDLINE: block 
!! WHEN DEFINING THE PROTOTYPE MATCHING THE NAMELIST
   !  o All parameters must be listed with a default value
   !  o string values  must be double-quoted
   !  o numeric lists must be comma-delimited. No spaces are allowed
   !  o a short uppercase name -L maps to a variable in the NAMELIST of name L_
   !  o long keynames must be all lowercase

   !! SET ALL ARGUMENTS TO DEFAULTS AND THEN ADD IN COMMAND LINE VALUES
   character(len=:),allocatable :: readme  ! stores updated namelist
   character(len=256)           :: message
   integer                      :: ios
   readme=get_commandline(' &
       & -x 1 -y 2 -z 3     &
       & --point -1,-2,-3   &
       & --title "my title" &
       & -h F --help F      &
       & -v F --version F   &
       & -u F --usage F     &
       & -l F -L F          &
   ')
   read(readme,nml=args,iostat=ios,iomsg=message)
   call check_commandline_status(ios,message)
   if(usage)call print_dictionary('USAGE:',stop=.true.)
   endblock COMMANDLINE
!! -x-x-x-x END CUT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

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
