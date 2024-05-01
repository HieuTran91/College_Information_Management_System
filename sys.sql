alter session set current_schema = sys;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
alter session set container = PDB_ATBMHTTT;
alter pluggable database PDB_ATBMHTTT open READ WRITE;

--DROP USER ad cascade;

CREATE user ad IDENTIFIED by 123;
GRANT CREATE SESSION TO ad container = current;
--CONNECT ad/123;
show con_name;

Grant SYSDBA TO AD;
GRANT EXECUTE ANY PROCEDURE TO ad; 
GRANT ALL PRIVILEGES TO ad;
grant execute on sys.DBMS_RLS to ad; -- to add policy
GRANT INHERIT PRIVILEGES ON USER sys TO ad; -- to create function
-------------------------------------------------------------------------------------------------

--select * from dba_users where username = 'ADMIN_OLS';

SELECT VALUE FROM v$option WHERE parameter = 'Oracle Label Security'; 
SELECT status FROM dba_ols_status WHERE name = 'OLS_CONFIGURE_STATUS'; 
EXEC LBACSYS.CONFIGURE_OLS;
EXEC LBACSYS.OLS_ENFORCEMENT.ENABLE_OLS;
--SELECT name, open_mode FROM v$pdbs;
SHUTDOWN IMMEDIATE; 
STARTUP; 


select * from v$services; 

ALTER USER lbacsys IDENTIFIED BY lbacsys ACCOUNT UNLOCK container = all;
ALTER SESSION SET CONTAINER= PDB_ATBMHTTT; 
SHOW CON_NAME; 


--CREATE USER ad IDENTIFIED BY 123 CONTAINER = CURRENT; 
GRANT CONNECT,RESOURCE, SELECT_CATALOG_ROLE TO ad; --CẤP QUYỀN CONNECT VÀ RESOURCE 
GRANT UNLIMITED TABLESPACE TO ad; --CẤP QUOTA CHO ADMIN_OLS 
GRANT SELECT ANY DICTIONARY TO ad; --CẤP QUYỀN ĐỌC DICTIONARY


---> CẤP QUYỀN EXECUTE CHO ADMIN_OLS 
GRANT EXECUTE ON LBACSYS.SA_COMPONENTS TO ad WITH GRANT OPTION; 
GRANT EXECUTE ON LBACSYS.SA_SYSDBA TO ad WITH GRANT OPTION; 
GRANT EXECUTE ON LBACSYS.sa_user_admin TO ad WITH GRANT OPTION; 
GRANT EXECUTE ON LBACSYS.sa_label_admin TO ad WITH GRANT OPTION; 
GRANT EXECUTE ON sa_policy_admin TO ad WITH GRANT OPTION; 
GRANT EXECUTE ON char_to_label TO ad WITH GRANT OPTION; ---> ADD ADMIN_OLS VÀO LBAC_DBA 
GRANT LBAC_DBA TO ad; 
GRANT EXECUTE ON sa_sysdba TO ad;  
GRANT EXECUTE ON TO_LBAC_DATA_LABEL TO ad; -- CẤP QUYỀN THỰC THI 
GRANT notification_policy_DBA to ad;

GRANT inherit privileges ON USER sys TO lbacsys;
GRANT lbac_dba to SYS;