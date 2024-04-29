alter session set current_schema = ad;

SELECT * FROM DBA_ROLE_PRIVs where GRANTEE = 'SV0001';
SELECT * FROM SYS.FGA_LOG$;

grant RL_SV to SV0001

select * from ad.sinhvien;

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

GRANT INHERIT PRIVILEGES ON USER sys TO ad; -- avoid insufficient bug by granting inherit

-- DELETE USER HERE

-- RUN AGAIN

CREATE OR REPLACE PROCEDURE USP_CREATENHANVIEN authid current_user -- to fix insufficient bug, need to grant inherit to DBA
AS 
    CURSOR CUR IS (SELECT MANV 
                    FROM NHANSU 
                    WHERE MANV NOT IN (SELECT USERNAME 
                                                FROM ALL_USERS) 
                    ); 
    STRSQL VARCHAR(2000); 
    USR VARCHAR2(5); 
BEGIN 
    OPEN CUR; 
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE'; 
    EXECUTE IMMEDIATE(STRSQL); 
    LOOP 
        FETCH CUR INTO USR; 
        EXIT WHEN CUR%NOTFOUND; 
             
        STRSQL := 'CREATE USER '||USR||' IDENTIFIED BY 123'; 
        EXECUTE IMMEDIATE(STRSQL); 
        STRSQL := 'GRANT CONNECT TO '||USR; 
        EXECUTE IMMEDIATE(STRSQL); 
        
        -- do some if else to grant specific role here
    END LOOP; 
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = FALSE'; 
    EXECUTE IMMEDIATE(STRSQL); 
    CLOSE CUR; 
END; 
/

CREATE OR REPLACE PROCEDURE USP_CREATESINHVIEN authid current_user
AS 
    CURSOR CUR IS (SELECT MASV 
                    FROM SINHVIEN 
                    WHERE MASV NOT IN (SELECT USERNAME 
                                                FROM ALL_USERS) 
                    ); 
    STRSQL VARCHAR(2000); 
    USR VARCHAR2(6); 
BEGIN 
    OPEN CUR; 
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE'; 
    EXECUTE IMMEDIATE(STRSQL); 
    LOOP 
        FETCH CUR INTO USR; 
        EXIT WHEN CUR%NOTFOUND; 
             
        STRSQL := 'CREATE USER '||USR||' IDENTIFIED BY 123'; 
        EXECUTE IMMEDIATE(STRSQL); 
        STRSQL := 'GRANT CONNECT TO '||USR; 
        EXECUTE IMMEDIATE(STRSQL);
        
    END LOOP; 
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = FALSE'; 
    EXECUTE IMMEDIATE(STRSQL); 
    CLOSE CUR; 
END; 
/

exec USP_CREATESINHVIEN;
exec USP_CREATENHANVIEN;

SELECT * FROM dba_roles;
SELECT * FROM dba_users;


SELECT username, created FROM dba_users where username like 'SV%' or username like 'NV%';


--create user NV001 IDENTIFIED by 1;
--GRANT CREATE SESSION TO NV001 container = all;
--create user NV009 IDENTIFIED by 9;
--GRANT CREATE SESSION TO NV009 container = all;

--create role RL_NVCB;
select * from nhansu;


-- create role
create role RL_NVCB;
create role RL_GIAOVU;
create role RL_GIANGVIEN;
create role RL_TDV;
create role RL_TK;
create role RL_SV;


--drop role RL_NVCB;
--drop role RL_GIAOVU;
--drop role RL_GIANGVIEN;
--drop role RL_TDV;
--drop role RL_TK;
--drop role RL_SV;

--grant ROLE to USER
CREATE OR REPLACE PROCEDURE GRANT_ROLE_TO_SV authid current_user
AS 
    CURSOR CUR IS (SELECT MASV FROM SINHVIEN); 
    STRSQL VARCHAR(2000); 
    USR VARCHAR2(6);
