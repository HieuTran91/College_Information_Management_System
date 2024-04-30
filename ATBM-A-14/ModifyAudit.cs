using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.IdentityModel.Tokens;
using Oracle.ManagedDataAccess.Client;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace ATBM_A_14
{
    public partial class ModifyAudit : Form
    {
        public ModifyAudit()
        {
            InitializeComponent();
        }

        private void ModifyAudit_Load(object sender, EventArgs e)
        {
            // label4.Text = "OFF"; // read from the database


            // load object
            comboBox1.Items.Add("NHANSU");
            comboBox1.Items.Add("SINHVIEN");
            comboBox1.Items.Add("DANGKY");
            comboBox1.Items.Add("PHANCONG");
            comboBox1.Items.Add("KHMO");
            comboBox1.Items.Add("HOCPHAN");
            comboBox1.Items.Add("DONVI");

            // load action
            comboBox2.Items.Add("SELECT");
            comboBox2.Items.Add("INSERT");
            comboBox2.Items.Add("UPDATE");
            comboBox2.Items.Add("DELETE");
        }
        // set audit
        private void button1_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(comboBox1.Text) || string.IsNullOrEmpty(comboBox2.Text)) return;
            string when = (checkBox1.Checked) ? "SUCCESSFUL" : "NO SUCCESSFUL";
            string sql = "BEGIN EXECUTE IMMEDIATE 'AUDIT ' || :action || ' ON ' || :schema || '.' || :table || ' BY ACCESS WHENEVER ' || :when; END;";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                cmd.Parameters.Add(new OracleParameter("action", OracleDbType.Varchar2)).Value = comboBox2.Text;
                cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                cmd.Parameters.Add(new OracleParameter("when", OracleDbType.Varchar2)).Value = when;
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully turned audit on");
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }
        }
        // cancel audit
        private void button2_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(comboBox1.Text) || string.IsNullOrEmpty(comboBox2.Text)) return;
            string when = (checkBox1.Checked) ? "SUCCESSFUL" : "NO SUCCESSFUL";
            string sql = "BEGIN EXECUTE IMMEDIATE 'NOAUDIT ' || :action || ' ON ' || :schema || '.' || :table || ' WHENEVER ' || :when; END;";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                cmd.Parameters.Add(new OracleParameter("action", OracleDbType.Varchar2)).Value = comboBox2.Text;
                cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                cmd.Parameters.Add(new OracleParameter("when", OracleDbType.Varchar2)).Value = when;
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully turned audit off");
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {

        }
    }
}
