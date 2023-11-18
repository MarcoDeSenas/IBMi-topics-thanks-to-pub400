--
-- The goal of this script is to create sample database objects.
--
-- Dates: 2023/11/18 Creation
--
-- Warning: statements do not include schema name, so you must be sure that
-- CURRENT SCHEMA is properly set before running this script.
-- On top of this, the library (i.e. schema) you will create objects in
-- must be set like an SQL would be. It means that the library must be journaled.
--

CREATE TABLE DEPARTMENT
      (DEPTNO    CHAR(3)           NOT NULL,
       DEPTNAME  VARCHAR(36)       NOT NULL,
       MGRNO     CHAR(6)                   ,
       ADMRDEPT  CHAR(3)           NOT NULL, 
       LOCATION      CHAR(16),
       PRIMARY KEY (DEPTNO))
;
CREATE UNIQUE INDEX XDEPT1
       ON DEPARTMENT (DEPTNO)
;
CREATE INDEX XDEPT2
       ON DEPARTMENT (MGRNO)
;
CREATE INDEX XDEPT3
       ON DEPARTMENT (ADMRDEPT)
;       
CREATE ALIAS DEPT FOR DEPARTMENT
;
CREATE TABLE EMPLOYEE
      (EMPNO       CHAR(6)         NOT NULL,
       FIRSTNME    VARCHAR(12)     NOT NULL,
       MIDINIT     CHAR(1)         NOT NULL,
       LASTNAME    VARCHAR(15)     NOT NULL,
       WORKDEPT    CHAR(3)                 ,
       PHONENO     CHAR(4)                 ,
       HIREDATE    DATE                    ,
       JOB         CHAR(8)                 ,
       EDLEVEL     SMALLINT        NOT NULL,
       SEX         CHAR(1)                 ,
       BIRTHDATE   DATE                    ,
       SALARY      DECIMAL(9,2)            ,
       BONUS       DECIMAL(9,2)            ,
       COMM        DECIMAL(9,2)            ,        
       PRIMARY KEY (EMPNO))
;
ALTER TABLE EMPLOYEE 
      ADD CONSTRAINT NUMBER 
      CHECK (PHONENO >= '0000' AND PHONENO <= '9999')
;
CREATE UNIQUE INDEX XEMP1 
       ON EMPLOYEE (EMPNO)
;
CREATE INDEX XEMP2 
       ON EMPLOYEE (WORKDEPT)
;
CREATE ALIAS EMP FOR EMPLOYEE
;
CREATE TABLE EMP_PHOTO  
             (EMPNO CHAR(6) NOT NULL, 
              PHOTO_FORMAT VARCHAR(10) NOT NULL, 
              PICTURE BLOB(100K), 
              EMP_ROWID CHAR(40) NOT NULL DEFAULT '', 
              PRIMARY KEY (EMPNO,PHOTO_FORMAT))
;
ALTER TABLE EMP_PHOTO
            ADD COLUMN DL_PICTURE DATALINK(1000)
                LINKTYPE URL NO LINK CONTROL
;
CREATE UNIQUE INDEX XEMP_PHOTO 
              ON EMP_PHOTO (EMPNO,PHOTO_FORMAT)
;
CREATE TABLE EMP_RESUME  
             (EMPNO CHAR(6) NOT NULL, 
              RESUME_FORMAT VARCHAR(10) NOT NULL, 
              RESUME CLOB(5K), 
              EMP_ROWID CHAR(40) NOT NULL DEFAULT '', 
              PRIMARY KEY (EMPNO,RESUME_FORMAT))
;
ALTER TABLE EMP_RESUME
            ADD COLUMN DL_RESUME DATALINK(1000)
                LINKTYPE URL NO LINK CONTROL
;
CREATE UNIQUE INDEX XEMP_RESUME 
              ON EMP_RESUME (EMPNO,RESUME_FORMAT)
;
CREATE TABLE EMPPROJACT
      (EMPNO     CHAR(6)          NOT NULL,
       PROJNO    CHAR(6)          NOT NULL,
       ACTNO     SMALLINT         NOT NULL,
       EMPTIME   DECIMAL(5,2)             ,
       EMSTDATE  DATE                     ,
       EMENDATE  DATE                     )
;
CREATE ALIAS EMPACT FOR EMPPROJACT
;
CREATE ALIAS EMP_ACT FOR EMPPROJACT
;
CREATE TABLE PROJECT
      (PROJNO    CHAR(6)        NOT NULL,
       PROJNAME  VARCHAR(24)    NOT NULL DEFAULT,
       DEPTNO    CHAR(3)        NOT NULL,
       RESPEMP   CHAR(6)        NOT NULL,
       PRSTAFF   DECIMAL(5,2)           ,
       PRSTDATE  DATE                   ,
       PRENDATE  DATE                   ,
       MAJPROJ   CHAR(6)                ,
       PRIMARY KEY (PROJNO))
;
CREATE UNIQUE INDEX XPROJ1 
              ON PROJECT (PROJNO)
;
CREATE INDEX XPROJ2 
              ON PROJECT (RESPEMP)
;
CREATE ALIAS PROJ FOR PROJECT
;
CREATE TABLE PROJACT 
             (PROJNO CHAR(6) NOT NULL, 
              ACTNO SMALLINT NOT NULL, 
              ACSTAFF DECIMAL(5,2), 
              ACSTDATE DATE NOT NULL, 
              ACENDATE DATE , 
              PRIMARY KEY (PROJNO, ACTNO, ACSTDATE))
;
CREATE UNIQUE INDEX XPROJAC1 
              ON PROJACT (PROJNO, ACTNO, ACSTDATE)
;
CREATE TABLE ACT 
             (ACTNO SMALLINT NOT NULL, 
              ACTKWD CHAR(6) NOT NULL, 
              ACTDESC VARCHAR(20) NOT NULL, 
              PRIMARY KEY (ACTNO))
;
CREATE UNIQUE INDEX XACT1 
              ON ACT (ACTNO)
;
CREATE UNIQUE INDEX XACT2 
              ON ACT (ACTKWD)
;
CREATE TABLE CL_SCHED
      (CLASS_CODE          CHAR(7),
       "DAY"               SMALLINT,
       STARTING            TIME,
       ENDING              TIME)
; 
CREATE TABLE IN_TRAY
    (RECEIVED            TIMESTAMP,
     SOURCE              CHAR(8),
     SUBJECT             CHAR(64),
     NOTE_TEXT           VARCHAR(3000))
;  
CREATE TABLE ORG 
             (DEPTNUMB SMALLINT NOT NULL, 
              DEPTNAME VARCHAR(14),
              MANAGER SMALLINT, 
              DIVISION VARCHAR(10), 
              LOCATION VARCHAR(13))
;
CREATE TABLE STAFF 
             (ID  SMALLINT NOT NULL, 
              NAME VARCHAR(9), 
              DEPT SMALLINT, 
              JOB CHAR(5), 
              YEARS SMALLINT, 
              SALARY DECIMAL(7,2), 
              COMM DECIMAL(7,2))
; 
CREATE TABLE SALES 
             (SALES_DATE DATE, 
              SALES_PERSON VARCHAR(15), 
              REGION VARCHAR(15), 
              SALES INTEGER)
;

commit;