BEGIN 
    OPEN CUR; 
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE'; 
    EXECUTE IMMEDIATE(STRSQL); 
    LOOP 
        FETCH CUR INTO USR; 
        EXIT WHEN CUR%NOTFOUND; 
             
        STRSQL := 'GRANT RL_SV TO '|| USR; 
        EXECUTE IMMEDIATE(STRSQL);     
    END LOOP;     
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = FALSE'; 
    EXECUTE IMMEDIATE(STRSQL); 
    CLOSE CUR;
END; 
/

CREATE OR REPLACE PROCEDURE GRANT_ROLE_TO_NV authid current_user
AS 
    CURSOR CUR IS (SELECT MANV, VAITRO FROM AD.NHANSU); 
    STRSQL VARCHAR(2000); 
    USR VARCHAR2(5);
    ROLE_USR NVARCHAR2(50);
BEGIN 
    OPEN CUR; 
    LOOP 
        FETCH CUR INTO USR, ROLE_USR; 
        EXIT WHEN CUR%NOTFOUND; 
        IF ROLE_USR = 'Nhân viên cơ bản' THEN
            STRSQL := 'GRANT RL_NVCB TO '||USR; 
        END IF;
        IF ROLE_USR = 'Giảng viên' THEN
            STRSQL := 'GRANT RL_GIANGVIEN TO '||USR; 
        END IF;
        IF ROLE_USR = 'Giáo vụ' THEN
            STRSQL := 'GRANT RL_GIAOVU TO '||USR; 
        END IF;
        IF ROLE_USR = 'Trưởng đơn vị' THEN
            STRSQL := 'GRANT RL_TDV TO '||USR; 
        END IF;
        IF ROLE_USR = 'Trưởng khoa' THEN
            STRSQL := 'GRANT RL_TK TO '||USR; 
        END IF;
        EXECUTE IMMEDIATE(STRSQL);     
    END LOOP; 
    
    
    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = FALSE'; 
    EXECUTE IMMEDIATE(STRSQL); 
    CLOSE CUR;
END; 
/

EXEC GRANT_ROLE_TO_SV;

EXEC GRANT_ROLE_TO_NV;


--revoke select,UPDATE on ad.NHANSU from RL_NVCB;
-- grant select on ad.NHANSU to RL_NVCB; -- sai quyền truy cập
grant select on ad.SINHVIEN to RL_NVCB;
grant select on ad.DONVI to RL_NVCB;
grant select on ad.HOCPHAN to RL_NVCB;
grant select on ad.KHMO to RL_NVCB;
grant RL_NVCB to NV001;


SELECT *
FROM dba_roles where ROLE like '%RL%';

--revoke select,UPDATE on ad.NHANSU from RL_GIAOVU;
grant select,insert,update on ad.SINHVIEN to RL_GIAOVU;
grant select,insert,update on ad.DONVI to RL_GIAOVU;
grant select,insert,update on ad.HOCPHAN to RL_GIAOVU;
grant select,insert,update on ad.KHMO to RL_GIAOVU;
grant select,update on ad.PHANCONG to RL_GIAOVU;
grant insert, delete, select on ad.DANGKY to RL_GIAOVU;

grant RL_GIAOVU to NV009;

CREATE VIEW VIEW_THONGTIN_NVCB AS
SELECT *
FROM NHANSU
WHERE MaNV = SYS_CONTEXT('USERENV', 'SESSION_USER');

GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_NVCB;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_NVCB;

GRANT SELECT ON V_NVCB TO RL_GIAOVU;
GRANT UPDATE(DT) ON V_NVCB TO RL_GIAOVU;

--CREATE OR REPLACE PROCEDURE USP_CREATEUSER AS
--    CURSOR CUR IS 
--        SELECT MANV
--        FROM NHANSU
--        WHERE MANV NOT IN (SELECT TO_NUMBER(USERNAME) FROM ALL_USERS);
--    STRSQL VARCHAR2(2000);
--    USR NUMBER;
--BEGIN
--    OPEN CUR;
--    
--    -- Set Oracle script mode to true for creating users
--    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE';
--    EXECUTE IMMEDIATE STRSQL;
--    
--    LOOP
--    FETCH CUR INTO USR;
--    EXIT WHEN CUR%NOTFOUND;
--    
--    -- Create user directly using the number value
--    STRSQL := 'CREATE USER "' || USR || '" IDENTIFIED BY "' || USR || '"';
--    EXECUTE IMMEDIATE STRSQL;
--    
--    -- Grant connect privileges to the newly created user
--    STRSQL := 'GRANT CONNECT TO "' || USR || '"';
--    EXECUTE IMMEDIATE STRSQL;
--    END LOOP;
--
--    STRSQL := 'ALTER SESSION SET "_ORACLE_SCRIPT" = FALSE';
--    EXECUTE IMMEDIATE STRSQL;
--    
--    CLOSE CUR;
--END;

