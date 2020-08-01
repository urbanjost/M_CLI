
If enough interest:

- DESCRIBE_COMMANDLINE('name','string') would be trivial to add so that --usage has optional descriptions

- other command-line syntax (like DOS uses, perhaps?)

- as long as the prototype has () in the values, allow them to be implied on input for complex values

- allow subscript on keywords, like "--point(2:3) 100,200". Using NAMELIST, which already supports that type of syntax

- interactive prompting mode, maybe screen-based using ncurses. Simplest one user could add would be something like
  namelist_prompter(3f) in example programs. See fixedform(1).

- If you parsed the syntax often used in the SYNTAX area of a manpage you could handle most subprogram and mutually
  exclusive options.

       command [run[program[ --args "ARGUMENTS"]]|build]
