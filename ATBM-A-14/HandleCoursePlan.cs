using System;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class HandleCoursePlan : Form
    {
        public HandleCoursePlan()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            string sql = "UPDATE KHMO SET ";

        }

        private void button3_Click(object sender, EventArgs e)
        {
            
        }

        private void HandleCoursePlan_Load(object sender, EventArgs e)
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
                    comboBox2.Items.Add(privilege);
                }
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }

            // load year
            for (int i = 1; i < 4; i++) 
            {
                comboBox3.Items.Add(i.ToString());
            }

            // load Training Program
            comboBox4.Items.Add("CTTT");
            comboBox4.Items.Add("CQ");
            comboBox4.Items.Add("CLC");
            comboBox4.Items.Add("VP");
        }
    }
}
