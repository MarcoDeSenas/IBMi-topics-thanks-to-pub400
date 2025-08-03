
/*--------------------------------------------------------------------------*/
/*                                                                          */ 
/* USRSPCRTVI: retrieve information from a user space                       */
/*                                                                          */
/* Dates: 2025/07/31 Creation                                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

CMD PROMPT('Get user space information') ALLOW(*BPGM *IPGM *BMOD *IMOD *BREXX *IREXX) VLDCKR(USRSPCRTI0)

PARM KWD(USRSPC) TYPE(USRSPC) MIN(1) PROMPT('User space')
USRSPC: QUAL TYPE(*NAME) LEN(10)
        QUAL TYPE(*NAME) LEN(10) DFT(*CURLIB) SPCVAL((*CURLIB) (*LIBL)) PROMPT('Library')
PARM KWD(ERRC0100) TYPE(*CHAR) LEN(3024) MIN(1) RTNVAL(*YES) PROMPT('Standard API error structure')
PARM KWD(APIUSED) TYPE(*CHAR) LEN(10) MIN(1) RTNVAL(*YES) PROMPT('API used')
PARM KWD(FORMATNAME) TYPE(*CHAR) LEN(8) MIN(1) RTNVAL(*YES) PROMPT('API format name used')
PARM KWD(STARTPOS) TYPE(*UINT4) MIN(1) RTNVAL(*YES) PROMPT('Starting position of the list')
PARM KWD(ENTRYNB) TYPE(*UINT4) MIN(1) RTNVAL(*YES) PROMPT('Number of entries in the list')
PARM KWD(ENTRYLG) TYPE(*UINT4) MIN(1) RTNVAL(*YES) PROMPT('Length of an entry')