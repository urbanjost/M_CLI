## NAME

print_dictionary(3f) - print internal dictionary created by calls to commandline(3f)

## SYNOPSIS

    subroutine print_dictionary(header,stop)

       character(len=*),intent(in),optional :: header
       logical,intent(in),optional          :: stop

## DESCRIPTION

Print the internal dictionary created by calls to commandline(3f). This
routine is intended to print the state of the argument list if an error
occurs in using the commandline(3f) procedure..

## OPTIONS

**HEADER:** label to print before printing the state of the command argument list.

**STOP:** set to .TRUE. if the program should stop after printing the dictionary

## EXAMPLE

    Typical usage:

```fortran
    program demo_commandline
    use M_CLI,  only : unnamed, commandline, print_dictionary
    implicit none
    integer                      :: i
    character(len=255)           :: message ! use for I/O error messages
    character(len=:),allocatable :: readme  ! stores updated namelist
    integer                      :: ios

    real               :: x, y, z
    logical            :: help, h
    equivalence       (help,h)
    namelist /args/ x,y,z,help,h
    character(len=*),parameter :: cmd='-x 1 -y 2 -z 3 --help F -h F'

    ! initialize namelist from string and then update from command line
    readme=commandline(cmd)
    !!write(*,*)'README=',readme
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
    end program demo_commandline
```
## SAMPLE OUTPUTS

Calling the sample program with an unknown parameter produces the
following:

    $ ./demo_print_dictionary -A
    UNKNOWN SHORT KEYWORD: -A

     KEYWORD  PRESENT  VALUE
     z        F        [3]
     y        F        [2]
     x        F        [1]
     help     F        [F]
     h        F        [F]
     STOP 2

notice that both HELP and H change because they are equivalenced
and no dictionary is printed because no error occurred:

    $ ./demo_print_dictionary -x 100.234 --help

      &ARGS
       X=  100.234001    ,
       Y=  2.00000000    ,
       Z=  3.00000000    ,
       HELP=T,
       H=T,
       /

The NAMELIST READ(7f) error messages may vary between platforms:

    $ ./demo_print_dictionary -x NOT_A_NUMBER

      ERROR:5010 Cannot match namelist object name not_a_number
      OPTIONS:
      KEYWORD             PRESENT  VALUE
      z                   F        [3]
      y                   F        [2]
      x                   T        [NOT_A_NUMBER]
      help                F        [F]
      h                   F        [F]
      STOP 1
