**free

//--------------------------------------------------------------------------*/
//                                                                          */
// This is the program which displays the content of a user space in a      */
// formatted way depending on the API and format used to populate the user  */
// space.                                                                   */
//                                                                          */
// Input parameters: User space name                                        */
//                   User space library                                     */
// Output parameters: standard ERRC0100 API error structure                 */
//                                                                          */
// Specific indicators usage: IN90 To condition a special error display     */
//                                 when retrieving the detail of an entry   */
//                            IN91 To condition not displaying the counters */
//                                 when the user space is empty             */
//                                                                          */
//                                                                          */
//                                                                          */
// Dates: 2025/08/07 Creation (with QUSLSPL/SPLF0300 API/Format)            */
//        2025/10/30 Fix wrong setup of SCREEN name                         */
//        2025/10/31 Allow requesting a position in the list                */
//                                                                          */
//--------------------------------------------------------------------------*/

ctl-opt option(*srcstmt:*nodebugio) actgrp('USRSPC') bnddir('USRSPCAPI');
ctl-opt main(Main);

dcl-f usrspcdsp workstn indds(InfWorkStn) sfile(SFLDTA:$RRN) usropn;

/COPY ../../Common/Includes/inc_basic_declare.rpgle
/COPY ../../Common/Includes/inc_stdapi_declare.rpgle
/COPY ../../Common/Includes/inc_usrspc_declare.rpgle
/COPY ../../Common/Includes/inc_wrkstn_declare.rpgle

/COPY ../../Common/Includes/inc_QUSLSPL_SPLF0300_declare.rpgle

//--------------------------------------------------------------------------*/
//                                                                          */
// Main procedure                                                           */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc Main;
    dcl-pi *n;
        InUserSpace                                 like(ObjectName)        const;
        InUserSpaceLib                              like(ObjectName)        const;
        OutERRC0100                                 like(ERRC0100);
    end-pi;

    dcl-s API                                       like(APIListHeader.APIUsed)     inz;
    dcl-s Format                                    like(APIListHeader.FormatName)  inz;
    dcl-s OutStartingPosition                       like(FourBytes)         inz(Zero);
    dcl-s OutEntryNumber                            like(FourBytes)         inz(Zero);
    dcl-s OutEntryLength                            like(FourBytes)         inz(Zero);

    dcl-ds AcceptedAPI                              qualified               dim(1);
        API                                         like(API);
    end-ds;
    dcl-ds AcceptedFormat                           qualified               dim(1);
        Format                                      like(Format);
    end-ds;
    dcl-s FoundAPI                                  int(10)                 inz(Zero);
    dcl-s FoundFormat                               int(10)                 inz(Zero);

//--------------------------------------------------------------------------*/
//                                                                          */
// Retrieve information from the user space.                                */
// In case of issue, we forward the error structure to the calling program  */
// and stop here.                                                           */
//                                                                          */
//--------------------------------------------------------------------------*/

    clear ERRC0100;

    UserSpaceRtvInf(InUserSpace:
                    InUserSpaceLib:
                    ERRC0100:
                    API:
                    Format:
                    OutStartingPosition:
                    OutEntryNumber:
                    OutEntryLength);
    if ERRC0100.ExceptionId <> Blank;
        clear OutERRC0100;
        OutERRC0100 = ERRC0100;
        ReturnProc();
        return;
    endif;

//--------------------------------------------------------------------------*/
//                                                                          */
// No issue, we can now open the display file.                              */
//                                                                          */
//--------------------------------------------------------------------------*/

    open usrspcdsp;

    $USRSPC = InUserSpace;
    $USRSPCLIB = InUserSpaceLib;
    $USRSPCQUA = %trimr(InUserSpaceLib:*natural) + '/' + %trimr(InUserSpace:*natural);

//--------------------------------------------------------------------------*/
//                                                                          */
// In order to display user space content, we accept only some API and      */
// formats.                                                                 */
// For those which are not we display a special format which suggests to    */
// use DSPF command against the user space.                                 */
//                                                                          */
//--------------------------------------------------------------------------*/

    AcceptedAPI(1).API = API_QUSLSPL;
    AcceptedFormat(1).Format = FMT_SPLF0300;

    FoundAPI = %lookup(API:AcceptedAPI(*).API);
    FoundFormat = %lookup(Format:AcceptedFormat(*).Format);

    $APINAME = API;
    $FMTNAME = Format;

    if (FoundAPI = Zero or FoundFormat = Zero);
        InvokeDSPF();
        ReturnProc();
        return;      
    endif;

