import json
import oracledb
from fakeLib import *

with open('config.json', 'r') as json_file:
    json_data = json.load(json_file)

connection = oracledb.connect(
    user=json_data['username'],
    password=json_data['password'],
    dsn=f"localhost/{json_data['pdb_name']}")

print("Successfully connected to Oracle Database")

connection.autocommit = True # make it automatically
cursor = connection.cursor()
File = open("DataGen.sql",'w',encoding='utf-8')

#-----------------CLEAR DATA
command = """
DELETE FROM SINHVIEN;
DELETE FROM DONVI;
DELETE FROM NHANSU;
DELETE FROM HOCPHAN;
DELETE FROM KHMO;
DELETE FROM PHANCONG;
DELETE FROM DANGKY;
"""
# cursor.execute("DELETE FROM SINHVIEN")
# cursor.execute("DELETE FROM DONVI")
# cursor.execute("DELETE FROM NHANSU")
# cursor.execute("DELETE FROM HOCPHAN")
# cursor.execute("DELETE FROM KHMO")
# cursor.execute("DELETE FROM PHANCONG")
# cursor.execute("DELETE FROM DANGKY")

File.write(command)

print("Start gen ... ")

#----------------GEN SINHVIEN
command = """
{0}
"""
temp = ""

for i in range(1, student_size + 1):
    student_id = f"SV{i:04}"
    student_list.append(student_id)
    name = gen_name(30)
    phai = gen_gender()
    ngsinh = gen_birthday(18,21)
    dchi = gen_address(50)
    dt = gen_phone()
    MACT = gen_MACT()
    MANGANH = gen_MANGANH()
    SOTC = random.randint(0,138)
    DTB = round(random.uniform(5.0,10.0),2)
    MACS = 'CS1' if random.randint(0,1) == 1 else 'CS2'
    text = """insert into SINHVIEN (MASV,HOTEN,PHAI,NGSINH,DCHI,DT,MACT,MANGANH,SOTCTL,DTBTL,MACS) values('{9}',{0},{1},TO_DATE({2},'YY-MM-DD'),{3},{4},{5},{6},{7},{8},'{10}')"""
    text_val = text.format(name,phai,ngsinh,dchi, dt, MACT, MANGANH, random.randint(0,138),DTB,student_id,MACS)
    temp += text_val + ";\n"
    # cursor.execute(text_val)

command = command.format(temp)
File.write(command)

#---------------GEN DONVI
dv_cnt = 0
dvList = []
for i in DONVI_name:
    dv_cnt += 1
    madv = f"DV{dv_cnt:02}"
    dvList.append(madv)
    text = f"insert into DONVI(MADV,TENDV) values('{madv}',{i});\n"
    File.write(text)

#--------------GEN NHANSU
for i in range(1,EmployeeSize + 1):
    manv = f"NV{i:03}"
    name = gen_name(30)
    phai = gen_gender()
    ngsinh = gen_birthday(21,65)
    dchi = gen_address(50)
    dt = gen_phone()
    phucap = round(random.uniform(0.0,5.0),1)
    vaitro = gen_ROLE(manv)
    madv = ""
    MACS = 'CS1' if random.randint(0,1) == 1 else 'CS2'
    if vaitro == "N'Nhân viên cơ bản'" or vaitro == "N'Giáo vụ'": madv = "DV01"
    elif vaitro == "N'Trưởng đơn vị'": madv = f"DV{len(DONVI_TRG) + 1:02}" if len(DONVI_TRG) > 0 else "DV01"
    else: madv = f"DV{random.choice([2,3,4,5,6,7]):02}"
    text = """insert into NHANSU(MANV,HOTEN,PHAI,NGSINH,PHUCAP,DT,VAITRO,MADV,MACS) values('{7}',{0},{1},TO_DATE({2},'YY-MM-DD'),{3},{4},{5},'{6}','{8}');\n"""
    text_val = text.format(name,phai,ngsinh,phucap,dt,vaitro,madv,manv,MACS)
    File.write(text_val)

#--------------UPDATE DONVI
text = """update DONVI set TRGDV = '{0}' where MADV = '{1}';\n"""
text_val = text.format(EmployeeDict["N'Trưởng khoa'"][2][0],dvList[0])
File.write(text_val)
for i in range(2,len(DONVI_name) + 1):
    text = """update DONVI set TRGDV = '{0}' where MADV = '{1}';\n"""
    text_val = text.format(EmployeeDict["N'Trưởng đơn vị'"][2][i - 2], dvList[i - 1])
    File.write(text_val)
    
#-------------GEN HOCPHAN
cnt = 0
HocPhan = []
for key,val in HocPhanList.items():
    cnt += 1
    mahp = f"HP{cnt:02}"
    HocPhan.append(mahp)
    text  = """insert into HOCPHAN(MAHP,TENHP,SOTC,STLT,STTH,SOSVTD,MADV) values('{6}',{0},{1},{2},{3},{4},'{5}');\n"""
    text_val = text.format(key,val[0],random.randint(40,50),random.randint(20,25),random.randint(30,100),random.choice(dvList),mahp)
    File.write(text_val)

#-------------GEN KHMO
while len(KHMOlist) < KHMOsize:
    text = """insert into KHMO(MAHP,HK,NAM,MACT) values('{0}',{1},{2},{3});\n"""
    hp = random.choice(HocPhan)
    hk = random.randint(1,3)
    nam = random.randint(2020,2024)
    mact = gen_MACT()
    KHMOlist.add((hp,hk,nam,mact))
    text_val = text.format(hp,hk,nam,mact)
    File.write(text_val)

#------------GEN PHANCONG
while len(PHANCONGlist) < PHANCONGsize:
    text = """insert into PHANCONG(MAGV,MAHP,HK,NAM,MACT) values('{0}','{1}',{2},{3},{4});\n"""
    magv = random.choice(EmployeeDict["N'Giảng viên'"][2])
    hp = random.choice(HocPhan)
    hk = random.randint(1,3)
    nam = random.randint(2020,2024)
    mact = gen_MACT()
    PHANCONGlist.add((magv,hp,hk,nam,mact))
    text_val = text.format(magv,hp,hk,nam,mact)
    File.write(text_val)

#------------GEN DANGKY
combined_employees = []
combined_employees.extend(EmployeeDict["N'Giảng viên'"])
combined_employees.extend(EmployeeDict["N'Trưởng đơn vị'"])
combined_employees.extend(EmployeeDict["N'Trưởng khoa'"])
while len(DANGKYlist) < DANGKYsize:
    text = """insert into DANGKY(MASV,MAGV,MAHP,HK,NAM,MACT,DIEMTH,DIEMQT,DIEMCK,DIEMTK) values('{0}','{1}','{2}',{3},{4},{5},{6},{7},{8},{9});\n"""
    masv = random.choice(student_list)
    magv = random.choice(combined_employees[2])
    hp = random.choice(HocPhan)
    hk = random.randint(1,3)
    nam = random.randint(2020,2024)
    mact = gen_MACT()
    diemth = round(random.uniform(0.0,10.0),2)
    diemqt = round(random.uniform(0.0,10.0),2)
    diemck = round(random.uniform(0.0,10.0),2)
    diemTK = round(sum([diemth,diemqt,diemck]) / 3,2)
    DANGKYlist.add((masv,magv,hp,hk,nam,mact,diemth,diemqt,diemck,diemTK))
    text_val = text.format(masv,magv,hp,hk,nam,mact,diemth,diemqt,diemck,diemTK)
    File.write(text_val)


print("Gen finished !")
cursor.close()
connection.close()