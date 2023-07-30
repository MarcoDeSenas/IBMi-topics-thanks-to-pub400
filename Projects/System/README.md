The system projects provides the following programs.

# Environment save
This tool provides a way to save the personal environment on PUB400.com. The initial version is limited to create a zip file with the content of this environment. The intent is to upgrade this version with a way to automate the invokation of creating this zip file then downloading it to the workstation.
The tool is based on the standard setup on PUB400.com with three libraries, named with 1, 2, B suffix added to the user profile and an IFS home directory named with the user profile in /home directory.

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

### Sources files used
|File|Object|Object type|Object attribute|Description|
|----|------|-----------|----------------|-----------|
|envsav.cmd|ENVSAV|*CMD||Save environment command|
|envsav.pgm.clle|ENVSAV|*PGM|CLLE|Save environment|
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

