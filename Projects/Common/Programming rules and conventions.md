# Rules and conventions

In all programs sources and other objects listed in this repository, the rules and conventions below were followed.

## Error handling routines

### ILE CL standard error handling

Links to files:

1. [inc_errorhandling_declare.clle](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/be5185c025bc746fa71221515b5c64e8d374b102/Projects/Common/inc_errorhandling_declare.clle)
2. [inc_errorhandling_routine.clle](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/be5185c025bc746fa71221515b5c64e8d374b102/Projects/Common/inc_errorhandling_routine.clle)
3. [inc_errorhandling.clle](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/be5185c025bc746fa71221515b5c64e8d374b102/Projects/Common/inc_errorhandling.clle)

The objective of standard error handling routine (let's call it SEHR) is to be executed each time an unexpected error occurs within an ILE CL program. It must be possible as well to use it without taking care of it, other than ensure that our programs are able to take advantage of it. The chosen solution is to use include source files, so that error handling pieces of code is part of the program. Other ways were possible, using modules or service programs but were not selected, mainly because of ILE understanding troubles. However, this method has the main drawback that, every time we need to modifiy the routine, we will have to recompile all programs. With modules/service programs usage, we would only have to update all programs.

Let's call the program which is compiled including the standard error handling sources files, the target program. The SEHR is expected to catch all unexpected errors, and therefore, when an unexpected, e.g. not specifically monitored, *EXCP message is received by the target program, proceed with the following steps:

- ensure that there will be no looping due to an error occuring within the SEHR itself
- browse target program message queue to receive the last available *DIAG message
- propagate this message to the target program calling program, still as a *DIAG message
- retrieve *EXCP message, e.g. the one which was catched, from the target program message queue
- propagate this message to the target program calling program, as an *ESCAPE message
- because this is an *ESCAPE message, the program will fail and end

The inspiration for this routine comes from TAATOOL's similar standard procedure [TAATOOL standard error](https://www.taatool.com/document/L_clpstderr.html), but the idea was to try to have all instructions in a single include source file whenever it is possible. As the general monitoring command must follow the last DCL or DCLF command of the target program, it means that the SEHR piece of code must be included just after the last DCL(F) command.
SEHR is built with two kinds of commands:

1. the DCL variables commands
2. the piece of code

In order to allow using the SEHR wether or not the target program makes use of DCLF commands, all the sources were split into two distinct files:

1. one for the DCL variables, named errorhandling_declare.clleinc, which must be included immediately after the last DCL command
2. the second one for the piece of code, named errorhandling_routine.clleinc, which must be included immediately after the last DCLF command

In case there is no DCLF command in the target program, there is also a third, named errorhandling.clleinc, include file which must be included imeediately after the last DCL, and which includes the two other files (this is a nested include).

So within target programs without a DCLF command, source will be something like:

```CLLE
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling.clle')
/* first target program instruction */
```

Or within target program with a DCLF command, source will be something like:

```CLLE
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

### ILE CL error routine within validity checker programs

Links to files:

1. [inc_errorhandling_forchecker_declare.clle](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/be5185c025bc746fa71221515b5c64e8d374b102/Projects/Common/inc_errorhandling_forchecker_declare.clle)
2. [inc_errorhandling_forchecker_routine.clle](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/be5185c025bc746fa71221515b5c64e8d374b102/Projects/Common/inc_errorhandling_forchecker_routine.clle)

The standard error routine does not fit system requirements of a command validity checker program. Indeed, in cas of failures those programs must send a '*DIAG' message with a special format followed by a CPF0002 '*ESCAPE' message. The message data of the diagnostic message must start with 4 bytes which are not used in the message first and second level. Checkout [Validity checking program for a CL command](https://www.ibm.com/docs/en/i/7.3?topic=commands-validity-checking-program-cl-command) for some reference.

Here also, the chosen method is to use include source files. However, as opposite to the standard error routine, the processing part of the routine is at the end of the program. Therefore, there are only one way to include those files. The first file contains the variables declaration. The second contains the instructions and must be included at the end of the program. The program flow will always pass through the routine before ending wether an error was detected by the checking instruction or the general monitoring instruction gets activated, or even if there is no error at all.

So within the validity checker program source, we have something like that:

```CLLE
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling_forchecker_declare.clle')
MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
/* first program instruction */
/* last program instruction */
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling_forchecker_routine.clle')
ENDPGM
```

The error handling routine performs the following steps:

1. Check to see if there is at least one *EXCP message in the program message queue, which means that some unexpected error occured
2. If there is one, CPD0006 '*DIAG' message is sent to calling program with the message text of the '*EXCP' message as its message data
3. If there is none, it means that there is no unexpected error
4. If there is an unexpected error message (decided with &ERROR logical variable set in step 2) or if there is an error based on the command parameters checking (decided with &ERRORPARAM logical variable set during the checkings), CPF0002 *ESCAPE message is sent to the calling program

Note 1: the routine makes use of ERROR tag

Note 2: the routine expects that a logical variable &TRUE exists with the value '1', it does not declare nor it initializes this variable (must be done by the validity checker program)

Note 3: the routine expects that a character variable &BLANK exists with the value ' ', it does not declare nor it initializes this variable (must be done by the validity checker program)

## Standard variables

### ILE CL standard variables

Links to files:

1. [inc_variables_declare.clle](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/6d8d8f97ec83803a3c7292b9db743af5014cf67b/Projects/Common/inc_variables_declare.clle)
2. [inc_variables_init.clle](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/6d8d8f97ec83803a3c7292b9db743af5014cf67b/Projects/Common/inc_variables_init.clle)

All ILE CL programs should use those two includes files. The first one contains variables declarations, and the second one contains variables initializations. Most of the times, they are used in conjunction with the error handling includes.

Example when there is no DCLF:

```CLLE
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../common/includes/inc_variables_declare.clle')
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling.clle')
INCLUDE SRCSTMF('../../common/includes/inc_variables_init.clle')
/* first program instruction */
```

Example when there is at least one DCLF:

```CLLE
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../common/includes/inc_variables_declare.clle')
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling_declare.clle')
DCLF ...
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling_routine.clle')
INCLUDE SRCSTMF('../../common/includes/inc_variables_init.clle')
/* first program instruction */
```

Example for a validity checker program:

```CLLE
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../common/includes/inc_variables_declare.clle')
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling_forchecker_declare.clle')
MONMSG MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
INCLUDE SRCSTMF('../../common/includes/inc_variables_init.clle')
/* first program instruction */
/* last program instruction */
INCLUDE SRCSTMF('../../common/includes/inc_errorhandling_forchecker_routine.clle')
ENDPGM
```
