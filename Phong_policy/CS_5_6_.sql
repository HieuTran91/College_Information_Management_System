alter session set current_schema = AD;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
SELECT * FROM ALL_POLICIES;
select * from ad.hocphan;
select * from ad.khmo;

select * from nhansu where vaitro like '%G%';

SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION'
  AND UPPER(OBJECT_NAME) like '%FUNC%';  -- Replace 'FUNC_DATE' with your function name

-- CS#5:
-- Như một người dùng có vai trò “Giảng viên”  
-- Thêm, Xóa, Cập nhật dữ liệu trên quan hệ PHANCONG đối với các học phần quản lý bởi đơn vị “Văn phòng khoa”. 
-- Được quyền Xem, Thêm, Xóa, Cập nhật trên quan hệ NHANSU. 
-- Được quyền Xem (không giới hạn) dữ liệu trên toàn bộ lược đồ CSDL. 

GRANT SELECT ON VIEW_GV_PC TO RL_TK;
GRANT SELECT ON VIEW_GV_DK TO RL_TK;
GRANT UPDATE(DIEMTH, DIEMQT, DIEMCK, DIEMTK) ON VIEW_GV_DK TO RL_TK;


grant select on SINHVIEN to RL_TK;
grant select on DONVI to RL_TK;
grant select on HOCPHAN to RL_TK;
grant select on KHMO to RL_TK;
GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_TK;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_TK;

-- Thêm, Xóa, Cập nhật dữ liệu trên quan hệ PHANCONG đối với các học phần quản lý bởi đơn vị “Văn phòng khoa”. 
CREATE OR REPLACE VIEW VIEW_TK_PC AS
SELECT PC.*
FROM DONVI DV JOIN HOCPHAN HP ON hp.madv = dv.madv JOIN PHANCONG PC ON pc.mahp = hp.mahp
WHERE dv.tendv = 'VĂN PHÒNG KHOA' AND dv.trgdv = SYS_CONTEXT('USERENV', 'SESSION_USER');

-- Được quyền Xem, Thêm, Xóa, Cập nhật trên quan hệ NHANSU. 
GRANT SELECT, DELETE, UPDATE, INSERT ON VIEW_TK_PC TO RL_TK;

grant select, update, delete on NHANSU to RL_TK;


-- Được quyền Xem (không giới hạn) dữ liệu trên toàn bộ lược đồ CSDL.
grant select on SINHVIEN to TruongKhoa;
grant select on DANGKY to TruongKhoa;
grant select on KHMO to TruongKhoa;
grant select on HOCPHAN to TruongKhoa;
grant select on DONVI to TruongKhoa;

-- CS#6: Người dùng có VAITRO là “Sinh viên”
-- Trên quan hệ SINHVIEN, sinh viên chỉ được xem thông tin của chính mình, được 
-- Chỉnh sửa thông tin địa chỉ (ĐCHI) và số điện thoại liên lạc (ĐT) của chính sinh viên. 
-- Xem danh sách tất cả học phần (HOCPHAN), kế hoạch mở môn (KHMO) của chương trình đào tạo mà sinh viên đang theo học. 
-- Thêm, Xóa các dòng dữ liệu đăng ký học phần (ĐANGKY) liên quan đến chính sinh viên đó trong học kỳ của năm học hiện tại (nếu thời điểm hiệu chỉnh đăng ký còn hợp lệ).  
-- Sinh viên không được chỉnh sửa trên các trường liên quan đến điểm.  

