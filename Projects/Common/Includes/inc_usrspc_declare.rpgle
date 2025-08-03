**free
//--------------------------------------------------------------------------*/
//                                                                          */
// This is the include file for user space service program prototypes       */
//                                                                          */
// Dates: 2025/06/23 Creation                                               */
//        2025/07/31 Retrieve info procedure                                */
//                                                                          */
//--------------------------------------------------------------------------*/

/DEFINE UsrSpcImported
/IF NOT DEFINED(StdAPIImported)
    /COPY ../Common/Includes/inc_basic_declare.rpgle
    /COPY ../Common/Includes/inc_stdapi_declare.rpgle
/ENDIF

dcl-pr UserSpaceCrt                                 like(ERRC0100);
    UsrSpc                                          like(ObjectName)        const;
    UsrSpcLib                                       like(ObjectName)        const;
    UsrSpcAtt                                       like(ObjectName)        const;
    UsrSpcTxt                                       like(ObjectText)        const;
end-pr;

dcl-pr UserSpaceRtvInfo;
    UsrSpc                                          like(ObjectName)        const;
    UsrSpcLib                                       like(ObjectName)        const;
    ErrorCode                                       like(ERRC0100);
    APIUsed                                         like(ObjectName);
    FormatName                                      char(8);
    StartPos                                        like(FourBytes);
    EntriesCount                                    like(FourBytes);
    EntryLength                                     like(FourBytes);
end-pr;
