alter session set current_schema = SV0001;

SELECT * FROM AD.KHMO;

select * from ad.hocphan;

select * from ad.sinhvien;

update ad.sinhvien set MANGANH = 'KHMT';

update ad.sinhvien set DT = '0999999999';

select * from ad.dangky;

SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') FROM DUAL;
SELECT SYS_CONTEXT('USERENV', 'ISDBA') FROM DUAL;

delete from AD.DANGKY WHERE hk = 1 and nam = 2024;

select MAHP, HK, NAM, MACT from AD.KHMO WHERE FUNC_DATE(HK, NAM) > (SYSDATE - 120) AND FUNC_DATE(HK, NAM) < SYSDATE

insert into AD.DANGKY(MASV,MAGV,MAHP,HK,NAM,MACT,DIEMTH,DIEMQT,DIEMCK,DIEMTK) values('SV0001','NV080','HP21',1,2024,'CTTT',NULL,NULL,NULL,NULL);

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
    CURSOR CUR IS (select MAHP from AD.KHMO WHERE FUNC_DATE(HK, NAM) > (SYSDATE - 120) AND FUNC_DATE(HK, NAM) < SYSDATE);
begin
    RETURN 'MAHP IN (select MAHP from AD.KHMO)';
--    is_dba := SYS_CONTEXT('USERENV', 'ISDBA');
--    IF is_dba = 'TRUE' THEN
--        RETURN ' ';
--    else
--        user := sys_context('userenv','session_user');
--        role := substr(user,1,2);
--        IF ROLE = 'SV' THEN
--            OPEN CUR;
--            LOOP 
--                FETCH CUR INTO MAHP, HK, NAM, MACT;
--                EXIT WHEN CUR%NOTFOUND;
--              
--                IF (MAHP_LIST IS NOT NULL) THEN 
--                    MAHP_LIST := MAHP_LIST ||''', '''; 
--                END IF; 
--                IF (HK_LIST IS NOT NULL) THEN 
--                    HK_LIST := HK_LIST ||''', '''; 
--                END IF; 
--                IF (NAM_LIST IS NOT NULL) THEN 
--                    NAM_LIST := NAM_LIST ||''', '''; 
--                END IF; 
--                IF (MACT_LIST IS NOT NULL) THEN 
--                    MACT_LIST := MACT_LIST ||''', '''; 
--                END IF; 
--                MAHP_LIST := MAHP_LIST || MAHP;
--                HK_LIST := HK_LIST || HK;
--                NAM_LIST := NAM_LIST || NAM;
--                MACT_LIST := MACT_LIST || MACT;
--                
--            END LOOP;
--            CLOSE CUR;
--            RETURN 'MAHP IN ('''|| MAHP_LIST ||''') AND HK IN ('''|| HK_LIST ||''') AND NAM IN ('''|| NAM_LIST ||''') AND MACT IN ('''|| MACT_LIST ||''')';
--        else
--            RETURN '1 = 0';
--        end if;
--    end if;
end;
/
select FUNC_SV_Insert('ad','dangky') from dual;

