
--
-- Create the application message file if it does not exist
--
-- The message file is created in current library
-- If the procedure runs several times, the message file already exists
--    but we do not care. 
--

begin
    declare msgf char(10);
    declare text char(50);
    declare cmd char (200);
    declare issue int;
    declare quote char(1);

    set msgf = 'TOOMSGF';
    set text = 'Tools application messages file';

    set quote = '''';
    set cmd = 'CRTMSGF MSGF(*CURLIB/'
        concat msgf
        concat ') CCSID(*JOB) TEXT('
        concat quote 
        concat text 
        concat quote 
        concat')';

    select qsys2.qcmdexc(cmd)
        into issue
        from sysibm.sysdummy1;
    
end;