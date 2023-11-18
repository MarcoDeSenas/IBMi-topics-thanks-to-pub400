--
-- The goal of this script is to clean sample database objects.
--
-- Dates: 2023/11/18 Creation
--
-- Warning: statements do not include schema name, so you must be sure that
-- CURRENT SCHEMA is properly set before running this script.
--

drop table if exists DEPARTMENT;
drop alias if exists DEPT;
drop table if exists EMPLOYEE;
drop alias if exists EMP;
drop table if exists EMP_PHOTO;
drop table if exists EMP_RESUME;
drop table if exists EMPPROJACT;
drop alias if exists EMPACT;
drop alias if exists EMP_ACT;
drop table if exists PROJECT;
drop alias if exists PROJ;
drop table if exists PROJACT;
drop table if exists ACT;
drop table if exists CL_SCHED;
drop table if exists IN_TRAY;
drop table if exists ORG;
drop table if exists STAFF;
drop table if exists SALES;

commit;