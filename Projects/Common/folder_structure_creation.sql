--
-- Projects folder structure creation
-- Dates: 2023/08/20 Creation
--

--
-- Make sure the environment is properly set
--      Current directory must be /home/USERNAME
--

create or replace variable cmd char(33);
create or replace variable homedir char(16);
set homedir = '/home/' concat CURRENT USER;
values homedir;
set cmd = 'CHGCURDIR DIR(''' concat trim(homedir) concat ''')';
values cmd;
call qsys2.qcmdexc (cmd);
drop variable cmd;
drop variable homedir;

--
-- Create directory structure
--

cl: CRTDIR DIR(projects);
cl: CRTDIR DIR(projects/common);
cl: CRTDIR DIR(projects/common/docs);
cl: CRTDIR DIR(projects/common/includes);
cl: CRTDIR DIR(projects/common/scripts);
cl: CRTDIR DIR(projects/system);
cl: CRTDIR DIR(projects/system/docs);
cl: CRTDIR DIR(projects/system/includes);
cl: CRTDIR DIR(projects/system/scripts);
cl: CRTDIR DIR(projects/system/sources);
cl: CRTDIR DIR(projects/system/sqlstmt);
cl: CRTDIR DIR(projects/system/sqlstmt/DDL);
cl: CRTDIR DIR(projects/system/sqlstmt/DML);
cl: CRTDIR DIR(projects/tools);
cl: CRTDIR DIR(projects/tools/docs);
cl: CRTDIR DIR(projects/tools/includes);
cl: CRTDIR DIR(projects/tools/scripts);
cl: CRTDIR DIR(projects/tools/sources);
cl: CRTDIR DIR(projects/tools/sqlstmt);
cl: CRTDIR DIR(projects/tools/sqlstmt/DDL);
cl: CRTDIR DIR(projects/tools/sqlstmt/DML);