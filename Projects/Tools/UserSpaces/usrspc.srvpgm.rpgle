**free

//--------------------------------------------------------------------------*/
//                                                                          */
// This is the service program to use when dealing with user spaces.        */
// Available functions/procedures:                                          */
//        UserSpaceCrt: to create a user space                              */
//        UserSpaceRtvInf: to retrieve information about the user space     */
//                         content                                          */
//        UserSpaceRtvEnt: to retrieve the content of one entry in case of  */
//                         a user space filled with a list API              */
//                                                                          */
// As a general rule, all functions send back the API error structure on    */
// top of the expected output when there is one. The program using the      */
// functions is therefore responsible to handle any error.                  */
//                                                                          */
// Dates: 2025/06/23 Creation                                               */
//        2025/07/31 Retrieve info procedure                                */
//        2025/08/02 Retrieve entry procedure                               */
//                                                                          */
//--------------------------------------------------------------------------*/

ctl-opt option(*srcstmt:*nodebugio);
ctl-opt nomain;

/COPY ../../Common/Includes/inc_basic_declare.rpgle
/COPY ../../Common/Includes/inc_stdapi_declare.rpgle
/COPY ../../Common/Includes/inc_usrspc_declare.rpgle

dcl-s QualUsrSpc                                    like(QualifiedObject);

//--------------------------------------------------------------------------*/
//                                                                          */
// UserSpaceCrt:  creating a user space                                     */
//                                                                          */
// Output parameters: ERRC0100 is the standard API error structure          */
// Input parameters: User space name                                        */
//                   User space library                                     */
//                   User space attribute                                   */
//                   Object description                                     */
//                                                                          */
// Important notices: The following QUSCRTUS API parameters are forced:     */
//      2000 for Initial Size                                               */
//      ' ' for Initial content                                             */
//      *LIBCRTAUT for public authority                                     */
//      *YES for automatic replacement of existing user space               */
//      *DEFAULT for object domain                                          */
//      0 for transfer size request                                         */
//      1 for optimum alignment                                             */
//      1 for automatic extendibility                                       */
//                                                                          */
//  Typical usage in RPGLE:                                                 */
//      Sources to include:                                                 */
//         inc_basic_declare.rpgle                                          */
//         inc_stdapi_declare.rpgle                                         */
//         inc_usrspc_declare.rpgle                                         */
//      Invoke the function:                                                */
//         ERRC0100 = UserSpaceCrt(UserSpace:Library:Attribute:Text);       */
//      Handle ERRC0100 content                                             */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc UserSpaceCrt export;
    dcl-pi *n                                       like(ERRC0100);
        InUsrSpc                                    like(ObjectName)        const;
        InUsrSpcLib                                 like(ObjectName)        const;
        InUsrSpcAtt                                 like(ObjectName)        const;
        InUsrSpcTxt                                 like(ObjectText)        const;
    end-pi;
    
    dcl-pr QUSCRTUS extpgm('QUSCRTUS');
        QualifiedName                               like(QualifiedObject)   const;
        ExtendedAttribute                           like(ObjectName)        const;
        InitialSize                                 int(10)                 const;
        InitialValue                                char(1)                 const;
        PublicAuthority                             like(ObjectName)        const;
        Description                                 like(ObjectText)        const;
        Replacement                                 char(10)                options(*nopass)            const;
        APIErrorCode                                likeds(ERRC0100)        options(*nopass: *varsize);
        Domain                                      char(10)                options(*nopass)            const;
        TransferSizeRequest                         int(10)                 options(*nopass)            const;
        OptimumAlignment                            char(1)                 options(*nopass)            const;
        Extendibility                               char(1)                 options(*nopass)            const;
    end-pr;

//                                                                          */
// Initialization of API parameters                                         */
//                                                                          */

    clear ERRC0100;
    ERRC0100.BytesProvided = 116;
    QualUsrSpc = InUsrSpc + InUsrSpcLib;

    QUSCRTUS(QualUsrSpc:
            InUsrSpcAtt:
            2000:
            Blank:
            '*LIBCRTAUT':
            InUsrSpcTxt:
            '*YES':
            ERRC0100:
            '*DEFAULT':
            Zero:
            *on:
            *on);

    return ERRC0100;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// UserSpaceRtvInf: retrieving user space information for list based APIs   */
//                                                                          */
// Output parameters: ERRC0100 is the standard API error structure          */
//                    API Used                                              */
//                    Format name                                           */
//                    Starting position                                     */
//                    Number of entries                                     */
//                    Length of an entry                                    */
// Input parameters: User space name                                        */
//                   User space library                                     */
//                                                                          */
// ERRC0100 is populated as soon as an error is found when calling          */
// QUSRTVUS API is called several times and ERRC0100 is populated as soon   */
//    as an error is found                                                  */ 
//                                                                          */
//  Typical usage in RPGLE:                                                 */
//      Sources to include:                                                 */
//         inc_basic_declare.rpgle                                          */
//         inc_stdapi_declare.rpgle                                         */
//         inc_usrspc_declare.rpgle                                         */
//      Invoke the function:                                                */
//         UserSpaceInf(UserSpace:Library:ERRC0100:API:                     */
//                                       Format:Start:Number:Length);       */
//      Handle ERRC0100 content                                             */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc UserSpaceRtvInf export;
    dcl-pi *n;
        InUsrSpc                                    like(ObjectName)        const;
        InUsrSpcLib                                 like(ObjectName)        const;
        OutERRC0100                                 like(ERRC0100);
        OutAPIUsed                                  like(APIListHeader.APIUsed);
        OutFormatName                               like(APIListHeader.FormatName);
        OutStartPos                                 like(FourBytes);
        OutEntriesCount                             like(FourBytes);
        OutEntryLength                              like(FourBytes);
    end-pi;
    
    dcl-pr QUSRTVUS extpgm('QUSRTVUS');
        QualifiedName                               like(QualifiedObject)   const;
        StartingPosition                            like(FourBytes)         const;
        DataLength                                  like(FourBytes)         const;
        StdHeaderData                               char(192);
        APIErrorCode                                likeds(ERRC0100)        options(*nopass: *varsize);
    end-pr;

