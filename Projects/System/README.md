The system project provides the following programs.

# Environment save
This tool provides a way to save the personal environment on PUB400.com. The initial version is limited to create a zip file with the content of this environment in term of save files. The intent is to upgrade this version with a way to automate the invokation of creating this zip file then downloading it to the workstation.
The tool is based on the standard setup on PUB400.com with three libraries, named with 1, 2, B suffix added to the user profile and an IFS home directory named with the user profile in */home* directory.

## Save on PUB400.com
This action is done with *ENVSAV* command. The description of each parameter is the following:
|Parameter|Description|Choices|Notes|
|---------|-----------|-------|-----|
|SAVELIBB|Backup library B|*YES, __*NO__|Optional, default *NO|
|SAVELIB1|Backup library 1|__*YES__, *NO|Optional, default *YES|
|SAVELIB2|Backup library 2|__*YES__, *NO|Optional, default *YES|
|SAVEHOME|Backup home directory|__*YES__, *NO|Optional, default *YES|
|INCLJOBLOG|Include job log into backup|__*YES__, *NO|Optional, default *YES|
|CLEANTMP|Clean all temporary objects|__*YES__, *NO|Optional, default *YES|
|EXCLUDETMP|Exclude HOME/tmp subdirectory|__*YES__, *NO|Optional, default *YES, prompted with SAVEHOME(*YES)|

Recommended invokation for a regular usage is to keep the default, so either *ENVSAV* or _ENVSAV SAVELIBB(*NO) SAVELIB1(*YES) SAVELIB2(*YES) SAVEHOME(*YES) INCLJOBLOG(*YES) CLEANTMP(*YES) EXCLUDETMP(*YES)_ are suitable.
If it is needed to only clean the temporary objects, use _ENVSAV SAVELIBB(*NO) SAVELIB1(*NO) SAVELIB2(*NO) SAVEHOME(*NO) INCLJOBLOG(*NO) CLEANTMP(*YES)_.

### Validity checker actions
The validity checker redoes all the checks which are done by command interface. It will never detect any issue when it is called by the command interface, but it might detect an issue in case the command processing program is directly used without the command interface. For more information about the standard for a validity checker program, checkout "ILE CL error routine within validity checker programs" in [Programming rules and conventions](https://github.com/MarcoDeSenas/IBMi-topics-thanks-to-pub400/blob/b52b70f3ebd7653c7503790c6ec5d2dfdccf0e96/Projects/Common/Programming%20rules%20and%20conventions.md).

Basically this program performs the following actions:
1. if SAVELIBB does not contain expected *YES or *NO value, set the error parameter status to TRUE and send CPD0084 *DIAG message to caller program
2. if SAVELIB1 does not contain expected *YES or *NO value, set the error parameter status to TRUE and send CPD0084 *DIAG message to caller program
3. if SAVELIB2 does not contain expected *YES or *NO value, set the error parameter status to TRUE and send CPD0084 *DIAG message to caller program
4. if SAVEHOME does not contain expected *YES or *NO value, set the error parameter status to TRUE and send CPD0084 *DIAG message to caller program
5. if INCLJOBLOG does not contain expected *YES or *NO value, set the error parameter status to TRUE and send CPD0084 *DIAG message to caller program
6. if CLEANTMP does not contain expected *YES or *NO value, set the error parameter status to TRUE and send CPD0084 *DIAG message to caller program
7. if EXCLUDETMP does not contain expected *YES or *NO value, set the error parameter status to TRUE and send CPD0084 *DIAG message to caller program
8. if there is at least one error, send CPF0002 *ESCAPE message to caller program

### Behavior of the command
The command processing program (CPP) makes use of two temporary subdirectories in HOME directory and of the B library to store files and objects. Those subdirectories are named:
- *env_backup_YYYYYYMMDDHHMMSSssssss* in HOME/tmp subdirectory to retain a copy of each save files, this is the "temporary" subdirectory
- *forws* in HOME directory to retain the final file to keep until next invokation, this is the "backup" subdirectory

If at least one backup is requested, it produces a zip file with the name of the temporary subdirectory (and .zip suffix) in the backup subdirectory. In this zip file there is one save file for each requested backup (see below for the name of those files) and, if including job log is requested, a text file named *backup.joblog*.
Note: the full path to the files is included in the zip file.

Users have limited allowed storage. Therefore, the CPP takes care as much as possible of temporary objects and delete them as soon as they are no longer needed. However, in case an unexpected error occurs, those temporary objects might still exist. This is the reason of the CLEANTMP parameter.

Basically, the CPP performs the following tasks:
1. check the proper number of parameters in case the program is not called through command interface; CPX6148 *ESCAPE message is sent to itself in order to activate the standard error handling routine
2. call the validity checker program in case the program is not called through command interface
3. create *tmp* subdirectory in HOME directory if it does not exist
4. set the variables related to the standard error handling routine in case of an unexpected error: CPDA4A8 message is used in this case
5. if clean all temporary objects is requested
   - delete all save files in B library which were remaining from a previous command invokations
   - delete backup subdirectory which was remaining from a previous command invokations
   - delete temporary directories which were remaining from a previous command invokations
6. if at least one backup is requested, create the temporary subdirectory of HOME/tmp
7. if B library backup is requested
   - create or clear a save file in B library with the name of B library
   - save B library to this save file with *ZLIB compression (excluding the save file itself)
   - copy the save file into the temporary subdirectory
   - delete the save file
9. if 1 library backup is requested
   - create or clear a save file in B library with the name of 1 library
   - save 1 library to this save file with *ZLIB compression
   - copy the save file into the temporary subdirectory
   - delete the save file
10. if 2 library backup is requested
   - create or clear a save file in B library with the name of 2 library
   - save 2 library to this save file with *ZLIB compression
   - copy the save file into the temporary subdirectory
   - delete the save file
11. if HOME directory backup is requested
   - create or clear a save file in B library with the name of user profile
   - if HOME/tmp exclusion is requested
      - save HOME directory to this save file omitting HOME/tmp with *ZLIB compression
   - if HOME/tmp exclusion is not requested
      - save HOME directory to this save file with *ZLIB compression- 
   - copy the save file into the temporary subdirectory
   - delete the save file
12. if at least one backup is requested
  - if including joblog is requested, using a QSH system command, output the joblog to a file named *backup.joblog* in the temporary subdirectory
  - copy and compress the content of the temporary subdirectory in a zip file in the backup directory, ready for download or restore process (note: this action is not included in the joblog)

### Sources files used
|File|Object|Object type|Object attribute|Description|
|----|------|-----------|----------------|-----------|
|envsav.cmd|ENVSAV|*CMD||Save environment command|
|envsav.pgm.clle|ENVSAV|*PGM|CLLE|Save environment command processing program|
|envsav0.pgm.clle|ENVSAV0|*PGM|CLLE|Save environment command validity checker|

### Common includes files used
These sources files make use the following common includes files. For details about which one uses which one, review the sources.
- inc_variables_declare.clle
- inc_variables_init.clle
- inc_errorhandling_forchecker_declare.clle
- inc_errorhandling_forchecker_routine.clle
- inc_errorhandling.clle

## Automation from the workstation
In progress...

## How to restore something
In progress...

