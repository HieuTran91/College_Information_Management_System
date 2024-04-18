using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Configuration;
using Oracle.ManagedDataAccess.Client;
using System.Data.SqlTypes;

namespace ATBM_A_14
{
    public partial class LoginForm : Form
    {
        public LoginForm()
        {
            InitializeComponent();
        }

        private void Click_Click(object sender, EventArgs e)
        {
            string _username = username.Text;
            string _password = password.Text;
            if (_username == "" || _password == "")
            {
                MessageBox.Show("Empty username or password is not allowed !!!");
                return;
            }
            string conn_str = $"Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST={Program.HOST})(PORT={Program.PORT})))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME={Program.SERVICE})));User Id={_username};Password={_password};";
            try
            {
                OracleConnection conn = new OracleConnection(conn_str);
                conn.Open();
                Program.conn = conn;
                Program.username = _username;
                Program.password = _password;

                // if else here for each user each form

                this.Hide();
                if (_username == Program.SCHEMA)
                {
                    conn.Close(); // close the current one and make a new one
                    conn_str = $"Data Source=(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST={Program.HOST})(PORT={Program.PORT})))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME={Program.SERVICE})));User Id={_username};Password={_password};DBA Privilege=SYSDBA;";
                    conn = new OracleConnection(conn_str); // log as SYSDBA
                    conn.Open(); // open it again

                    Program.conn = conn;

                    Admin_Menu userTab = new Admin_Menu();
                    userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                    userTab.Show();
                }
                else if (_username.ToUpper().Contains("NV"))
                {
                    string sql = $"SELECT VAITRO FROM {Program.SCHEMA}.NHANSU WHERE MANV = '{_username.ToUpper()}'";
                    OracleCommand cmd = new OracleCommand(sql, Program.conn);
                    string role = cmd.ExecuteScalar().ToString();
                    //  MessageBox.Show(role + " code: " + sql);

                    // if else for specific tab
                    if (role.Contains("Nhân viên cơ bản"))
                    {
                        NVCB_MENU userTab = new NVCB_MENU();
                        userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                        userTab.Show();
                    }
                    if (role.Contains("Giáo vụ"))
                    {
                        GIAOVU_MENU userTab = new GIAOVU_MENU();
                        userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                        userTab.Show();
                    }
                    if (role.Contains("Giáo viên"))
                    {
                        NVCB_MENU userTab = new NVCB_MENU();
                        userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                        userTab.Show();
                    }
                    if (role.Contains("Trưởng đơn vị"))
                    {
                        NVCB_MENU userTab = new NVCB_MENU();
                        userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                        userTab.Show();
                    }
                    if (role.Contains("Trưởng khoa"))
                    {
                        NVCB_MENU userTab = new NVCB_MENU();
                        userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                        userTab.Show();
                    }
                    // do some sql to check if a table exist to the user
                }
                else if (_username.ToUpper().Contains("SV"))
                {
                    SV_MENU userTab = new SV_MENU();
                    userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                    userTab.Show();
                }
                else
                {
                    SV_MENU userTab = new SV_MENU();
                    userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                    userTab.Show();
                }
                // Program.conn.Close();
            }
            catch (OracleException ex)
            {
                if (ex.Message.Contains("ORA-28009")) MessageBox.Show("We don't use highest SYSDBA here, pls use another lower SYSDBA account");
                else MessageBox.Show($"Failed to connect: {ex.Message}");
            }
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }
    }
}

