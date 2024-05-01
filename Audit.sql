alter session set current_schema = ad;
alter session set container = PDB_ATBMHTTT;

--SELECT * FROM v$option where PARAMETER like '%Audit%'

show parameter audit;
show con_name;
show parameter audit_trail;

-- STANDARD AUDIT
-- xem các audit đã được ghi

select * from DBA_FGA_AUDIT_TRAIL order by extended_timestamp;
select * from dba_audit_trail where OWNER = 'AD' order by extended_timestamp;

-- audit trên đối tượng cụ thể và chỉ định thành công
AUDIT SELECT ON AD.NHANSU BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT ON AD.PHANCONG BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT ON AD.KHMO BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT ON AD.DANGKY BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT ON AD.SINHVIEN BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT ON AD.DONVI BY ACCESS WHENEVER SUCCESSFUL;
AUDIT SELECT ON AD.HOCPHAN BY ACCESS WHENEVER SUCCESSFUL;
AUDIT UPDATE ON AD.THONGBAO BY ACCESS WHENEVER SUCCESSFUL;

select * from AD.NHANSU;

-- NOAUDIT SELECT ON AD.SINHVIEN WHENEVER SUCCESSFUL; -- cancel audit

-- FINE-GRAINED AUDIT
-- xem policy audit đã được tạo
SELECT * FROM DBA_AUDIT_POLICIES;

-- Hành vi Cập nhật quan hệ ĐANGKY tại các trường liên quan đến điểm số nhưng người đó không thuộc vai trò Giảng viên. 
CREATE OR REPLACE FUNCTION FUNC_IS_GIANGVIEN 
RETURN NUMBER
AS USER_ROLE NVARCHAR2(20);
    User_name varchar2(6);
    role_user varchar2(2);
BEGIN
    User_name := SYS_CONTEXT('USERENV','SESSION_USER');
    role_user := substr(user,1,2);
    if role_user = 'NV' then
        SELECT VAITRO INTO USER_ROLE
        FROM AD.VIEW_THONGTIN_NVCB;
        
        if(USER_ROLE = 'Giảng viên') then
            return 1;
        end if;
        return 0;
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

BEGIN
    DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_PROPERTY(
    DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
    DBMS_AUDIT_MGMT.AUDIT_TRAIL_WRITE_MODE,
    DBMS_AUDIT_MGMT.AUDIT_TRAIL_IMMEDIATE_WRITE);
END;
/

select EVENT_TIMESTAMP, ACTION_NAME, RMAN_SESSION_RECID,
RMAN_SESSION_STAMP, RMAN_OPERATION, RMAN_OBJECT_TYPE, RMAN_DEVICE_TYPE
from unified_audit_trail where ACTION_NAME like '%RMAN%' order by 1;