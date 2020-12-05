# M_CLI.f90 and associated files

![parse](docs/images/parse.png)

## NAME

### M_CLI - parse Unix-like command line arguments from Fortran

## DESCRIPTION

   M_CLI(3f) is a Fortran module that will crack the command line when
   given a NAMELIST and a prototype string that looks very much like an
   invocation of the program. Using the NAMELIST group has the benefit
   that there is no requirement to convert the strings to their required
   types or to duplicate the type declarations.

## DOWNLOAD
   ```bash
       git clone https://github.com/urbanjost/M_CLI.git
       cd M_CLI/src
       # change Makefile if not using one of the listed compilers
     
       # for gfortran
       make clean
       make F90=gfortran gfortran
     
       # for ifort
       make clean
       make F90=ifort ifort

       # for nvfortran
       make clean
       make F90=nvfortran nvfortran
   ```
   This will compile the M_CLI module and build all the example programs.

## SUPPORTS FPM (registered at the [fpm(1) registry](https://github.com/fortran-lang/fpm-registry) )

   Alternatively, download the github repository and build it with 
   fpm ( as described at [Fortran Package Manager](https://github.com/fortran-lang/fpm) )
   
   ```bash
        git clone https://github.com/urbanjost/M_CLI.git
        cd M_CLI
        fpm build
        fpm test
   ```
   
   or just list it as a dependency in your fpm.toml project file.
   
```toml
        [dependencies]
        M_CLI        = { git = "https://github.com/urbanjost/M_CLI.git" }
```

## FUNCTIONAL SPECIFICATION

**This is how the interface works --**
   
* Basically you define a NAMELIST group called ARGS that has the names of all your command line arguments.
* Next, pass in a string that looks like the command you would use to execute the program with all values specified.
* you read the output as the NAMELIST group ARGS with a fixed block of code (that could be in an INCLUDE file)
* Now call a routine to handle errors and help-related text
   
Now all the values in the NAMELIST should be updated using values from the
command line and ready to use.

## DOCUMENTATION
There are several styles possible for defining the NAMELIST group as well as
options on whether to do the parsing in the main program or in a contained procedure.
These demo programs provide templates for the most common usage:
   
- [demo1](PROGRAMS/demo1/demo1.f90) full usage 
- [demo2](PROGRAMS/demo2/demo2.f90) shows putting everything including **help** and **version** information into a contained procedure.
- [demo3](PROGRAMS/demo3/demo3.f90) example of **basic** use 
- [demo4](PROGRAMS/demo4/demo4.f90) using  **COMPLEX** values!
- [demo5](PROGRAMS/demo5/demo5.f90) demo2 with added example code for **interactively editing the NAMELIST group**
- [demo6](PROGRAMS/demo6/demo6.f90) a more complex example showing how to create a command with subcommands
- [demo7](PROGRAMS/demo7/demo7.f90) problems with CHARACTER arrays and quotes

### manpages
   
- [M_CLI](https://urbanjost.github.io/M_CLI/M_CLI.3m_cli.html)  -- An overview of the M_CLI module

- [commandline](https://urbanjost.github.io/M_CLI/commandline.3m_cli.html)  -- parses the command line options
   
- [check_commandline](https://urbanjost.github.io/M_CLI/check_commandline.3m_cli.html)  -- convenience
  routine for checking status of READ of NAMELIST group

- [print_dictionary](https://urbanjost.github.io/M_CLI/print_dictionary.3m_cli.html)  -- print the dictionary
  of command line keywords and values (typically not directly by a user, as automatically called when
  --usage option is supplied).

- [specified](https://urbanjost.github.io/M_CLI/specified.3m_cli.html)  -- detect if a keyword was specified on the command line

- [BOOK_M_CLI](https://urbanjost.github.io/M_CLI/BOOK_M_CLI.html) -- All manpages consolidated using JavaScript

### doxygen

- [doxygen(1) output](https://urbanjost.github.io/M_CLI/doxygen_out/html/index.html).

## EXAMPLE PROGRAM
   
This short program defines a command that can be called like
   
```bash
   ./show -x 10 -y -20 --point 10,20,30 --title 'plot of stuff' *.in
   ./show -x 10 -y -20 --point 10,20,30 --title 'plot of stuff' *.in
   ./show -z 300
   ./show *.in
   ./show --usage
   ./show --help
   ./show --version
```

```fortran
   program show
   use M_CLI, only : commandline, check_commandline, files=>unnamed
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
      COMMANDLIN : block
         character(len=255)           :: message
         character(len=:),allocatable :: readme
         integer                      :: ios
         readme=commandline(cmd)
         read(readme,nml=args,iostat=ios,iomsg=message) !! UPDATE NAMELIST VARIABLES
         call check_commandline(ios,message)     !! HANDLE ERRORS FROM NAMELIST READ AND --usage
      endblock COMMANDLIN
   
   !! USE THE VALUES IN YOUR PROGRAM.
      write(*,nml=args)
   
   !! OPTIONAL UNNAMED VALUES FROM COMMAND LINE
      if(size(files).gt.0)then
         write(*,'(a)')'files:'
         write(*,'(i6.6,3a)')(i,'[',files(i),']',i=1,size(files))
      endif
   
   end program show
```

## FEEDBACK
   
   Please provide feedback on the
   [wiki](https://github.com/urbanjost/M_CLI/wiki) or in the
   [__issues__](https://github.com/urbanjost/M_CLI/issues)
   section or star the repository if you use the module (or let me know
   why not and let others know what you did use!).

-------

## Other things to do with [NAMELIST](https://urbanjost.github.io/M_CLI/index.html)

   click on the link for some unusual things to do with NAMELIST,
   Capture and Replay unit testing, exposing variables for interactive
   editing ...
