program show_get_commandline_unix_prototype
!! ADDING HELP AND VERSION DISPLAY
   use M_CLI,  only : unnamed
   implicit none
   integer            :: i

!! DEFINE VALUES TO PUT IN NAMELIST "ARGS"
   real               :: x
   real               :: y
   real               :: z
   real               :: point(3)
   character(len=80)  :: title
   logical            :: help, h
   logical            :: version, v
   logical            :: l
   logical            :: l_
   equivalence       (help,h),(version,v)

   !! DEFINE AND PARSE COMMAND LINE
   call parse()
   !! ALL DONE CRACKING THE COMMAND LINE USE THE VALUES IN YOUR PROGRAM.
   write(*,*)x+y+z
   write(*,*)point*2
   write(*,*)title
   write(*,*)l,l_

   !! THE OPTIONAL UNNAMED VALUES ON THE COMMAND LINE ARE
   !! ACCUMULATED IN THE CHARACTER ARRAY "UNNAMED"
   if(size(unnamed).gt.0)then
      write(*,'(a)')'files:'
      write(*,'(i6.6,3a)')(i,'[',unnamed(i),']',i=1,size(unnamed))
   endif

contains
   subroutine parse()
      !! PUT EVERYTHING TO DO WITH COMMAND PARSING HERE FOR CLARITY
      use M_CLI,  only : set_commandline, get_commandline, print_dictionary
      character(len=255) :: message ! use for I/O error messages
      character(len=:),allocatable :: readme ! stores updated namelist
      integer                      :: ios

      !! DEFINE COMMAND PROTOTYPE
      !!  o All parameters must be listed with a default value
      !!  o string values  must be double-quoted
      !!  o numeric lists must be comma-delimited. No spaces are allowed
      !!  o a short uppercase name -L maps to a variable in the NAMELIST of name L_
      !!  o long keynames must be all lowercase

      namelist/args/x,y,z,point,title,help,h,version,v,l,l_
      character(len=*),parameter :: cmd='&
      & -x 1 -y 2 -z 3     &
      & --point -1,-2,-3   &
      & --title "my title" &
      & -h --help          &
      & -v --version       &
      & -l -L              &
      & '

      !! CALL ONCE TO DEFINE COMMAND DEFAULTS
      readme=set_commandline(cmd)
      read(readme,nml=args,iostat=ios,iomsg=message)
      if(ios.ne.0)then
         write(*,'("ERROR IN COMMAND DEFINITION:",i0,1x,a)')ios, trim(message)
         call print_dictionary('OPTIONS:')
         stop 1
      endif

      !! CALL AGAIN TO PROCESS COMMAND LINE ARGUMENTS
      readme=get_commandline(cmd)
      read(readme,nml=args,iostat=ios,iomsg=message)
      if(ios.ne.0)then
         write(*,'("ERROR IN COMMAND ARGUMENTS:",i0,1x,a)')ios, trim(message)
         call print_dictionary('OPTIONS:')
         stop 2
      endif

      if(help)then
         write(*,'(a)')[character(len=80) :: &
            'NAME                                                    ', &
            '   myprocedure(1) - make all things possible            ', &
            'SYNOPSIS                                                ', &
            '   function myprocedure(stuff)                          ', &
            '   class(*) :: stuff                                    ', &
            'DESCRIPTION                                             ', &
            '   myprocedure(1) makes all things possible given STUFF ', &
            'OPTIONS                                                 ', &
            '   STUFF  things to do things to                        ', &
            'RETURNS                                                 ', &
            '   MYPROCEDURE  the answers you want                    ', &
            'EXAMPLE                                                 ', &
            '' ]
         call print_dictionary('CURRENT STATE:')
         stop 3
      endif

      if(version)then
         write(*,'(a)')[character(len=80) :: &
            'PROGRAM:     demo3            ', &
            'DESCRIPTION: My demo program  ', &
            'VERSION:     1.0 20200115     ', &
            'AUTHOR:      me, myself, and I', &
            'LICENSE:     Public Domain    ', &
            '' ]
         stop 4
      endif

   end subroutine parse

end program show_get_commandline_unix_prototype
