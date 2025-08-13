**free
//--------------------------------------------------------------------------*/
//                                                                          */
// This is the include file for QUSLSPL API with SPLF0300 format            */
// There are two data structures:                                           */
//    The first one describes the pure data coming from the format          */
//    The second one includes character variables in place of binary        */
//        of binary variables. The program which uses those data structures */
//        is responsible to populate the variables according to their types */
// Basically, the program will use the first data structure to receive raw  */
// data from the format. And can use the second one for display purposes    */
// instance.                                                                */
//                                                                          */
// Dates: 2025/08/07 Creation                                               */
//                                                                          */
//--------------------------------------------------------------------------*/

/DEFINE SPLF0300Imported

dcl-c API_QUSLSPL 'QUSLSPL';
dcl-c FMT_SPLF0300 'SPLF0300';

dcl-ds SPLF0300 qualified inz;
    JobName                                         like(JobName);
    JobUser                                         like(JobUser);
    JobNbr                                          like(JobNbr);
    SpoolFile                                       like(SpoolFile);
    SpoolNbr                                        like(FourBytes);
    SpoolStatus                                     like(FourBytes);
    SpoolDateOpen                                   like(Date7);
    SpoolTimeOpen                                   like(Time6);
    SpoolSchedule                                   char(1);
    SpoolSystemName                                 char(10);
    SpoolUsrData                                    char(10);
    SpoolFormType                                   char(10);
    SpoolOutQueue                                   like(OutQueue);
    SpoolOutQueueLibrary                            like(OutQueueLibrary);
    SpoolASP                                        like(ASPNumber);
    SpoolSize                                       like(FourBytes);
    SpoolSizeMultiplier                             like(FourBytes);
    SpoolPages                                      like(FourBytes);
    SpoolCopiesLeft                                 like(FourBytes);
    SpoolPriority                                   char(1);
    SpoolReserved                                   char(3);
    SpoolIPPJobId                                   like(FourBytes);
end-ds;

dcl-ds SPLF0300NoBin qualified inz;
    JobName                                         like(JobName);
    JobUser                                         like(JobUser);
    JobNbr                                          like(JobNbr);
    SpoolFile                                       like(SpoolFile);
    SpoolNbrNoBin                                   char(6);
    SpoolStatusNoBin                                char(2);
    SpoolDateOpen                                   like(Date7);
    SpoolTimeOpen                                   like(Time6);
    SpoolSchedule                                   char(1);
    SpoolSystemName                                 char(10);
    SpoolUsrData                                    char(10);
    SpoolFormType                                   char(10);
    SpoolOutQueue                                   like(OutQueue);
    SpoolOutQueueLibrary                            like(OutQueueLibrary);
    SpoolASPNoBin                                   char(4);
    SpoolSizeNoBin                                  char(10);
    SpoolSizeMultiplierNoBin                        char(10);
    SpoolPagesNoBin                                 char(10);
    SpoolCopiesLeftNoBin                            char(4);
    SpoolPriority                                   char(1);
    SpoolReserved                                   char(3);
    SpoolIPPJobIdNoBin                              char(10);
end-ds;