import random

text = """update DONVI set TRGDV = {0} where MADV = {1};\n"""
# text_val = text.format(EmployeeDict["N'Trưởng khoa'"][2][0],1)
# File.write(text_val)
# for i in range(1,len(DONVI_TRG)):
#     text = """update DONVI set TRGDV = {0} where MADV = {1};\n"""
#     text_val = text.format(DONVI_TRG[i], i + 1)
#     File.write(text_val)



diemth = round(random.uniform(0.0,10.0),2)
print(diemth)




MACS = 'CS1' if random.randint(0,1) == 1 else 'CS2'
print(MACS)