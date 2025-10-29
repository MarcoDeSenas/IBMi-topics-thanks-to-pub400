# Installation

Using Code4i and its local development and deployment capabilities, and Git/GitHub Desktop are the easest ways to proceed.

1. Make sure to fork the repository from GitHub on your workstation
2. Deploy the project on your IBM i system
3. Make sure to properly set your current library

## CALLSTACK Service Program

### Common includes files used in CALLSTACK Service Program

These sources files make use the following common includes files. For details about which one uses which one, review the sources.

- inc_basic_declare.rpgle
- inc_stdapi_declare.rpgle
- inc_QWVRCSTK_declare.rpgle

### CALLSTACK Installation

Run Actions on the sources below:

- callstack.srvpgm.rpgle (with Create RPG Module then Create Service Program with EXPORT(*ALL))
