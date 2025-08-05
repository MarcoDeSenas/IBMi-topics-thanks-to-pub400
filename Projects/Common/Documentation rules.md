# Documentation Rules

## For the repository

Every folder should have a README.md file which describes the content of the folder. If there are subfolders, the parent README.md file shoud provide a link to the README.md file of each subfolder.
When applicable, an installation.md file should exist in a folder to describe how to install the tools listed in that folder. And the README.md file should provide a link to this installation.md file (something like "More information about the way to install the tool here.").

## For the sources files

At the beginning of a program (or similar) source file, a standard comment should exist which includes a description of the source, the list of dated updates, and more or less detailed information.

Examples below:

For an RPGLE program source:

```RPGLE
//--------------------------------------------------------------------------*/
//                                                                          */
// This is the service program to use when dealing with user spaces.        */
// Available functions/procedures:                                          */
//        UserSpaceCrt: to create a user space                              */
//        UserSpaceRtvInf: to retrieve information about the user space     */
//                         content                                          */
//        UserSpaceRtvEnt: to retrieve the content of one entry in case of  */
//                         a user space filled with a list API              */
//                                                                          */
// As a general rule, all functions send back the API error structure on    */
// top of the expected output when there is one. The program using the      */
// functions is therefore responsible to handle any error.                  */
//                                                                          */
// Dates: 2025/06/23 Creation                                               */
//        2025/07/31 Retrieve info procedure                                */
//        2025/08/02 Retrieve entry procedure                               */
//                                                                          */
//--------------------------------------------------------------------------*/
```

For a CLLE program source:

```CLLE
/*--------------------------------------------------------------------------*/
/*                                                                          */
/* Backup of user environment on PUB400 and prepare for copy from a         */
/* workstation.                                                             */
/*                                                                          */
/* Dates: 2023/07/27 Creation                                               */
/*        2023/08/19 Remove some messages from job log to keep it clean     */
/*                   Replace backup of HOME directory with a zip file       */
/*                                                                          */
/*--------------------------------------------------------------------------*/
```
