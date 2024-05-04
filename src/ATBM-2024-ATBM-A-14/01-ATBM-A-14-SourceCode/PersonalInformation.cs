using System;
using System.Data;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class PersonalInformation : Form
    {
        string table = "";
        public PersonalInformation()
        {
            InitializeComponent();
            table = (!Program.human.getName().Contains("Trưởng khoa")) ? "VIEW_THONGTIN_NVCB" : "NHANSU";
        }

        private void PersonalInformation_Load(object sender, EventArgs e)
        {
            if (Program.human.getName().Contains("Trưởng khoa"))
            {
                groupBox2.Visible = false;
            }
            string sql1 = $"select * from {Program.SCHEMA}.{table}";
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
        // update phone number button, for non-Truong khoa role
        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text.Length != 10)
            {
                MessageBox.Show("Phone number must be exactly 10 characters.");
                return;
            }
            string sql = $"UPDATE {Program.SCHEMA}.VIEW_THONGTIN_NVCB SET DT = :phone";
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
            PersonalInformation_Load(sender, e);
        }
    }
}