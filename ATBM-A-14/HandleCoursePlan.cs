using System;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace ATBM_A_14
{
    public partial class HandleCoursePlan : Form
    {
        public HandleCoursePlan()
        {
            InitializeComponent();
        }
        // Insert
        private void button2_Click(object sender, EventArgs e)
        {
            //if (string.IsNullOrEmpty(comboBox2.Text) || string.IsNullOrEmpty(comboBox3.Text) ||
            //    string.IsNullOrEmpty(comboBox4.Text) || string.IsNullOrEmpty(textBox2.Text)) return;
            string sql = $"INSERT INTO {Program.SCHEMA}.KHMO (MAHP,HK,NAM,MACT) VALUES (:mahp,:hk,:nam,:mact)";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                cmd.Parameters.Add(new OracleParameter("mahp", OracleDbType.Varchar2)).Value = comboBox2.Text;
                cmd.Parameters.Add(new OracleParameter("hk", OracleDbType.Varchar2)).Value = comboBox3.Text;
                cmd.Parameters.Add(new OracleParameter("nam", OracleDbType.Varchar2)).Value = textBox2.Text;
                cmd.Parameters.Add(new OracleParameter("mact", OracleDbType.Varchar2)).Value = comboBox4.Text;
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully inserted");
            }
            catch(OracleException ex) { MessageBox.Show("Failed to insert"); }
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
