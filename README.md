
# M_CLI.f90 and associated files

## NAME

   M_CLI - parse Unix-like command line arguments from Fortran

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
It has only been tested using GNU Fortran (GCC) 8.3.0 at this point.
As there is some variability in how NAMELIST works I am very intersted
in results using other compilers.

Basically you define a NAMELIST group called ARGS that has the names
of all your command line arguments.

Next, call a routine passing it a string that looks
like the command you would use to execute the program.

The routine passes back a string you read as NAMELIST group ARGS.

All the values in the namelist should be updated using values from the
command line and ready to use.

- [get_commandline](md/get_commandline.md) defines the command and
  parses the command line options

- [print_dictionary](md/print_dictionary.md) is used to show the state
  of the parameters as part of handling errors

This short program defines a command that can be called like

   ./show -x 10 -y -20 -point 10 20 30 -title 'plot of stuff' *.in

```fortran
      program show
      use M_CLI
      implicit none
      integer                      :: i, ios
      character(len=255)           :: message
      character(len=:),allocatable :: readme

      !! DEFINE NAMELIST
      real               :: x, y, z, point(3)
      character(len=80)  :: title
      logical            :: help, version, l
      namelist /args/ x,y,z,point,title,help,version,l

      !! DEFINE COMMAND, READ COMMAND LINE OPTIONS
      readme=get_commandline(&
      ' -x 1 -y 2 -z 3 --point -1,-2,-3 --title "my title" --help --version -l')

      !! UPDATE NAMELIST VARIABLES
      read(readme,nml=args,iostat=ios,iomsg=message)

      !! HANDLE ERRORS
      if(ios.ne.0)then
         write(*,'("ERROR:",i0,1x,a)')ios, trim(message)
         call print_dictionary('OPTIONS:')
         stop 1
      endif

      !! USE THE VALUES IN YOUR PROGRAM.
      write(*,nml=args)
      if(size(unnamed).gt.0)then
         write(*,'(a)')'files:'
         write(*,'(i6.6,3a)')(i,'[',unnamed(i),']',i=1,size(unnamed))
      endif

      end program show
```
