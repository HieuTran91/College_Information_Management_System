using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class HandleRegistration : Form
    {
        public HandleRegistration()
        {
            InitializeComponent();
        }
        // insert
        private void button1_Click(object sender, EventArgs e)
        {

        }
        // delete
        private void button2_Click(object sender, EventArgs e)
        {

        }
        // loader
        private void HandleRegistration_Load(object sender, EventArgs e)
        {
            string sql = $"SELECT MAHP FROM {Program.SCHEMA}.HOCPHAN";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            OracleDataReader reader = null;
            try
            {
                reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string privilege = reader.GetString(0);
                    comboBox4.Items.Add(privilege);
                }
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }

            // load Training Program
            comboBox1.Items.Add("CTTT");
            comboBox1.Items.Add("CQ");
            comboBox1.Items.Add("CLC");
            comboBox1.Items.Add("VP");

            comboBox2.Items.Add(1);
            comboBox2.Items.Add(2);
            comboBox2.Items.Add(3); 

            if (Program.human.getName().Contains("Sinh viên"))
            {
                label1.Visible = false;
                textBox1.Visible = false;
                label2.Visible = false;
                comboBox3.Visible = false;
            }

            if (Program.human.getName().Contains("Giáo vụ"))
            {
                button3.Visible = false; // no update
            }
            else
            {
                button1.Visible = false; // no insert
                button2.Visible = false; // no delete
            }
        }
        // update
        private void button3_Click(object sender, EventArgs e)
        {

        }
        // search
        private void button4_Click(object sender, EventArgs e)
        {

        }
    }
}
