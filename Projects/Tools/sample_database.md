# Sample database

The idea of this tool comes from a discussion I had on PUB400's chat. It was requested if a sample database exists on this system.
On each IBM i system there is no pre-installed database which could be used as a sample. There is only a single table QCUSTCDT in QIWS library which is often referred to in some documentation topics. But this is not really a sample.

Online [documentation](https://www.ibm.com/docs/en/i/7.5?topic=tables-sample) says that there is a way to create such a sample database with QSYS.CREATE_SQL_SAMPLE procedure, with the name of the schema to create as a parameter. That is fine and can be used on any IBM i system.

Unfortunately, it expects to create the schema (i.e. the library) which we are not allowed to do on PUB400. Therefore, this procedure cannot be used here. However, the documentation provides the SQL instructions to create database objects (tables, index, ...) and provides the list of tables content.
This tool here is built to perform all the described DDL statements, and then to perform the needed SQL insert statements to populate data according to provided content lists.
Four SQL scripts are available to create this sample database. SQL statements do not specify the schema so that they can run without changes for any user on PUB400. However, this is crucial to run them on the appropriate schema/library/collection/database. Typically, they can be used:

1. Directly from iACS Run SQL Scripts feature, once the CURRENT SCHEMA is properly set using either "set schema" instruction or through the "default SQL schema" of JDBC configuration.
2. Or with RUNSQLSTM SRCSTMF(yourSQLscript) COMMIT(\*CHG) NAMING(\*SQL) DATFMT(\*ISO) DATSEP('-') TIMFMT(\*ISO) TIMSEP(':') DFTRDBCOL(yourlib) DECMPT(\*PERIOD) command on an IBM i 5250 session, once the scripts are uploaded into an IFS directory.

Though, we can use any of our 3 libraries as the schema for creating the sample database. However, this library must be set like an SQL collection would be, which is not the case by default when they are created when we request our user profile. Refer to [Projects ReadMe](../README.md) to learn how to make a library working as an SQL collection.

The scripts are described below and should be used in the order:

1. [Clean](sample_clean.sql) the database; all objects are deleted (dropped)
2. [Create](sample_create.sql) the database; all objects are created (tables, index, basic data integrity created)
3. [Populate](sample_populate.sql) the database; all tables are populated witha bunch of insert statements
    Notice that some data is not exactly the same as in the documentation; this is the case of text which contains the ' character replaced with a space.
4. [Set](sample_integrity.sql) database integrity; all referential integrity constraints are created
    Make sure to set the integrity after populating, because some rows insertion might not work (for instance, the DEPARTMENT table integrity requires that a department reports to another one, which prevents the inserttion of the very first one).

Enjoy the sample database!
