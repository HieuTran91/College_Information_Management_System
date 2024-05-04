alter session set current_schema = sys;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

drop user ad cascade;

create user ad IDENTIFIED by 123;
GRANT CREATE SESSION TO ad container = all;
CONNECT ad/123; 

Grant SYSDBA TO ad;