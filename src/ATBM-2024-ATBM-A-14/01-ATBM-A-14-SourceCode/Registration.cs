using System;
using System.Data;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class Registration : Form
    {
        public Registration()
        {
            InitializeComponent();
        }

        private void Registration_Load(object sender, EventArgs e)
        {
            string sql1 = $"select * from {Program.SCHEMA}.{Program.human.DANGKY()}";
            OracleCommand command = new OracleCommand(sql1, Program.conn);
            try
            {
                DataTable data = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView1.DataSource = data;
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string sql1 = $"select * from {Program.SCHEMA}.{Program.human.DANGKY()}";
            OracleCommand command = new OracleCommand(sql1, Program.conn);
            try
            {
                DataTable data = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView1.DataSource = data;
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }
        }
    }
}