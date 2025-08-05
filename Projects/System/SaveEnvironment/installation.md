# Installation and configuration

Several steps are needed for installing the utility.
The prerequisite is to create the directory structure within HOME directory. This can be done once for all the tools from this GitHub repository.

## Requirements

The requirements for the installation and runtime operations are the following:

1. On PUB400, the user must have an HOME subdirectory, named /home/MYUSER, which must also be set as its home directory on the user profile.
   - if this subdirectory does not exist (e.g. not created at user profile creation time), it must be created with *CRTDIR DIR('/home/MYUSER') DTAAUT(\*NONE) OBJAUT(\*NONE)* command
   - if it not assigned as home directory (e.g. not done at user profile creation time), it must be done with *CHGPRF HOMEDIR('/home/MYUSER')* command
2. On PUB400, the user profile must have one the three libraries the user owns, assigned as the current library.
   - if this is not the case (e.g. not done at user profile creation time), it must be done with *CHGPRF CURLIB(MYLIBRARY)* command
3. On the workstation, the software below must be installed, checkout [Workstation tools](../../../HowTo/Workstation%20tools.md) for more information:
   - Windows 10 or higher
   - PowerShell 7 or higher
   - IBM i Access Client Solutions (required only for installation)
   - Putty 0.76 or higher
     - ssh keys pair exchange must be set so that authentication with key can be used (checkout [How to setup ssh keys exchange to login from a workstation to an IBM i system](../../../HowTo/Using%20an%20ssh%20keys%20pair%20to%20login.md) for more information)
4. On the workstation, additional software may be used but is not mandatory
   - SSHFS-Win Manager 1.3.1 or higher
   - SSHFS-Win 3.5 or higher

__Warning : needs an update because of folder structure change!__

1. Download into a local workstation directory from Github the [folder structure creation SQL script](../../Common/folder_structure_creation.sql) script.
2. Execute it from iACS Run SQL Scripts

Further step are specifically related to ENVSAV tool.

1. Download all inc* files from Github repository into the desired directory on PUB400
2. Download the sources of objects from Github into the desired directory on PUB400
   1. [ENVSAV command](envsav.cmd)
   2. [ENVSAV command processing programe](envsav.pgm.clle)
   3. [ENVSAV command validity checker](envsav0.pgm.clle)
3. Download into a local workstation directory from Github the [ENVSAV build](envsav_build.sql) script
4. If it was decided not to keep the same directory structure as described in this [Projects organization](../../README.md) document, review all INCLUDE statements in programs sources and review build script to update source file location in order to handle the modification.
5. Execute it from iACS Run SQL Scripts
6. Download into a workstation directory from Github the [envsav.ps1](envsav.ps1) PowerShell script
   - this workstation directory may be one of PUB400 HOME directory if using SSHFS-Win!
7. Run the script once from a Windows command window with the appropriate parameters to ensure it works fine; review the joblog and the content of output zip file to ensure it contains the good information
8. Setup a new Windows scheduler entry if required for full automation

Enjoy backups!
