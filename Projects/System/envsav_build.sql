--
-- ENVSAV build
-- Dates: 2023/08/13 Creation
--

--
-- Make sure the environment is properly set
--      Current directory must be /home/USERNAME
--      Current library must be USERNAME1, which means the library named with 1 as a suffix of the user name
--

create or replace variable cmd char(33);
create or replace variable homedir char(16);
create or replace variable curlib char(10);
set homedir = '/home/' concat CURRENT USER;
set curlib = CURRENT USER concat '1';
values homedir;
values curlib;
set cmd = 'CHGCURDIR DIR(''' concat trim(homedir) concat ''')';
values cmd;
call qsys2.qcmdexc (cmd);
set cmd = 'CHGCURLIB CURLIB(' concat CURLIB concat ')';
call qsys2.qcmdexc (cmd);
drop variable cmd;
drop variable homedir;
drop variable curlib;

--
-- Create objects
--

cl: CRTBNDCL PGM(*CURLIB/ENVSAV) SRCSTMF('projects/system/sources/envsav.pgm.clle') OPTION(*EVENTF) DBGVIEW(*SOURCE) REPLACE(*YES);
cl: CRTBNDCL PGM(*CURLIB/ENVSAV0) SRCSTMF('projects/system/sources/envsav0.pgm.clle') OPTION(*EVENTF) DBGVIEW(*SOURCE) REPLACE(*YES);
cl: CRTCMD CMD(*CURLIB/ENVSAV) PGM(*CURLIB/ENVSAV) SRCSTMF('projects/system/sources/envsav.cmd') OPTION(*EVENTF) REPLACE(*YES);