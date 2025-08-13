# Installation

Prior to perform any installation tasks, make sure that a TOOMSGF message file exists in the library where the programs reside. If needed, run the [TOOMSGF creation SQL](../toomsgf.msgf.sql) to create it.

Using Code4i and its local development and deployment capabilities, and Git/GitHub Desktop are the easest ways to proceed.

1. Make sure to fork the repository from GitHub on your workstation
2. Deploy the project on your IBM i system
3. Make sure to properly set your current library

## USRSPC Service Program

### Common includes files used in USRSPC Service Program

The service program source makes use of the following includes files.

- inc_basic_declare.rpgle
- inc_stdapi_declare.rpgle
- inc_usrspc_declare.rpgle

### USRSPC Installation

Run Actions on the sources below:

- usp0101.msgid.sql (with Run SQL statements)
- usp0202.msgid.sql (with Run SQL statements)
- usp0203.msgid.sql (with Run SQL statements)
- usp0211.msgid.sql (with Run SQL statements)
- usp0212.msgid.sql (with Run SQL statements)
- usrspc.srvpgm.rpgle (with Create RPG Module then Create Service Program (with EXPORT(*ALL)))
- usrspcapi.bnddir.sql (with Run SQL statements)

## USRSPCCRT command

### Include files used in USRSPCCRT command

These sources files make use the following common includes files. For details about which one uses which one, review the sources.

- inc_variables_declare.clle
- inc_variables_init.clle
- inc_errorhandling_forchecker_declare.clle
- inc_errorhandling_forchecker_routine.clle
- inc_errorhandling.clle
- inc_stdapi_declare.clle

### USRSPCCRT Installation

Ensure USRSPC service program is deployed and built.
Run Actions on the sources below:

- usrspccrt.clle (with Create Bound CL Program)
- usrspccrt0.clle (with Create Bound CL Program)
- usrspccrt.cmd (with Create Command)

## USRSPCRTVI command

### Include files used in USRSPCRTVI command

These sources files make use the following common includes files. For details about which one uses which one, review the sources.

- inc_variables_declare.clle
- inc_variables_init.clle
- inc_errorhandling_forchecker_declare.clle
- inc_errorhandling_forchecker_routine.clle
- inc_errorhandling.clle
- inc_stdapi_declare.clle

### USRSPCRTVI Installation

Ensure USRSPC service program is deployed and built
Run Actions on the sources below:

- usrspcrtvi.clle (with Create Bound CL Program)
- usrspcrti0.clle (with Create Bound CL Program)
- usrspcrtvi.cmd (with Create Command)

## USRSPCRTVE command

### Include files used in USRSPCRTVE command

These sources files make use the following common includes files. For details about which one uses which one, review the sources.

- inc_variables_declare.clle
- inc_variables_init.clle
- inc_errorhandling_forchecker_declare.clle
- inc_errorhandling_forchecker_routine.clle
- inc_errorhandling.clle
- inc_stdapi_declare.clle

### USRSPCRTVE Installation

Ensure USRSPC service program is deployed and built
Run Actions on the sources below:

- usrspcrtve.clle (with Create Bound CL Program)
- usrspcrte0.clle (with Create Bound CL Program)
- usrspcrtve.cmd (with Create Command)

## SPLFDLT command

### Include files used in SPLFDLT command

These sources files make use the following common includes files. For details about which one uses which one, review the sources.

- inc_variables_declare.clle
- inc_variables_init.clle
- inc_errorhandling_forchecker_declare.clle
- inc_errorhandling_forchecker_routine.clle
- inc_errorhandling.clle
- inc_stdapi_declare.clle
- inc_QUSLSPL_SPLF0300_declare.clle

### SPLFDLT Installation

Ensure USRSPCCRT, USRSPCRTVE and USRSPCRTVI commands are deployed and built.
Run Actions on the sources below:

- splfdlt.clle (with Create Bound CL Program)
- splfdlt0.clle (with Create Bound CL Program)
- splfdlt.cmd (with Create Command)
- usp0301.msgid.sql (with Run SQL statements)
- usp0302.msgid.sql (with Run SQL statements)
- usp0303.msgid.sql (with Run SQL statements)
- usp0304.msgid.sql (with Run SQL statements)
- usp0311.msgid.sql (with Run SQL statements)
- usp0312.msgid.sql (with Run SQL statements)

## USRSPCDSP command

### Common includes files used in USRSPCDSP command

The program sources make use of the following includes files.

- inc_basic_declare.rpgle
- inc_stdapi_declare.rpgle
- inc_usrspc_declare.rpgle
- inc_QUSLSPL_SPLF0300_declare.rpgle
- inc_wrkstn_declare.rpgle
- inc_variables_declare.clle
- inc_variables_init.clle
- inc_errorhandling_forchecker_declare.clle
- inc_errorhandling_forchecker_routine.clle
- inc_errorhandling.clle
- inc_stdapi_declare.clle
- inc_QUSLSPL_SPLF0300_declare.clle

### USRSPCDSP Installation

Run Actions on the sources below:

- usrspcdsp.clle (with Create Bound CL Program)
- usrspcdsp0.clle (with Create Bound CL Program)
- usrspcdsp.cmd (with Create Command)
- usrspcdsp.dspf (with Create a Display File)
- usrspcdsp1.rpgle (with Create aRPGLE program)
