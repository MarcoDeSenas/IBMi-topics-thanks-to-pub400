**free

//--------------------------------------------------------------------------*/
//                                                                          */
// This is the include file for workstation display related information     */
//                                                                          */
// Dates: 2025/08/07 Creation                                               */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-ds InfWorkStn qualified;
    Help                                            ind                     pos(01);
    Exit                                            ind                     pos(03);
    Prompt                                          ind                     pos(04);
    Refresh                                         ind                     pos(05);
    Add                                             ind                     pos(06);
    Backward                                        ind                     pos(07);
    Forward                                         ind                     pos(08);
    Retrieve                                        ind                     pos(09);
    NextView                                        ind                     pos(10);
    PreviousView                                    ind                     pos(11);
    Cancel                                          ind                     pos(12);
    MoreOptions                                     ind                     pos(23);
    MoreKeys                                        ind                     pos(24);
    SflDspCtl                                       ind                     pos(30);
    SflDsp                                          ind                     pos(31);
//                                                                          */
// From 81 to 99, can be used to condition displaying data                  */
//                                                                          */
    In81                                            ind                     pos(81);
    In82                                            ind                     pos(82);
    In83                                            ind                     pos(83);
    In84                                            ind                     pos(84);
    In85                                            ind                     pos(85);
    In86                                            ind                     pos(86);
    In87                                            ind                     pos(87);
    In88                                            ind                     pos(88);
    In89                                            ind                     pos(89);
    In90                                            ind                     pos(90);
    In91                                            ind                     pos(91);
    In92                                            ind                     pos(92);
    In93                                            ind                     pos(93);
    In94                                            ind                     pos(94);
    In95                                            ind                     pos(95);
    In96                                            ind                     pos(96);
    In97                                            ind                     pos(97);
    In98                                            ind                     pos(98);
    In99                                            ind                     pos(99);
end-ds;

dcl-c F01        x'31';
dcl-c F02        x'32';
dcl-c F03        x'33';
dcl-c F04        x'34';
dcl-c F05        x'35';
dcl-c F06        x'36';
dcl-c F07        x'37';
dcl-c F08        x'38';
dcl-c F09        x'39';
dcl-c F10        x'3A';
dcl-c F11        x'3B';
dcl-c F12        x'3C';
dcl-c F13        x'B1';
dcl-c F14        x'B2';
dcl-c F15        x'B3';
dcl-c F16        x'B4';
dcl-c F17        x'B5';
dcl-c F18        x'B6';
dcl-c F19        x'B7';
dcl-c F20        x'B8';
dcl-c F21        x'B9';
dcl-c F22        x'BA';
dcl-c F24        x'BC';
dcl-c ENTER      x'F1';
dcl-c HELP       x'F3';
dcl-c PRINT      x'F6';

dcl-s WorkStationKey                                char(2)                 inz;

dcl-c MaxSfl 9999;