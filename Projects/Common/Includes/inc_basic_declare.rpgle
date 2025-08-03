**free
//--------------------------------------------------------------------------*/
//                                                                          */
// This is the include file for basic variables                             */
//                                                                          */
// Dates: 2023/08/27 Creation                                               */
//        2024/06/04 Updated with some constant declarations                */
//        2025/06/22 Updated with names related declarations                */
//        2025/08/01 Updated with hexDigits declaration                     */
//                                                                          */
//--------------------------------------------------------------------------*/

/DEFINE BasicImported

dcl-s ObjectName                                    char(10);
dcl-s ObjectText                                    char(50);
dcl-s QualifiedObject                               char(20);

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
