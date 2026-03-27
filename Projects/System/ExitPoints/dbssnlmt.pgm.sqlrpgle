**free

//--------------------------------------------------------------------------*/
//                                                                          */
// The goal of this program is to check whether or not the count of         */
// database connections for the current user is over a defined limit.       */
// It is intended to be used as an exit program of the QIBM_QZDA_INIT exit  */  
// point.                                                                   */
// Once created, it has to be registered with the command:                  */
// ADDEXITPGM EXITPNT(QIBM_QZDA_INIT) FORMAT(ZDAI0100) PGMNBR(*LOW)         */
//            PGM(yourlib/DBSSNLMT) TEXT('Limit DB connections per user')   */
//                                                                          */
// Output parameter: Flag to allow or reject                                */
// Input parameter:  ZDAI0100 format structure                              */
//                                                                          */
// Dates: 2026/03/18 Creation                                               */
//                                                                          */
// Based on https://www.ibm.com/docs/en/i/7.5.0?topic=administration-use-server-exit-programs */
//                                                                          */
//--------------------------------------------------------------------------*/

ctl-opt option(*srcstmt:*nodebugio) actgrp(*NEW);
ctl-opt main(Main);

dcl-c OpenBracket '(';
dcl-c CloseBracket ')';
dcl-c Blank ' ';
dcl-c Comma ',';
dcl-c Quote '''';
dcl-c Zero 0;
dcl-c Yes 'Y';
dcl-c No 'N';
dcl-c AcceptFlag '1';
dcl-c RejectFlag '0';

dcl-ds EnvVariable                                  ExtName('QSYS2/ENV_VARS')       qualified;
end-ds;

dcl-s FourBytes                                     int(10);
dcl-s Char1                                         char(1);

//--------------------------------------------------------------------------*/
//                                                                          */
// Main procedure                                                           */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc Main;
    dcl-pi *n;
        OutFlag                                     like(Char1);
        InZDAI0100                                  like(EZDQIF)                    const;
    end-pi;

/COPY /QSYS.LIB/QSYSINC.LIB/QRPGLESRC.FILE/EZDAEP.MBR

    dcl-c Localhost '127.0.0.1';
    dcl-c DefaultAcceptQ 'Y';
    dcl-c DefaultMaxSessions 5;
    dcl-c DefaultService1 'as-database';
    dcl-c DefaultService2 'as-database-s';
    dcl-c DefaultService3 'drda';
    dcl-c DefaultService4 'ddm';
    dcl-c DefaultService5 'ddm-ssl';
    dcl-c DefaultIncludeLocalhost 'N';
    dcl-c VariableNameRoot 'DATABASE_LIMIT_%';
    dcl-c VariableNameMaxSessions 'DATABASE_LIMIT_CONCURRENTSESSIONS';
    dcl-c VariableNameServiceList 'DATABASE_LIMIT_SERVICENAMES';
    dcl-c VariableNameIncludeLocalHost 'DATABASE_LIMIT_INCLUDELOCALHOST';
    dcl-c VariableNameAcceptQ 'DATABASE_LIMIT_ALLWAYSACCEPTQ';

    dcl-s CurrentSessions                           like(FourBytes)                 inz;
    dcl-s IncludeLocalhost                          like(Char1)                     inz;
    dcl-s AcceptQ                                   like(Char1)                     inz;
    dcl-s MaxSessions                               like(CurrentSessions)           inz;
    dcl-s ServiceList                               like(EnvVariable.VAR_VALUE)     inz;
    dcl-s SQLstmt                                   char(1024)                      inz;
    dcl-s MessageData                               char(132)                       inz;
    dcl-s MessageDataLength                         int(10)                         inz;

    EZDQIF = InZDAI0100;

//--------------------------------------------------------------------------*/
//                                                                          */
// Retrieve configuration parameters which are stored as environment values.*/
// DATABASE_LIMIT_CONCURRENTSESSIONS is the number of allowed concurrent    */
// connections. If it does not exist, the default is 5.                     */
// DATABASE_LIMIT_SERVICENAMES is the list of database service names. If it */
// does not exist, the default is as-database,as-database-s,drda,ddm,ddm-ssl*/
// DATABASE_LIMIT_ALLWAYSACCEPTQ defines whether or not we accept sessions  */
// from a Q* user profile regardless any count of existing sessions. If it  */
// does not exist, the default is Y (which means that we accept the         */
// connections regardless the count of active connections.                  */
// (this is to avoid potential issues for connections on Localhost for user */
// profiles such as QWEBADMIN used by IBM Navigator for i)                  */
// DATABASE_LIMIT_INCLUDELOCALHOST defines whether or not, we include local */
// sessions from and to localhost in the count of sessions. If it does not  */
// exist, the default is N (which means that we do not check for localhost  */
// sessions).                                                               */
//                                                                          */
// Note: *SYSTEM level environment variables are automatically copied at    */
//       the *JOB level for each job when it is initiated; therefore we     */
//       can indeed select JOB environment_variable_type to retrieve only   */
//       one occurence of each variable.                                    */
//                                                                          */
//--------------------------------------------------------------------------*/

    SQLstmt = 'SELECT environment_variable_name,environment_variable_value';
    SQLstmt = %trim(SQLstmt) + ' FROM qsys2.environment_variable_info';
    SQLstmt = %trim(SQLstmt) + ' WHERE environment_variable_type =';
    SQLstmt = %trim(SQLstmt) + Blank + Quote + 'JOB' + Quote;
    SQLstmt = %trim(SQLstmt) + ' AND environment_variable_name LIKE(';
    SQLstmt = %trim(SQLstmt) + Quote + VariableNameRoot + Quote + CloseBracket;

    exec sql PREPARE DblimitsString FROM :SQLstmt;
    exec sql DECLARE DblimitsCursor CURSOR FOR DblimitsString;
    exec sql OPEN DblimitsCursor;

    exec sql FETCH NEXT FROM DblimitsCursor INTO :EnvVariable.VAR_NAME,:EnvVariable.VAR_VALUE;
    dow (SQLSTATE = '00000');
        if (EnvVariable.VAR_NAME = VariableNameAcceptQ);
            AcceptQ = DecodeYN(EnvVariable.VAR_VALUE);
        endif;
        if (EnvVariable.VAR_NAME = VariableNameMaxSessions);
            MaxSessions = DecodeMaxSessions(EnvVariable.VAR_VALUE);
        endif;
        if (EnvVariable.VAR_NAME = VariableNameServiceList);
            ServiceList = DecodeServiceList(EnvVariable.VAR_VALUE);
        endif;
        if (EnvVariable.VAR_NAME = VariableNameIncludeLocalHost);
            IncludeLocalhost = DecodeYN(EnvVariable.VAR_VALUE);
        endif;
        exec sql FETCH NEXT FROM DblimitsCursor INTO :EnvVariable.VAR_NAME,:EnvVariable.VAR_VALUE;
    enddo;

    exec sql CLOSE DblimitsCursor;

//--------------------------------------------------------------------------*/
//                                                                          */
// Set default values if environment variables are neither found nor valid. */
//                                                                          */
//--------------------------------------------------------------------------*/

    if (AcceptQ = Blank);
        AcceptQ = DefaultAcceptQ;
    endif;
    if (MaxSessions = Zero);
        MaxSessions = DefaultMaxSessions;
    endif;
    if (ServiceList = Blank);
        ServiceList = Quote + DefaultService1 + Quote + Comma
                    + Quote + DefaultService2 + Quote + Comma
                    + Quote + DefaultService3 + Quote + Comma
                    + Quote + DefaultService4 + Quote + Comma
                    + Quote + DefaultService5 + Quote;
    endif;
    if (IncludeLocalhost = Blank);
        IncludeLocalhost = DefaultIncludeLocalhost;
    endif;

//--------------------------------------------------------------------------*/
//                                                                          */
// User profile checking in regard to DATABASE_LIMIT_ALLWAYSACCEPTQ content.*/
// If this environment variable is Y for Yes and the user profile is Q*, we */
// accept the connection regardless the count of active sessions, and we    */
// quit here.                                                               */
//                                                                          */
//--------------------------------------------------------------------------*/

    if (AcceptQ = Yes and %subst(EZDUP : 1 : 1) = 'Q');
        snd-msg *INFO %msg('CPI3701' : 'QCPFMSG' : 'Database access accepted as a system user profile') %target(*SELF);
        OutFlag = AcceptFlag;
    else;

//--------------------------------------------------------------------------*/
//                                                                          */
// Run the SQL statement over QSYS2.NETSTAT_JOB_INFO view according to      */
// configuration parameters to retrieve the count of active connections.    */
//                                                                          */
//--------------------------------------------------------------------------*/

        CurrentSessions = 0;

        SQLstmt = 'VALUES (SELECT COUNT(*) FROM qsys2.netstat_job_info';
        SQLstmt = %trim(SQLstmt) + ' WHERE authorization_name = current user';
        SQLstmt = %trim(SQLstmt) + ' AND local_port_name IN (';
        SQLstmt = %trim(SQLstmt) + ServiceList;
        SQLstmt = %trim(SQLstmt) + CloseBracket;
        if (IncludeLocalhost = No);
            SQLstmt = %trim(SQLstmt) + ' AND remote_address <>';
            SQLstmt = %trim(SQLstmt) + Blank + Quote;
            SQLstmt = %trim(SQLstmt) + Localhost;
            SQLstmt = %trim(SQLstmt) + Quote;
        endif;

        SQLstmt = %trim(SQLstmt) + ') INTO ?';

        exec sql PREPARE SessionsCount FROM :SQLstmt;
        exec sql EXECUTE SessionsCount USING :CurrentSessions;

//--------------------------------------------------------------------------*/
//                                                                          */
// Set the output flag parameter according to the number of current sessions*/
// versus the maximum allowed.                                              */
//                                                                          */
// If accepted, we send an information message to the joblog to confirm the */
// access.                                                                  */
// If rejected, we send another information message to the joblog to show   */
// the rejection. And another information message is sent to QSYSOPR and    */
// system log for analysis if needed. The message id is CPD436F which is the*/
// unique message id from QCPFMSG which complies with QSYS2.SEND_MESSAGE    */
// SQL procedure requirements.                                              */
//                                                                          */
//--------------------------------------------------------------------------*/

        if (CurrentSessions >= MaxSessions);
            snd-msg *DIAG %msg('CPI3701' : 'QCPFMSG' : 'Database access rejected per rules') %target(*SELF);
            MessageData = 'Database access rejected for ' + %trim(EZDUP) + ' with ' + %char(CurrentSessions) + ' active sessions';
            MessageDataLength = %len(%trim(MessageData));
            exec sql CALL QSYS2.SEND_MESSAGE(
                    MESSAGE_ID => 'CPD436F',
                    MESSAGE_LENGTH => :MessageDataLength,
                    MESSAGE_TEXT => :MessageData,
                    MESSAGE_FILE_LIBRARY => '*LIBL',
                    MESSAGE_FILE => 'QCPFMSG',
                    MESSAGE_QUEUE_LIBRARY => '*LIBL',
                    MESSAGE_QUEUE => 'QSYSOPR');
            OutFlag = RejectFlag;
        else;
            snd-msg *INFO %msg('CPI3701' : 'QCPFMSG' : 'Database access accepted per rules') %target(*SELF);
            OutFlag = AcceptFlag;
        endif;

    endif;

//--------------------------------------------------------------------------*/
//                                                                          */
// This is the normal end.                                                  */
//                                                                          */
//--------------------------------------------------------------------------*/
 
    *inlr = *on;
    return;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Decode Sessions limit value from environment value                       */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc DecodeMaxSessions;
    dcl-pi *n                                       like(FourBytes);
        EnvironmentValue                            like(EnvVariable.VAR_VALUE) const;
    end-pi;

    dcl-s ReturnValue                               like(FourBytes)             inz;

    monitor;
        ReturnValue = %int(%trim(%char(EnvironmentValue)));
    on-error;
        ReturnValue = Zero;
    endmon;

    return ReturnValue;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Decode Service list value from environment value                         */
// Service list is expected to be a comma separated value list such as      */
// service1,service2, service3....                                          */
// Returned service list will be transformed to a list that SQL accepts     */
// 'service1','service2','service3',...                                     */
//                                                                          */
// Note: we try to reformat the environment variable value with the removal */
// of ' and spaces. So that we can add a ' back at the beginning and end    */
// and just before and after each comma.                                    */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc DecodeServiceList;
    dcl-pi *n                                       like(EnvVariable.VAR_VALUE);
        EnvironmentValue                            like(EnvVariable.VAR_VALUE) const;
    end-pi;

    dcl-s ReturnValue                               like(EnvironmentValue)      inz;
    dcl-s CommaPosition                             like(FourBytes)             inz;
    dcl-s Left                                      like(ReturnValue)           inz;
    dcl-s Right                                     like(ReturnValue)           inz;
    dcl-s PreviousCommaPosition                     like(CommaPosition)         inz;
    dcl-s ScanString                                like(Char1)                 inz;

//--------------------------------------------------------------------------*/
//                                                                          */
// Remove all quote and space characters from the environment variable value*/
//                                                                          */
//--------------------------------------------------------------------------*/

    ScanString = Quote;
    ReturnValue = %scanrpl(ScanString : '' : %trim(%char(EnvironmentValue)) : 1 : %len(%trim(%char(EnvironmentValue))));
    ScanString = Blank;
    ReturnValue = %scanrpl(ScanString : '' : %trim(%char(ReturnValue)) : 1 : %len(%trim(%char(ReturnValue))));

//--------------------------------------------------------------------------*/
//                                                                          */
// Add a quote at the beginning and the end of environment variable value   */
//                                                                          */
//--------------------------------------------------------------------------*/

    ReturnValue = Quote + %trim(ReturnValue) + Quote;

//--------------------------------------------------------------------------*/
//                                                                          */
// Add a quote just before and just after each comma                        */
//                                                                          */
//--------------------------------------------------------------------------*/

    PreviousCommaPosition = 1;
    ScanString = Comma;
    CommaPosition = %scan(ScanString : %char(ReturnValue) : PreviousCommaPosition);
    dow (CommaPosition <> Zero);
        Left = %left(ReturnValue : CommaPosition - 1 );
        Right = %right(ReturnValue : %len(ReturnValue) - CommaPosition);
        ReturnValue = %char(Left) + Quote + Comma + Quote + %char(Right);
        PreviousCommaPosition = CommaPosition + 2;
        CommaPosition = %scan(ScanString : %char(ReturnValue) : PreviousCommaPosition);
    enddo;

    return ReturnValue;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Decode Y/N from environment value                                        */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc DecodeYN;
    dcl-pi *n                                       like(Char1);
        EnvironmentValue                            like(EnvVariable.VAR_VALUE) const;
    end-pi;

    dcl-s ReturnValue                               like(Char1) inz;

    ReturnValue = Blank;
    if (%trim(%char(EnvironmentValue)) = Yes);
        ReturnValue = Yes;
    endif;
    if (%trim(%char(EnvironmentValue)) = No);
        ReturnValue = No;
    endif;

    return ReturnValue;

end-proc;