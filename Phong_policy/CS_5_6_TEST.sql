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

select * from ad.VIEW_GV_PC;

select * from dba_roles where role like 'RL%';

select * from ad.DANGKY, NHANSU where manv = magv and vaitro like 'Giảng viên';

select * from ad.VIEW_TDV_PC_GV , ad.VIEW_TDV_PC;

select * from ad.VIEW_GV_DK where masv = 'SV0105' and magv = sys_context('userenv','current_user') and hk = 2 and nam = 2020 and mact = 'CLC';

update ad.VIEW_GV_DK set diemck = '10' where masv = 'SV0105' and magv = 'NV012' and hk = 2 and nam = 2020 and mact = 'CLC';

select * from ad.PHANCONG where HK = FUNC_HK() and NAM = to_char(sysdate,'YYYY'); -- asasasdasdasdasd

insert into ad.DANGKY(MASV,MAGV,MAHP,HK,NAM,MACT)
values ('SV0003',null,'HP10',null,to_char(sysdate,'YYYY'),null);

--a asdasdasdasdasd
select * from AD.PHANCONG WHERE HK = FUNC_HK() AND NAM = TO_CHAR(SYSDATE, 'YYYY') and MAHP = 'HP10';

select pc.MAGV,pc.HK,pc.NAM,pc.MACT  from AD.PHANCONG pc join ad.KHMO kh on pc.MAHP = kh.MAHP and pc.NAM = kh.NAM and pc.HK = kh.HK
WHERE pc.HK = FUNC_HK() AND pc.NAM = TO_CHAR(SYSDATE, 'YYYY') and pc.MAHP = 'HP39' and ROWNUM = 1;

select * from ad.DANGKY where MAHP = 'HP23' and NAM = to_char(sysdate,'YYYY') and HK = func_hk(); -- asdasdasdasd

select func_hk() from dual;

select to_char(sysdate,'YY') from dual;

SELECT *
    FROM ad.HOCPHAN
    WHERE MAHP = 'HP48';