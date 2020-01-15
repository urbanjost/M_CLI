## NAME

   set_commandline(3f) - NAMELIST-based command line argument parsing using a command prototype

## SYNOPSIS

    function set_commandline(definition) result(string)
     character(len=*),intent(in),optional  :: definition
     character(len=:),allocatable :: string

## DESCRIPTION

This routine is used prior to calling get_commandline(3f) to process
the prototype string ignoring command line options so that default
values are initialized properly. It does not need called if all the
values in the NAMELIST group defined for use with get_commandline(3f)
are initialized already, but it is easier to use this routine instead
of making sure the prototype string and initial values are synchronized.

See the example program in the get_commandline(3f) documentation for
more detailed examples of the usage.

EXAMPLE

    program demo_setcommandline
    use M_CLI,  only : set_commandline, get_commandline, print_dictionary
    imlicit none
    character(len=:),allocatable :: readme ! stores updated namelist
    character(len=256)           :: message
    real                         :: x, y, z
    namelist /args/ x,y,z
    character(len=*),parameter   :: cmd='-x 1 -y 2 -z 3'
       readme=SET_commandline(cmd) ! set defaults
       read(readme,nml)
       readme=GET_commandline(cmd) ! parse command line
       read(readme,nml=args,iostat=ios,iomsg=message)
       if(ios.ne.0)then
          write(*,'("ERROR IN COMMAND ARGUMENTS:",i0,1x,a)')ios,message
          call print_dictionary()
          stop 2
       endif
       !! ALL DONE CRACKING THE COMMAND LINE.  USE THE VALUES IN YOUR PROGRAM.
       write(*,nml=args)
    end program demo_setcommandline
