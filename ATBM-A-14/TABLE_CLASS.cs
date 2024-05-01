using System;
using System.Collections.Generic;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public abstract class Human
    {
        private static Dictionary<string, (Human, Form)> SubClassList = new Dictionary<string, (Human,Form)>
        {
            {"Nhân viên cơ bản", (new NVCB(), new NVCB_MENU())},
            {"Giảng viên", (new GIANGVIEN(), new GIANGVIEN_MENU())},
            {"Giáo vụ", (new GIAOVU(), new GIAOVU_MENU())},
            {"Trưởng đơn vị", (new TDV(), new TDV_MENU())},
            {"Trưởng khoa", (new TK(), new TK_MENU())},
            {"Sinh viên", (new SINHVIEN(), new SV_MENU())}
        };
        public static Human getClass(string role) => SubClassList[role].Item1;
        public static Form getForm(string role) => (Form)Activator.CreateInstance(SubClassList[role].Item2.GetType());
        public abstract string PHANCONG();
        public abstract string DANGKY();
        public abstract string getName();
    }
    public class NVCB : Human
    {
        public override string PHANCONG() => "PHANCONG";
        public override string DANGKY() => "DANGKY";

        public override string getName() => "Nhân viên cơ bản";
    }
    public class SINHVIEN : Human
    {
        public override string PHANCONG() => "";
        public override string DANGKY() => "DANGKY";

        public override string getName() => "Sinh viên";
    }
    public class GIANGVIEN : NVCB
    {
        public override string PHANCONG() => "VIEW_GV_PC";
        public override string DANGKY() => "VIEW_GV_DK";

        public override string getName() => "Giảng viên";
    }
    public class GIAOVU : NVCB
    {
        public override string PHANCONG() => "PHANCONG";
        public override string DANGKY() => "DANGKY";
        public override string getName() => "Giáo vụ";
    }
    public class TDV : GIANGVIEN
    {
        public override string PHANCONG() => $"VIEW_TDV_PC_GV,{Program.SCHEMA}.VIEW_TDV_PC";
        public override string DANGKY() => "VIEW_GV_DK";
        public override string getName() => "Trưởng đơn vị";
    }
    public class TK : GIANGVIEN
    {
        public string PC_CRUD() => "VIEW_TK_PC";
        public override string PHANCONG() => "PHANCONG"; // VIEW_TK_PC
        public override string DANGKY() => "DANGKY";
        public override string getName() => "Trưởng khoa";
    }
}