
# M_CLI.f90 and associated files

![parse](images/parse.png)

## NAME

### M_CLI - parse Unix-like command line arguments from Fortran

## DESCRIPTION

This package is a self-contained version of one mode of the M_args(3f)
module in the GPF (General Purpose Fortran) package that has been
extracted for those just interested in a library to crack the command
line. In the GPF package this library is intertwined with several other
large modules.

    git clone https://github.com/urbanjost/M_CLI.git
    cd M_CLI/src
    # change Makefile if not using gfortran(1)
    make

This will compile the M_CLI module and build all the example programs.

**__This is how the inteface works --__** 

Basically you define a NAMELIST group called ARGS that has the names of
all your command line arguments.

Next, call a routine passing it a string that looks like the command
you would use to execute the program with all values specified.

you read the output as the NAMELIST group ARGS.

Now all the values in the namelist should be updated using values from the
command line and ready to use.

- [get_commandline](md/get_commandline.md) parses the command line options

- [check_commandline_status](md/check_commandline_status.md) convenience
  routine for checking status of READ of NAMELIST group

This short program defines a command that can be called like

   ./show -x 10 -y -20 --point 10,20,30 --title 'plot of stuff' *.in

```fortran
program show
use M_CLI, only : get_commandline, check_commandline_status, files=>unnamed
implicit none
integer :: i

!! DEFINE NAMELIST
real               :: x, y, z             ; namelist /args/ x,y,z
real               :: point(3)            ; namelist /args/ point
character(len=80)  :: title               ; namelist /args/ title
logical            :: l                   ; namelist /args/ l

!! DEFINE COMMAND
character(len=*),parameter :: cmd= &
   '-x 1 -y 2.0 -z 3.5e0 --point -1,-2,-3 --title "my title" -l F '

!! THIS BLOCK DOES THE COMMAND LINE PARSING AND SHOULD NOT HAVE TO CHANGE
   COMMANDLINE : block
      character(len=255)           :: message
      character(len=:),allocatable :: readme
      integer                      :: ios
      readme=get_commandline(cmd)
      read(readme,nml=args,iostat=ios,iomsg=message) !! UPDATE NAMELIST VARIABLES
      call check_commandline_status(ios,message)     !! HANDLE ERRORS FROM NAMELIST READ AND --usage
   endblock COMMANDLINE

!! USE THE VALUES IN YOUR PROGRAM.
   write(*,nml=args)

!! OPTIONAL UNNAMED VALUES FROM COMMAND LINE
   if(size(files).gt.0)then
      write(*,'(a)')'files:'
      write(*,'(i6.6,3a)')(i,'[',files(i),']',i=1,size(files))
   endif

end program show
```

There are several styles possible for defining the NAMELIST group as well as
options on whether to do the parsing in the main program or in a contained procedure..

- [demo1](src/PROGRAMS/demo1.f90) full usage 
- [demo2](src/PROGRAMS/demo2.f90) shows putting everything including help and version information into a contained procedure.
- [demo3](src/PROGRAMS/demo3.f90) example of basic use (__for beginners__).
- [demo4](src/PROGRAMS/demo4.f90) minimalist example of use for a quick prototype command, and with a complex value!

Please provide feedback on the [wiki](https://github.com/urbanjost/M_CLI/wiki) or in the __issues__ section or star the
repository if you use the module (or let me know why not and let others know what you did use!).
