
/*--------------------------------------------------------------------------*/
/*                                                                          */ 
/* USRSPCDSP: display the content of a user space in a formatted way        */
/*                                                                          */
/* Dates: 2025/08/07 Creation                                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

CMD PROMPT('Display a user space') VLDCKR(USRSPCDSP0)

PARM KWD(USRSPC) TYPE(USRSPC) MIN(1) PROMPT('User space')
USRSPC: QUAL TYPE(*NAME) LEN(10)
        QUAL TYPE(*NAME) LEN(10) DFT(*CURLIB) SPCVAL((*CURLIB *CURLIB) (*LIBL)) PROMPT('Library')
