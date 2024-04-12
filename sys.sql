alter session set current_schema = sys;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE user ad IDENTIFIED by 123;
GRANT CREATE SESSION TO ad container = all;
CONNECT ad/123;

DROP USER ad cascade;

GRANT EXECUTE ANY PROCEDURE TO ad; 
GRANT ALL PRIVILEGES TO ad;

Grant SYSDBA TO AD;

SELECT VALUE FROM v$option WHERE parameter = 'Oracle Label Security';
SELECT status FROM dba_ols_status WHERE name = 'OLS_CONFIGURE_STATUS';