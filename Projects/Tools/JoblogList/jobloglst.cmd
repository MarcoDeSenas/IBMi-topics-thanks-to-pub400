
/*--------------------------------------------------------------------------*/
/*                                                                          */ 
/* JOBLOGLST : display joblog of events when running this command           */
/*                                                                          */
/* Dates: 2023/07/24 Creation                                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

CMD PROMPT('Display joblog of events') VLDCKR(JOBLOGLST0)

PARM KWD(GROUP) TYPE(*CHAR) LEN(10) SPCVAL(*ALL) MIN(1) MAX(1) + 
    PROMPT('Group of commands') 
PARM KWD(REPORTCMD) TYPE(*CHAR) LEN(4) DFT(*YES) VALUES(*YES *NO) RSTD(*YES) + 
    MAX(1) PROMPT('Report commands') 
PARM KWD(OUTPUT) TYPE(*CHAR) LEN(6) DFT(*) VALUES(* *PRINT) RSTD(*YES) MAX(1) + 
    PROMPT('Output') 