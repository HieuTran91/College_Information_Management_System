using System;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    internal static class Program
    {
        public static OracleConnection conn;
        public static string username = ""; // just variable, dont touch
        public static string password = ""; // just variable, dont touch
        public static Human human = null;
        public static string masv = "";
        public static string manv = "";
        public static string mact = "";

        // config here
        public static string HOST = "localhost";
        public static string SERVICE = "xe"; // SID is also fine here
        public static string PORT = "1521";
        public static string SCHEMA = "ad";

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]

        public static int getHK()
        {
            int currentMonth = DateTime.Now.Month;
            if (currentMonth >= 1 && currentMonth <= 5) return 1;
            else if (currentMonth >= 6 && currentMonth <= 9) return 2;
            return 3;
        }
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new LoginForm());
        }
    }
}