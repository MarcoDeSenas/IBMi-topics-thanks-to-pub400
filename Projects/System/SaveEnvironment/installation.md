# Installation and configuration

Using Code4i and its local development and deployment capabilities, and Git/GitHub Desktop are the easest ways to proceed.

1. Make sure to fork the repository from GitHub on your workstation
2. Deploy the project on your IBM i system
3. Make sure to properly set your current library

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
   - Putty 0.76 or higher
     - ssh keys pair exchange must be set so that authentication with key can be used (checkout [How to setup ssh keys exchange to login from a workstation to an IBM i system](../../../HowTo/Using%20an%20ssh%20keys%20pair%20to%20login.md) for more information)
4. On the workstation, additional software may be used but is not mandatory
   - SSHFS-Win Manager 1.3.1 or higher
   - SSHFS-Win 3.5 or higher

## Common includes files used

These sources files make use the following common includes files. For details about which one uses which one, review the sources.

- inc_variables_declare.clle
- inc_variables_init.clle
- inc_errorhandling_forchecker_declare.clle
- inc_errorhandling_forchecker_routine.clle
- inc_errorhandling.clle

## Installation on PUB400 side

Run Actions on the sources below:

- envsav.clle (with Create Bound CL Program)
- envsav0.clle (with Create Bound CL Program)
- envsav.cmd (with Create Command)

## Installation on Windows side (if Windows is used)

1. Download into a workstation directory from Github the [envsav.ps1](envsav.ps1) PowerShell script
   - this workstation directory may be one of PUB400 HOME directory if using SSHFS-Win!
2. Run the script once from a Windows command window with the appropriate parameters to ensure it works fine; review the joblog and the content of output zip file to ensure it contains the good information
3. Setup a new Windows scheduler entry if required for full automation

Enjoy backups!
