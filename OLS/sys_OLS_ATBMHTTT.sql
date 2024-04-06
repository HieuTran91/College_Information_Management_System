SELECT VALUE FROM v$option WHERE parameter = 'Oracle Label Security'; 
SELECT status FROM dba_ols_status WHERE name = 'OLS_CONFIGURE_STATUS'; 
EXEC LBACSYS.CONFIGURE_OLS;

EXEC LBACSYS.OLS_ENFORCEMENT.ENABLE_OLS;


SHUTDOWN IMMEDIATE; 
STARTUP; 


select * from v$services; 

ALTER USER lbacsys IDENTIFIED BY lbacsys ACCOUNT UNLOCK container = all;

ALTER PLUGGABLE DATABASE PDB_ATBMHTTT OPEN READ WRITE;

ALTER SESSION SET CONTAINER= PDB_ATBMHTTT; 
SHOW CON_NAME; 

CREATE USER ADMIN_OLS IDENTIFIED BY 123 CONTAINER = CURRENT; 
GRANT CONNECT,RESOURCE TO ADMIN_OLS; --CẤP QUYỀN CONNECT VÀ RESOURCE 
GRANT UNLIMITED TABLESPACE TO ADMIN_OLS; --CẤP QUOTA CHO ADMIN_OLS 
GRANT SELECT ANY DICTIONARY TO ADMIN_OLS; --CẤP QUYỀN ĐỌC DICTIONARY

---> CẤP QUYỀN EXECUTE CHO ADMIN_OLS 
GRANT EXECUTE ON LBACSYS.SA_COMPONENTS TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON LBACSYS.sa_user_admin TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON LBACSYS.sa_label_admin TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON sa_policy_admin TO ADMIN_OLS WITH GRANT OPTION; 
GRANT EXECUTE ON char_to_label TO ADMIN_OLS WITH GRANT OPTION; ---> ADD ADMIN_OLS VÀO LBAC_DBA 
GRANT LBAC_DBA TO ADMIN_OLS; 
GRANT EXECUTE ON sa_sysdba TO ADMIN_OLS;  
GRANT EXECUTE ON TO_LBAC_DATA_LABEL TO ADMIN_OLS; -- CẤP QUYỀN THỰC THI 