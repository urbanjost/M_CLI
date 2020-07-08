## NAME

   commandline(3f) - NAMELIST-based command line argument parsing using a command prototype

## SYNOPSIS

    function commandline(definition) result(string)
     character(len=*),intent(in),optional  :: definition
     character(len=:),allocatable :: string

## DESCRIPTION

This routine leverages NAMELIST groups to do the conversion from strings to
numeric values required by other command line parsers.

The following example program simply needs a variable added to the NAMELIST
and the prototype and it automatically is available as a command line
argument.

Even arrays and user-defined types can be used, complex values can be
input ... .

To use the routine :

   1) define a NAMELIST group called ARGS.

   2) Then call COMMANDLINE(3f) with a string that looks like a call to the
      program with all keywords and default values specified

   3) Read the returned value as a NAMELIST group called ARGS (skip this if
      there are no keywords and therefore no ARGS NAMELIST).

   4) call CHECK_COMMANDLINE(3f) to display errors, usage, version and
      help text. This will automatically give all commands working
      --usage, --help, and --version  switches

All the values in the NAMELIST should be defined and updated by arguments
from the command line.

Note that since all the arguments are defined in a NAMELIST group that
config files can easily be used for the same options. Just create a
NAMELIST input file and read it.

NAMELIST syntax can vary between different programming environments.
Currently, this routine has only been tested using gfortran 7.0.4;
and requires at least Fortran 2003.

typical usage:

```fortran
   program show
      use M_args,  only : unnamed, commandline, check_commandline
      implicit none
      integer                      :: i
      character(len=255)           :: message ! use for I/O error messages
      character(len=:),allocatable :: readme ! stores updated namelist
      integer                      :: ios
   
      ! add to the namelist
      real               :: x, y, z, point(3) ; namelist /args/ x, y, z, point
      character(len=80)  :: title             ; namelist /args/ title
      logical            :: l, l_             ; namelist /args/ l, l_
   
      ! Define the prototype
      !  o All parameters must be listed with a default value
      !  o string values  must be double-quoted
      !  o numeric lists must be comma-delimited. No spaces are allowed
      character(len=*),parameter  :: cmd='&
      & -x 1 -y 2 -z 3 --point -1,-2,-3  --title "my title" -l -L'

      ! reading in a NAMELIST definition defining the entire NAMELIST
      readme=commandline(cmd)
      !! if there are no arguments and thus no ARGS NAMELIST group skip the READ!
      read(readme,nml=args,iostat=ios,iomsg=message)
      call check_commandline(ios,message)
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
   end program show
```

## OPTIONS

**DESCRIPTION:** is composed of all command arguments concatenated into a
string that defines a Unix-line command prototype. Note that values on the
prototype definition and on the command line follow NAMELIST syntax rules,
so using the example program "-point 3*0" would define three values, for
example. "-point ,1000" would change the _second_ element of the POINT
array and so on. See NAMELIST(3f) for more information on NAMELIST syntax.

 *  all keywords get a value. Logicals should get F or T.


 *  strings MUST be delimited with double-quotes and must be at least
    one space and internal double-quotes are represented with two
    double-quotes

 *  lists of numbers should be comma-delimited. No spaces are allowed
    in lists of numbers.

 *  long names (--keyword) should be all lowercase

 *  short names (-letter) that are uppercase map to a NAMELIST variable
    called "letter_", but lowercase short names map to NAMELIST name
    "letter".

## RETURNS

**STRING:** The output is a NAMELIST string than can be read to update the
NAMELIST "ARGS" with the keywords that were supplied on the command
line.

Note that (subject to change) the following variations from other
common command-line parsers:

 *  duplicate keywords are replaced by the rightmost entry

 *  numeric keywords are not allowed; but this allows negative
    numbers to be used as values.

 *  specifying both names of an equivalenced keyword will have
    undefined results (currently, their alphabetical order will
    define what the Fortran variable values become).

 *  there is currently no mapping of short names to long names except
    via an EQUIVALENCE.

 *  short keywords cannot be combined. -a -b -c is required, not -abc
    even for Boolean keys.

 *  shuffling is not supported. Values must follow their keywords.

 *  if a parameter value of just "-" is supplied it is converted to
    the string "stdin".

 *  if the keyword "--" is encountered the rest of the command
    arguments go into the character array "UNUSED".

 *  values not matching a keyword go into the character array
    "UNUSED".

 *  long names do not take the --KEY=VALUE form, just --KEY VALUE;
    and long names should be all lowercase and always more than one
    character.

 *  short-name parameters of the form -LETTER VALUE map to a NAMELIST
    name of LETTER_ if uppercase