//--------------------------------------------------------------------------*/
//                                                                          */
// We can now handle displaying and managing the list of entries.           */
//                                                                          */
//--------------------------------------------------------------------------*/

    $ENTNB=OutEntryNumber;
    $ENTLG=OutEntryLength;

    HandleSflCtl(OutStartingPosition);

//--------------------------------------------------------------------------*/
//                                                                          */
// This is the normal end.                                                  */
//                                                                          */
//--------------------------------------------------------------------------*/
 
    ReturnProc();
    return;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Clear subfile procedure                                                  */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc ClearSubfile;
    dcl-pi *n ;
    end-pi;

        InfWorkStn.SflDspCtl = *off;
        InfWorkStn.SflDsp = *off;
        write SFLCTL;
        InfWorkStn.SflDspCtl = *on;
        InfWorkStn.SflDsp = *on;
        InfWorkStn.In91 = *on;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Load subfile procedure                                                   */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc LoadSubfile;
    dcl-pi *n;
        $ENTNB                                      like(FourBytes)         const;
        $ENTLG                                      like(FourBytes)         const;
        StartingPosition                            like(FourBytes)         const;
    end-pi;

    dcl-s Position                                  like(FourBytes);

    $OPT = Blank;

    for $RRN = 1 to %min(MaxSfl:%int(($MAXPOS - $REQPOS)/$ENTLG) + 1);

        $ATTRIBUTE = x'00';
        i = $RRN;
        Position = StartingPosition + (i - 1) * $ENTLG;
        UserSpaceRtvEnt($USRSPC:
                        $USRSPCLIB:
                        Position:
                        $ENTLG:
                        ERRC0100:
                        EntryData);

        if ERRC0100.ExceptionId <> Blank;
            $ATTRIBUTE = x'A7';
            $ROW = 'Error found with exception id ' +
                ERRC0100.ExceptionId + ' and exception data ' + ERRC0100.ExceptionData;
            i = i - 1;
        else;
            select;
                when ($APINAME = API_QUSLSPL and $FMTNAME = FMT_SPLF0300);
                    $ROW = %left(SPLF0300Proc(EntryData):%size($ROW));
                    InfWorkStn.In91 = *off;
                other;
                    Error = *on;
            endsl;
            if Error = *on;
                $ATTRIBUTE = x'A7';
                $ROW = 'Unexpected API/format name: ' +
                        %trimr($APINAME:*natural) + '/' +
                        %trimr($FMTNAME:*natural);
                i = i - 1;
            endif;
        endif;

        if $ENTLG > %size($ROW) and Error = *off;
            $ROW = %left($ROW:%size($ROW)-3) + '...';
            InfWorkStn.In91 = *off;
        endif;
        Error = *off;

        $STARTPOS = Position;
        write SFLDTA;

    endfor;

    $SFLRRN = 1;
    $ENTLDNB = %char(i) + '/' + %char($ENTNB);

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Refresh and load the subfile                                             */
//                                                                          */
// If entry number is not zero, we load the subfile with the content of     */
// user space.                                                              */
// Otherwise, we load the subfile with one empty row and a second one which */
// stands that there is no entry in the user space.                         */
// Attribute with A7 value stands for protected and non displayed. It       */
// applies to $OPT and $STARTPOS fields.                                    */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc RefreshSubFile;
    dcl-pi *n ;
        StartingPosition                            like(FourBytes)         const;
    end-pi;

    ClearSubfile();

    if ($ENTNB > Zero);
        LoadSubFile($ENTNB:$ENTLG:StartingPosition);
    else;
        $ATTRIBUTE = x'A7';
        $OPT = Blank;
        $ROW = Blank;
        $STARTPOS = Zero;
        $RRN = 1;
        write SFLDTA;
        $ROW = 'The list is empty.';
        $RRN = 2;
        write SFLDTA;
        $SFLRRN = 1;
    endif;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Handle SflCtl display.                                                   */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc HandleSflCtl;
    dcl-pi *n;
        StartingPosition                            like(FourBytes)         const;
    end-pi;

    dcl-s PreviousReqPos                            like(StartingPosition);

    $MINPOS = StartingPosition;
    $MAXPOS = $MINPOS + $ENTLG * ($ENTNB - 1);
    $REQPOS = $MINPOS;
    $MINMAX = OpenBracket + 'Mini ' + %char($MINPOS) + ' Maxi ' + %char($MAXPOS) + CloseBracket;
    RefreshSubFile($REQPOS);

    dou (InfWorkStn.Exit or InfWorkStn.Cancel);

        $SCREEN = PgmDs.PgmName + '-' + 'SFLCTL';
        PreviousReqPos = $REQPOS;
        write SFLFOOTER;
        exfmt SFLCTL;

        select;
            when InfWorkStn.Exit;
                leave;
            when InfWorkStn.Cancel;
                leave;
            when InfWorkStn.Refresh;
                $REQPOS = StartingPosition;
                RefreshSubFile(StartingPosition);
            when $REQPOS <> PreviousReqPos;
                if ($REQPOS > $MAXPOS);
                    $REQPOS = $MAXPOS;
                endif;
                if ($REQPOS < $MINPOS);
                    $REQPOS = $MINPOS;
                endif;
                $REQPOS = $MINPOS + $ENTLG * %div(($REQPOS - $MINPOS):$ENTLG);
                RefreshSubFile($REQPOS);
                PreviousReqPos = $REQPOS;
            when ($ENTNB <> Zero);
                WorkStationKey = ReadSubFile();
                InfWorkStn.Exit = *off;
                InfWorkStn.Cancel = *off;
                if (WorkStationKey = F03);
                        InfWorkStn.Exit = *on;
                endif;
        endsl;

    enddo;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Read the subfile for any selection.                                      */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc ReadSubfile;
    dcl-pi *n                                       like(WorkStationKey);
    end-pi;

    readc SFLDTA;
    dow (not %eof());
        $SFLRRN = $RRN;
        if ($OPT = '1');
            WorkStationKey = SelectFormat();
        endif;
        $OPT = Blank;
        update SFLDTA;
        if (WorkStationKey = ENTER);
            readc SFLDTA;
        else;
            leave;
        endif;
    enddo;

    return WorkStationKey;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Select and display the appropriate format according to API/format        */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc SelectFormat;
    dcl-pi *n                                       like(WorkStationKey);
    end-pi;

    $ENTPOS = $STARTPOS;
    $ENTRY = %char($RRN) + '/' + %char($ENTNB);
    $ENTRY = %char($RRN + %int(%div(($REQPOS - $MINPOS):$ENTLG))) + '/' + %char($ENTNB);

    select;
        when ($APINAME = API_QUSLSPL and $FMTNAME = FMT_SPLF0300);
            InfWorkStn.In90 = PrepareDETAIL01($ENTLG:$STARTPOS);
            $SCREEN = PgmDs.PgmName + '-' + 'DETAIL01';
            exfmt DETAIL01;
    endsl;

    select;
        when InfWorkStn.Exit;
            WorkStationKey = F03;
        when InfWorkStn.Cancel;
            WorkStationKey = F12;
        other;
            WorkStationKey = ENTER;
    endsl;

    return WorkStationKey;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Convert binary fields from entry data to text fields to allow displaying */
