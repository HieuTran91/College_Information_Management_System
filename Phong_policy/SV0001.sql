alter session set current_schema = SV0001;

SELECT * FROM AD.KHMO;

select * from ad.hocphan;

select * from ad.sinhvien;

update ad.sinhvien set MANGANH = 'KHMT';

update ad.sinhvien set DT = '0999999999';

select * from ad.dangky;

SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') FROM DUAL;
SELECT SYS_CONTEXT('USERENV', 'ISDBA') FROM DUAL;

delete from AD.DANGKY WHERE hk = 2;

insert into AD.DANGKY(MASV,MAGV,MAHP,HK,NAM,MACT,DIEMTH,DIEMQT,DIEMCK,DIEMTK) values('SV0001','NV029','HP21',1,2024,'CTTT',8.98,5.23,7.74,7.32);
