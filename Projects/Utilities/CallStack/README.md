# Call stack utility

This utility provides several procedures related to handling the programs call stack within a job or thread. They are mostly based on using [QWVRCSTK API](https://www.ibm.com/docs/en/i/7.5.0?topic=ssw_ibm_i_75/apis/qwvrcstk.html).

The first procedure is provided through CALLSTACK service program.

1. ProgramPositionRtv() to retrieve the program position in the call stack

## CALLSTACK Service Program

### ProgramPositionRtv procedure

Input parameters are the following :

1. Program name
2. Program library

Output parameter is the following :

1. Program position in the call stack
2. Standard API error structure [ERRC0100](https://www.ibm.com/docs/en/i/7.5.0?topic=parameter-error-code-format#errorcodeformat__title__2)

The procedure calls QWVRCSTK API twice.
The first one is required to retrieve the storage amount (e.g. the size of API receiving variable) needed for the API.
The second one is indeed the one which retrieves the full stack content.

In  order to find the program position, the procedure browses the receiver variable to seek for the program name and set its position. This position is computed to be relative to the program which invokes the procedure. Care must be taken in regard to the possible multiple entries for programs which run several procedures, as the call stack records one entry per procedure.

The position is set to -1 in case the requested program is not found in the call stack. It is set to 0, if the program calls the procedure with requesting its own position (weird request though!). Otherwise the position is a positive integer value.

As examples, let us consider the following call stack:

1. QSYS/QCMD
2. APP/PROGRAM1, ENTRY_PROCEDURE
3. APP/PROGRAM1, MAIN_PROCEDURE
4. APP/PROGRAM2
5. APP/PROGRAM3, ENTRY_PROCEDURE
6. APP/PROGRAM3, MAIN_PROCEDURE.

Let us assume that the last one (i.e. PROGRAM3) invokes ProgramPositionRtv procedure to check the position of various programs.

- if invoked to find APP/PROGRAM2, position is 1
- if invoked to find APP/PROGRAM3, position is 0
- if invoked to find APP/PROGRAM5, position is -1
- if invoked to find QSYS/QCMD, position is 3

When calling the API, Error structure Bytes Provided value is set to 116 in order to optimize the content of ERRC0100 parameter. In case of an error, Exception Id and Exception data will contain:

- any value provided back by the API.
- special CPF9898 message id when the API succeeds to run but fails to send back the complete stack entries

API error, if this rare case occurs, is sent back to the program which calls the procedure through the ERRC0100 output parameter. The calling program is then responsible to handle these errors.

#### ProgramPositionRtv() typical usage in RPGLE programs

Special CRTPGM compilation command parameter to set:

- BNDSRVPGM((CALLSTACK *IMMED))

Sources files to include:

- inc_basic_declare.rpgle
- inc_stdapi_declare.rpgle

Variales to declare:

- Program is 10 characters (like ObjectName)
- Library is 10 characters (like ObjectName)
- StackPosition is 10 integer (like FourBytes)

Invocation followed by ERRC0100 content handling to detect any error:

```RPGLE
ProgramPositionRtv(Program:Library:StackPosition:ERRC0100);
if ExceptId <> Blank;
    dosomething;
else;
    dosomething;
endif;

```

#### ProgramPositionRtv() typical usage in CLLE programs

Special processing option to declare:

- BNDSRVPGM((CALLSTACK))

Source files to include:

- inc_stdapi_declare.clle

Variales to declare:

- &PROGRAM is 10 characters
- &LIBRARY is 10 characters
- &STACKPOS is 4 integer (warning: do not use unsigned integer)

Invocation (notice to code the procedure name in upper case) followed by ERRC0100 content handling to detect any error:

```CLLE
CALLPRC PRC('PROGRAMPOSITIONRTV') PARM(&PROGRAM &LIBRARY &STACKPOS &ERRC0100)
IF COND(&EXCEPTID *NE &BLANK) THEN( dosomething)
ELSE CMD(dosomethingelse)
```

More information about the way to [install the tool here](installation.md).
