-- Code xóa những bảng đã tồn tại
DECLARE
   tables_to_drop   DBMS_SQL.VARCHAR2_TABLE
      := DBMS_SQL.VARCHAR2_TABLE ('SINHVIEN', 'DONVI', 'NHANSU','HOCPHAN','KHMO','PHANCONG','DANGKY');
BEGIN
   FOR i IN 1 .. tables_to_drop.COUNT
   LOOP
      BEGIN
         EXECUTE IMMEDIATE 'DROP TABLE ' || tables_to_drop (i) || ' CASCADE CONSTRAINTS';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
END;
/

CREATE TABLE SINHVIEN (
    MASV CHAR(6),
    HOTEN NVARCHAR2(30),
    PHAI NVARCHAR2(3),
    NGSINH DATE,
    DCHI NVARCHAR2(50),
    DT CHAR(10),
    MACT VARCHAR2(4),
    MANGANH VARCHAR2(10),
    SOTCTL INT,
    DTBTL FLOAT,
    
    PRIMARY KEY (MASV),
    constraint SV_PHAI check (PHAI = N'Nam' or PHAI = N'Nữ'),
    constraint SV_SOTC check (SOTCTL >= 0),
    constraint SV_DTB check (DTBTL >= 0)
);

CREATE TABLE DONVI (
    MADV CHAR(4),
    TENDV NVARCHAR2(30),
    TRGDV CHAR(5),
    
    PRIMARY KEY(MADV)
);

create table NHANSU
(
    MANV CHAR(5),
    HOTEN nvarchar2(30),
    PHAI nvarchar2(3),
    NGSINH date,
    PHUCAP float,
    DT char(10),
    VAITRO nvarchar2(20),
    MADV CHAR(4),
    
    PRIMARY KEY (MANV),
    constraint NHANSU_Phai check (PHAI = N'Nam' OR PHAI = N'Nữ'),
    constraint FK_NHANSU_DONVI foreign key (MADV) references DONVI(MADV)
);

Alter table DONVI
Add constraint FK_DONVI_TRGDV foreign key (TRGDV) references NHANSU(MANV);

CREATE TABLE HOCPHAN (
    MAHP CHAR(4),
    TENHP NVARCHAR2(60),
    SOTC INT,
    STLT INT,
    STTH INT,
    SOSVTD INT,
    MADV CHAR(4),
    
    PRIMARY KEY (MAHP),
    constraint HP_NUMBER CHECK (SOTC >= 0 and STLT >= 0 and STTH >= 0 and SOSVTD >= 0),
    constraint FK_HP_DV foreign key (MADV) references DONVI(MADV)
);

CREATE TABLE KHMO (
    MAHP CHAR(4),
    HK INT,
    NAM INT,
    MACT VARCHAR2(4),
    
    PRIMARY KEY (MAHP, HK, NAM, MACT),
    constraint KHMO_NUM check (HK >= 0 and NAM >= 0)
);

CREATE TABLE PHANCONG (
    MAGV CHAR(5),
    MAHP CHAR(4),
    HK INT,
    NAM INT,
    MACT VARCHAR2(4),
    PRIMARY KEY (MAGV, MAHP, HK, NAM, MACT),
    constraint PHANCONG_NUM check (HK >= 0 and NAM >= 0),
    constraint FK_PC_NS foreign key (MAGV) references NHANSU(MANV),
    constraint FK_PC_HP foreign key (MAHP) references HOCPHAN(MAHP)
);

CREATE TABLE DANGKY (
    MASV CHAR(6),
    MAGV CHAR(5),
    MAHP CHAR(4),
    HK INT,
    NAM INT,
    MACT VARCHAR2(4),
    DIEMTH FLOAT,
    DIEMQT FLOAT,
    DIEMCK FLOAT,
    DIEMTK FLOAT,
    
    PRIMARY KEY (MASV, MAGV, MAHP, HK, NAM, MACT),
    constraint FK_DK_SV foreign key (MASV) references SINHVIEN(MASV),
    constraint FK_DK_NS foreign key (MAGV) references NHANSU(MANV),
    constraint FK_DK_HP foreign key (MAHP) references HOCPHAN(MAHP),
    constraint DK_NUM check (HK >=0 and NAM >= 0)
);