// QUSLSPL, SPLF0300                                                        */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc SPLF0300Proc;
    dcl-pi *n                                       like(SPLF0300NoBin);
        InEntryData                                 like(EntryData);
    end-pi;

    dcl-s Char10 char(10);

    SPLF0300 = InEntryData;
    SPLF0300NoBin.JobName = SPLF0300.JobName;
    SPLF0300NoBin.JobUser = SPLF0300.JobUser;
    SPLF0300NoBin.JobNbr = SPLF0300.JobNbr;
    SPLF0300NoBin.SpoolFile = SPLF0300.SpoolFile;
    Char10 = %char(%editc(SPLF0300.SpoolNbr:'X'));
    SPLF0300NoBin.SpoolNbrNoBin= %right(Char10:%size(SPLF0300NoBin.SpoolNbrNoBin));
    Char10 = %char(%editc(SPLF0300.SpoolStatus:'X'));
    SPLF0300NoBin.SpoolStatusNoBin= %right(Char10:%size(SPLF0300NoBin.SpoolStatusNoBin));
    SPLF0300NoBin.SpoolDateOpen = SPLF0300.SpoolDateOpen;
    SPLF0300NoBin.SpoolTimeOpen = SPLF0300.SpoolTimeOpen;
    SPLF0300NoBin.SpoolSchedule = SPLF0300.SpoolSchedule;
    SPLF0300NoBin.SpoolSystemName = SPLF0300.SpoolSystemName;
    SPLF0300NoBin.SpoolUsrData = SPLF0300.SpoolUsrData;
    SPLF0300NoBin.SpoolFormType = SPLF0300.SpoolFormType;
    SPLF0300NoBin.SpoolOutQueue = SPLF0300.SpoolOutQueue;
    SPLF0300NoBin.SpoolOutQueueLibrary = SPLF0300.SpoolOutQueueLibrary;
    Char10 = %char(%editc(SPLF0300.SpoolASP:'X'));
    SPLF0300NoBin.SpoolASPNoBin= %right(Char10:%size(SPLF0300NoBin.SpoolASPNoBin));
    Char10 = %char(%editc(SPLF0300.SpoolSize:'X'));
    SPLF0300NoBin.SpoolSizeNoBin= %right(Char10:%size(SPLF0300NoBin.SpoolSizeNoBin));
    Char10 = %char(%editc(SPLF0300.SpoolSizeMultiplier:'X'));
    SPLF0300NoBin.SpoolSizeMultiplierNoBin= %right(Char10:%size(SPLF0300NoBin.SpoolSizeMultiplierNoBin));
    Char10 = %char(%editc(SPLF0300.SpoolPages:'X'));
    SPLF0300NoBin.SpoolPagesNoBin= %right(Char10:%size(SPLF0300NoBin.SpoolPagesNoBin));
    Char10 = %char(%editc(SPLF0300.SpoolCopiesLeft:'X'));
    SPLF0300NoBin.SpoolCopiesLeftNoBin= %right(Char10:%size(SPLF0300NoBin.SpoolCopiesLeftNoBin));
    SPLF0300NoBin.SpoolPriority = SPLF0300.SpoolPriority;
    SPLF0300NoBin.SpoolReserved = SPLF0300.SpoolReserved;
    Char10 = %char(%editc(SPLF0300.SpoolIPPJobId:'X'));
    SPLF0300NoBin.SpoolIPPJobIdNoBin= %right(Char10:%size(SPLF0300NoBin.SpoolIPPJobIdNoBin));

    return SPLF0300NoBin;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Prepare the content of DETAIL01 format                                   */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc PrepareDETAIL01;
    dcl-pi *n                                       like(InfWorkStn.In90);
        InEntryLength                               like(FourBytes)         const;
        InStartingPosition                          like(FourBytes)         const;
    end-pi;

    UserSpaceRtvEnt($USRSPC:
                    $USRSPCLIB:
                    InStartingPosition:
                    InEntryLength:
                    ERRC0100:
                    EntryData);
    if ERRC0100.ExceptionId <> Blank;
        return *on;
    endif;

    SPLF0300 = EntryData;
    $QUSLPB = SPLF0300.JobName;
	$QUSLPC = SPLF0300.JobUser;
	$QUSLPD = SPLF0300.JobNbr;
	$QUSLPF = SPLF0300.SpoolFile;
	$QUSLPG = SPLF0300.SpoolNbr;
	$QUSLPH = SPLF0300.SpoolStatus;
	$QUSLPJ = SPLF0300.SpoolDateOpen;
	$QUSLPK = SPLF0300.SpoolTimeOpen;
	$QUSLPL = SPLF0300.SpoolSchedule;
	$QUSLPM = SPLF0300.SpoolSystemName;
	$QUSLPN = SPLF0300.SpoolUsrData;
	$QUSLPP = SPLF0300.SpoolFormType;
	$QUSLPQ = SPLF0300.SpoolOutQueue;
	$QUSLPR = SPLF0300.SpoolOutQueueLibrary;
	$QUSLPS = SPLF0300.SpoolASP;
	$QUSLPT = SPLF0300.SpoolSize;
	$QUSLPV = SPLF0300.SpoolSizeMultiplier;
	$QUSLPW = SPLF0300.SpoolPages;
	$QUSLPX = SPLF0300.SpoolCopiesLeft;
	$QUSLPY = SPLF0300.SpoolPriority;
	$QUSLPZ = SPLF0300.SpoolReserved;
	$QUSLP0 = SPLF0300.SpoolIPPJobId;

    return *off;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// This is the end of program procedure                                     */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc ReturnProc;
    dcl-pi *n;
    end-pi;

    close usrspcdsp;
    *inlr = *on;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// Ask if the user wants to run DSPF command against the user space in case */
// API and format are not expected                                          */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc InvokeDSPF;
    dcl-pi *n;
    end-pi;

    Dcl-Pr QCMDEXC EXTPGM('QCMDEXC');
        commandString                               CHAR(32702) CONST OPTIONS(*VARSIZE);
        commandLength                               PACKED(15:5) CONST;
    End-Pr;

    dcl-s Command char(100);

    $SCREEN = PgmDs.PgmName + '-' + 'DSPF';
    exfmt DSPF;

    if (not InfWorkStn.Exit and not InfWorkStn.Cancel);
        Command = 'DSPF STMF(' + Quote;
        Command = %trimr(Command) + '/QSYS.LIB/';
        Command = %trimr(Command) + %trimr($USRSPCLIB);
        Command = %trimr(Command) + '.LIB/';
        Command = %trimr(Command) + %trimr($USRSPC);
        Command = %trimr(Command) + '.USRSPC';
        Command = %trimr(Command) + Quote;
        Command = %trimr(Command) + ')';
        QCMDEXC(Command:%len(Command));
    endif;

end-proc;
