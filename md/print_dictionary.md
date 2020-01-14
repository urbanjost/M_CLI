<?
  <div id="Container">
    <div id="Content">
      <div class="c1">
      </div><a name="0"></a>

      <h3><a name="0">NAME</a></h3>

      <blockquote>
        <b>print_dictionary(3f)</b> - print internal dictionary created by calls to <b>get_namelist</b>(3f)
      </blockquote><a name="contents" id="contents"></a>

      <h3>CONTENTS</h3>

      <h3><a name="7">SYNOPSIS</a></h3>

      <blockquote>
        <pre>
subroutine <b>print_dictionary</b>(<i>header</i>)
<br />   character(len=*),intent(in),optional :: header
</pre>
      </blockquote><a name="2"></a>

      <h3><a name="2">DESCRIPTION</a></h3>

      <blockquote>
        Print the internal dictionary created by calls to <b>get_namelist</b>(3f). This routine is intended to print the state of the argument list if an
        error occurs in using the <b>get_namelist</b>(3f) procedure..
      </blockquote><a name="3"></a>

      <h3><a name="3">OPTIONS</a></h3>

      <blockquote>
        <table cellpadding="3">
          <tr valign="top">
            <td class="c2" width="6%" nowrap="nowrap">HEADER</td>

            <td valign="bottom">label to print before printing the state of the command argument list.</td>
          </tr>

          <tr>
            <td></td>
          </tr>
        </table>
      </blockquote><a name="4"></a>

      <h3><a name="4">EXAMPLE</a></h3>

      <blockquote>
        Typical usage:
        <pre>
    program demo_get_namelist
    use M_args,  only : unnamed, get_namelist, print_dictionary
    implicit none
    integer                      :: i
    character(len=255)           :: message ! use for I/O error messages
    character(len=:),allocatable :: readme  ! stores updated namelist
    integer                      :: ios
    real               :: x, y, z
    logical            :: help, h
    equivalence       (help,h)
    namelist /args/ x,y,z,help,h
    character(len=*),parameter :: cmd='&amp;ARGS X=1 Y=2 Z=3 HELP=F H=F /'
    ! initialize namelist from string and then update from command line
    readme=cmd
    read(readme,nml=args,iostat=ios,iomsg=message)
    if(ios.eq.0)then
       ! update cmd with options from command line
       readme=get_namelist(cmd)
       read(readme,nml=args,iostat=ios,iomsg=message)
    endif
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
    end program demo_get_namelist
<br />
</pre>Sample output

        <p>Calling the sample program with an unknown parameter produces the following:</p>
        <pre>
      $ ./print_dictionary -A
      UNKNOWN SHORT KEYWORD: -A
</pre>
      </blockquote><a name=""></a>

      <h4><a name="">KEYWORD PRESENT VALUE</a></h4>

      <blockquote>
        <table cellpadding="3">
          <tr valign="top">
            <td class="c2" width="6%" nowrap="nowrap">z</td>

            <td valign="bottom">F [3]</td>
          </tr>

          <tr valign="top">
            <td class="c2" width="6%" nowrap="nowrap">y</td>

            <td valign="bottom">F [2]</td>
          </tr>

          <tr valign="top">
            <td class="c2" width="6%" nowrap="nowrap">x</td>

            <td valign="bottom">F [1]</td>
          </tr>

          <tr valign="top">
            <td class="c2" width="6%" nowrap="nowrap">help</td>

            <td valign="bottom">F [F]</td>
          </tr>

          <tr valign="top">
            <td class="c2" width="6%" nowrap="nowrap">h</td>

            <td valign="bottom">F [F]</td>
          </tr>

        </table>STOP 2
      </blockquote><a name="5"></a>
    </div>
  </div>
