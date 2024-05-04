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
    public partial class Create_Delete_Update : Form
    {
        public Create_Delete_Update()
        {
            InitializeComponent();
        }

        private void Create_Delete_Update_Load(object sender, EventArgs e)
        {
            string sql = "SELECT NAME FROM SYSTEM_PRIVILEGE_MAP";
            OracleCommand cmd =  new OracleCommand(sql, Program.conn);
            OracleDataReader reader = null;
            try
            {
                reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string privilege = reader.GetString(0);
                    privis.Items.Add(privilege);
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

        private void delete_user_Click(object sender, EventArgs e)
        {
            string username = delete_username.Text;
            string sql = $"SELECT s.sid, s.serial#, s.username FROM v$session s WHERE s.username = '{username.ToUpper()}'";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                OracleDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string sid = reader.GetInt32(0).ToString();
                    string serial = reader.GetInt32(1).ToString();
                    cmd = new OracleCommand($"ALTER SYSTEM KILL SESSION '{sid},{serial}'", Program.conn);
                    cmd.ExecuteNonQuery();
                }
                reader.Close();

                sql = $"DROP USER {username}";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.ExecuteNonQuery();
                MessageBox.Show($"Successfully deleted user {username}");
            }
            catch (OracleException ex)
            {
                MessageBox.Show($"Failed to delete user {username}: {ex.Message}");
            }
        }

        private void create_user_Click(object sender, EventArgs e)
        {
            string sql = $"CREATE USER {username_create.Text} IDENTIFIED BY {password.Text}";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                cmd.ExecuteNonQuery();
                sql = $"GRANT CREATE SESSION TO {username_create.Text}";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.ExecuteNonQuery();
                MessageBox.Show($"Successfully created user");
            }
            catch (OracleException ex)
            {
                MessageBox.Show($"Failed to create user: {ex.Message}");
            }
        }

        private void update_user_Click(object sender, EventArgs e)
        {
            string sql = $"ALTER USER {username_update.Text} IDENTIFIED BY {new_password.Text}";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                cmd.ExecuteNonQuery();
                MessageBox.Show($"Successfully changed user password");
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void create_role_Click(object sender, EventArgs e)
        {
            string sql = $"CREATE ROLE {textBox1.Text}";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully created role");
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void delete_role_Click(object sender, EventArgs e)
        {
            string sql = $"DROP ROLE {textBox1.Text}";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully dropped role");
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void grant_Click(object sender, EventArgs e)
        {
            string text = name_sys.Text;
            string sql = $"SELECT COUNT(*) FROM DBA_ROLES WHERE ROLE = UPPER('{text}')";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            bool allow_granted = false;
            try
            {
                int role_count = Convert.ToInt32(cmd.ExecuteScalar());

                sql = $"SELECT COUNT(*) FROM DBA_USERS WHERE USERNAME = UPPER('{text}')";
                cmd = new OracleCommand(sql, Program.conn);
                int user_count = Convert.ToInt32(cmd.ExecuteScalar());

                if (role_count > 0)
                {
                    // leave nothing here
                }
                else if (user_count > 0)
                {
                    if (checkBox1.Checked) allow_granted = true;
                }
                else
                {
                    MessageBox.Show($"{text} is neither a role nor a username");
                    return;
                }
                //
                string add = (allow_granted) ? "WITH ADMIN OPTION" : "";
                sql = $"GRANT {privis.Text} TO {name_sys.Text} {add}";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully granted system privileges to user");
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void revoke_Click(object sender, EventArgs e)
        {
            string sql = $"REVOKE {privis.Text} FROM {name_sys.Text}";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully revoke system privilege from user");
            }
            catch (OracleException ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}

