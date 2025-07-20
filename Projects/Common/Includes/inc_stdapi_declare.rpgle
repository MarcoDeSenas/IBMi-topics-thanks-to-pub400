**free
//--------------------------------------------------------------------------*/
//                                                                          */
// This is the include file for API standard variables                      */
//                                                                          */
// Dates: 2025/06/28 Creation                                               */
//                                                                          */
//--------------------------------------------------------------------------*/

/DEFINE StdAPIImported

dcl-ds ERRC0100 qualified inz;
    BytesProvided                                   int(10:0)   inz(%size(ERRC0100));
    BytesAvailable                                  int(10:0);
    ExceptionId                                     char(7);
    Reserved                                        char(1);
    ExceptionData                                   char(3000);
end-ds;

dcl-ds ERRC0200 qualified inz;
    Key                                             int(10:0)   inz(-1);
    BytesProvided                                   int(10:0)   inz(%size(ERRC0200));
    BytesAvailable                                  int(10:0);
    ExceptionId                                     char(7);
    Reserved                                        char(1);
    CharCCSID                                       int(10:0);
    ExceptionDataOffset                             int(10:0);
    ExceptionDataLength                             int(10:0);
    ExceptionData                                   char(3000);
end-ds;