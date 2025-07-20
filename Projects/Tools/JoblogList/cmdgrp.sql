--
-- The goal of this script is to create CMDGRP table and related database objects.
--
-- Dates: 2023/08/21 Creation
--

--
-- Set default settings
--

set schema = ?;
drop table if exists CMDGRP;

--
-- Groups commands temporal table, and its history table
-- System period columns will be hidden on temporal table once history table will be created
--

create table CMDGRP (
    CMDGRP          char(10) not null,
    SEQNUMBER       int not null,
    CMDSTRING       varchar(1024) not null,
    AUDIT_USER      varchar(128) generated always as (SESSION_USER),
    AUDIT_JOB       varchar(28) generated always as (QSYS2.JOB_NAME),
    AUDIT_OPER      char(1) generated always as (data change operation),
    SYS_START       timestamp(12) not null generated always as row begin,
    SYS_END         timestamp(12) not null generated always as row end, 
    TS_ID           timestamp(12) not null generated always as transaction start id,
    period system_time (SYS_START, SYS_END)
    )
;
label on table CMDGRP is 'Commands groups for joblog list';
label on column CMDGRP (
    CMDGRP is       'Commands group',
    SEQNUMBER is    'Sequence number',
    CMDSTRING is    'Command string',
    AUDIT_USER is   'Audit user',
    AUDIT_JOB is    'Audit job',
    AUDIT_OPER is   'Audit operation',
    SYS_START is    'Valid from',
    SYS_END is      'Valid to',
    TS_ID IS        'Transaction id'
    )
;
alter table CMDGRP add primary key (CMDGRP, SEQNUMBER)
;
create unique index CMDGRP_IX1 on CMDGRP (CMDGRP, SEQNUMBER)
;

create table CMDGRP_HST like CMDGRP
;
label on table CMDGRP_HST is 'Commands groups for joblog list (History)'
;

alter table CMDGRP add versioning use history table CMDGRP_HST on delete add extra row
;
alter table CMDGRP
    alter column    SYS_START set implicitly hidden
    alter column    SYS_END set implicitly hidden
    alter column    TS_ID set implicitly hidden
;
alter table CMDGRP drop versioning
;
alter table CMDGRP_HST
    alter column    SYS_START set not hidden
    alter column    SYS_END set not hidden
    alter column    TS_ID set not hidden
;
alter table CMDGRP add versioning use history table CMDGRP_HST on delete add extra row
;

commit
;