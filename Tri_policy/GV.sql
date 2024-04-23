alter session set current_schema = NV009;

select * from ad.V_NVCB;

select * from ad.sinhvien;

select * from ad.donvi;

select * from AD.hocphan;

select * from ad.khmo;

select * from ad.phancong where mahp = 'HP26' AND MAGV = 'NV012';

SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') FROM DUAL;
SELECT SYS_CONTEXT('USERENV', 'ISDBA') FROM DUAL;

UPDATE ad.PHANCONG
SET MACT = 'VP'
WHERE MAGV = 'NV048' AND MAHP = 'HP01' AND HK = 1 AND NAM = 2020;

UPDATE ad.PHANCONG
SET MACT = 'TT'
WHERE MAGV = 'NV012' AND MAHP = 'HP26' AND HK = 2 AND NAM = 2023;

select * from ad.dangky where masv = 'SV0499' ;

DELETE FROM AD.DANGKY
WHERE MASV = 'SV0499'    -- Replace 'SV0499' with the specific student ID
AND MAGV = 'NV048'       -- Replace 'NV048' with the specific lecturer ID
AND MAHP = 'HP14'        -- Replace 'HP14' with the specific course ID
AND HK = 2              -- Replace 1 with the specific semester value
AND NAM = 2024           -- Replace 2020 with the specific year value
AND MACT = 'CLC';

insert into AD.DANGKY(MASV,MAGV,MAHP,HK,NAM,MACT,DIEMTH,DIEMQT,DIEMCK,DIEMTK) values('SV0499','NV048','HP14',2,2020,'CLC',1.17,8.79,4.11,4.69);