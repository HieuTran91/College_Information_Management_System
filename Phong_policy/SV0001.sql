alter session set current_schema = SV0001;

SELECT * FROM AD.KHMO;

select * from ad.hocphan;

select * from ad.sinhvien;

update AD.sinhvien set MANGANH = 'KHMT';

update ad.sinhvien set DT = '0999999999';

select * from ad.dangky;

SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') FROM DUAL;
SELECT SYS_CONTEXT('USERENV', 'ISDBA') FROM DUAL;

--DELETE AD.DANGKY WHERE DIEMQT IS NULL AND MASV = 'SV0001';

insert into AD.DANGKY(MASV,MAGV,MAHP,HK,NAM,MACT) values('SV0001','NV080','HP21',1,2024,'CTTT');
