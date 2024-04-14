alter session set current_schema = ad;
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

select * from NHANSU;
select * from DANGKY;
select * from PHANCONG;
select * from DONVI;
select * from HOCPHAN;
select * from SINHVIEN;