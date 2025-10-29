**free

//--------------------------------------------------------------------------*/
//                                                                          */
// This is the service program to use when dealing with job call stack.     */
// Available functions/procedures:                                          */
//        ProgramPositionRtv: to retrieve the position of a given           */
//                              program in the current thread of current    */
//                              job call stack                              */
//                            the position sent back to the calling program */
//                              is relative to the program calling this     */
//                              procedure                                   */
//                            -1 value is sent back if the program does not */
//                              exist in the call stack                     */
//                            0 value is sent back if we want to check that */
//                              the current program does exist in the call  */
//                              call stack (weird request, indeed!)         */
//                                                                          */
// Inspired by                                                              */
// https://www.mcpressonline.com/programming/apis/the-api-corner-retrieving-information-part-i
// Dates: 2025/10/13 Creation                                               */
//                                                                          */
// Taking care of any API error is the responsibility of calling program,   */
// with the analysis of ERRC0100 error structure.                           */
//                                                                          */
//--------------------------------------------------------------------------*/

ctl-opt option(*srcstmt:*nodebugio);
ctl-opt nomain;

/COPY ../../Common/Includes/inc_basic_declare.rpgle
/COPY ../../Common/Includes/inc_stdapi_declare.rpgle
/COPY ../../Common/Includes/inc_QWVRCSTK_declare.rpgle

//--------------------------------------------------------------------------*/
//                                                                          */
// ProgramPositionRtv: retrieving the position of a program in the stack    */
//                                                                          */
// Output parameters: Position of the program                               */
//                    ERRC0100 is the standard API error structure          */
// Input parameters: Program name                                           */
//                   Program library                                        */
//                                                                          */
//  Typical usage in RPGLE:                                                 */
//      Sources to include:                                                 */
//         inc_basic_declare.rpgle                                          */
//         inc_stdapi_declare.rpgle                                         */
//      Invoke the function:                                                */
//         ProgramPositionRtv(Program:Library:Position:ERRC0100);           */
//      Handle ERRC0100 content                                             */
//                                                                          */
//  Typical usage in CLLE:                                                  */
//      Sources to include:                                                 */
//         inc_basic_declare.clle                                           */
//         inc_stdapi_declare.clle                                          */
//      Invoke the function:                                                */
//         CALLPRC PRC('PROGRAMPOSITIONRTV') +                              */
//                 PARM(&PROGRAM &LIBRARY &POSITION &ERRC0100)              */
//      Handle &ERRC0100 content                                            */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc ProgramPositionRtv export;
    dcl-pi *n ;
        InProgram                                   like(ObjectName)        const;
        InProgramLib                                like(ObjectName)        const;
        OutPosition                                 like(FourBytes);
        OutERRC0100                                 like(ERRC0100);
    end-pi;

    dcl-pr GetCallStack extpgm('QWVRCSTK');
        Receiver                                    char(1)                 options(*varsize);
        ReceiverLength                              like(FourBytes)         const;
        ReceiverFormat                              char(8)                 const;
        JobId                                       char(65535)             const options(*varsize);
        JobIdFormat                                 char(8)                 const;
        OutERRC0100                                 likeds(ERRC0100)        options(*nopass: *varsize);
    end-pr;

    dcl-ds Receiver                                 likeds(QWVK0100)        based(ReceiverPtr);     
    dcl-ds EntryInfo                                likeds(QWVCSTKE)        based(EntInfPtr);     

    dcl-s QualProgram                               like(QualifiedObject);
    dcl-s Position                                  like(FourBytes);


    dcl-s ProcName                   char(256) based(ProcNamePtr);
    dcl-s CurProcName                char(256);
    dcl-s PrvPgmName                 char(10);
    dcl-s Wait                       char(1);

    QualProgram = InProgram + InProgramLib;

//                                                                          */
// Initialization of API parameters                                         */
//                                                                          */

    clear ERRC0100;
    ERRC0100.BytesProvided = 116;

//                                                                          */
// Initialization of Job identification format JIDF0100                     */
//                                                                          */

    QWc_JIDF0100 = *loval;                                                  // Set structure to x'00's
    QWc_JIDF0100.JobName = '*';                                             //   Job name: * = this job
    QWc_JIDF0100.JobUser = *blanks;                                         //   User name            
    QWc_JIDF0100.JobNbr = *blanks;                                          //   Job number           
    QWc_JIDF0100.InternalJobId = *blanks;                                   //   Internal job ID      
    QWc_JIDF0100.ThreadIndicator = 1;                                       //   Thread = this thread 

//                                                                          */
// Call API to find out how much storage is needed                          */
//                                                                          */

    GetCallStack(QWVK0100:%size(QWVK0100):'CSTK0100':QWc_JIDF0100:'JIDF0100':ERRC0100);
    exsr UnexpectedError;

//                                                                          */
// Call API again to get all of the data                                    */
//                                                                          */

    ReceiverPtr = %alloc(QWVK0100.QWVBAVL);
    GetCallStack(Receiver:QWVK0100.QWVBAVL:'CSTK0100':QWc_JIDF0100:'JIDF0100':ERRC0100);
    exsr UnexpectedError;

//                                                                          */
// We browse the content of call stack to find the requested program.       */
// We avoid taking care of the current program running the service program. */
// We have to take care of the case when there are several procedures in    */
// the same program, as the API sends back one entry for each procedure.    */
//                                                                          */

    OutPosition = -1;
    Position = Zero;

    PrvPgmName = *blanks;
    EntInfPtr = ReceiverPtr + Receiver.QWVEO;                               // Get the first entry   
    for i = 1 to Receiver.QWVERTN;
        if EntryInfo.QWVPGMN <> PrvPgmName and EntryInfo.QWVPGMN <> PgmDs.PgmName;
            PrvPgmName = EntryInfo.QWVPGMN;
            if (EntryInfo.QWVPGMN + EntryInfo.QWVPGML = QualProgram);
                Found = *on;
                leave;
            endif;
            Position += 1;
        endif;                                                         
        EntInfPtr += EntryInfo.QWVEL;                                       // Move to next entry     
    endfor;

    if (Found);
        OutPosition = Position;
    endif;

//                                                                          */
// This is the subroutine (indeed not a subprocedure) to handle errors      */
// occurring when calling QWVRCSTK API.                                     */
// There should be only rare occurrences when this happens.                 */
// As we call the API twice, errors might happen after each call and the    */
// operations to handle the error are the same.                             */
// The reason for a subroutine in place of a subprocedure is that as soon   */
// as we get here we want to leave the entire procedure.                    */
//                                                                          */

    begsr UnexpectedError;

        if (QWVK0100.QWVIS <> Blank);
            ERRC0100.ExceptionId = 'CPF9898';
            ERRC0100.ExceptionData = 'Unexpected behavior of QWVRCSTK API, call stack list sent back is not complete';
        endif;
        if (ERRC0100.ExceptionId <> Blank);
            OutERRC0100 = ERRC0100;
            return;
        endif;
      
    endsr;

end-proc;
