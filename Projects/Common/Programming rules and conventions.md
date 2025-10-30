# Programming Rules and conventions

In all programs sources and other objects listed in this repository, the rules and conventions below were followed.

## Standard variables

### ILE CL standard variables

Links to files:

1. [inc_variables_declare.clle](./Includes/inc_variables_declare.clle)
2. [inc_variables_init.clle](./Includes/inc_variables_init.clle)

All ILE CL programs should use those two includes files. The first one contains variables declarations, and the second one contains variables initializations. Most of the times, they are used in conjunction with the error handling includes.

Example when there is no DCLF:

```CLLE
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../Common/Includes/inc_variables_declare.clle')
INCLUDE SRCSTMF('../../Common/Includes/inc_errorhandling.clle')
INCLUDE SRCSTMF('../../Common/Includes/inc_variables_init.clle')
/* first program instruction */
```

Example when there is at least one DCLF:

```CLLE
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../Common/Includes/inc_variables_declare.clle')
INCLUDE SRCSTMF('../../Common/Includes/inc_errorhandling_declare.clle')
DCLF ...
INCLUDE SRCSTMF('../../Common/Includes/inc_errorhandling_routine.clle')
INCLUDE SRCSTMF('../../Common/Includes/inc_variables_init.clle')
/* first program instruction */
```

## Error handling routines

### ILE CL standard error handling

Links to files:

1. [inc_errorhandling_declare.clle](./Includes/inc_errorhandling_declare.clle)
2. [inc_errorhandling_routine.clle](./Includes/inc_errorhandling_routine.clle)
3. [inc_errorhandling.clle](./Includes/inc_errorhandling.clle)

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
INCLUDE SRCSTMF('../../Common/Includes/inc_errorhandling.clle')
/* first target program instruction */
```

Or within target program with a DCLF command, source will be something like:

```CLLE
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../Common/Includes/inc_errorhandling_declare.clle')
DCLF ...
INCLUDE SRCSTMF('../../Common/Includes/inc_errorhandling_routine.clle')
/* first target program instruction */
```

Note 1: all variables used by SEHR are prefixed with E_

Note 2: SEHR makes use of STDERROR and STRPROGRAM tags

Note 3: SEHR expects that a logical variable &TRUE exists with the value '1', it does not declare nor it initializes this variable (must be done by the target program)

Note 4: in case an error occurs within SEHR, the target program will abend with an *ESCAPE message

- this will be CPF9898 "Unexpected error when handling errors. Review the joblog"
- or, this will be a message id from a message file with message data if P_MSGID, P_MSGF, P_MSGFLIB, P_MSGDTA variables are properly filled up by the target program

## ILE CL mandatories actions

There are a couple of rules to comply with, along with using standard error handling routines described above:

- If the program expects to receive parameters, it must check the number of received parameters
- If the program is a command processing program, it must call again the command validity checker (see description below) to ensure that we do not perform a direct call

So after declaring and initializing the variables, there should be someting like this:

```CLLE
IF COND(%PARMS() *NE expectednumberofparameters) THEN( +
    SNDPGMMSG TOPGMQ(*SAME) MSGID(CPX6148) MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
CALL PGM(validitycheckerprogram) +
    PARM(parameters list)
```

## ILE CL command validity checker programs

All commands should be set to use a validity checker program. The goal of this program is to make sure that we do not call the command processing program directly, in order to bypass syntax and dependencies checkings provided by the command interface, and to perform additional checking if needed.

Links to files:

1. [inc_validitychecker.clle](./Includes/inc_validitychecker.clle)

Notice that for this kind of program, the standard error routine does not fit system requirements of a command validity checker program. Indeed, in case of failures those programs must send a \*DIAG message with a special format followed by a CPF0002 \*ESCAPE message. The message data of the diagnostic message must start with 4 bytes which are not used in the message first and second level. Checkout [Validity checking program for a CL command](https://www.ibm.com/docs/en/i/7.5?topic=commands-validity-checking-program-cl-command) for some reference.

Here also, the chosen method is to use include source files. However, it is mandatory to include a BNDSRVPGM((CALLSTACK)) processing option declaration. Indeed, the included source calls a procedure provided by this service program.

So within the validity checker program source, we have something like that:

```CLLE
DCLPRCOPT .... _BNDSRVPGM((CALLSTACK))_
DCL ...
DCL ...
DCL ...
INCLUDE SRCSTMF('../../Common/Includes/inc_validitychecker.clle')
SUBR SUBR(FURTHER)
ENDSUBR
ENDPGM
```

The validity checker routine performs the following steps:

1. Retrieve the position of QSYS/QCATRS program (system program responsible to handle command entry) in the current call stack
2. If this position is 1, which is the expected position, it creates a data-area in QTEMP library as a marker of normal execution; then it executes a FURTHER subroutine which must exist in the validity checker program source; this subroutine retains other required controls not provided by the command interface, or nothing, but must exist
3. Otherwise, it means that the validity checker is called by the command processing program as its second call; normal execution is when the data-area in QTEMP does exist, which means that the command entry step was done, so we do nothing here; when the data-area does not exist, it means that the command entry was ot used, which is a not allowed state

In case more controls are needed, they must reside in FURTHER subroutine.
