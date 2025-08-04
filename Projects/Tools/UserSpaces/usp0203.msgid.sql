
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
    set msg = 'Unexpected data found in user space &2/&1.';
    set msgid = 'USP0203';
    set work = '&N Cause . . . . . :   Unexpected data exist within the user space.';
    set seclvl = rtrim(work);
    set work = ' This is specifically related to "Offset to List Data Section", "Number of List Entries"';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = ' and "Size of Each Entries" variables.';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = '&N Recovery  . . . :   Review the content of the user space,';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = ' and compare it to "General data structure for list APIs" content in online documentation.';
    set seclvl = rtrim(seclvl) concat rtrim(work);
    set work = ' Correct the issue, then run again the API which populates the user space.';
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