using System;
using System.Data;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class OLS_Notification : Form
    {
        public OLS_Notification()
        {
            InitializeComponent();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            OLS_Notification_Load(sender, e);
        }
        private void OLS_Notification_Load(object sender, EventArgs e)
        {
            string sql = $"select * from {Program.SCHEMA}.THONGBAO";
            OracleCommand command = new OracleCommand(sql, Program.conn);
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
