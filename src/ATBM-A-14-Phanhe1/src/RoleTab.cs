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
    public partial class RoleTab : Form
    {
        public RoleTab()
        {
            InitializeComponent();
        }
        private void RoleTab_Load(object sender, EventArgs e)
        {
            string sql = "SELECT * FROM DBA_ROLES";
            OracleCommand command = new OracleCommand(sql, Program.conn);

            DataTable data2 = new DataTable();
            OracleDataAdapter adapter = new OracleDataAdapter(command);
            adapter.Fill(data2);
            dataGridView1.DataSource = data2;
        }

        private void search_Click(object sender, EventArgs e)
        {
            string sql = $"SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = UPPER('{textBox1.Text}')";
            OracleCommand command = new OracleCommand(sql, Program.conn);
            try
            {
                DataTable data = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView2.DataSource = data;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void button1_Click(object sender, EventArgs e) // for refresh
        {
            string sql = $"SELECT * FROM DBA_ROLES";
            OracleCommand command = new OracleCommand(sql, Program.conn);

            DataTable data2 = new DataTable();
            OracleDataAdapter adapter = new OracleDataAdapter(command);
            adapter.Fill(data2);
            dataGridView1.DataSource = data2;
        }
    }
}