
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
    set msg = 'Unable to delete &1 spool file, with number &2, from &3/&4/&5 job.';
    set msgid = 'USP0312';
    set work = '&N Cause . . . . . :   Some possible causes are:';
    set seclvl = rtrim(work);
    set work = '&B - authority problem';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = '&B - the spool file might no longer exist';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = '&B - a discrepancy exists between the internal system indexes and spool and job structures';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = '&N Recovery  . . . :   Review the job log for more information to fix the issues and run again the same request.';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set fmt = '(*CHAR 10) (*UBIN 4) (*CHAR 6) (*CHAR 10) (*CHAR 10)'; -- set to *NONE if message id has no variable
    set sev = '40';

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