using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Configuration;
using Oracle.ManagedDataAccess.Client;

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
            OracleConnection conn = new OracleConnection(conn_str);
            try
            {
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
                else if (_username.Contains("NV"))
                {
                    NV_MENU userTab = new NV_MENU();
                    userTab.Closed += (s, args) => this.Show(); // Close Form1 when Form2 is closed
                    userTab.Show();
                }
                else if (_username.Contains("SV"))
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
    }
}

