alter session set current_schema = ad;

show parameter audit;

show parameter audit_trail;

-- STANDARD AUDIT
-- xem các audit đã được ghi

select * from DBA_FGA_AUDIT_TRAIL order by extended_timestamp;
select * from dba_audit_trail where OWNER = 'AD' order by extended_timestamp;

-- audit trên đối tượng cụ thể và chỉ định thành công
AUDIT SELECT ON AD.NHANSU BY ACCESS WHENEVER SUCCESSFUL;
AUDIT UPDATE ON AD.NHANSU BY ACCESS WHENEVER SUCCESSFUL;

-- FINE-GRAINED AUDIT
-- xem policy audit đã được tạo
SELECT * FROM DBA_AUDIT_POLICIES;


-- Hành vi Cập nhật quan hệ ĐANGKY tại các trường liên quan đến điểm số nhưng người đó không thuộc vai trò Giảng viên. 
CREATE OR REPLACE FUNCTION FUNC_IS_GIANGVIEN 
RETURN NUMBER
AS USER_ROLE NVARCHAR2(20);
BEGIN
    SELECT VAITRO INTO USER_ROLE
    FROM AD.VIEW_THONGTIN_NVCB;
    
    if(USER_ROLE = 'Giảng viên') then
        return 1;
    end if;
    return 0;
END;
/


begin
DBMS_FGA.ADD_POLICY(
    OBJECT_SCHEMA => 'AD',
    OBJECT_NAME => 'DANGKY',
    POLICY_NAME => 'DANGKY_GIANGVIEN_FUNC',
    AUDIT_CONDITION => 'FUNC_IS_GIANGVIEN!=1',
    AUDIT_COLUMN => 'DIEMTH, DIEMQT, DIEMCK, DIEMTK',
    ENABLE => TRUE,
    STATEMENT_TYPES => 'UPDATE');
end;
/

-- Hành vi của người dùng này có thể đọc trên trường PHUCAP của người khác ở quan hệ NHANSU.
begin
DBMS_FGA.ADD_POLICY(
    OBJECT_SCHEMA => 'AD',
    OBJECT_NAME => 'NHANSU',
    POLICY_NAME => 'TT_PHUCAP',
    AUDIT_CONDITION => 'SYS_CONTEXT(''USERENV'',''SESSION_USER'') != MANV',
    AUDIT_COLUMN => 'PHUCAP',
    ENABLE => TRUE,
    STATEMENT_TYPES => 'SELECT');
end;
/