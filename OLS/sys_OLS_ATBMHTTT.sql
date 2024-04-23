SELECT VALUE FROM v$option WHERE parameter = 'Oracle Label Security'; 
SELECT status FROM dba_ols_status WHERE name = 'OLS_CONFIGURE_STATUS'; 
EXEC LBACSYS.CONFIGURE_OLS;

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--ALTER DATABASE OPEN;
--ALTER PLUGGABLE DATABASE ALL OPEN;
EXEC LBACSYS.OLS_ENFORCEMENT.ENABLE_OLS;
--SELECT name, open_mode FROM v$pdbs;
SHUTDOWN IMMEDIATE; 
STARTUP; 

select * from v$services; 

ALTER USER lbacsys IDENTIFIED BY lbacsys ACCOUNT UNLOCK container = all;

ALTER PLUGGABLE DATABASE PDB_ATBMHTTT OPEN READ WRITE;

ALTER SESSION SET CONTAINER= PDB_ATBMHTTT; 
SHOW CON_NAME; 

--drop user admin_ols cascade;

CREATE USER ADMIN_OLS IDENTIFIED BY 123 CONTAINER = CURRENT; 
GRANT CONNECT,RESOURCE, SELECT_CATALOG_ROLE TO ADMIN_OLS; --CẤP QUYỀN CONNECT VÀ RESOURCE 
GRANT UNLIMITED TABLESPACE TO ADMIN_OLS; --CẤP QUOTA CHO ADMIN_OLS 
GRANT SELECT ANY DICTIONARY TO ADMIN_OLS; --CẤP QUYỀN ĐỌC DICTIONARY


---> CẤP QUYỀN EXECUTE CHO ADMIN_OLS 
GRANT EXECUTE ON LBACSYS.SA_COMPONENTS TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON LBACSYS.SA_SYSDBA TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON LBACSYS.sa_user_admin TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON LBACSYS.sa_label_admin TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON sa_policy_admin TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON char_to_label TO ADMIN_OLS WITH GRANT OPTION; ---> ADD ADMIN_OLS VÀO LBAC_DBA 
GRANT LBAC_DBA TO ADMIN_OLS; 
GRANT EXECUTE ON sa_sysdba TO ADMIN_OLS;  
GRANT EXECUTE ON TO_LBAC_DATA_LABEL TO ADMIN_OLS; -- CẤP QUYỀN THỰC THI 
GRANT notification_policy_DBA to ADMIN_OLS;


--GRANT CREATE SESSION TO ADMIN_OLS;
----TEST USER
--CREATE USER sales_manager IDENTIFIED BY 123;
--GRANT CONNECT TO sales_manager;
--BEGIN
-- SA_USER_ADMIN.SET_USER_LABELS('notification_policy','admin_ols','TK:HTTT:CS1');
--END; 
--
--grant inherit privileges on user sys to admin_ols;
--
--SELECT policy_name
--FROM user_policies
--WHERE policy_name = 'TEN_POLICY_BAN_MUON_KIEM_TRA';



