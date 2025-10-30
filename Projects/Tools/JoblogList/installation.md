# Installation

Using Code4i and its local development and deployment capabilities, and Git/GitHub Desktop are the easest ways to proceed.

1. Make sure to fork the repository from GitHub on your workstation
2. Deploy the project on your IBM i system
3. Make sure to properly set your current library

## Common includes files used

The sources files make use the following common includes files. For details about which one uses which one, review the sources.

- inc_variables_declare.clle
- inc_variables_init.clle
- inc_errorhandling.clle

## Creating the database objects

1. Download into a local workstation directory from Github the [CMDGRP database](cmdgrp.sql) script
2. Execute it from iACS Run SQL Scripts; it will ask for the library to create the database into
   - Warning, the script first deletes CMDGRP table if it exists; make sure to keep a copy somewhere of existing data somewhere; in a future version, it is planned to avoid deleting the table
3. Populate CMDGRP table with a couple of commands so that one can run a test once installation is complete

## Query Manager objects installation

On PUB400, REPLACE(*YES) does not work when creating QMQuery or QMForm, so objects must be deleted first, but DLTOBJ fails if the object does not exist. Therefore, the two CL commands below must run only if objects exist:

- DLTOBJ OBJ(\*CURLIB/JOBLOGLST) OBJTYPE(\*QMFORM) RMVMSG(\*YES)
- DLTOBJ OBJ(\*CURLIB/JOBLOGLST) OBJTYPE(\*QMQRY) RMVMSG(\*YES)

Make sure to set the current directory to the builds subfolder of the project. If Code4i deploy method is used this one is:

~/builds/IBMi-topics-thanks-to-pub400

Then run the CL commands below.

- CLRLIB LIB(QTEMP)
- CRTSRCPF FILE(QTEMP/QQMFORMSRC)
- CRTSRCPF FILE(QTEMP/QQMQRYSRC) RCDLEN(91)
- CPYFRMSTMF FROMSTMF('Projects/Tools/sources/JoblogLst.qmform') TOMBR('/QSYS.LIB/QTEMP.LIB/QQMFORMSRC.FILE/JOBLOGLST.MBR') MBROPT(\*REPLACE)
- CPYFRMSTMF FROMSTMF('Projects/Tools/Sources/JoblogLst.qmqry') TOMBR('/QSYS.LIB/QTEMP.LIB/QQMQRYSRC.FILE/JOBLOGLST.MBR') MBROPT(\*REPLACE)
- CRTQMFORM QMFORM(\*CURLIB/JOBLOGLST) SRCFILE(QTEMP/QQMFORMSRC) SRCMBR(\*QMFORM)
- CRTQMQRY QMQRY(\*CURLIB/JOBLOGLST) SRCFILE(QTEMP/QQMQRYSRC) SRCMBR(\*QMQRY) SRTSEQ(\*JOB) LANGID(\*JOB);

## Other objects installation

Run Actions on the sources below:

- jobloglst.clle (with Create Bound CL Program)
- jobloglst0.clle (with Create Bound CL Program)
- jobloglst.cmd (with Create Command)

Enjoy looking at your job log!
