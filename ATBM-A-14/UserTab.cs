using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class UserTab : Form
    {
        OracleDataAdapter adapter;
        OracleCommand command;
        public UserTab()
        {
            InitializeComponent();
        }
        private void UserTab_Load(object sender, EventArgs e)
        {
            try
            {
                string sql = $"select * from DBA_USERS"; // for system table we dont need schema
                command = new OracleCommand(sql, Program.conn);

                DataTable data = new DataTable();
                adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView1.DataSource = data;
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void search_Click(object sender, EventArgs e)
        {
            // dba_sys_privs
            string sql1 = "select * from dba_tab_privs where grantee = :username";
            command = new OracleCommand(sql1, Program.conn);
            command.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = username.Text.ToUpper();
            
            DataTable data2 = new DataTable();
            adapter = new OracleDataAdapter(command);
            adapter.Fill(data2);
            dataGridView2.DataSource = data2;
        }

        private void button1_Click(object sender, EventArgs e) // for refresh
        {
            UserTab_Load(sender, e);
        }
    }
}
