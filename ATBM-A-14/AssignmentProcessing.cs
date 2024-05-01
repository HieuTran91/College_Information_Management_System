using System;
using System.Data;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class AssignmentProcessing : Form
    {
        public AssignmentProcessing()
        {
            InitializeComponent();


        }
        private void AssignmentProcessing_Load(object sender, EventArgs e)
        {
            string sql1 = $"select * from {Program.SCHEMA}.{Program.human.PHANCONG()}";
            OracleCommand command = new OracleCommand(sql1, Program.conn);
            try
            {
                DataTable data = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView1.DataSource = data;
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }

            if (!Program.human.getName().Contains("Trưởng khoa"))
            {
                button2.Visible = false;
                button3.Visible = false;
            }
            else
            {
                // load Object
                string sql = $"SELECT MANV FROM {Program.SCHEMA}.NHANSU";
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                OracleDataReader reader = null;
                try
                {
                    reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        string privilege = reader.GetString(0);
                        comboBox1.Items.Add(privilege);
                    }
                }
                catch (OracleException ex)
                {
                    MessageBox.Show(ex.Message);
                }
                // load HK
                comboBox3.Items.Add(1);
                comboBox3.Items.Add(2);
                comboBox3.Items.Add(3);

                // load Program
                comboBox4.Items.Add("CLC");
                comboBox4.Items.Add("CQ");
                comboBox4.Items.Add("VP");
                comboBox4.Items.Add("CTTT");

                // load course
                // load Object
                sql = $"SELECT MAHP FROM {Program.SCHEMA}.HOCPHAN";
                cmd = new OracleCommand(sql, Program.conn);
                reader = null;
                try
                {
                    reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        string privilege = reader.GetString(0);
                        comboBox2.Items.Add(privilege);
                    }
                }
                catch (OracleException ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }
        // Insert
        private void button2_Click(object sender, EventArgs e)
        {
            //string sql = $"insert into {Program.SCHEMA}.VIEW_TK_PC (MANV,)";
            //OracleCommand command = new OracleCommand(sql, Program.conn);
            //try
            //{
                
            //    command.ExecuteNonQuery();
            //}
            //catch (OracleException ex) { MessageBox.Show(ex.Message); }
        }
        // Delete
        private void button3_Click(object sender, EventArgs e)
        {

        }
        // Update
        private void button4_Click(object sender, EventArgs e)
        {

        }
        // Refresh button
        private void button1_Click(object sender, EventArgs e)
        {
            AssignmentProcessing_Load(sender,e);
        }
    }
}