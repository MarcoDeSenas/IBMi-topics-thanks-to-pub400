# Exit points

## QIBM_QZDA_INIT exit point

I got the suggestion to create a program which limits database connections after a couple of abuses on PUB400. For instance a user initiated dozens of xDBC connections, leading the system to show several Ineligible QZDASOINIT jobs in QUSRWRK subsystem, which I do not remember seeing this behavior in my past experience!

Check out the online IBM documentation at this [Use server exit program](https://www.ibm.com/docs/en/i/7.5.0?topic=administration-use-server-exit-programs) page.

Disclaimer: we have no authority to play with exit points on PUB400, therefore, this program was never tested as an exit program. The name of this program is [DBSSNLMT](dbssnlmt.pgm.sqlrpgle). This is an SQL RPG ILE program. Note that it makes use of a *NEW activation group so that all the SQL resources that it creates are properly closed when it completes and do not disturb the calling programs.

### DBSSNLMT behavior

As the program is to be set as an exit program of QIBM_QZDA_INIT exit point, it must have two parameters:

1. A 1 character variable as ouput parameter to contain:
    - '0' to tell the exit point to reject the request
    - '1' to tell the exit point to accept the request
2. A 285 characters variable as input paramater which is filled according to ZDAI0100 format.

The first operation of the program is to gather its configuration from environment variables if they exist at job level. Indeed, the way to provide some configuration to this program is to create/update up to four environment variables at the system level. Do not forget that system level environment variables are duplicated to the job level at initiation time of each job. The program expects up to four environment variables, and gather this information through [qsys2.environment_variable_info SQL view](https://www.ibm.com/docs/en/i/7.5.0?topic=services-environment-variable-info-view).

- DATABASE_LIMIT_CONCURRENTSESSIONS is the number of allowed concurrent connections. If it does not exist or contain an invalid value, the default is 5 and set in the program. Valid values are numeric integer values.
- DATABASE_LIMIT_SERVICENAMES is the list of database service names. If it does not exist, the default is as-database,as-database-s,drda,ddm,ddm-ssl and set in the program. Valid values are a comma separated values list without spaces. There is no control in the program about the validity of any service, which means that the program does not control that a service exists in system service table. If the environment variable contains values which are not a real service, it means that all connections will be accepted.
- DATABASE_LIMIT_ALLWAYSACCEPTQ defines whether or not we accept sessions from a Q* user profile regardless any count of existing sessions. If it does not exist or contains an invalid value, the default is Y which means that we accept the connections regardless the count of active connections (this is to avoid potential issues for connections on Localhost for user profiles such as QWEBADMIN used by IBM Navigator for i), and is set in the program.  Valid values are Y for Yes and N for No.
- DATABASE_LIMIT_INCLUDELOCALHOST defines whether or not, we include local sessions from and to localhost in the count of sessions. If it does not exist or contains an invalid value, the default is N (which means that we do not check for localhost sessions) and is set in the program. Valid values are Y for Yes and N for No.

The following operation is to check if the situation is the case of a Q* user profile trying to connect and if DATABASE_LIMIT_ALLWAYSACCEPTQ configuration item is Y for Yes. If this is the case, we send a CPI3701 information message to the joblog and set the program output parameter to '1' as required by the exit point, and the program completes.

The last operation is to count the number of active sessions for the current user profile. We use the [qsys2.netstat_job_info SQL view](https://www.ibm.com/docs/en/i/7.5.0?topic=services-netstat-job-info-view) for that.
If the count is lower that the DATABASE_LIMIT_CONCURRENTSESSIONS envirnment variable value, we send a CPI3701 information message to the joblog and set the program output parameter to '1' as required by the exit point, and the program completes.
If the count is equal or higher, we send another CPI3701 information message to the joblog, and a CPD436F information message to QSYSOPR message queue and system log and set the program output to '0' as required by the exit point, and the program completes.

When the exit point receives a flag set to '0', it rejects the connection request. When the exit point receives a flag set to '1', it accepts the connection request.
The goal of sending this CPD436F message to the system log is to provide some basic analysis capability of rejected requests if needed.

### DBSSNLMT program installation

One requirement I had when writing this program was that it should need as less as possible any other object and provide default setting by itself. For instance, as opposite to other tools provided in this repository, it does not use any common file import.

Therefore, to install this programe, it is required to:

1. Upload the source in a IFS stream file of your choice named dbssnlmt.srvpgm.sqlrpgle (with a CCSID set to 1252).
2. Compile the program in the library of your choice using the command below:
    CRTSQLRPGI OBJ(yourlib/DBSSNTLMT) SRCSTMF('/yourdirectory/dbssnlmt.srvpgm.sqlrpgle')
3. Add it to the exit point with the command below:
    ADDEXITPGM EXITPNT(QIBM_QZDA_INIT) FORMAT(ZDAI0100) PGMNBR(*LOW) PGM(yourlib/DBSSNLMT) TEXT('Limit DB connections per user')
4. If default settings do not comply with your needs, add the required environment variable with the required value at the system level with a command as below:
    ADDENVVAR ENVVAR(DATABASE_LIMIT_CONCURRENTSESSIONS) VALUE(3) LEVEL(*SYS)
