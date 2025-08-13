# Delete a bunch of spool files

There are much more ways to achieve the same results (with DLTSPLF command for instance), but this is a demonstration of using USRSPCCRT, USRSPCRTVI and USRSPCRTVE commands.

This action is done with SPLFDLT command. The description of each parameter is the following:

|Parameter|Description|Choices|Notes|
|---------|-----------|-------|-----|
|USER|Spool files owner||Must be valid names, special value \*CURRENT for current user profile|
|ACTION|Action against each spool file|\*BOTH, \*DLTONLY, \*LOGONLY|\*BOTH is the default|
|FORMTYPE|Form type|a 10 characters string, \*ALL, \*STD|\*ALL is the default|
|USRDTA|User specified data|a 10 characters string, \*ALL|\*ALL is the default|

![SPLFDLT command prompt](../Assets/splfdlt_command_prompt.png)

## SPLFDLT command Validity checker actions

The validity checker redoes all the checks which are done by command interface. It will never detect any issue when it is called by the command interface, but it might detect an issue in case the command processing program is directly used without the command interface. For more information about the standard for a validity checker program, checkout "ILE CL error routine within validity checker programs" in [Programming rules and conventions](../../Common/Programming%20rules%20and%20conventions.md).

Basically this program performs the following actions:

1. if USER is not *CURRENT and is not a valid name, set the error parameter status to TRUE and send CPD0084 \*DIAG message to caller program
2. if ACTION is neither \*BOTH, nor \*DLTONLY and nor \*LOGONLY, set the error parameter status to TRUE and send CPD0084 \*DIAG message to caller program

In order to detect name validity, the program does the following. It tries to check the existence of a user profile object in QTEMP library with the value to check as the user profile name. There will never be a user profile outside of QSYS library. Therefore, if the name is valid, the program will detect a CPF9801 exception, and if the name is not valid, it will detect a CPD0078 diagnostic.

## Behavior of SPLFDLT command

The command processing program (CPP) sends back to the calling program any exception received when running User Space commands.
The CPP performs the following tasks (not included here those which are standard for calling the validity checker program and initializing variables).

1. Create a user space in QTEMP library with SPLFxxxxxx name and xxxxxx is the job number
2. Call QUSLSPL API to fill the user space
3. Retrieve user space information
4. Browse all entries list from the user space
    - counter of non deleted spool files is updated accordingly to the spool files deletion command
    - counter of deleted spool files is updated accordingly to the spool files deletion command or entry retrieval depending on ACTION parameter
    - if ACTION parameter is *LOGONLY
        - send USP0301 message if from TOOMSGF as an information message to the job log with spool file identifiers
    - if ACTION parameter is *DLTONLY
        - delete spool file
        - if deletion is not successful
            - send USP0312 from TOOMSGF as a diagnostic message to the log log with spool file identifiers
    - if ACTION parameter is *BOTH
        - delete spool file
        - if deletion is successful
            - send USP0302 from TOOMSGF as an information message to the job log with spool file identifiers
        - if deletion is not successful
            - send USP0312 from TOOMSGF as a diagnostic message to the log log with spool file identifiers
5. When done
    - if no error found, send a completion message with the count of either eligible or deleted spool files
        - if ACTION parameter
            - was *LOGONLY, message id is USP0303 from TOOMSGF
            - otherwise, message id is USP0304 from TOOMSGF
    - at least one error was found, send a USP0311 from TOOMSGF as an escape message

## Exception messages sent by SPLFDLT command

- any message provided back by the API
- USP0311 message id from TOOMSGF message file and count of deleted and non deleted spool files

## Possible improvements

A possible improvement is to allow more criteria to select more spool files, according to QUSLSPL API capabilities.

- *ALL could be added as a special value for USER parameter
- add a parameter to select output queues
