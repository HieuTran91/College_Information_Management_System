using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
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
            string user = username.Text;
            // FROM DBA_SYS_PRIVS ?? DBA_TAB_PRIVS ? 
            string sql1 = $"SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = UPPER('{user}')";
            command = new OracleCommand(sql1, Program.conn);

            DataTable data2 = new DataTable();
            adapter = new OracleDataAdapter(command);
            adapter.Fill(data2);
            dataGridView2.DataSource = data2;
        }

        private void button1_Click(object sender, EventArgs e) // for refresh
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
    }
}
