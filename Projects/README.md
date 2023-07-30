The Projects folder retains documentation and sources files of programs written on PUB400.com. There are three main sections related to project groups.

The first Project is named **Common**. It contains all resources which are shared by all other projects such as standard includes files.

The second Project is named **System**. It contains resources related to system administration topics. In a real world they could be used by system administrators.

The third Project is named **Tools**. It contains resources related to common usage on an IBM i system, not necessarily related to system administration. In a real world they could be used by every user.

Regarding the organization in place on PUB400.com to retain the source files, which are as much as possible IFS files in place of regular physical source files, all the projects have the same structure described below.

|Home directory|Sub-level 1|Sub-level 2|Sub-level 3|Sub-level 4|Content|
|:---:|:---|:---|:---|:---|:---|
|~|||||home directory|
||projects||||directory of projects files|
|||common|||common sources files used by other projects|
||||docs||documentation about common project|
||||includes||includes files|
|||system|||system administration project|
||||docs||documentation about system project|
||||includes||includes files limited to project use|
||||scripts||scripts (QSH, PASE, python...) files of system project|
||||sources||sources files of system project|
||||sqlstmt||SQL statements of system project|
|||||DDL|Database Definition Language scripts for system project|
|||||DML|Database Manipulation Language scripts for tools project|
|||tools|||tools and utilities project|
||||docs||documentation about tools project|
||||includes||includes files limited to project use|
||||scripts||scripts (QSH, PASE, python...) files of tools project|
||||sources||sources files of tools project|
||||sqlstmt||SQL statements of tools project|
|||||DDL|Database Definition Language scripts for system project|
|||||DML|Database Manipulation Language scripts for tools project|

Important notice regarding includes files of common project. If one wants to use the sources files of all projects, and if those files make use of common includes files (which is the case for almost all of them), the directory structure must remain the one described above. Files can be in another home directory but with the same structure. If the structure is not the same, INCLUDE statements must be updated in all sources files prior to compilation.
