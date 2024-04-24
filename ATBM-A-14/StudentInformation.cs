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
            StudentInformation_Load(sender, e);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (textBox1.Text.Length != 10)
            {
                MessageBox.Show("Phone number must be exactly 10 characters.");
                return;
            }
            string sql = $"UPDATE {Program.SCHEMA}.SINHVIEN SET DT = :phone";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                OracleParameter param = new OracleParameter("phone", OracleDbType.Char);
                param.Value = textBox1.Text;
                param.Size = 10;
                cmd.Parameters.Add(param);
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully changed user phone");
            }
            catch (OracleException ex)
            {
                MessageBox.Show("Failed to change user phone ");
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string sql = $"UPDATE {Program.SCHEMA}.SINHVIEN SET DCHI = :address";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("address", OracleDbType.Varchar2)).Value = textBox2.Text;
                cmd.ExecuteNonQuery();
                MessageBox.Show($"Successfully changed user phone");
            }
            catch (OracleException ex)
            {
                MessageBox.Show("Failed to change user address ");
            }
        }
    }
}
