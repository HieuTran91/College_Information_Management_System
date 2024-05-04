using System;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    internal static class Program
    {
        public static OracleConnection conn;
        // public static string connectionString = ""; // just variable, dont touch
        public static string username = ""; // just variable, dont touch
        public static string password = ""; // just variable, dont touch

        // config here
        public static string HOST = "localhost";
        public static string SERVICE = "xe"; // SID is also fine here
        public static string PORT = "1521";
        public static string SCHEMA = "ad";
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new LoginForm());
        }
    }
}
