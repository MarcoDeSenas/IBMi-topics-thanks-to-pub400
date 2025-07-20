
/*--------------------------------------------------------------------------*/
/*                                                                          */ 
/* USRSPCCRT: create or replace a user space                                */
/*                                                                          */
/* Dates: 2025/06/28 Creation                                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

CMD PROMPT('Create/replace a user space') VLDCKR(USRSPCCRT0)

PARM KWD(USRSPC) TYPE(USRSPC) MIN(1) PROMPT('User space')
USRSPC: QUAL TYPE(*NAME) LEN(10)
        QUAL TYPE(*NAME) LEN(10) DFT(*CURLIB) SPCVAL(*CURLIB) PROMPT('Library')
PARM KWD(ATTRIBUTE) TYPE(*NAME) LEN(10) MIN(1) PROMPT('Attribute')
PARM KWD(TEXT) TYPE(*CHAR) LEN(50) PROMPT('Text Description')