create or replace function FUNC_SV_SV (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN '';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'SV' THEN
            RETURN 'MASV = ''' || USER ||'''';
        else
            return '';
        end if;
    end if;
end;
/

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'SINHVIEN',
    policy_name     => 'SV_SV',
    function_schema => 'AD',
    policy_function => 'FUNC_SV_SV',
    statement_types => 'SELECT, UPDATE'
    );
END;
/

--BEGIN
--    DBMS_RLS.DROP_POLICY(
--        object_schema => 'ad',  -- replace with your schema name
--        object_name => 'SINHVIEN',  -- replace with your table name
--        policy_name => 'SV_SV'  -- replace with your policy name
--    );
--END;

create or replace function FUNC_SV_KHMO (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
    MA VARCHAR2(4);
    STRSQL VARCHAR2(20000);
    CURSOR CUR IS (SELECT MACT FROM AD.SINHVIEN where masv = sys_context('userenv','session_user') and nam = EXTRACT(YEAR FROM SYSDATE));
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN ' ';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'SV' THEN
            OPEN CUR;
            LOOP 
                FETCH CUR INTO MA;
                EXIT WHEN CUR%NOTFOUND;
              
                IF (STRSQL IS NOT NULL) THEN 
                    STRSQL := STRSQL ||''', '''; 
                END IF; 
              
                STRSQL := STRSQL || upper(MA);
            END LOOP;
            CLOSE CUR;
            RETURN 'MACT IN ('''|| STRSQL||''')';
        else
            RETURN '1 = 0';
        end if;
    end if;
end;
/

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'KHMO',
    policy_name     => 'SV_KHMO',
    function_schema => 'AD',
    policy_function => 'FUNC_SV_KHMO',
    statement_types => 'SELECT'
    );
END;
/

--BEGIN
--    DBMS_RLS.DROP_POLICY(
--        object_schema => 'AD',  -- replace with your schema name
--        object_name => 'KHMO',  -- replace with your table name
--        policy_name => 'SV_KHMO'  -- replace with your policy name
--    );
--END;

create or replace function FUNC_SV_HOCPHAN (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
    MA VARCHAR2(4);
    STRSQL VARCHAR2(20000);
    CURSOR CUR IS (SELECT MAHP FROM AD.KHMO WHERE MACT IN (SELECT MACT FROM AD.SINHVIEN where MASV = sys_context('userenv','session_user')));
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN ' ';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'SV' THEN
            OPEN CUR;
            LOOP 
                FETCH CUR INTO MA;
                EXIT WHEN CUR%NOTFOUND;
              
                IF (STRSQL IS NOT NULL) THEN 
                    STRSQL := STRSQL ||''', '''; 
                END IF; 
              
                STRSQL := STRSQL || upper(MA);
            END LOOP;
            CLOSE CUR;
            RETURN 'MAHP IN ('''|| STRSQL||''')';
        else
            RETURN '1 = 1';
        end if;
    end if;
end;
/

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'HOCPHAN',
    policy_name     => 'SV_HP',
    function_schema => 'AD',
    policy_function => 'FUNC_SV_HOCPHAN',
    statement_types => 'SELECT'
    );
END;
/
SELECT * FROM ALL_POLICIES;
BEGIN
    DBMS_RLS.DROP_POLICY(
        object_schema => 'AD',  -- replace with your schema name
        object_name => 'HOCPHAN',  -- replace with your table name
        policy_name => 'SV_HP'  -- replace with your policy name
    );
END;

GRANT SELECT ON AD.SINHVIEN TO RL_SV;
GRANT UPDATE(DT, DCHI) ON AD.SINHVIEN TO RL_SV;
GRANT SELECT ON AD.KHMO TO RL_SV;
GRANT SELECT ON AD.HOCPHAN TO RL_SV;
GRANT SELECT ON AD.DANGKY TO RL_SV;
GRANT DELETE ON AD.DANGKY TO RL_SV;
GRANT INSERT ON AD.DANGKY TO RL_SV;

create or replace function FUNC_SV_DK (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN '';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'SV' THEN
            RETURN 'MASV = ''' || USER ||'''';
        else
            return '';
        end if;
    end if;
end;
/

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'DANGKY',
    policy_name     => 'SV_DK',
    function_schema => 'AD',
    policy_function => 'FUNC_SV_DK ',
    statement_types => 'SELECT'
);
END;
/
BEGIN
    DBMS_RLS.DROP_POLICY(
        object_schema => 'AD',  
        object_name => 'DANGKY', 
        policy_name => 'SV_DK'  
    );
END;


create or replace function FUNC_SV_Delete (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
    MASV_LIST VARCHAR2(2000);
    MAGV_LIST VARCHAR2(2000);
    MAHP_LIST VARCHAR2(2000);
    HK_LIST VARCHAR2(2000);
    NAM_LIST VARCHAR2(2000);
    MASV CHAR(6);
    MAGV CHAR(5);
    MAHP CHAR(4);
    HK INT;
    NAM INT;
    CURSOR CUR IS (select MASV, MAGV, MAHP, HK, NAM from AD.DANGKY WHERE MASV = sys_context('userenv','session_user') AND FUNC_DATE(HK, NAM) > (SYSDATE - 120) AND FUNC_DATE(HK, NAM) < SYSDATE);
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN ' ';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'SV' THEN
            OPEN CUR;
            LOOP 
                FETCH CUR INTO MASV, MAGV, MAHP, HK, NAM;
                EXIT WHEN CUR%NOTFOUND;
              
                IF (MASV_LIST IS NOT NULL) THEN 
                    MASV_LIST := MASV_LIST ||''', '''; 
                END IF; 
                IF (MAGV_LIST IS NOT NULL) THEN 
                    MAGV_LIST := MAGV_LIST ||''', '''; 
                END IF; 
                IF (MAHP_LIST IS NOT NULL) THEN 
                    MAHP_LIST := MAHP_LIST ||''', '''; 
                END IF; 
                IF (HK_LIST IS NOT NULL) THEN 
                    HK_LIST := HK_LIST ||''', '''; 
                END IF; 
                IF (NAM_LIST IS NOT NULL) THEN 
                    NAM_LIST := NAM_LIST ||''', '''; 
                END IF; 
                MASV_LIST := MASV_LIST || MASV;
                MAGV_LIST := MAGV_LIST || MAGV;
                MAHP_LIST := MAHP_LIST || MAHP;
                HK_LIST := HK_LIST || HK;
                NAM_LIST := NAM_LIST || NAM;
            END LOOP;
            CLOSE CUR;
            RETURN 'MASV IN ('''|| MASV_LIST||''') AND MAGV IN ('''|| MAGV_LIST||''') AND MAHP IN ('''|| MAHP_LIST||''') AND HK IN ('''|| HK_LIST||''') AND NAM IN ('''|| NAM_LIST||''')';
        else
            RETURN '1 = 0';
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

----exec ad.FUNC_DATE(1, 2024);
--

SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'FUNCTION'
  AND UPPER(OBJECT_NAME) LIKE '%FUNC%';


--select FUNC_DATE(1, 2024) as Dateis;


BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'DANGKY',
    policy_name     => 'SV_Delete',
    function_schema => 'AD',
    policy_function => 'FUNC_SV_Delete ',
    statement_types => 'DELETE',
    update_check    => TRUE,
    enable          => TRUE);
END;
/

BEGIN
    DBMS_RLS.DROP_POLICY(
        object_schema => 'AD',  
        object_name => 'DANGKY', 
        policy_name => 'SV_Delete'  
    );
END;

CREATE OR REPLACE FUNCTION SV_avoid_insert_policy (
    p_schema_name  IN VARCHAR2,
    p_object_name  IN VARCHAR2
) RETURN VARCHAR2
AS
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
    v_condition VARCHAR2(4000);
BEGIN
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN ' ';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'SV' THEN
            v_condition := 'CASE WHEN :NEW.DIEMTH IS NULL THEN 1 ELSE 0 END';
        ELSE
            v_condition := '1 = 1';
        END IF;
    END IF;
    RETURN v_condition;
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'DANGKY',
    policy_name      => 'avoid_insert_policy',
    policy_function  => 'SV_avoid_insert_policy',
    statement_types  => 'INSERT, DELETE',
    update_check    => TRUE,
    enable          => TRUE);
END;
/
BEGIN
    DBMS_RLS.DROP_POLICY(
        object_schema => 'AD',  -- replace with your schema name
        object_name => 'DANGKY',  -- replace with your table name
        policy_name => 'avoid_insert_policy'  -- replace with your policy name
    );
END;

--create or replace function FUNC_SV_Insert (P_SCHEMA varchar2, P_OBJ varchar2)
--return varchar2
--as
--    user varchar(100);
--    is_dba VARCHAR2(5);
--    role VARCHAR(2);
--    MAHP_LIST VARCHAR2(2000);
--    HK_LIST VARCHAR2(2000);
--    NAM_LIST VARCHAR2(2000);
--    MACT_LIST VARCHAR2(2000);
--    MAHP CHAR(4);
--    HK CHAR(1);
--    NAM CHAR(4);
--    MACT VARCHAR2(4); -- MACT = (SELECT MACT FROM AD.SINHVIEN where MASV = sys_context('userenv','session_user')) AND
--    CURSOR CUR IS (select MAHP, HK, NAM, MACT from AD.KHMO WHERE FUNC_DATE(HK, NAM) > (SYSDATE - 120) AND FUNC_DATE(HK, NAM) < SYSDATE);
--begin
--    --RETURN 'MAHP IN (select MAHP from AD.KHMO;)';
--    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
--    IF is_dba = 'TRUE' THEN
--        RETURN ' ';
--    else
--        user := sys_context('userenv','session_user');
--        role := substr(user,1,2);
--        IF ROLE = 'SV' THEN
--            OPEN CUR;
--            LOOP 
--                FETCH CUR INTO MAHP, HK, NAM, MACT;
--                EXIT WHEN CUR%NOTFOUND;
--              
--                IF (MAHP_LIST IS NOT NULL) THEN 
--                    MAHP_LIST := MAHP_LIST ||''', '''; 
--                END IF; 
--                IF (HK_LIST IS NOT NULL) THEN 
--                    HK_LIST := HK_LIST ||''', '''; 
--                END IF; 
--                IF (NAM_LIST IS NOT NULL) THEN 
--                    NAM_LIST := NAM_LIST ||''', '''; 
--                END IF; 
--                IF (MACT_LIST IS NOT NULL) THEN 
--                    MACT_LIST := MACT_LIST ||''', '''; 
--                END IF; 
--                MAHP_LIST := MAHP_LIST || MAHP;
--                HK_LIST := HK_LIST || HK;
--                NAM_LIST := NAM_LIST || NAM;
--                MACT_LIST := MACT_LIST || MACT;
--                
--            END LOOP;
--            CLOSE CUR;
--            RETURN 'MAHP IN ('''|| MAHP_LIST ||''') AND HK IN ('''|| HK_LIST ||''') AND NAM IN ('''|| NAM_LIST ||''') AND MACT IN ('''|| MACT_LIST ||''')';
--        else
--            RETURN '1 = 0';
--        end if;
--    end if;
--end;
--/


create or replace function FUNC_SV_Insert (P_SCHEMA varchar2, P_OBJ varchar2)
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
    MACT VARCHAR2(4); -- MACT = (SELECT MACT FROM AD.SINHVIEN where MASV = sys_context('userenv','session_user')) AND
    CURSOR CUR IS (select MAHP, HK, NAM, MACT from AD.KHMO WHERE FUNC_DATE(HK, NAM) > (SYSDATE - 120) AND FUNC_DATE(HK, NAM) < SYSDATE);
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN ' ';
    else
        user := sys_context('userenv','session_user');
        role := substr(user,1,2);
        IF ROLE = 'SV' THEN
            OPEN CUR;
            LOOP 
                FETCH CUR INTO MAHP, HK, NAM, MACT;
                EXIT WHEN CUR%NOTFOUND;
              
                IF (MAHP_LIST IS NOT NULL) THEN 
                    MAHP_LIST := MAHP_LIST ||''', '''; 
                END IF; 
                MAHP_LIST := MAHP_LIST || MAHP;
                
            END LOOP;
            CLOSE CUR;
            RETURN 'MAHP IN ('''|| MAHP_LIST ||''')';
        else
            RETURN '1 = 0';
        end if;
    end if;
end;
/

select FUNC_SV_Insert('ad','dangky') from dual;

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'DANGKY',
    policy_name     => 'SV_Insert',
    function_schema => 'AD',
    policy_function => 'FUNC_SV_Insert',
    statement_types => 'INSERT',
    update_check    => TRUE,
    enable          => TRUE
  );
END;
/

BEGIN
    DBMS_RLS.DROP_POLICY(
        object_schema => 'AD',  -- replace with your schema name
        object_name => 'DANGKY',  -- replace with your table name
        policy_name => 'SV_Insert'  -- replace with your policy name
    );
END;