EXEC USP_CREATEUSER;

--CREATE OR REPLACE FUNCTION NVCB1(schema_var IN VARCHAR2, table_name IN VARCHAR2)
--RETURN VARCHAR2
--AS
--    v_session_user VARCHAR2(20);
--    v_vaitro NHANSU.VAITRO%TYPE; 
--    is_dba VARCHAR2(5);
--BEGIN
--    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
--    IF is_dba = 'TRUE' THEN
--        RETURN '1 = 1';
--    ELSE
--        v_session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
--        SELECT VAITRO INTO v_vaitro
--        FROM NHANSU
--        WHERE MANV = v_session_user;   
--    END IF;
--
--  IF v_vaitro = N'Nhân viên cơ bản' OR v_vaitro = N'Giáo vụ' OR v_vaitro = N'Trưởng khoa' THEN
--    RETURN '1 = 1'; 
--  ELSE
--    RETURN '1 = 0'; 
--  END IF;
--END;
/
--CREATE OR REPLACE FUNCTION NVCB(schema_var IN VARCHAR2, table_name IN VARCHAR2)
--RETURN VARCHAR2
--AS
--    v_session_user VARCHAR2(20);
--    is_dba VARCHAR2(5);
--BEGIN
--  is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
--  IF is_dba = 'TRUE' THEN
--    RETURN '1 = 1';
--  ELSE
--    v_session_user := SYS_CONTEXT('USERENV', 'SESSION_USER');
--    RETURN 'MANV = ''' || v_session_user || '''';  
--  END IF;
--END;


--BEGIN
-- DBMS_RLS.ADD_POLICY(
-- OBJECT_SCHEMA =>'ad',
-- OBJECT_NAME=>'NHANSU',
-- POLICY_NAME =>'NVCB',
-- FUNCTION_SCHEMA => 'ad',
-- POLICY_FUNCTION=>'NVCB',
-- STATEMENT_TYPES=>'SELECT'
-- );
--END;

SELECT * FROM DBA_POLICIES where PF_OWNER = 'AD';

BEGIN
 DBMS_RLS.DROP_POLICY(
 'ad','NHANSU','NVCB'
 );
END;

CREATE OR REPLACE FUNCTION GV (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
    MA CHAR(4);
    STRSQL VARCHAR2(2000);
    CURSOR CUR IS 
       (SELECT MAHP 
       FROM AD.HOCPHAN hp JOIN AD.DONVI dv ON hp.MADV = dv.MADV --JOIN AD.NHANSU ns ON dv.TRGDV = ns.MANV WHERE ns.VAITRO = 'Trưởng khoa'
       WHERE dv.TENDV = 'Văn phòng khoa');
BEGIN
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN '';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'GV' THEN
            OPEN CUR;
             LOOP
             FETCH CUR INTO MA;
             EXIT WHEN CUR%NOTFOUND;
             IF (STRSQL IS NOT NULL) THEN
             STRSQL := STRSQL ||''',''';
             END IF;
             STRSQL := STRSQL || MA;
             END LOOP;
             CLOSE CUR;           
             RETURN 'MAHP IN ('''||STRSQL||''')';
        else
            RETURN '1 = 1';
        end if;
    end if;
END;

select GV('AD','PHANCONG') FROM DUAL;

BEGIN
 DBMS_RLS.ADD_POLICY(
 OBJECT_SCHEMA =>'AD',
 OBJECT_NAME=>'PHANCONG',
 POLICY_NAME =>'GV_PHANCONG',
 FUNCTION_SCHEMA => 'AD',
 POLICY_FUNCTION=>'GV',
 STATEMENT_TYPES=>'UPDATE',
 UPDATE_CHECK => TRUE 
 );
END; 

BEGIN
 DBMS_RLS.DROP_POLICY(
 'ad','PHANCONG','GV_PHANCONG'
 );
END;

--drop trigger TRG_DK_DELETE

--
--CREATE OR REPLACE TRIGGER TRG_DK_DELETE
--BEFORE DELETE ON DANGKY
--FOR EACH ROW
--DECLARE
--    v_hoc_ky_start_date DATE;
--BEGIN
--  CASE :OLD.HK
--    WHEN 1 THEN
--      v_hoc_ky_start_date := TO_DATE('01-JAN-' || TO_CHAR(:OLD.NAM), 'DD-MON-YYYY');
--    WHEN 2 THEN
--      v_hoc_ky_start_date := TO_DATE('01-MAY-' || TO_CHAR(:OLD.NAM), 'DD-MON-YYYY');
--    WHEN 3 THEN
--      v_hoc_ky_start_date := TO_DATE('01-SEP-' || TO_CHAR(:OLD.NAM), 'DD-MON-YYYY');
--    ELSE
--      RAISE_APPLICATION_ERROR(-20002, 'Invalid semester value');
--  END CASE;
--  IF (SYSDATE - v_hoc_ky_start_date) > 14 THEN
--    RAISE_APPLICATION_ERROR(-20001, 'Deletion deadline exceeded');
--  END IF;
--END;
--/
--
--CREATE OR REPLACE TRIGGER TRG_DK_INSERT
--BEFORE INSERT ON DANGKY
--FOR EACH ROW
--DECLARE
--  v_hoc_ky_start_date DATE;
--BEGIN
--  CASE :NEW.HK
--    WHEN 1 THEN
--      v_hoc_ky_start_date := TO_DATE('01-JAN-' || TO_CHAR(:NEW.NAM), 'DD-MON-YYYY');
--    WHEN 2 THEN
--      v_hoc_ky_start_date := TO_DATE('01-MAY-' || TO_CHAR(:NEW.NAM), 'DD-MON-YYYY');
--    WHEN 3 THEN
--      v_hoc_ky_start_date := TO_DATE('01-SEP-' || TO_CHAR(:NEW.NAM), 'DD-MON-YYYY');
--    ELSE
--      RAISE_APPLICATION_ERROR(-20002, 'Invalid semester value');
--  END CASE;
--  IF (SYSDATE - v_hoc_ky_start_date) > 14 THEN
--    RAISE_APPLICATION_ERROR(-20001, 'Insertion deadline exceeded');
--  END IF;
--END;
--/

SELECT FUNC_GV_DELETE('AD', 'DANGKY') FROM DUAL;

create or replace function FUNC_GV_Delete (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
    MAHP_LIST VARCHAR2(2000);
    HK_LIST VARCHAR2(2000);
    NAM_LIST VARCHAR2(2000);
    MAHP CHAR(4);
    HK INT;
    NAM INT;
    CURSOR CUR IS (select MAHP, HK, NAM from AD.DANGKY WHERE FUNC_DATE(HK, NAM) > (SYSDATE - 120) AND FUNC_DATE(HK, NAM) < SYSDATE);
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN '1=1';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'GV' THEN
            OPEN CUR;
            LOOP 
                FETCH CUR INTO MAHP, HK, NAM;
                EXIT WHEN CUR%NOTFOUND;
              
                IF (MAHP_LIST IS NOT NULL) THEN 
                    MAHP_LIST := MAHP_LIST ||''', '''; 
                END IF; 
                IF (HK_LIST IS NOT NULL) THEN 
                    HK_LIST := HK_LIST ||''', '''; 
                END IF; 
                IF (NAM_LIST IS NOT NULL) THEN 
                    NAM_LIST := NAM_LIST ||''', '''; 
                END IF; 
                MAHP_LIST := MAHP_LIST || MAHP;
                HK_LIST := HK_LIST || HK;
                NAM_LIST := NAM_LIST || NAM;
            END LOOP;
            CLOSE CUR;
            RETURN 'MAHP IN ('''|| MAHP_LIST||''') AND HK IN ('''|| HK_LIST||''') AND NAM IN ('''|| NAM_LIST||''')';
        else
            RETURN '1 = 1';
        end if;
    end if;
end;
/

CREATE OR REPLACE FUNCTION FUNC_DATE (
    p_hk IN NUMBER,
    p_nam IN NUMBER
) RETURN DATE AS
    l_hoc_ky_start_date DATE;
BEGIN
    CASE p_hk
        WHEN 1 THEN
            l_hoc_ky_start_date := TO_DATE('01-JAN-' || TO_CHAR(p_nam), 'DD-MON-YYYY');
        WHEN 2 THEN
            l_hoc_ky_start_date := TO_DATE('01-MAY-' || TO_CHAR(p_nam), 'DD-MON-YYYY');
        WHEN 3 THEN
            l_hoc_ky_start_date := TO_DATE('01-SEP-' || TO_CHAR(p_nam), 'DD-MON-YYYY');
    END CASE;
    RETURN l_hoc_ky_start_date;
END;

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'DANGKY',
    policy_name     => 'GV_Delete',
    function_schema => 'AD',
    policy_function => 'FUNC_GV_Delete ',
    statement_types => 'DELETE',
    update_check    => TRUE,
    enable          => TRUE);
END;
/

--BEGIN
--    DBMS_RLS.DROP_POLICY(
--        object_schema => 'AD',  -- replace with your schema name
--        object_name => 'DANGKY',  -- replace with your table name
--        policy_name => 'GV_Delete'  -- replace with your policy name
--    );
--END;

SELECT FUNC_GV_INSERT('AD', 'DANGKY') FROM DUAL;

create or replace function FUNC_GV_Insert (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
    MAHP_LIST VARCHAR2(2000);
    HK_LIST VARCHAR2(2000);
    NAM_LIST VARCHAR2(2000);
    MACT_LIST VARCHAR2(2000);
    MAHP CHAR(4);
    HK CHAR(1);
    NAM CHAR(4);
    MACT VARCHAR2(4);
    CURSOR CUR IS (select MAHP, HK, NAM, MACT from AD.KHMO WHERE FUNC_DATE(HK, NAM) > (SYSDATE - 120) AND FUNC_DATE(HK, NAM) < SYSDATE);
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN '';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'GV' THEN
            OPEN CUR;
            LOOP 
                FETCH CUR INTO MAHP, HK, NAM, MACT;
                EXIT WHEN CUR%NOTFOUND;
              
                IF (MAHP_LIST IS NOT NULL) THEN 
                    MAHP_LIST := MAHP_LIST ||''', '''; 
                END IF; 
                IF (HK_LIST IS NOT NULL) THEN 
                    HK_LIST := HK_LIST ||''', '''; 
                END IF; 
                IF (NAM_LIST IS NOT NULL) THEN 
                    NAM_LIST := NAM_LIST ||''', '''; 
                END IF; 
                IF (MACT_LIST IS NOT NULL) THEN 
                    MACT_LIST := MACT_LIST ||''', '''; 
                END IF; 
                MAHP_LIST := MAHP_LIST || MAHP;
                HK_LIST := HK_LIST || HK;
                NAM_LIST := NAM_LIST || NAM;
                MACT_LIST := MACT_LIST || MACT;
                
            END LOOP;
            CLOSE CUR;
            RETURN 'MAHP IN ('''|| MAHP_LIST ||''') AND HK IN ('''|| HK_LIST ||''') AND NAM IN ('''|| NAM_LIST ||''') AND MACT IN ('''|| MACT_LIST ||''')';
        else
            RETURN '1 = 1';
        end if;
    end if;
end;
/

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'DANGKY',
    policy_name     => 'GV_Insert',
    policy_function => 'FUNC_GV_Insert',
    statement_types => 'INSERT',
    update_check    => TRUE,
    enable => TRUE
  );
END;
/

--BEGIN
--    DBMS_RLS.DROP_POLICY(
--        object_schema => 'AD',  -- replace with your schema name
--        object_name => 'DANGKY',  -- replace with your table name
--        policy_name => 'GV_Insert'  -- replace with your policy name
--    );
--END;
