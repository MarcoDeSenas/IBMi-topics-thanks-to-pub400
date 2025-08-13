
--
-- Create/update a message id
--
-- The message file is expected to reside in current library
--

begin

    declare msgf char(10);
    declare msg char(132);
    declare msgid char(7);
    declare seclvl char (3000);
    declare fmt char(100);
    declare sev char(2);
    
    declare cmd char (4000);
    declare issue int;
    declare quote char(1);
    declare work char(3000);

    set msgf = 'TOOMSGF';
    set msg = '&1 spool files were successfully deleted.';
    set msgid = 'USP0304';
    set work = '&N Cause . . . . . :   The request was to *DLTONLY or *BOTH when using SPLFDLT command.';
    set seclvl = rtrim(work);
    set work = ' Therefore, those &1 spool files were deleted.';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = '&N Recovery  . . . :   None. This is the expected behavior.';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set fmt = '(*UBIN 4)'; -- set to *NONE if message id has no variable
    set sev = '00';

    set quote = '''';

    set cmd = 'MSGD MSGF(*CURLIB/'
        concat msgf
        concat ') CCSID(*JOB) MSGID('
        concat msgid
        concat ') MSG('
        concat quote
        concat rtrim(msg)
        concat quote 
        concat') FMT('
        concat rtrim(fmt)
        concat ') SEV('
        concat sev
        concat ')';

    if seclvl = '*NONE'
        then set cmd = rtrim(cmd)
        concat ' SECLVL(*NONE)';
    else
        set cmd = trim(cmd)
        concat ' SECLVL('
        concat quote
        concat rtrim(seclvl)
        concat quote
        concat ')';
    end if;
call systools.lprintf(fmt);
call systools.lprintf(cmd);
--
-- First, we try to add the message id
--

    select qsys2.qcmdexc('ADD' concat rtrim(cmd))
        into issue
        from sysibm.sysdummy1;

--
-- If QCMDEXC fails, it returns -1, 99% of time because message id already exists.
-- In this case, we change the message id.
--

    if issue = -1 then
        select qsys2.qcmdexc('CHG' concat rtrim(cmd))
            into issue
            from sysibm.sysdummy1;
    end if;

end;