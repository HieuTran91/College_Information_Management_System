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
    public partial class GrantPrivileges : Form
    {
        public GrantPrivileges()
        {
            InitializeComponent();
        }
        private void grant_Click(object sender, EventArgs e)
        {
            string sql = $"GRANT {role_name.Text} TO {user_name.Text} ";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully granted role to user");
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }

            sql = $"SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = UPPER('{user_name.Text}')";
            cmd = new OracleCommand(sql, Program.conn);

            DataTable data2 = new DataTable();
            OracleDataAdapter adapter = new OracleDataAdapter(cmd);
            adapter.Fill(data2);
            dataGridView1.DataSource = data2;
        }
        private void revoke_Click(object sender, EventArgs e)
        {
            string sql = $"REVOKE {role_name.Text} FROM {user_name.Text} ";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try 
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully revoked role from user");
            } catch (OracleException ex) { MessageBox.Show(ex.Message); }

            sql = $"SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = UPPER('{user_name.Text}')";
            cmd = new OracleCommand(sql, Program.conn);

            DataTable data2 = new DataTable();
            OracleDataAdapter adapter = new OracleDataAdapter(cmd);
            adapter.Fill(data2);
            dataGridView1.DataSource = data2;
        }

        private void grant_user_Click(object sender, EventArgs e)
        {
            string sql = "";
            string add = (grant_option.Checked) ? "WITH GRANT OPTION" : "";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                if (Select.Checked)
                {
                    sql = $"GRANT SELECT ON {Program.SCHEMA}.{comboBox1.Text} TO {name.Text} {add}";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.ExecuteNonQuery();
                }
                if (Insert.Checked)
                {
                    sql = $"GRANT INSERT ON {Program.SCHEMA}.{comboBox1.Text} TO {name.Text} {add}";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.ExecuteNonQuery();
                }
                if (Delete.Checked)
                {
                    sql = $"GRANT DELETE ON {Program.SCHEMA}.{comboBox1.Text} TO {name.Text} {add}";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.ExecuteNonQuery();
                }
                if (Update.Checked)
                {
                    sql = $"GRANT UPDATE({column.Text}) ON {Program.SCHEMA}.{comboBox1.Text} TO {name.Text} {add}";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.ExecuteNonQuery();
                }

                sql = $"SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = UPPER('{name.Text}')";
                cmd = new OracleCommand(sql, Program.conn);
                
                DataTable data2 = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                adapter.Fill(data2);
                dataGridView1.DataSource = data2;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void revoke_user_Click(object sender, EventArgs e)
        {
            string sql = "";
            string add = (grant_option.Checked) ? "WITH GRANT OPTION" : "";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                if (Select.Checked)
                {
                    sql = $"REVOKE SELECT ON {Program.SCHEMA}.{comboBox1.Text} FROM {name.Text} {add}";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.ExecuteNonQuery();
                }
                if (Insert.Checked)
                {
                    sql = $"REVOKE INSERT ON {Program.SCHEMA}.{comboBox1.Text} FROM {name.Text} {add}";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.ExecuteNonQuery();
                }
                if (Delete.Checked)
                {
                    sql = $"REVOKE DELETE ON {Program.SCHEMA}.{comboBox1.Text} FROM {name.Text} {add}";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.ExecuteNonQuery();
                }
                if (Update.Checked)
                {
                    sql = $"REVOKE UPDATE ON {Program.SCHEMA}.{comboBox1.Text} FROM {name.Text} {add}";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.ExecuteNonQuery();
                }

                sql = $"SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = UPPER('{name.Text}')";
                cmd = new OracleCommand(sql, Program.conn);

                DataTable data2 = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                adapter.Fill(data2);
                dataGridView1.DataSource = data2;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void GrantPrivileges_Load(object sender, EventArgs e)
        {
            string sql = $"SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = UPPER('{Program.SCHEMA}')";
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
            finally
            {
                if (reader != null)
                {
                    reader.Close();
                }
            }
        }
    }
}