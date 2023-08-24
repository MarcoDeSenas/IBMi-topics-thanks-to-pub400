--
-- JOBLOG build
-- Dates: 2023/08/24 Creation
--

--
-- Ask for the environment where the sources reside and where to create the objects
--     We need the parent directory of projects directory
--     We need the current library
--     We need the library where the database was created in the library list
--

create or replace variable CMD char(150);
create or replace variable PARENTDIR char(100);
create or replace variable CURLIB char(10);

set PARENTDIR = ?;
set CURLIB = ?;

set CMD = 'CHGCURDIR DIR(''' concat trim(PARENTDIR) concat ''')';
call qsys2.qcmdexc (CMD); -- command will fail and script stop if any issue with PARENTDIR directory
set CMD = 'CHGCURLIB CURLIB(' concat trim(CURLIB) concat ')';
call qsys2.qcmdexc (CMD); -- command will fail and script stop if any issue with CURLIB library
set CMD = 'ADDLIBLE LIB(' concat (select OBJLIB from table(QSYS2.OBJECT_STATISTICS('*ALLUSR', 'FILE', 'CMDGRP_IX1')) a) concat ')';
call qsys2.qcmdexc (CMD); -- command will fail and script stop if any issue to add library

drop variable CMD;
drop variable PARENTDIR;
drop variable CURLIB;

--
-- Create objects
--

cl: CRTBNDCL PGM(*CURLIB/JOBLOGLST) SRCSTMF('projects/tools/sources/jobloglst.pgm.clle') OPTION(*EVENTF) DBGVIEW(*SOURCE) REPLACE(*YES);
cl: CRTBNDCL PGM(*CURLIB/JOBLOGLST0) SRCSTMF('projects/tools/sources/jobloglst0.pgm.clle') OPTION(*EVENTF) DBGVIEW(*SOURCE) REPLACE(*YES);
cl: CRTCMD CMD(*CURLIB/JOBLOGLST) PGM(*CURLIB/JOBLOGLST) SRCSTMF('projects/tools/sources/jobloglst.cmd') OPTION(*EVENTF) REPLACE(*YES);

-- on PUB400, REPLACE(*YES) does not work when creating QMQuery or QMForm, so objects must be deleted first, but DLTOBJ fails if the object does not exist
-- therefore, the two CL commands below must run only if objects exist
-- cl: DLTOBJ OBJ(*CURLIB/JOBLOGLST) OBJTYPE(*QMFORM) RMVMSG(*YES);
-- cl: DLTOBJ OBJ(*CURLIB/JOBLOGLST) OBJTYPE(*QMQRY) RMVMSG(*YES);

cl: CLRLIB LIB(QTEMP);
cl: CRTSRCPF FILE(QTEMP/QQMFORMSRC);
cl: CRTSRCPF FILE(QTEMP/QQMQRYSRC) RCDLEN(91);
cl: CPYFRMSTMF FROMSTMF('projects/tools/sources/jobloglst.qmform') TOMBR('/QSYS.LIB/QTEMP.LIB/QQMFORMSRC.FILE/JOBLOGLST.MBR') MBROPT(*REPLACE);
cl: CPYFRMSTMF FROMSTMF('projects/tools/sources/jobloglst.qmqry') TOMBR('/QSYS.LIB/QTEMP.LIB/QQMQRYSRC.FILE/JOBLOGLST.MBR') MBROPT(*REPLACE);
cl: CRTQMFORM QMFORM(*CURLIB/JOBLOGLST) SRCFILE(QTEMP/QQMFORMSRC) SRCMBR(*QMFORM);
cl: CRTQMQRY QMQRY(*CURLIB/JOBLOGLST) SRCFILE(QTEMP/QQMQRYSRC) SRCMBR(*QMQRY) SRTSEQ(*JOB) LANGID(*JOB);
