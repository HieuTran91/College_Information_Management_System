using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ATBM_A_14
{
    public partial class StudentInformation : Form
    {
        public StudentInformation()
        {
            InitializeComponent();
        }

        private void StudentInformation_Load(object sender, EventArgs e)
        {
            string sql1 = $"select * from {Program.SCHEMA}.SINHVIEN";
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
            string sql1 = $"select * from {Program.SCHEMA}.SINHVIEN";
            OracleCommand command = new OracleCommand(sql1, Program.conn);

            DataTable data = new DataTable();
            OracleDataAdapter adapter = new OracleDataAdapter(command);
            adapter.Fill(data);
            dataGridView1.DataSource = data;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            // string sql = $"update {Program.SCHEMA}.SINHVIEN set DT = {}";
        }

        private void button3_Click(object sender, EventArgs e)
        {

        }
    }
}
