
--
-- Create and populate USRSPCAPI binding directory
--
-- The binding directory is expected to be in current library
-- If the procedure runs several times, the binding directory and its entries already exist
--    but we do not care. 
--

begin
    declare directory char(10);
    declare srvpgm char(10);
    declare text char(50);
    declare cmd char (200);
    declare issue int;
    declare quote char(1);
    set quote = '''';

    set directory = 'USRSPCAPI';
    set text = 'User Space API usage Service programs';

    set cmd = 'CRTBNDDIR BNDDIR(*CURLIB/'
        concat directory
        concat ') TEXT('
        concat quote 
        concat text 
        concat quote 
        concat')';

    select qsys2.qcmdexc(cmd)
        into issue
        from sysibm.sysdummy1;

    set srvpgm = 'USRSPC';
    set cmd = 'ADDBNDDIRE BNDDIR(*CURLIB/'
        concat directory
        concat ') OBJ('    
        concat srvpgm 
        concat')';

    select qsys2.qcmdexc(cmd)
        into issue
        from sysibm.sysdummy1;

end;