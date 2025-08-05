# Installation

__Warning : needs an update because of folder structure change!__

Several steps are needed for installing the utility.
The prerequisite is to create the directory structure within HOME directory. This can be done once for all the tools from this GitHub repository.

1. Download into a local workstation directory from Github the [folder structure creation SQL script](../../Common/folder_structure_creation.sql) script.
   - __important notice__: the script assumes that the projects directory will be a subdirectory of HOME directory __and__ that this HOME directory is named /home/USERPROFILE; however, as long as its internal structure remains the same, the projects directory can be anywhere, and INCLUDE statements in the sources should work; but, if it is decided to install projects directory elsewhere than below /home/USERPROFILE, script must be updated to set the parent directory as the current directory before running the CRTDIR CL commands
2. Execute it from iACS Run SQL Scripts

Further step are specifically related to JOBLOG tool.

1. Download all inc* files from Github repository into the desired directory on the system
2. Download into a local workstation directory from Github the [CMDGRP database](cmdgrp.sql) script
3. Execute it from iACS Run SQL Scripts; it will ask for the library to create the database into
   - Warning, the script first deletes CMDGRP table if it exists; make sure to keep a copy somewhere of existing data somewhere; in a future version, it is planned to avoid deleting the table
4. Download the sources of objects from Github into the desired directory on the system
   1. [JOBLOGLST command](jobloglst.cmd)
   2. [JOBLOGLST command processing programe](jobloglst.pgm.clle)
   3. [JOBLOGLST command validity checker](jobloglst0.pgm.clle)
   4. [JOBLOGLST QM Query](jobloglst.qmqry)
   5. [JOBLOGLST QM Form](jobloglst.qmform)
5. Download into a local workstation directory from Github the [JOBLOG build](joblog_build.sql) script
6. If it was decided not to keep the same directory structure as described in this [Projects organization](../../README.md) document, review all INCLUDE statements in programs sources and review build script to update source file location in order to handle the modification
7. Execute it from iACS Run SQL Scripts; it will ask for the projects parent directory fullpath and library to create the objects into; the script runs CRTQMQRY and CRTQMFORM commands which seem to have an issue with REPLACE(*YES) parameter on PUB400, which means that the commands send an inquiry message to ask for replacement confirmation; to avoid that, the script includes two commented DLTOBJ commands which must be uncommented if the script runs more than one time for the same library
8. Populate CMDGRP table with a couple of commands and run a test

Enjoy looking at your job log!
