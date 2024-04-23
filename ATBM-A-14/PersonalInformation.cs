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
    public partial class PersonalInformation : Form
    {
        public PersonalInformation()
        {
            InitializeComponent();
        }

        private void PersonalInformation_Load(object sender, EventArgs e)
        {
            string sql1 = $"select * from {Program.SCHEMA}.NHANSU";
            OracleCommand command = new OracleCommand(sql1, Program.conn);
            try
            {
                DataTable data = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView1.DataSource = data;
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }

            string sql = $"SELECT VAITRO FROM {Program.SCHEMA}.NHANSU WHERE MANV = sys_context('userenv','current_user')";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            string role = cmd.ExecuteScalar().ToString();
            if (role.Contains("Trưởng khoa"))
            {
                groupBox2.Visible = false;
            }
        }
        // update phone number button
        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text.Length != 10)
            {
                MessageBox.Show("Phone number must be exactly 10 characters.");
                return;
            }
            string sql = $"UPDATE {Program.SCHEMA}.NHANSU SET DT = :phone";
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
        // refresh button
        private void button2_Click(object sender, EventArgs e)
        {
            string sql1 = $"select * from {Program.SCHEMA}.NHANSU";
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
