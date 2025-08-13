
/*--------------------------------------------------------------------------*/
/*                                                                          */ 
/* SPLFDLT: delete a selection of spool files                               */
/*                                                                          */
/* Dates: 2025/08/05 Creation                                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

CMD PROMPT('Delete spool files') VLDCKR(SPLFDLT0)

PARM KWD(USER) TYPE(*NAME) LEN(10) DFT(*CURRENT) SPCVAL(*CURRENT) PROMPT('Spool file owner')
PARM KWD(ACTION) TYPE(*CHAR) LEN(8) RSTD(*YES) DFT(*BOTH) VALUES(*BOTH *DLTONLY *LOGONLY) PROMPT('Action against each spool file')
PARM KWD(FORMTYPE) TYPE(*CHAR) LEN(10) DFT(*ALL) SPCVAL(*ALL *STD) Prompt('Form type')
PARM KWD(USRDTA) TYPE(*CHAR) LEN(10) DFT(*ALL) SPCVAL(*ALL) Prompt('User specified data')
