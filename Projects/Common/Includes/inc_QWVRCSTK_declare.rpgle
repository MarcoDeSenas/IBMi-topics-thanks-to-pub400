**free

//--------------------------------------------------------------------------*/
//                                                                          */
// This is the include file for QWVRCSTK API usage                          */
//                                                                          */
// Dates: 2025/08/15 Creation                                               */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-ds QWVK0100 qualified;                                                  // Qwv CSTK0100
    QWVBRTN                                         Int(10)                 Pos(001);   // Bytes Returned
    QWVBAVL                                         Int(10)                 Pos(005);   // Bytes Available
    QWVEAVL                                         Int(10)                 Pos(009);   // Entry Available
    QWVEO                                           Int(10)                 Pos(013);   // Entry Offset
    QWVERTN                                         Int(10)                 Pos(017);   // Entry Returned
    QWVRTNTI                                        Char(8)                 Pos(021);   // Returned Thread Id
    QWVIS                                           Char(1)                 Pos(029);   // Information Status
end-ds;

dcl-ds QWVCSTKE qualified;                                                          // Qwv RCSTK Entry
    QWVEL                                           Int(10)                 Pos(001);   // Entry Length
    QWVSD                                           Int(10)                 Pos(005);   // Stmt Displacement
    QWVSRTN                                         Int(10)                 Pos(009);   // Stmt Returned
    QWVPD                                           Int(10)                 Pos(013);   // Proc Displacement
    QWVPL                                           Int(10)                 Pos(017);   // Proc Length
    QWVRL01                                         Int(10)                 Pos(021);   // Request Level
    QWVPGMN                                         Char(10)                Pos(025);   // Program Name
    QWVPGML                                         Char(10)                Pos(035);   // Program Library
    QWVCTION                                        Int(10)                 Pos(045);   // Instruction
    QWVMN                                           Char(10)                Pos(049);   // Module Name
    QWVMLIB                                         Char(10)                Pos(059);   // Module Library
    QWVCB                                           Char(1)                 Pos(069);   // Control Bdy
    QWVERVED01                                      Char(3)                 Pos(070);   // Reserved
    QWVAGNBR                                        Uns(10)                 Pos(073);   // Act Group Number
    QWVAGN                                          Char(10)                Pos(077);   // Act Group Name
    QWVRSV201                                       Char(2)                 Pos(087);   // Reserved 2
    QWVPASPN                                        Char(10)                Pos(089);   // Program ASP Name
    QWVLASPN                                        Char(10)                Pos(099);   // Program Library ASP Name
    QWVPASPN00                                      Int(10)                 Pos(109);   // Program ASP Number
    QWVLASPN00                                      Int(10)                 Pos(113);   // Program Library ASP Number
    QWVAGNL                                         Uns(20)                 Pos(117);   // Act Group Number Long
end-ds;

dcl-ds QWc_JIDF0100 qualified;
    JobName                                         like(JobName);
    JobUser                                         like(JobUser);
    JobNbr                                          like(JobNbr);
    InternalJobId                                   like(InternalJobId);
    Reserved                                        char(2);
    ThreadIndicator                                 like(FourBytes);
    ThreadId                                        char(8);
end-ds;