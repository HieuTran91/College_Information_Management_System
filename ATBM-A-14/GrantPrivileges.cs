using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
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
            string sql = "BEGIN EXECUTE IMMEDIATE 'GRANT ' || :role || ' TO ' || :user; END;";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter(":role", OracleDbType.Varchar2)).Value = role_name.Text;
            cmd.Parameters.Add(new OracleParameter(":user", OracleDbType.Varchar2)).Value = user_name.Text;
            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully granted role to user");
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }

            sql = "SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = :username";
            cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = user_name.Text.ToUpper();

            DataTable data2 = new DataTable();
            OracleDataAdapter adapter = new OracleDataAdapter(cmd);
            adapter.Fill(data2);
            dataGridView1.DataSource = data2;
        }
        private void revoke_Click(object sender, EventArgs e)
        {
            string sql = "BEGIN EXECUTE IMMEDIATE 'REVOKE ' || :role || ' FROM ' || :user; END;";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter(":role", OracleDbType.Varchar2)).Value = role_name.Text;
            cmd.Parameters.Add(new OracleParameter(":user", OracleDbType.Varchar2)).Value = user_name.Text;

            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully revoked role from user");
            } catch (OracleException ex) { MessageBox.Show(ex.Message); }

            sql = "SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = :username";
            cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = user_name.Text.ToUpper();

            DataTable data2 = new DataTable();
            OracleDataAdapter adapter = new OracleDataAdapter(cmd);
            adapter.Fill(data2);
            dataGridView1.DataSource = data2;
        }

        private void grant_user_Click(object sender, EventArgs e)
        {
            string sql = "";
            string add = (grant_option.Checked) ? " WITH GRANT OPTION " : "";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                if (Select.Checked)
                {
                    sql = "BEGIN EXECUTE IMMEDIATE 'GRANT SELECT ON ' || :schema || '.' || :table || ' TO ' || :user || '" + add + "'; END;";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                    cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                    cmd.Parameters.Add(new OracleParameter("user", OracleDbType.Varchar2)).Value = name.Text;
                    
                    cmd.ExecuteNonQuery();
                }
                if (Insert.Checked)
                {
                    sql = "BEGIN EXECUTE IMMEDIATE 'GRANT INSERT ON ' || :schema || '.' || :table || ' TO ' || :user || '" + add + "'; END;";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                    cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                    cmd.Parameters.Add(new OracleParameter("user", OracleDbType.Varchar2)).Value = name.Text;
                    
                    cmd.ExecuteNonQuery();
                }
                if (Delete.Checked)
                {
                    sql = "BEGIN EXECUTE IMMEDIATE 'GRANT DELETE ON ' || :schema || '.' || :table || ' TO ' || :user || '" + add + "'; END;";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                    cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                    cmd.Parameters.Add(new OracleParameter("user", OracleDbType.Varchar2)).Value = name.Text;

                    cmd.ExecuteNonQuery();
                }
                if (Update.Checked)
                {
                    sql = "BEGIN EXECUTE IMMEDIATE 'GRANT UPDATE'|| :column ||' ON ' || :schema || '.' || :table || ' TO ' || :user || '" + add + "'; END;";
                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.Parameters.Add(new OracleParameter("column", OracleDbType.Varchar2)).Value = (column.Text != "") ? "(" + column.Text + ")" : "";
                    cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                    cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                    cmd.Parameters.Add(new OracleParameter("user", OracleDbType.Varchar2)).Value = name.Text;

                    cmd.ExecuteNonQuery();
                }
                sql = "SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = :username";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = name.Text.ToUpper();

                DataTable data2 = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                adapter.Fill(data2);
                dataGridView1.DataSource = data2;

                MessageBox.Show("Granting successful");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void revoke_user_Click(object sender, EventArgs e)
        {
            string sql = "";
            string add = (grant_option.Checked) ? " WITH GRANT OPTION " : "";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                if (Select.Checked)
                {
                    sql = "BEGIN EXECUTE IMMEDIATE 'REVOKE SELECT ON ' || :schema || '.' || :table || ' FROM ' || :user || '" + add + "'; END;";

                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                    cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                    cmd.Parameters.Add(new OracleParameter("user", OracleDbType.Varchar2)).Value = name.Text;

                    cmd.ExecuteNonQuery();
                }
                if (Insert.Checked)
                {
                    sql = "BEGIN EXECUTE IMMEDIATE 'REVOKE INSERT ON ' || :schema || '.' || :table || ' FROM ' || :user || '" + add + "'; END;";

                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                    cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                    cmd.Parameters.Add(new OracleParameter("user", OracleDbType.Varchar2)).Value = name.Text;

                    cmd.ExecuteNonQuery();
                }
                if (Delete.Checked)
                {
                    sql = "BEGIN EXECUTE IMMEDIATE 'REVOKE DELETE ON ' || :schema || '.' || :table || ' FROM ' || :user || '" + add + "'; END;";

                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                    cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                    cmd.Parameters.Add(new OracleParameter("user", OracleDbType.Varchar2)).Value = name.Text;

                    cmd.ExecuteNonQuery();
                }
                if (Update.Checked)
                {
                    sql = "BEGIN EXECUTE IMMEDIATE 'REVOKE UPDATE ON ' || :schema || '.' || :table || ' FROM ' || :user || '" + add + "'; END;";

                    cmd = new OracleCommand(sql, Program.conn);
                    cmd.Parameters.Add(new OracleParameter("schema", OracleDbType.Varchar2)).Value = Program.SCHEMA;
                    cmd.Parameters.Add(new OracleParameter("table", OracleDbType.Varchar2)).Value = comboBox1.Text;
                    cmd.Parameters.Add(new OracleParameter("user", OracleDbType.Varchar2)).Value = name.Text;

                    cmd.ExecuteNonQuery();
                }
                sql = "SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = :username";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = name.Text.ToUpper();

                DataTable data2 = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(cmd);
                adapter.Fill(data2);
                dataGridView1.DataSource = data2;

                MessageBox.Show("Revoke successful");
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