-- Người dùng có VAITRO là “Giảng viên” có quyền truy cập dữ liệu
-- Như một người dùng có vai trò “Nhân viên cơ bản” (xem mô tả CS#1). 
-- Xem dữ liệu phân công giảng dạy liên quan đến bản thân mình (PHANCONG). 
-- Xem dữ liệu trên quan hệ ĐANGKY liên quan đến các lớp học phần mà giảng viên  được phân công giảng dạy. 
-- Cập nhật dữ liệu tại các trường liên quan điểm số (trong quan hệ ĐANGKY) của các sinh viên có tham gia lớp học phần mà giảng viên đó được phân công giảng dạy. Các trường liên quan điểm số bao gồm: ĐIEMTH, ĐIEMQT, ĐIEMCK, ĐIEMTK.
alter session set current_schema = ad;

--select * from sys.nhansu;

alter session set current_schema = ad;

CREATE OR REPLACE VIEW VIEW_GV_PC AS
SELECT *
FROM PHANCONG
WHERE MAGV = SYS_CONTEXT('USERENV', 'SESSION_USER'); 

CREATE OR REPLACE VIEW VIEW_GV_DK AS
SELECT *
FROM DANGKY
WHERE MAGV = SYS_CONTEXT('USERENV', 'SESSION_USER'); 

-- Xem dữ liệu phân công giảng dạy liên quan đến bản thân mình (PHANCONG). 
GRANT SELECT ON VIEW_GV_PC TO RL_GIANGVIEN;
-- Xem dữ liệu trên quan hệ ĐANGKY liên quan đến các lớp học phần mà giảng viên  được phân công giảng dạy. 
GRANT SELECT ON VIEW_GV_DK TO RL_GIANGVIEN;
-- Cập nhật dữ liệu tại các trường liên quan điểm số (trong quan hệ ĐANGKY) của các sinh viên có tham gia lớp học phần mà giảng viên đó được phân công giảng dạy. Các trường liên quan điểm số bao gồm: ĐIEMTH, ĐIEMQT, ĐIEMCK, ĐIEMTK.
GRANT UPDATE(DIEMTH, DIEMQT, DIEMCK, DIEMTK) ON VIEW_GV_DK TO RL_GIANGVIEN;

-- Như một người dùng có vai trò “Nhân viên cơ bản” (xem mô tả CS#1).
grant select on SINHVIEN to RL_GIANGVIEN;
grant select on DONVI to RL_GIANGVIEN;
grant select on HOCPHAN to RL_GIANGVIEN;
grant select on KHMO to RL_GIANGVIEN;
GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_GIANGVIEN;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_GIANGVIEN;

grant RL_GIANGVIEN to NV006

select * from nhansu


grant RL_TDV to NV004


-- TRƯỞNG ĐƠN VỊ
-- Như một người dùng có vai trò “Giảng viên” (xem mô tả CS#2)
GRANT UPDATE(DIEMTH, DIEMQT, DIEMCK, DIEMTK) ON VIEW_GV_DK TO RL_TDV;
GRANT SELECT ON VIEW_GV_PC TO RL_TDV;
GRANT SELECT ON VIEW_GV_DK TO RL_TDV;
grant select on SINHVIEN to RL_TDV;
grant select on DONVI to RL_TDV;
grant select on HOCPHAN to RL_TDV;
grant select on KHMO to RL_TDV;
GRANT SELECT ON VIEW_THONGTIN_NVCB TO RL_TDV;
GRANT UPDATE(DT) ON VIEW_THONGTIN_NVCB TO RL_TDV;

-- Thêm, Xóa, Cập nhật dữ liệu trên quan hệ PHANCONG, đối với các học phần được  phụ trách chuyên môn bởi đơn vị mà mình làm trưởng, 

CREATE OR REPLACE VIEW VIEW_TDV_PC AS
SELECT PC.*
FROM DONVI dv join HOCPHAN hp on hp.madv = dv.madv join PHANCONG pc ON pc.mahp = hp.mahp
WHERE dv.trgdv = SYS_CONTEXT('USERENV', 'SESSION_USER'); 

GRANT SELECT, INSERT, DELETE, UPDATE ON VIEW_TDV_PC TO RL_TDV;

-- Được xem dữ liệu phân công giảng dạy của các giảng viên thuộc các đơn vị mà mình làm trưởng. 
CREATE OR REPLACE VIEW VIEW_TDV_PC_GV AS
SELECT PC.*
FROM DONVI dv join NHANSU NS ON ns.madv = dv.madv JOIN PHANCONG PC ON pc.magv = ns.manv
WHERE dv.trgdv = SYS_CONTEXT('USERENV', 'SESSION_USER'); 

GRANT SELECT ON VIEW_TDV_PC_GV TO RL_TDV;
