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

//--------------------------------------------------------------------------*/
//                                                                          */
// Initialization of API parameters                                         */
//                                                                          */
//--------------------------------------------------------------------------*/

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
