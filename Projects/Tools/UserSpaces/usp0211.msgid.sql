
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
    declare fmt char(50);
    declare sev char(2);
    
    declare cmd char (4000);
    declare issue int;
    declare quote char(1);
    declare work char(3000);

    set msgf = 'TOOMSGF';
    set msg = 'Unexpected value found when retrieving &2/&1 user space information.';
    set msgid = 'USP0211';
    set work = '&N Cause . . . . . :   The information expected to be found in user space is incorrect.';
    set seclvl = rtrim(work);
    set work = ' Most probably, the user did not invoke properly USRSPCRTVI command.';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = '&N Recovery  . . . :   Make sure to use the command,';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = ' in place of direct program invocation. Then run again the operation.';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set fmt = '(*CHAR 10) (*CHAR 10)'; -- set to *NONE if message id has no variable
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