program demo1
use M_CLI,  only : commandline, check_commandline
use M_CLI,  only : unnamed
implicit none
integer            :: i

!! DECLARE A NAMELIST CALLED "ARGS"
real               :: x             ;namelist /args/ x
real               :: y             ;namelist /args/ y
real               :: z             ;namelist /args/ z
real               :: point(3),p(3) ;namelist /args/ point,p
character(len=80)  :: title         ;namelist /args/ title
logical            :: l             ;namelist /args/ l
logical            :: l_            ;namelist /args/ l_
equivalence(point,p)

!! -x-x-x-x CUT HERE  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
   COMMANDLIN: block 
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
   readme=commandline('&
   & -x 1 -y 2 -z 3 --point -1,-2,-3 --p -1,-2,-3 --title "my title" -l F -L F')
   read(readme,nml=args,iostat=ios,iomsg=message)
   call check_commandline(ios,message)
   endblock COMMANDLIN
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

end program demo1
