using System;
using System.Diagnostics;
using System.Threading;
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
        public static System.Threading.Timer backupTimer;
        public static bool autobackup = false;

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
        public static void backup(object state)
        {
            if (!autobackup) return;
            string command = "/C cd /D D:/backup/ && backup.bat"; // Change directory and run your command here
            ProcessStartInfo procStartInfo = new ProcessStartInfo("CMD.exe", command);
            procStartInfo.RedirectStandardOutput = true;
            procStartInfo.UseShellExecute = false;
            procStartInfo.CreateNoWindow = true;
            Process proc = new Process();
            proc.StartInfo = procStartInfo;
            proc.Start();

            // Get the output into a string
            string result = proc.StandardOutput.ReadToEnd();
            MessageBox.Show(result + "Check the backup.log in D:/backup");
        }
        static void Main()
        {
            // Create a TimerCallback delegate that specifies the method to be executed
            TimerCallback tcb = backup;
            // Create a new Timer that calls the backup method every 5 minutes
            backupTimer = new System.Threading.Timer(tcb, null, 0, 5 * 60 * 1000);

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new LoginForm());
        }
    }
}