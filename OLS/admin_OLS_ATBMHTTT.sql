BEGIN
    SA_SYSDBA.DROP_POLICY(
        policy_name     => 'notification_policy',
        drop_column     => TRUE
    );
END;
/

--BEGIN
--    SA_SYSDBA.DROP_POLICY(
--        policy_name     => 'nhansu_policy',
--        drop_column     => TRUE
--    );
--END;
--/

BEGIN 
    SA_SYSDBA.CREATE_POLICY( 
    policy_name => 'notification_policy',  
    column_name => 'notification_label' 
    ); 
END;

BEGIN
    SA_SYSDBA.DROP_POLICY(
        policy_name => 'notification_policy',  -- replace with your policy name
        drop_column=> true
    );
END;

EXEC SA_SYSDBA.ENABLE_POLICY ('notification_policy'); 

-- create level
EXECUTE SA_COMPONENTS.CREATE_LEVEL('notification_policy',120,'TK', 'TRUONG KHOA'); 
EXECUTE SA_COMPONENTS.CREATE_LEVEL('notification_policy',100,'TDV','TRUONG DON VI'); 
EXECUTE SA_COMPONENTS.CREATE_LEVEL('notification_policy',80,'GVN','GIAO VIEN');
EXECUTE SA_COMPONENTS.CREATE_LEVEL('notification_policy',60,'GV','GIAO VU');
EXECUTE SA_COMPONENTS.CREATE_LEVEL('notification_policy',40,'NV','NHAN VIEN');
EXECUTE SA_COMPONENTS.CREATE_LEVEL('notification_policy',20,'SV','SINH VIEN');

-- create compartment
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('notification_policy',5,'HTTT','HE THONG THONG TIN'); 
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('notification_policy',10,'CNPM','CONG NGHE PHAN MEM'); 
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('notification_policy',15,'KHMT','KHOA HOC MAY TINH'); 
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('notification_policy',20,'CNTT','CONG NGHE THONG TIN'); 
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('notification_policy',25,'TGMT','THI GIAC MAY TINH'); 
EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('notification_policy',30,'MMT','MANG MAY TINH'); 

-- create group
EXECUTE SA_COMPONENTS.CREATE_GROUP('notification_policy',10,'CS1','CO SO 1'); 
EXECUTE SA_COMPONENTS.CREATE_GROUP('notification_policy',15,'CS2','CO SO 2');

--BEGIN 
--SA_SYSDBA.CREATE_POLICY( 
--policy_name => 'nhansu_policy',  
--column_name => 'nhansu_label' 
--); 
--END;
--
--EXEC SA_SYSDBA.ENABLE_POLICY ('nhansu_policy'); 
--
--EXECUTE SA_COMPONENTS.CREATE_LEVEL('nhansu_policy',120,'TK', 'TRUONG KHOA'); 
--EXECUTE SA_COMPONENTS.CREATE_LEVEL('nhansu_policy',100,'TDV','TRUONG DON VI'); 
--EXECUTE SA_COMPONENTS.CREATE_LEVEL('nhansu_policy',80,'GVN','GIAO VIEN');
--EXECUTE SA_COMPONENTS.CREATE_LEVEL('nhansu_policy',60,'GV','GIAO VU');
--EXECUTE SA_COMPONENTS.CREATE_LEVEL('nhansu_policy',40,'NV','NHAN VIEN');
--EXECUTE SA_COMPONENTS.CREATE_LEVEL('nhansu_policy',20,'SV','SINH VIEN');
--
---- create compartment
--EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('nhansu_policy',5,'HTTT','HE THONG THONG TIN'); 
--EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('nhansu_policy',10,'CNPM','CONG NGHE PHAN MEM'); 
--EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('nhansu_policy',15,'KHMT','KHOA HOC MAY TINH'); 
--EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('nhansu_policy',20,'CNTT','CONG NGHE THONG TIN'); 
--EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('nhansu_policy',25,'TGMT','THI GIAC MAY TINH'); 
--EXECUTE SA_COMPONENTS.CREATE_COMPARTMENT('nhansu_policy',30,'MMT','MANG MAY TINH'); 
--
---- create group
--EXECUTE SA_COMPONENTS.CREATE_GROUP('nhansu_policy',10,'CS1','CO SO 1'); 
--EXECUTE SA_COMPONENTS.CREATE_GROUP('nhansu_policy',15,'CS2','CO SO 2');

--create table NHANSU_OLS
--(
--    MANV CHAR(5),
--    HOTEN nvarchar2(30),
--    VAITRO nvarchar2(20),
--    COSO NVARCHAR2(10),
--    
--    PRIMARY KEY (MANV),
--    constraint NHANSU_Phai check (PHAI = N'Nam' OR PHAI = N'Nữ')
--);

CREATE TABLE SINHVIEN_OLS (
    MASV CHAR(6),
    HOTEN NVARCHAR2(30),
    MANGANH VARCHAR2(10),
    COSO NVARCHAR2(10),
    
    PRIMARY KEY (MASV)
);

create table NHANSU_OLS
(
    MANV CHAR(5),
    VAITRO nvarchar2(20),
    MADV CHAR(4),
    COSO NVARCHAR2(10),
    
    PRIMARY KEY (MANV)
);

--DROP TABLE NHANSU_OLS;

INSERT INTO NHANSU_OLS(MANV, VAITRO, MADV, COSO) VALUES('NV001', 'TK', 'HTTT', 'CS1');
INSERT INTO NHANSU_OLS(MANV, VAITRO, MADV, COSO) VALUES('NV002', 'NV', 'HTTT', 'CS2');

