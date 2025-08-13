**free
//--------------------------------------------------------------------------*/
//                                                                          */
// This is the include file for basic variables                             */
//                                                                          */
// Dates: 2023/08/27 Creation                                               */
//        2024/06/04 Updated with some constant declarations                */
//        2025/06/22 Updated with names related declarations                */
//        2025/08/01 Updated with hexDigits declaration                     */
//        2025/08/08 Updated with Error declaration                         */
//                                                                          */
//--------------------------------------------------------------------------*/

/DEFINE BasicImported

dcl-s FourBytes                                     int(10);

dcl-s ObjectName                                    char(10);
dcl-s ObjectText                                    char(50);
dcl-s QualifiedObject                               char(20);
dcl-s UserProfile                                   like(ObjectName);
dcl-s SpoolFile                                     like(ObjectName);
dcl-s JobName                                       char(10);
dcl-s JobNbr                                        char(6);
dcl-s JobUser                                       like(UserProfile);
dcl-s Date7                                         char(7);
dcl-s Time6                                         char(6);
dcl-s OutQueue                                      like(ObjectName);
dcl-s OutQueueLibrary                               like(ObjectName);
dcl-s ASPNumber                                     like(FourBytes);

dcl-c Blank ' ';
dcl-c Comma ', ';
dcl-c Quote '''';
dcl-c OpenBracket '(';
dcl-c CloseBracket ')';
dcl-c Zero 0;
dcl-c hexDigits '0123456789ABCDEFabcdef';

dcl-ds PgmDs psds qualified;
    PgmName                                         *proc;
end-ds;

dcl-s i                                             int(20);
dcl-s Error                                         ind inz(*off);
