alter session set current_schema = sv0001;
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

create user SV0001 identified by SV0001;
grant create session to SV0001;
--select * from DANGKY where MASV = 'SV0001'

create user SV0002 identified by SV0002;
grant create session to SV0002;
grant SinhVien to SV0002;

-- change to sinh vien user to test this one
-- alter session set current_schema = SV0001;
select * from ad.SINHVIEN;
select * from ad.DANGKY;

update SINHVIEN set DT = '0906858115';

--create TruongKhoa
create user NV003 identified by NV003;
grant create session to NV003;
grant TruongKhoa to NV003;

select vaitro from ad.NHANSU where manv = 'nv001'; -- sys_context('userenv','current_user');
select * from ad.DANGKY;
select * from ad.PHANCONG;
select * from ad.DONVI;
select * from ad.HOCPHAN;
select * from ad.SINHVIEN;


select VAITRO from ad.VIEW_THONGTIN_NVCB;


SELECT distinct GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS WHERE GRANTEE like '%SV%' and GRANTED_ROLE <> 'CONNECT';

select * from dba_roles where role like 'RL%';

select * from ad.DANGKY, NHANSU where manv = magv and vaitro like 'Giảng viên';

select * from ad.VIEW_TDV_PC_GV , ad.VIEW_TDV_PC;

select * from ad.VIEW_GV_DK where masv = 'SV0105' and magv = sys_context('userenv','current_user') and hk = 2 and nam = 2020 and mact = 'CLC';

update ad.VIEW_GV_DK set diemck = '10' where masv = 'SV0105' and magv = 'NV012' and hk = 2 and nam = 2020 and mact = 'CLC';

insert into ad.DANGKY(MASV,MAHP,HK,NAM,MACT) 
values ('SV0001','HP39',3,2024,'CTTT')