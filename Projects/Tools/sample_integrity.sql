--
-- The goal of this script is to establish integrity relationships on sample database tables.
--
-- Dates: 2023/11/18 Creation
--
-- Warning: statements do not include schema name, so you must be sure that
-- CURRENT SCHEMA is properly set before running this script.
--

ALTER TABLE DEPARTMENT
      ADD FOREIGN KEY ROD (ADMRDEPT)
          REFERENCES DEPARTMENT
          ON DELETE CASCADE
;          
ALTER TABLE EMPLOYEE 
      ADD FOREIGN KEY RED (WORKDEPT) 
      REFERENCES DEPARTMENT 
      ON DELETE SET NULL
;
ALTER TABLE DEPARTMENT
      ADD FOREIGN KEY RDE (MGRNO)
          REFERENCES EMPLOYEE
          ON DELETE SET NULL
;
ALTER TABLE EMP_PHOTO 
              ADD FOREIGN KEY (EMPNO) 
              REFERENCES EMPLOYEE 
              ON DELETE RESTRICT 
;
ALTER TABLE EMP_RESUME 
              ADD FOREIGN KEY (EMPNO) 
              REFERENCES EMPLOYEE 
              ON DELETE RESTRICT
;
ALTER TABLE PROJECT 
              ADD FOREIGN KEY (DEPTNO) 
              REFERENCES DEPARTMENT 
              ON DELETE RESTRICT
;
ALTER TABLE PROJECT 
              ADD FOREIGN KEY (RESPEMP) 
              REFERENCES EMPLOYEE 
              ON DELETE RESTRICT
;
ALTER TABLE PROJECT 
              ADD FOREIGN KEY  RPP (MAJPROJ) 
              REFERENCES PROJECT 
              ON DELETE CASCADE
;
ALTER TABLE PROJACT 
              ADD FOREIGN KEY RPAP (PROJNO) 
              REFERENCES PROJECT 
              ON DELETE RESTRICT
;

ALTER TABLE EMPPROJACT 
              ADD FOREIGN KEY REPAPA (PROJNO, ACTNO, EMSTDATE) 
              REFERENCES PROJACT 
              ON DELETE RESTRICT
;
ALTER TABLE PROJACT
            ADD FOREIGN KEY RPAA (ACTNO)
                REFERENCES ACT
                ON DELETE RESTRICT
;
commit
;