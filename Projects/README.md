# Projects folder

The Projects folder retains documentation and sources files of programs written on PUB400.com. There are three main sections related to project groups.

The first Project is named **Common**. It contains all [shared resources](Common/README.md) by all other projects such as standard includes files.

The second Project is named **System**. It contains resources related to [system administration](System/README.md) topics. In a real world they could be used by system administrators.

The third Project is named **Tools**. It contains resources related to [common usage](Tools/README.md) on an IBM i system, not necessarily related to system administration. In a real world they could be used by every user.

The fourth Project is named **Utilities**. It contains resources related to [programming services](Utilities/README.md), which are available for all other tools and programs.

Regarding the organization in place on PUB400.com to retain the source files, which are as much as possible IFS files in place of regular physical source files, all the projects have the same structure described below.

|Home directory|Sub-level 1|Sub-level 2|Sub-level 3|Sub-level 4|Content|
|:---:|:---|:---|:---|:---|:---|
|~/builds/IBMi-topics-thanks-to-pub400|||||home directory|
||Projects||||directory of projects files|
|||Common|||common sources files used by other projects|
||||Includes||includes files|
|||System|||system administration project|
||||Assets||assets files such as pictures, images...|
||||System1||System 1 utility files...|
||||System2||System 2 utility files...|
||||SystemN||System N utility files...|
|||Tools|||tools project|
||||Assets||assets files such as pictures, images...|
||||Tool1||Tool 1 files|
||||Tool2||Tool 2 files|
||||ToolN||Tool N files|
|||Utilities|||utilities project|
||||Assets||assets files such as pictures, images...|
||||Utility1||Utility 1 files|
||||Utility2||Utility 2 files|
||||UtilityN||Utility N files|

In order to use Code4i local development and build capabilities, all files are retained in "~/builds/IBMi-topics-thanks-to-pub400". And Code4i creates the basic structure when setting up the deploy directory.

Important notice regarding includes files of common project. If one wants to use the sources files of all projects, and if those files make use of common includes files (which is the case for almost all of them), the directory structure must remain the one described above. Files can be in another home directory but with the same structure. If the structure is not the same, INCLUDE statements must be updated in all sources files prior to compilation.

Regarding the libraries usage, I have the following organization. We all have three libraries that we can use for what we want. They are named with our user profile with a suffix which is either 1, or 2, or B.

|Library|Content|
|:---|:---|
|LIBRARY1|Non-database objects, such as programs, commands, modules, binding directories, display, printer, source files...|
|LIBRARY2|Database objects|
|LIBRARYB|Backup library, not used explicitely, might be used by the programs|

LIBRARY1 is set as the current library of my user profile.
LIBRARY2, is set almost as a DB2 collection, with STRJRNLIB command and the following settings:

- Journal: LIBRARY2/JRN
- Journal images: *AFTER
- Omit journal entries: *NONE
- New objects inherit journalig: *YES
- Inherit rules: \*ALL objects types, \*ALL objects, \*ALLOPR journal operations, \*OBJDFT images and omitted entries
