In all programs sources and other objects listed in this repository, the rules and conventions below were followed.

# ILE CL standard error handling
The objective of standard error handling routine (let's call it SEHR) is to be executed each time an unexpected error occurs within an ILE CL program. It must be possible as well to use it without taking care of it, other than ensure that our programs are able to take advantage of it. The chosen solution is to use include source files, so that error handling pieces of code is part of the program. Other ways were possible, using modules or service programs but were not selected, mainly because of ILE understanding troubles. However, this method has the main drawback that, every time we need to modifiy the routine, we will have to recompile all programs. With modules/service programs usage, we would only have to update all programs.

Let's call the program which is compiled including the standard error handling sources files, the target program. The SEHR is expected to catch all unexpected errors, and therefore, when an unexpected, e.g. not specifically monitored, *EXCP message is received by the target program, proceed with the following steps:
- ensure that there will be no looping due to an error occuring within the SEHR itself
- browse target program message queue to receive the last available *DIAG message
- propagate this message to the target program calling program, still as a *DIAG message
- retrieve *EXCP message, e.g. the one which was catched, from the target program message queue
- propagate this message to the target program calling program, as an *ESCAPE message
- because this is an *ESCAPE message, the program will fail and end

The inspiration for this routine comes from TAATOOL's similar standard procedure (https://www.taatool.com/document/L_clpstderr.html), but the idea was to try to have all instructions in a single include source file whenever it is possible. As the general monitoring command must follow the last DCL or DCLF command of the target program, it means that the SEHR piece of code must be included just after the last DCL(F) command.
SEHR is built with two kinds of commands:
1. the DCL variables commands
2. the piece of code

In order to allow using the SEHR wether or not the target program makes use of DCLF commands, all the sources were split into two distinct files:
1. one for the DCL variables, named errorhandling_declare.clleinc, which must be included immediately after the last DCL command
2. the second one for the piece of code, named errorhandling_routine.clleinc, which must be included immediately after the last DCLF command

In case there is no DCLF command in the target program, there is also a third, named errorhandling.clleinc, include file which must be included imeediately after the last DCL, and which includes the two other files (this is a nested include).

So within target programs without a DCLF command, source will be something like:
```
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling.clle')
/* first target program instruction */
```
Or within target program with a DCLF command, source will something like:
```
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling_declare.clle')
DCLF ...
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling_routine.clle')
/* first target program instruction */
```

Note 1: all variables used by SEHR are prefixed with E_

Note 2: SEHR makes use of STDERROR and STRPROGRAM tags

Note 3: SEHR expects that a logical variable &TRUE exists with the value '1', it does not declare nor it initializes this variable (must be done by the target program)

Note 4: in case an error occurs within SEHR, the target program will abend with an *ESCAPE message
- this will be CPF9898 "Unexpected error when handling errors. Review the joblog"
- or, this will be a message id from a message file with message data if P_MSGID, P_MSGF, P_MSGFLIB, P_MSGDTA variables are properly filled up by the target program

