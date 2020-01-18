## NAME

check_commandline_status(3f) - check status from READ of NAMELIST group and process pre-defined options

## SYNOPSIS

    subroutine check_commandline_status(ios,message)

     integer,intent(in)                   :: ios
     character(len=*),intent(in)          :: message
     character(len=*),intent(in),optional :: help_text
     character(len=*),intent(in),optional :: version_text

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

or if the --usage switch is present does

    if(usage)
       call print_dictionary('OPTIONS:')
    endif

If the optional text values are supplied they will be displayed by --help
and --version command-line options, respectively.

## OPTIONS

**IOS:** status from READ(7f) of NAMELIST after calling GET_COMMANDLINE(3f)

**MESSAGE:** message from READ(7f) of NAMELIST after calling GET_COMMANDLINE(3f)

**HELP_TEXT**     if present, will be displayed if program is called with --help
switch, and then the program will terminate.

**VERSION_TEXT**  if present, will be displayed if program is called with --version
switch, and then the program will terminate.

If the first four characters of each line are "@(#)" this prefix will not
be displayed. This if for support of the SCCS what(1) command. If you do not have
the what(1) command on GNU/Linux and Unix platforms you can probably see how it can
be used to place metadata in a binary by entering:

    strings demo2|grep '@(#)'|tr '>' '\n'|sed -e 's/  */ /g'

## EXAMPLE
    Typical usage:

```fortran
    program demo_get_commandline
    use M_CLI,  only : unnamed, get_commandline, check_commandline_status
    implicit none
    integer                      :: i
    character(len=255)           :: message ! use for I/O error messages
    character(len=:),allocatable :: readme  ! stores updated namelist
    character(len=:),allocatable :: version_text(:), help_text(:)
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
    version_text=[character(len=80) :: "version 1.0","author: me"]
    help_text=[character(len=80) :: "wish I put instructions","here","I suppose?"]
    call check_commandline_status(ios,message,help_text,version_text)

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