CREATE USER NV001 IDENTIFIED BY 123;
CREATE USER NV002 IDENTIFIED BY 123;

GRANT CONNECT TO NV001, NV002;
GRANT SELECT ON ADMIN_OLS.THONGBAO_OLS TO NV001, NV002;



create table THONGBAO_OLS
(
    MATB CHAR(5),
    NOIDUNG NVARCHAR2(200),
    VAITRO nvarchar2(4),
    MADV CHAR(4),
    COSO NVARCHAR2(4),
    
    PRIMARY KEY (MATB)
);


INSERT INTO ADMIN_OLS.THONGBAO_OLS (MATB, NOIDUNG, VAITRO, MADV, COSO)
VALUES ('A0001', 'Thông báo 1 - nội dung mẫu', 'TK', 'HTTT', 'CS1');
INSERT INTO ADMIN_OLS.THONGBAO_OLS (MATB, NOIDUNG, VAITRO, MADV, COSO)
VALUES ('A0002', 'Thông báo 2 - nội dung khác', 'NV', 'HTTT', 'CS2');
INSERT INTO ADMIN_OLS.THONGBAO_OLS (MATB, NOIDUNG, VAITRO, MADV, COSO)
VALUES ('A0003', 'Thông báo 3 - nội dung khác', 'GV', NULL, NULL);
INSERT INTO ADMIN_OLS.THONGBAO_OLS (MATB, NOIDUNG, VAITRO, MADV, COSO)
VALUES ('A0004', 'Thông báo 3 - nội dung khác', 'TK', NULL, NULL);

BEGIN
 SA_POLICY_ADMIN.APPLY_TABLE_POLICY (
 POLICY_NAME => 'NOTIFICATION_POLICY',
 SCHEMA_NAME => 'ADMIN_OLS',
 TABLE_NAME => 'THONGBAO_OLS',
 TABLE_OPTIONS => 'NO_CONTROL'
 );
END; 

SELECT * FROM ADMIN_OLS.THONGBAO_OLS;

UPDATE ADMIN_OLS.THONGBAO_OLS
SET notification_label = CHAR_TO_LABEL('NOTIFICATION_POLICY','TK:HTTT:CS1')
WHERE MATB = 'A0001'; 
UPDATE ADMIN_OLS.THONGBAO_OLS
SET notification_label = CHAR_TO_LABEL('NOTIFICATION_POLICY','NV:HTTT:CS2')
WHERE MATB = 'A0002'; 
UPDATE ADMIN_OLS.THONGBAO_OLS
SET notification_label = CHAR_TO_LABEL('NOTIFICATION_POLICY','GV::')
WHERE MATB = 'A0003'; 

BEGIN
    SA_POLICY_ADMIN.REMOVE_TABLE_POLICY('notification_policy', 'admin_ols', 'THONGBAO_OLS');
    SA_POLICY_ADMIN.APPLY_TABLE_POLICY (
        policy_name    => 'notification_policy',
        schema_name    => 'ADMIN_OLS', 
        table_name     => 'THONGBAO_OLS',
        table_options  => 'READ_CONTROL',
        PREDICATE => NULL
    );
END;
/

BEGIN
 SA_USER_ADMIN.SET_USER_LABELS('notification_policy','NV001','TK::');
END; 

BEGIN
 SA_USER_ADMIN.SET_USER_LABELS('notification_policy','NV002','NV:HTTT:CS2');
END; 

BEGIN
 SA_USER_ADMIN.SET_USER_LABELS('notification_policy','ADMIN_OLS','TK,GV');
END; 

UPDATE THONGBAO_OLS
SET NOTIFICATION_LABEL = CHAR_TO_LABEL('NOTIFICATION_POLICY','TK');

UPDATE THONGBAO_OLS
SET MATB = MATB;

--SELECT * FROM USER_POLICIES;



-- CHECK
--SELECT * FROM DBA_SA_LEVELS; 
--SELECT * FROM DBA_SA_COMPARTMENTS; 
--SELECT * FROM DBA_SA_GROUPS; 
--SELECT * FROM DBA_SA_GROUP_HIERARCHY; 

CREATE OR REPLACE FUNCTION gen_notification_label(MATB VARCHAR2, VAITRO VARCHAR2, DONVI VARCHAR2, COSO VARCHAR2)
RETURN lbacsys.lbac_label AS
label VARCHAR(20);
CURSOR CUR IS (SELECT )
BEGIN
    label := VAITRO || ':' || DONVI || ':' || COSO;
    RETURN to_lbac_data_label('notification_policy', label);
END;

SELECT * FROM ALL_SA_LABELS;
--/
--
--GRANT EXECUTE ON gen_notification_label TO PUBLIC;
--
----GRANT INHERIT PRIVILEGES ON USER SYS TO ORDSYS;
--
--BEGIN
--    SA_POLICY_ADMIN.REMOVE_TABLE_POLICY('notification_policy', 'admin_ols', 'THONGBAO_OLS');
--    SA_POLICY_ADMIN.APPLY_TABLE_POLICY (
--        policy_name    => 'notification_policy',
--        schema_name    => 'ADMIN_OLS', 
--        table_name     => 'THONGBAO_OLS',
--        table_options  => 'ALL_CONTROL',
--        label_function => 'ADMIN_OLS.gen_notification_label(:new.MATB, :new.VAITRO, :new.DONVI, :new.COSO)'
--    );
--END;
--/