//                                                                          */
// Initialization of procedure parameters                                   */
//                                                                          */

    clear OutERRC0100;
    clear OutAPIUsed;
    clear OutFormatName;
    OutStartPos = Zero;
    OutEntriesCount = Zero;
    OutEntryLength  = Zero;

//                                                                          */
// Initialization of API parameters                                         */
//                                                                          */

    clear ERRC0100;
    ERRC0100.BytesProvided = 116;
    QualUsrSpc = InUsrSpc + InUsrSpcLib;

//                                                                          */
// Retrieve list API standard header                                        */
//                                                                          */

    StartingPosition = 1;
    DataLength = %size(StdHeaderData);
    clear StdHeaderData;

    QUSRTVUS(QualUsrSpc:
            StartingPosition:
            DataLength:
            StdHeaderData:
            ERRC0100);
    if ERRC0100.ExceptionId <> Blank;
        OutERRC0100 = ERRC0100;
        return;
    endif;

//                                                                          */
// Handle API used                                                          */
// (the code below does not check all the possible errors; will be fixed    */
// with the next release; right now we consider that if the API is not      */
// blank, then this is a correct value)                                     */
//                                                                          */

    if %subst(StdHeaderData:81:10:*natural) = Blank;
        ERRC0100.ExceptionId = 'USP0201';
        ERRC0100.ExceptionData = %subst(StdHeaderData:81:10:*natural) + QualUsrSpc;
        OutERRC0100 = ERRC0100;
        return;
    endif;

//                                                                          */
// Handle format name                                                       */
// (the code below does not check all the possible errors; will be fixed    */
// with the next release; right now we consider that if the format is not   */
// blank, then this is a correct value)                                     */
//                                                                          */

    if %subst(StdHeaderData:73:8:*natural) = Blank;
        ERRC0100.ExceptionId = 'USP0202';
        ERRC0100.ExceptionData = %subst(StdHeaderData:73:8:*natural) + QualUsrSpc;
        OutERRC0100 = ERRC0100;
        return;
    endif;

//                                                                          */
// Populate parameters back, monitor any unexpected error when updating     */
// variables                                                                */
//                                                                          */

    monitor;
        APIListHeader = StdHeaderData;
        OutAPIUsed = APIListHeader.APIUsed;
        OutFormatName = APIListHeader.FormatName;
        OutStartPos = APIListHeader.OffsetListData + 1;
        OutEntriesCount = APIListHeader.NumberListEntries;
        OutEntryLength = APIListHeader.SizeEachEntry;
        on-error;
            ERRC0100.ExceptionId = 'USP0203';
            ERRC0100.ExceptionData = QualUsrSpc;
    endmon;

    return;

end-proc;

//--------------------------------------------------------------------------*/
//                                                                          */
// UserSpaceRtvEnt: retrieving one list based API user space entry          */
//                                                                          */
// Output parameters: ERRC0100 is the standard API error structure          */
//                    Entry data                                            */
// Input parameters: User space name                                        */
//                   User space library                                     */
//                   Starting position                                     */
//                   Length of an entry                                    */
// ERRC0100 is populated as soon as an error is found when calling          */
//                                                                          */
//  Typical usage in RPGLE:                                                 */
//      Sources to include:                                                 */
//         inc_basic_declare.rpgle                                          */
//         inc_stdapi_declare.rpgle                                         */
//         inc_usrspc_declare.rpgle                                         */
//      Invoke the function:                                                */
//         UserSpaceEnt(UserSpace:Library:Start:Length:ERRC0100:EntryData)  */
//      Handle ERRC0100 content                                             */
//                                                                          */
//--------------------------------------------------------------------------*/

dcl-proc UserSpaceRtvEnt export;
    dcl-pi *n;
        InUsrSpc                                    like(ObjectName)        const;
        InUsrSpcLib                                 like(ObjectName)        const;
        InStartingPosition                          like(FourBytes)         const;
        InEntryLength                               like(FourBytes)         const;
        OutERRC0100                                 like(ERRC0100);
        OutEntryData                                like(EntryData);
    end-pi;
    
    dcl-pr QUSRTVUS extpgm('QUSRTVUS');
        QualifiedName                               like(QualifiedObject)   const;
        StartingPosition                            like(FourBytes)         const;
        DataLength                                  like(FourBytes)         const;
        EntryData                                   like(EntryData);
        APIErrorCode                                likeds(ERRC0100)        options(*nopass: *varsize);
    end-pr;

//                                                                          */
// Initialization of procedure parameters                                   */
//                                                                          */

    clear OutERRC0100;
    clear OutEntryData;

//                                                                          */
// Initialization of API parameters                                         */
//                                                                          */

    clear ERRC0100;
    ERRC0100.BytesProvided = 116;
    QualUsrSpc = InUsrSpc + InUsrSpcLib;

//                                                                          */
// Retrieve entry data                                                      */
//                                                                          */

    StartingPosition = InStartingPosition;
    DataLength = InEntryLength;
    clear EntryData;

    QUSRTVUS(QualUsrSpc:
            StartingPosition:
            DataLength:
            EntryData:
            ERRC0100);
    if ERRC0100.ExceptionId <> Blank;
        OutERRC0100 = ERRC0100;
        return;
    endif;

//                                                                          */
// Populate parameters back                                                 */
//                                                                          */

    OutEntryData = EntryData;

    return;

end-proc;