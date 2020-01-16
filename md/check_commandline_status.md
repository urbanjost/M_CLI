## NAME

check_commandline_status(3f) - convenience routine for checking status from READ of NAMELIST group

## SYNOPSIS

    subroutine check_commandline_status(ios,message)
     character(len=*),intent(in) :: message
     integer,intent(in)          :: ios

## DESCRIPTION

Essentially a convenience routine for checking the status of a READ(7f)
of the NAMELIST after calling GET_COMMANDLINE(3f). Basically, it lets
you replace

    if(ios.ne.0)then
       write(*,'("ERROR:",i0,1x,a)')ios, trim(message)
       call print_dictionary('OPTIONS:')
       stop 1
    endif

with

   call check_commandline_status(ios,message)


## OPTIONS

**IOS:** status from READ(7f) of NAMELIST after calling GET_COMMANDLINE(3f)

**MESSAGE:** message from READ(7f) of NAMELIST after calling GET_COMMANDLINE(3f)

## EXAMPLE

    Typical usage:

```fortran
    program demo_get_commandline
    use M_CLI,  only : unnamed, get_commandline, check_commandline_status
    !!use M_CLI,  only : print_dictionary
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
    readme=get_commandline(cmd)
    !!write(*,*)'README=',readme
    read(readme,nml=args,iostat=ios,iomsg=message)
    call check_commandline_status(ios,message)
    !! REPLACES
    !!if(ios.ne.0)then
    !!   write(*,'("ERROR:",i0,1x,a)')ios, trim(message)
    !!   call print_dictionary('OPTIONS:')
    !!   stop 1
    !!endif

    ! all done cracking the command line
    ! use the values in your program.
    write(*,nml=args)
    ! the optional unnamed values on the command line are
    ! accumulated in the character array "UNNAMED"
    if(size(unnamed).gt.0)then
       write(*,'(a)')'files:'
       write(*,'(i6.6,3a)')(i,'[',unnamed(i),']',i=1,size(unnamed))
    endif
    end program demo_get_commandline
```
