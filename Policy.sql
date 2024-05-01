alter session set current_schema = ad;

show con_name;

------Yêu cầu 1: Cấp quyền truy cập 

--select * from AD.NHANSU;

-- DROP USERS

--BEGIN
--  FOR user_rec IN (
--    SELECT username
--    FROM dba_users
--    WHERE username LIKE 'NV%' OR username LIKE 'SV%'
--  ) LOOP
--    -- Add additional checks and validations here if necessary
--    EXECUTE IMMEDIATE 'DROP USER ' || user_rec.username || ' CASCADE'; 
--  END LOOP;
--END;
--/

-- tạo user

CREATE OR REPLACE PROCEDURE USP_CREATENHANVIEN authid current_user
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
    LOOP 
        FETCH CUR INTO USR; 
        EXIT WHEN CUR%NOTFOUND; 
             
        STRSQL := 'CREATE USER '||USR||' IDENTIFIED BY 123'; 
        EXECUTE IMMEDIATE(STRSQL); 
        STRSQL := 'GRANT CONNECT TO '||USR; 
        EXECUTE IMMEDIATE(STRSQL); 
        
        -- do some if else to grant specific role here
    END LOOP; 
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
    LOOP 
        FETCH CUR INTO USR; 
        EXIT WHEN CUR%NOTFOUND; 
             
        STRSQL := 'CREATE USER '||USR||' IDENTIFIED BY 123'; 
        EXECUTE IMMEDIATE(STRSQL); 
        STRSQL := 'GRANT CONNECT TO '||USR; 
        EXECUTE IMMEDIATE(STRSQL);
        
    END LOOP;  
    CLOSE CUR; 
END; 
/

exec USP_CREATESINHVIEN;
exec USP_CREATENHANVIEN;



-- kiểm tra user đã tạo
SELECT username, created FROM dba_users where username like 'SV%' or username like 'NV%';

--tạo role
create role RL_NVCB;
create role RL_GIAOVU;
create role RL_GIANGVIEN;
create role RL_TDV;
create role RL_TK;
create role RL_SV;

---- test audit
--select * from dangky;

-- gán role cho user
CREATE OR REPLACE PROCEDURE GRANT_ROLE_TO_SV authid current_user
AS 
    CURSOR CUR IS (SELECT MASV FROM SINHVIEN); 
    STRSQL VARCHAR(2000); 
    USR VARCHAR2(6);
BEGIN 
    OPEN CUR;
    LOOP 
        FETCH CUR INTO USR; 
        EXIT WHEN CUR%NOTFOUND; 
             
        STRSQL := 'GRANT RL_SV TO '|| USR; 
        EXECUTE IMMEDIATE(STRSQL);     
    END LOOP;
    CLOSE CUR;
END; 
/

EXEC GRANT_ROLE_TO_SV;

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
        IF ROLE_USR = N'Nhân viên cơ bản' THEN
            STRSQL := 'GRANT RL_NVCB TO '||USR; 
        END IF;
        IF ROLE_USR = N'Giảng viên' THEN
            STRSQL := 'GRANT RL_GIANGVIEN TO '||USR; 
        END IF;
        IF ROLE_USR = N'Giáo vụ' THEN
            STRSQL := 'GRANT RL_GIAOVU TO '||USR; 
        END IF;
        IF ROLE_USR = N'Trưởng đơn vị' THEN
            STRSQL := 'GRANT RL_TDV TO '||USR; 
        END IF;
        IF ROLE_USR = N'Trưởng khoa' THEN
            STRSQL := 'GRANT RL_TK TO '||USR; 
        END IF;
        EXECUTE IMMEDIATE(STRSQL);     
    END LOOP; 
    CLOSE CUR;
END;
/

EXEC GRANT_ROLE_TO_NV;

--
--revoke select on ad.nhansu from RL_NVCB
-- cs1: Người dùng có VAITRO là “Nhân viên cơ bản” 

---- Xem thông tin của tất cả SINHVIEN, ĐƠNVỊ, HOCPHAN, KHMO. 

grant select on ad.SINHVIEN to RL_NVCB;
grant select on ad.DONVI to RL_NVCB;
grant select on ad.HOCPHAN to RL_NVCB;
grant select on ad.KHMO to RL_NVCB;


