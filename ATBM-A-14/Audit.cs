using System;
using System.Data;
using System.Text;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class Audit : Form
    {
        public Audit()
        {
            InitializeComponent();
        }

        private void Audit_Load(object sender, EventArgs e)
        {
            // load standard
            string sql1 = $"select * from dba_audit_trail where OWNER = '{Program.SCHEMA}' order by extended_timestamp";
            OracleCommand command = new OracleCommand(sql1, Program.conn);
            try
            {
                DataTable data = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView2.DataSource = data;
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }


            // load fine-grained
            sql1 = $"select * from dba_fga_audit_trail order by extended_timestamp";
            command = new OracleCommand(sql1, Program.conn);
            try
            {
                DataTable data = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView1.DataSource = data;
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }
        }
        // refresh buttons
        private void button4_Click(object sender, EventArgs e)
        {
            Audit_Load(sender, e);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Audit_Load(sender, e);
        }
    }
}
