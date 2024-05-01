using System;
using System.Diagnostics;
using System.Windows.Forms;

namespace ATBM_A_14
{
    public partial class Recovery : Form
    {
        public Recovery()
        {
            InitializeComponent();
        }
        // instant backup
        private void button5_Click(object sender, EventArgs e)
        {
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
        // auto backup
        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            Program.autobackup = checkBox1.Checked;
        }
        // recover
        private void button3_Click(object sender, EventArgs e)
        {

        }
        // load backup files
        private void Recovery_Load(object sender, EventArgs e)
        {
            string folderPath = @"D:\oracle_fra\XE\AUTOBACKUP\2024_05_01";
            string[] fileNames = System.IO.Directory.GetFiles(folderPath);
            foreach (string fileName in fileNames)
            {
                comboBox1.Items.Add(System.IO.Path.GetFileName(fileName));
            }
        }
        // refresh 
        private void button1_Click(object sender, EventArgs e)
        {
            comboBox1.Items.Clear();
            Recovery_Load(sender, e);
        }
    }
}