-- grant select on ad.NHANSU to RL_NVCB; -- này lỗi rồi nhé 

---- Xem dòng dữ liệu của chính mình trong quan hệ NHANSU, có thể chỉnh sửa số điện thoại (ĐT) của chính mình (nếu số điện thoại có thay đổi). 

CREATE or replace VIEW VIEW_THONGTIN_NVCB AS
SELECT *
FROM ad.NHANSU
WHERE MaNV = SYS_CONTEXT('USERENV', 'SESSION_USER');

GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_NVCB;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_NVCB;

-- cs2: Người dùng có VAITRO là “Giảng viên”

---- Như một người dùng có vai trò “Nhân viên cơ bản” (xem mô tả CS#1).
grant select on ad.SINHVIEN to RL_GIANGVIEN;
grant select on ad.DONVI to RL_GIANGVIEN;
grant select on ad.HOCPHAN to RL_GIANGVIEN;
grant select on ad.KHMO to RL_GIANGVIEN;
GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_GIANGVIEN;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_GIANGVIEN;

---- Xem dữ liệu phân công giảng dạy liên quan đến bản thân mình (PHANCONG).

CREATE OR REPLACE VIEW VIEW_GV_PC AS
SELECT *
FROM ad.PHANCONG
WHERE MAGV = SYS_CONTEXT('USERENV', 'SESSION_USER'); 

GRANT SELECT ON VIEW_GV_PC TO RL_GIANGVIEN;

---- Xem dữ liệu trên quan hệ ĐANGKY liên quan đến các lớp học phần mà giảng viên được phân công giảng dạy. 
CREATE OR REPLACE VIEW VIEW_GV_DK AS
SELECT *
FROM ad.DANGKY
WHERE MAGV = SYS_CONTEXT('USERENV', 'SESSION_USER'); 

GRANT SELECT ON VIEW_GV_DK TO RL_GIANGVIEN;

---- Cập nhật dữ liệu tại các trường liên quan điểm số (trong quan hệ ĐANGKY) của các sinh viên có tham gia lớp học phần mà giảng viên đó được phân công giảng dạy. Các trường liên quan điểm số bao gồm: ĐIEMTH, ĐIEMQT, ĐIEMCK, ĐIEMTK. 
GRANT UPDATE(DIEMTH, DIEMQT, DIEMCK, DIEMTK) ON VIEW_GV_DK TO RL_GIANGVIEN;



-- cs3: Người dùng có VAITRO là “Giáo vụ”
---- Như một người dùng có vai trò “Nhân viên cơ bản” (xem mô  tả CS#1). 
grant select on ad.SINHVIEN to RL_GIAOVU;
grant select on ad.DONVI to RL_GIAOVU;
grant select on ad.HOCPHAN to RL_GIAOVU;
grant select on ad.KHMO to RL_GIAOVU;
GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_NVCB;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_NVCB;

---- Xem, Thêm mới hoặc Cập nhật dữ liệu trên các quan hệ SINHVIEN, ĐONVI, HOCPHAN, KHMO, theo yêu cầu của trưởng khoa.
grant select,insert,update on ad.SINHVIEN to RL_GIAOVU;
grant select,insert,update on ad.DONVI to RL_GIAOVU;
grant select,insert,update on ad.HOCPHAN to RL_GIAOVU;
grant select,insert,update on ad.KHMO to RL_GIAOVU;

---- Xem dữ liệu trên toàn bộ quan hệ PHANCONG. Tuy nhiên, chỉ được sửa trên các dòng dữ liệu phân công liên quan các học phần do “Văn phòng khoa” phụ trách phân công giảng dạy, thừa hành người trưởng đơn vị tương ứng là trưởng khoa. 
grant select,update on ad.PHANCONG to RL_GIAOVU;

---- Xóa hoặc Thêm mới dữ liệu trên quan hệ ĐANGKY theo yêu cầu của sinh viên trong khoảng thời gian còn cho hiệu chỉnh đăng ký, xem điều kiện có thể hiệu chỉnh đăng ký học phần được mô tả bên dưới.
grant insert, delete, select on ad.DANGKY to RL_GIAOVU;

-- Grant quyền cho những role thừa hành
grant RL_NVCB to RL_GIAOVU;
grant RL_NVCB to RL_GIANGVIEN;
grant RL_GIANGVIEN to RL_TDV;
grant RL_GIANGVIEN to RL_TK;

--- Hàm tính ngày bắt đầu của học kì

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
/

-- get hoc ky hien tai
CREATE OR REPLACE FUNCTION FUNC_HK
RETURN INT
IS
    l_hoc_ky_start_date DATE;
BEGIN
    CASE
        WHEN TO_NUMBER(TO_CHAR(SYSDATE, 'MM')) BETWEEN 1 AND 5 THEN
            RETURN 1; -- Fall semester
        WHEN TO_NUMBER(TO_CHAR(SYSDATE, 'MM')) BETWEEN 5 AND 9 THEN
            RETURN 2; -- Spring semester
        ELSE
            RETURN 3; -- Summer semester
    END CASE;
END;
/

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
/

DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'PHANCONG'
  AND POLICY_NAME = 'GV_PHANCONG'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'PHANCONG',
      policy_name     => 'GV_PHANCONG'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
/

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
/

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

DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'DANGKY'
  AND POLICY_NAME = 'GV_Delete'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'DANGKY',
      policy_name     => 'GV_Delete'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
/

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

DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'DANGKY'
  AND POLICY_NAME = 'GV_Insert'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'DANGKY',
      policy_name     => 'GV_Insert'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
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




--cs4: Người dùng có VAITRO là “Trưởng đơn vị”

---- Như một người dùng có vai trò “Giảng viên”  
grant select on ad.SINHVIEN to RL_TDV;
grant select on ad.DONVI to RL_TDV;
grant select on ad.HOCPHAN to RL_TDV;
grant select on ad.KHMO to RL_TDV;

GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_TDV;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_TDV;

GRANT SELECT ON VIEW_GV_PC TO RL_TDV;
GRANT SELECT ON VIEW_GV_DK TO RL_TDV;
GRANT UPDATE(DIEMTH, DIEMQT, DIEMCK, DIEMTK) ON VIEW_GV_DK TO RL_TDV;

----Thêm, Xóa, Cập nhật dữ liệu trên quan hệ PHANCONG, đối với các học phần được phụ trách chuyên môn bởi đơn vị mà mình làm trưởng, 
CREATE OR REPLACE VIEW VIEW_TDV_PC AS
SELECT PC.*
FROM ad.DONVI dv join ad.HOCPHAN hp on hp.madv = dv.madv join ad.PHANCONG pc ON pc.mahp = hp.mahp
WHERE dv.trgdv = SYS_CONTEXT('USERENV', 'SESSION_USER'); 

GRANT SELECT, INSERT, DELETE, UPDATE ON VIEW_TDV_PC TO RL_TDV;

---- Được xem dữ liệu phân công giảng dạy của các giảng viên thuộc các đơn vị mà mình làm trưởng.  
CREATE OR REPLACE VIEW VIEW_TDV_PC_GV AS
SELECT PC.*
FROM ad.DONVI dv join ad.NHANSU NS ON ns.madv = dv.madv JOIN ad.PHANCONG PC ON pc.magv = ns.manv
WHERE dv.trgdv = SYS_CONTEXT('USERENV', 'SESSION_USER'); 

GRANT SELECT ON VIEW_TDV_PC_GV TO RL_TDV;

--cs5: Người dùng có VAITRO là “Trưởng khoa” 

---- Như một người dùng có vai trò “Giảng viên”  
grant select on ad.SINHVIEN to RL_TK;
grant select on ad.DONVI to RL_TK;
grant select on ad.HOCPHAN to RL_TK;
grant select on ad.KHMO to RL_TK;

GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_TK;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_TK;

GRANT SELECT ON VIEW_GV_PC TO RL_TK;
GRANT SELECT ON VIEW_GV_DK TO RL_TK;
GRANT UPDATE(DIEMTH, DIEMQT, DIEMCK, DIEMTK) ON VIEW_GV_DK TO RL_TK;

---- Thêm, Xóa, Cập nhật dữ liệu trên quan hệ PHANCONG đối với các học phần quản lý bởi đơn vị “Văn phòng khoa”. 
CREATE OR REPLACE VIEW VIEW_TK_PC AS
SELECT PC.*
FROM ad.DONVI DV JOIN ad.HOCPHAN HP ON hp.madv = dv.madv JOIN ad.PHANCONG PC ON pc.mahp = hp.mahp
WHERE dv.tendv = 'VĂN PHÒNG KHOA' AND dv.trgdv = SYS_CONTEXT('USERENV', 'SESSION_USER');

GRANT SELECT, DELETE, UPDATE, INSERT ON VIEW_TK_PC TO RL_TK;


---- Được quyền Xem, Thêm, Xóa, Cập nhật trên quan hệ NHANSU. 
grant select, update, delete on NHANSU to RL_TK;


---- Được quyền Xem (không giới hạn) dữ liệu trên toàn bộ lược đồ CSDL.
grant select on ad.SINHVIEN to RL_TK;
grant select on ad.DANGKY to RL_TK;
grant select on ad.KHMO to RL_TK;
grant select on ad.HOCPHAN to RL_TK;
grant select on ad.DONVI to RL_TK;

--revoke update on ad.DANGKY from RL_TK;

-- cs6: Người dùng có VAITRO là “Sinh viên”

---- Trên quan hệ SINHVIEN, sinh viên chỉ được xem thông tin của chính mình, được Chỉnh sửa thông tin địa chỉ (ĐCHI) và số điện thoại liên lạc (ĐT) của chính sinh viên.
GRANT SELECT ON AD.SINHVIEN TO RL_SV;
GRANT UPDATE(DT, DCHI) ON AD.SINHVIEN TO RL_SV;

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
            return '1 = 1';
        end if;
    end if;
end;
/

DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'SINHVIEN'
  AND POLICY_NAME = 'SV_SV'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'SINHVIEN',
      policy_name     => 'SV_SV'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
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

-- Xem danh sách tất cả học phần (HOCPHAN), kế hoạch mở môn (KHMO) của chương trình đào tạo mà sinh viên đang theo học. 
GRANT SELECT ON AD.KHMO TO RL_SV;
GRANT SELECT ON AD.HOCPHAN TO RL_SV;

create or replace function FUNC_SV_KHMO (P_SCHEMA varchar2, P_OBJ varchar2)
return varchar2
as
    user varchar(100);
    is_dba VARCHAR2(5);
    role VARCHAR(2);
    MA VARCHAR2(4);
    STRSQL VARCHAR2(20000);
    CURSOR CUR IS (SELECT MACT FROM AD.SINHVIEN where masv = sys_context('userenv','session_user'));
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
            RETURN '1 = 1';
        end if;
    end if;
end;
/

DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'KHMO'
  AND POLICY_NAME = 'SV_KHMO'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'KHMO',
      policy_name     => 'SV_KHMO'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
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


DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'HOCPHAN'
  AND POLICY_NAME = 'SV_HP'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'HOCPHAN',
      policy_name     => 'SV_HP'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
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


---- Sinh viên được Xem tất cả thông tin trên quan hệ ĐANGKY tại các dòng dữ liệu liên quan đến chính sinh viên. 
GRANT SELECT ON AD.DANGKY TO RL_SV;

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
            return '1 = 1';
        end if;
    end if;
end;
/


DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'DANGKY'
  AND POLICY_NAME = 'SV_DK'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'DANGKY',
      policy_name     => 'SV_DK'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
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

---- Thêm, Xóa các dòng dữ liệu đăng ký học phần (ĐANGKY) liên quan đến chính sinh viên đó trong học kỳ của năm học hiện tại (nếu thời điểm hiệu chỉnh đăng ký còn hợp lệ).  
---- Sinh viên không được chỉnh sửa trên các trường liên quan đến điểm. 
---- Sinh viên có thể hiệu chỉnh đăng ký học phần (thêm, xóa) nếu ngày hiện tại không vượt quá 14 ngày so với ngày bắt đầu học kỳ (xem thêm thông tin về học kỳ trong quan hệ KHMO) mà sinh viên đang hiệu chỉnh đăng ký học phần. 
GRANT DELETE ON AD.DANGKY TO RL_SV;
GRANT INSERT ON AD.DANGKY TO RL_SV;

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
    CURSOR CUR IS (select MASV, MAGV, MAHP, HK, NAM from AD.DANGKY WHERE MASV = sys_context('userenv','session_user') AND FUNC_DATE(HK, NAM) > (SYSDATE - 15) AND FUNC_DATE(HK, NAM) < SYSDATE AND DIEMQT IS NULL AND DIEMTH IS NULL AND DIEMCK IS NULL AND DIEMTK IS NULL);
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
            RETURN '1 = 1';
        end if;
    end if;
end;
/

DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'DANGKY'
  AND POLICY_NAME = 'SV_Delete'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'DANGKY',
      policy_name     => 'SV_Delete'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
/

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
    MACT VARCHAR2(4);
    CURSOR CUR IS (select MAHP, HK, NAM, MACT from AD.KHMO WHERE MACT = (SELECT MACT FROM AD.SINHVIEN where MASV = sys_context('userenv','session_user')) AND FUNC_DATE(HK, NAM) > (SYSDATE - 15) AND FUNC_DATE(HK, NAM) < SYSDATE);
begin
    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
    IF is_dba = 'TRUE' THEN
        RETURN '';
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
            RETURN 'MAHP IN ('''|| MAHP_LIST ||''') AND HK IN ('''|| HK_LIST ||''') AND NAM IN ('''|| NAM_LIST ||''') AND MACT IN ('''|| MACT_LIST ||''') AND DIEMQT IS NULL AND DIEMTH IS NULL AND DIEMCK IS NULL AND DIEMTK IS NULL';
        else
            RETURN '1 = 1';
        end if;
    end if;
end;
/

DECLARE
  policy_exists NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO policy_exists
  FROM ALL_POLICIES
  WHERE OBJECT_NAME = 'DANGKY'
  AND POLICY_NAME = 'SV_Insert'
  AND OBJECT_OWNER = 'AD';

  IF policy_exists > 0 THEN
    DBMS_RLS.DROP_POLICY(
      object_schema   => 'AD',
      object_name     => 'DANGKY',
      policy_name     => 'SV_Insert'
    );
    DBMS_OUTPUT.PUT_LINE('Policy dropped.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Policy does not exist.');
  END IF;
END;
/

BEGIN
  DBMS_RLS.ADD_POLICY (
    object_schema   => 'AD',
    object_name     => 'DANGKY',
    policy_name     => 'SV_Insert',
    policy_function => 'FUNC_SV_Insert',
    statement_types => 'INSERT',
    update_check    => TRUE,
    enable => TRUE
  );
END;
/

-- trigger for insertion into DANGKY
CREATE OR REPLACE TRIGGER trg_insert_dangky
BEFORE INSERT ON AD.DANGKY
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    IF :NEW.MAGV IS NOT NULL THEN
        SELECT COUNT(*)
        INTO v_count
        FROM AD.PHANCONG
        WHERE MAGV = :NEW.MAGV
        AND MAHP = :NEW.MAHP
        AND HK = :NEW.HK
        AND NAM = :NEW.NAM
        AND MACT = :NEW.MACT;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Môn học chưa được phân công cho giáo viên');
        END IF;
    END IF;
    IF :NEW.MAGV IS NULL THEN
        SELECT COUNT(*)
        INTO v_count
        FROM AD.PHANCONG
        WHERE MAHP = :NEW.MAHP
        AND HK = :NEW.HK
        AND NAM = :NEW.NAM
        AND MACT = :NEW.MACT;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Môn học chưa được mở');
        ELSE
            SELECT MAGV
            INTO :NEW.MAGV
            FROM AD.PHANCONG
            WHERE MAHP = :NEW.MAHP
            AND HK = :NEW.HK
            AND NAM = :NEW.NAM
            AND MACT = :NEW.MACT
            AND ROWNUM = 1;
        END IF;
    END IF;
END;
/

-- drop trigger trg_insert_dangky;