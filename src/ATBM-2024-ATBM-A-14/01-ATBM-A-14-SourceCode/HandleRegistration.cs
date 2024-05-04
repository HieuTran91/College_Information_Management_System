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

            if (Program.human.getName().Contains("Sinh viên"))
            {
                label1.Visible = false; // ID Student
                textBox1.Visible = false; // above

                groupBox2.Visible = false; // Score board
                button3.Visible = false; // no update
            }
            else if (Program.human.getName().Contains("Giáo vụ"))
            {
                groupBox2.Visible = false;
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
            string set = "SET ";
            if (!string.IsNullOrEmpty(textBox3.Text))
                set += "DIEMTH = :diemth,";
            if (!string.IsNullOrEmpty(textBox4.Text))
                set += "DIEMQT = :diemqt,";
            if (!string.IsNullOrEmpty(textBox5.Text))
                set += "DIEMCK = :diemck,";
            if (!string.IsNullOrEmpty(textBox6.Text))
                set += "DIEMTK = :diemtk,";
            set = set.Remove(set.Length - 1);
            if (set.Length <= 4) return;

            if (string.IsNullOrEmpty(comboBox4.Text)) return;

            string sql = $"UPDATE {Program.SCHEMA}.{Program.human.DANGKY()} " + set +
                " WHERE MASV = :masv and MAGV = :magv and MAHP = :mahp and HK = :hk and NAM = :nam and MACT = :mact";
            
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                string masv = "";
                if (textBox1.Text == "" || textBox1.Visible == false)
                {
                    masv = (Program.masv == "") ? "NULL" : Program.masv;
                }
                else masv = textBox1.Text.ToUpper();
                if (masv == "") return;

                cmd.Parameters.Add(new OracleParameter("masv", OracleDbType.Varchar2)).Value = masv;
                cmd.Parameters.Add(new OracleParameter("mahp", OracleDbType.Varchar2)).Value = comboBox4.Text;

                if (!string.IsNullOrEmpty(textBox3.Text))
                    cmd.Parameters.Add(new OracleParameter("diemth", OracleDbType.Varchar2)).Value = textBox3.Text; //DBNull.Value; //double.Parse(textBox3.Text);
                                                                                                   
                if (!string.IsNullOrEmpty(textBox4.Text))                                          
                    cmd.Parameters.Add(new OracleParameter("diemqt", OracleDbType.Varchar2)).Value = textBox4.Text;
                                                                                                   
                if (!string.IsNullOrEmpty(textBox5.Text))                                          
                    cmd.Parameters.Add(new OracleParameter("diemck", OracleDbType.Double)).Value = textBox5.Text;
                                                                                                   
                if (!string.IsNullOrEmpty(textBox6.Text))                                          
                    cmd.Parameters.Add(new OracleParameter("diemtk", OracleDbType.Double)).Value = textBox6.Text;

                cmd.ExecuteNonQuery();
                MessageBox.Show("Sucessfully updated");
            }
            catch(OracleException ex) { MessageBox.Show("Failed to update " + ex.Message); }
        }
        // insert
        private void button1_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(comboBox4.Text)) return;
            string sql = $"INSERT INTO {Program.SCHEMA}.DANGKY(MASV,MAGV,MAHP,HK,NAM,MACT) " + 
                         $"VALUES(:masv,null,:mahp,{Program.getHK()},to_char(sysdate,'YYYY'),'{Program.mact}')";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                string masv = "";
                if (textBox1.Text == "" || textBox1.Visible == false)
                {
                    masv = (Program.masv == "") ? null : Program.masv;
                }
                else masv = textBox1.Text.ToUpper();
                if (masv == "") return;

                cmd.Parameters.Add(new OracleParameter("masv", OracleDbType.Varchar2)).Value = masv;
                cmd.Parameters.Add(new OracleParameter("mahp", OracleDbType.Varchar2)).Value = comboBox4.Text;

                cmd.ExecuteNonQuery();
                MessageBox.Show("Sucessfully inserted");
            }
            catch (OracleException ex) { MessageBox.Show("Failed to insert " + ex.Message); }
        }
        // delete
        private void button2_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(comboBox4.Text)) return;
            string sql = $"DELETE FROM {Program.SCHEMA}.DANGKY WHERE MASV = :masv and MAHP = :mahp";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                string masv = "";
                if (textBox1.Text == "" || textBox1.Visible == false)
                {
                    masv = (Program.masv == "") ? "NULL" : Program.masv;
                }
                else masv = textBox1.Text.ToUpper();
                if (masv == "") return;

                cmd.Parameters.Add(new OracleParameter("masv", OracleDbType.Varchar2)).Value = masv;
                cmd.Parameters.Add(new OracleParameter("mahp", OracleDbType.Varchar2)).Value = comboBox4.Text;

                cmd.ExecuteNonQuery();
                MessageBox.Show("Sucessfully deleted");
            }
            catch (OracleException ex) { MessageBox.Show("Failed to delete " + ex.Message); }
        }
    }
}