**free
//--------------------------------------------------------------------------*/
//                                                                          */
// This is the include file for API standard variables                      */
//                                                                          */
// Dates: 2025/06/28 Creation                                               */
//        2025/07/31 APIListHeader data-structure                           */
//                                                                          */
//--------------------------------------------------------------------------*/

/DEFINE StdAPIImported

dcl-s FourBytes                                     int(10);

dcl-ds ERRC0100 qualified inz;
    BytesProvided                                   like(FourBytes) inz(%size(ERRC0100));
    BytesAvailable                                  like(FourBytes);
    ExceptionId                                     char(7);
    Reserved                                        char(1);
    ExceptionData                                   char(3000);
end-ds;

dcl-ds ERRC0200 qualified inz;
    Key                                             like(FourBytes) inz(-1);
    BytesProvided                                   like(FourBytes) inz(%size(ERRC0200));
    BytesAvailable                                  like(FourBytes);
    ExceptionId                                     char(7);
    Reserved                                        char(1);
    CharCCSID                                       like(FourBytes);
    ExceptionDataOffset                             like(FourBytes);
    ExceptionDataLength                             like(FourBytes);
    ExceptionData                                   char(3000);
end-ds;

dcl-ds APIListHeader qualified inz;
    UserArea                                    char(64);
    SizeGenericHeader                           like(FourBytes);
    StructureReleaseLevel                       char(4);
    FormatName                                  char(8);
    APIUsed                                     char(10);
    DateTimeCreated                             char(13);
    InformationStatus                           char(1);
    SizeUserSpace                               like(FourBytes);
    OffsetInputParameter                        like(FourBytes);
    SizeInputParameter                          like(FourBytes);
    OffsetHeaderSection                         like(FourBytes);
    SizeHeaderSection                           like(FourBytes);
    OffsetListData                              like(FourBytes);
    SizeListData                                like(FourBytes);
    NumberListEntries                           like(FourBytes);
    SizeEachEntry                               like(FourBytes);
    CCSIDListEntry                              like(FourBytes);
    CountryId                                   char(2);
    LanguageId                                  char(3);
    SubsetListIndicator                         char(1);
    APIEntryPointName                           char(42);
end-ds;

dcl-s StartingPosition                              like(FourBytes);
dcl-s DataLength                                    like(FourBytes);
dcl-s StdHeaderData                                 char(192);