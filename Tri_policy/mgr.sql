alter session set current_schema = ad;

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

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

Exec USP_CREATENHANVIEN;

CREATE OR REPLACE PROCEDURE USP_CREATESINHVIEN
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

exec USP_CREATESINHVIEN;
exec USP_CREATENHANVIEN;

SELECT username, created FROM dba_users where username like 'SV%' or username like 'NV%';

select * from ad.SINHVIEN;
select * from ad.nhansu;

--create user NV001 IDENTIFIED by 1;
--GRANT CREATE SESSION TO NV001 container = all;
--create user NV009 IDENTIFIED by 9;
--GRANT CREATE SESSION TO NV009 container = all;

--create role RL_NVCB;

select * from nhansu
-- create role
create role RL_NVCB;
create role RL_GIAOVU;
create role RL_GIANGVIEN;
create role RL_TDV;
create role RL_TK;
create role RL_SV;

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

CREATE OR REPLACE FUNCTION GV
 (P_SCHEMA VARCHAR2, P_OBJ VARCHAR2)
RETURN VARCHAR2
AS
 MA ad.HOCPHAN.MAHP%TYPE;
 STRSQL VARCHAR2(2000);
 CURSOR CUR IS 
   (SELECT MAHP 
   FROM HOCPHAN hp JOIN DONVI dv ON hp.MADV = dv.MADV JOIN NHANSU ns ON dv.TRGDV = ns.MANV 
   WHERE ns.VAITRO = 'Trưởng khoa');
BEGIN
 STRSQL := '';
 OPEN CUR;
 LOOP
     FETCH CUR INTO MA;
     EXIT WHEN CUR%NOTFOUND;
     IF (STRSQL IS NOT NULL) THEN
     STRSQL := STRSQL ||''',''';
     END IF;
     STRSQL := STRSQL || MA;
 END LOOP;
 RETURN 'MAHP IN ('''||STRSQL||''')';
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


select GV('AD','PHANCONG') from dual;
select SYS_CONTEXT('USERENV', 'ISDBA') from dual;


BEGIN
 DBMS_RLS.ADD_POLICY(
 OBJECT_SCHEMA =>'ad',
 OBJECT_NAME=>'PHANCONG',
 POLICY_NAME =>'GV',
 FUNCTION_SCHEMA => 'ad',
 POLICY_FUNCTION=>'GV',
 STATEMENT_TYPES=>'UPDATE',
 UPDATE_CHECK => TRUE 
 );
END; 

BEGIN
 DBMS_RLS.DROP_POLICY(
 'ad','PHANCONG','GV'
 );
END;

select * from dangky

--BEGIN
-- DBMS_RLS.ADD_POLICY(
-- OBJECT_SCHEMA =>'ad',
-- OBJECT_NAME=>'NHANSU',
-- POLICY_NAME =>'NVCB_DT',
-- FUNCTION_SCHEMA => 'ad',
-- POLICY_FUNCTION =>'NVCB',
-- statement_types   => 'UPDATE',
-- update_check => TRUE,
-- sec_relevant_cols => 'DT'
-- );
--END;