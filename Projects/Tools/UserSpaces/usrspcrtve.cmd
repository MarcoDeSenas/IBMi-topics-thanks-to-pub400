
/*--------------------------------------------------------------------------*/
/*                                                                          */ 
/* USRSPCRTVE: retrieve an entry from a List API based user space           */
/*                                                                          */
/* Dates: 2025/08/03 Creation                                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

CMD PROMPT('Get one user space list entry') ALLOW(*BPGM *IPGM *BMOD *IMOD *BREXX *IREXX) VLDCKR(USRSPCRTE0)

PARM KWD(USRSPC) TYPE(USRSPC) MIN(1) PROMPT('User space')
USRSPC: QUAL TYPE(*NAME) LEN(10)
        QUAL TYPE(*NAME) LEN(10) DFT(*CURLIB) SPCVAL((*CURLIB) (*LIBL)) PROMPT('Library')
PARM KWD(STARTPOS) TYPE(*UINT4) MIN(1) PROMPT('Starting position of the entry')
PARM KWD(ENTRYLG) TYPE(*UINT4) MIN(1) PROMPT('Length of an entry')
PARM KWD(ERRC0100) TYPE(*CHAR) LEN(3024) MIN(1) RTNVAL(*YES) PROMPT('Standard API error structure')
PARM KWD(ENTRYDTA) TYPE(*CHAR) LEN(2000) MIN(1) RTNVAL(*YES) PROMPT('Entry content')
