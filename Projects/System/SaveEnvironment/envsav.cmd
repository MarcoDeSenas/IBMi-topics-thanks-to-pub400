
/*--------------------------------------------------------------------------*/
/*                                                                          */ 
/* ENVSAV : backup to save files then into a zip file of user environment   */
/*                                                                          */
/* Dates: 2023/07/26 Creation                                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

CMD PROMPT('Backup environment') VLDCKR(ENVSAV0)

PARM KWD(SAVELIBB) TYPE(*CHAR) LEN(4) DFT(*NO) VALUES(*YES *NO) RSTD(*YES) + 
    MAX(1) PROMPT('Backup library B') 
PARM KWD(SAVELIB1) TYPE(*CHAR) LEN(4) DFT(*YES) VALUES(*YES *NO) RSTD(*YES) + 
    MAX(1) PROMPT('Backup library 1') 
PARM KWD(SAVELIB2) TYPE(*CHAR) LEN(4) DFT(*YES) VALUES(*YES *NO) RSTD(*YES) + 
    MAX(1) PROMPT('Backup library 2') 
PARM KWD(SAVEHOME) TYPE(*CHAR) LEN(4) DFT(*YES) VALUES(*YES *NO) RSTD(*YES) + 
    MAX(1) PROMPT('Backup home directory') 
PARM KWD(INCLJOBLOG) TYPE(*CHAR) LEN(4) DFT(*YES) VALUES(*YES *NO) RSTD(*YES) + 
    MAX(1) PROMPT('Include job log into backup') 
PARM KWD(CLEANTMP) TYPE(*CHAR) LEN(4) DFT(*YES) VALUES(*YES *NO) RSTD(*YES) + 
    MAX(1) PROMPT('Clean all temporary objects')
PARM KWD(EXCLUDETMP) TYPE(*CHAR) LEN(4) DFT(*YES) VALUES(*YES *NO) RSTD(*YES) + 
    MAX(1) PROMPT('Exclude HOME/tmp subdirectory') PMTCTL(SAVEHOME)


SAVEHOME: PMTCTL CTL(SAVEHOME) COND((*EQ *YES))
