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
            string username = delete_username.Text.ToUpper();
            string sql = "SELECT sid, serial#, username FROM v$session WHERE username = :username";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = username;

                OracleDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string sid = reader.GetInt32(0).ToString();
                    string serial = reader.GetInt32(1).ToString();
                    cmd = new OracleCommand($"ALTER SYSTEM KILL SESSION '{sid},{serial}'", Program.conn);
                    cmd.ExecuteNonQuery();
                    Console.WriteLine($"DELETE SESSION {reader.GetString(2)},{sid},{serial}");
                }
                reader.Close();

                sql = "BEGIN EXECUTE IMMEDIATE 'DROP USER ' || :username; END;";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = username;

                cmd.ExecuteNonQuery();
                MessageBox.Show($"Successfully deleted user {username}");
            }
            catch (OracleException ex)
            {
                MessageBox.Show($"Failed to delete user {username}");
            }
        }

        private void create_user_Click(object sender, EventArgs e)
        {
            string sql = "BEGIN EXECUTE IMMEDIATE 'CREATE USER ' || :username || ' IDENTIFIED BY ' || :password; END;";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = username_create.Text;
            cmd.Parameters.Add(new OracleParameter("password", OracleDbType.Varchar2)).Value = password.Text;
            try
            {
                cmd.ExecuteNonQuery();
                sql = "BEGIN EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO ' || :username; END;";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = username_create.Text;
                cmd.ExecuteNonQuery();
                MessageBox.Show($"Successfully created user {username_create}");
            }
            catch (OracleException ex)
            {
                MessageBox.Show($"Failed to create user: {username_create.Text}");
            }
        }

        private void update_user_Click(object sender, EventArgs e)
        {
            string sql = "BEGIN EXECUTE IMMEDIATE 'ALTER USER ' || :username || ' IDENTIFIED BY ' || :password; END;";
            try
            {
                OracleCommand cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("username", OracleDbType.Varchar2)).Value = username_update.Text;
                cmd.Parameters.Add(new OracleParameter("password", OracleDbType.Varchar2)).Value = new_password.Text;
                cmd.ExecuteNonQuery();
                MessageBox.Show($"Successfully changed user password");
            }
            catch (OracleException ex)
            {
                MessageBox.Show("Failed to change user password");
            }
        }

        private void create_role_Click(object sender, EventArgs e)
        {
            string sql = "BEGIN EXECUTE IMMEDIATE 'CREATE ROLE ' || :role; END;";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter("role", OracleDbType.Varchar2)).Value = textBox1.Text;
            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully created role");
            }
            catch (OracleException ex)
            {
                MessageBox.Show("Failed to create role");
            }
        }

        private void delete_role_Click(object sender, EventArgs e)
        {
            string sql = "BEGIN EXECUTE IMMEDIATE 'DROP ROLE ' || :role; END;";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter("role", OracleDbType.Varchar2)).Value = textBox1.Text;
            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully dropped role " + textBox1.Text);
            }
            catch (OracleException ex)
            {
                MessageBox.Show("Failed to drop role");
            }
        }

        private void grant_Click(object sender, EventArgs e)
        {
            string text = name_sys.Text.ToUpper();
            string sql = "SELECT COUNT(*) FROM DBA_ROLES WHERE ROLE = :role";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter("role", OracleDbType.Varchar2)).Value = text;
            bool allow_granted = false;
            try
            {
                int role_count = Convert.ToInt32(cmd.ExecuteScalar());
                sql = "SELECT COUNT(*) FROM DBA_USERS WHERE USERNAME = :role";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("role", OracleDbType.Varchar2)).Value = text;
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
                string add = (allow_granted) ? " WITH ADMIN OPTION " : "";
                sql = "BEGIN EXECUTE IMMEDIATE 'GRANT ' || :privis || ' TO ' || :name_sys || '" + add + "'; END;";
                cmd = new OracleCommand(sql, Program.conn);
                cmd.Parameters.Add(new OracleParameter("privis", OracleDbType.Varchar2)).Value = privis.Text;
                cmd.Parameters.Add(new OracleParameter("name_sys", OracleDbType.Varchar2)).Value = name_sys.Text;

                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully granted system privileges to user");
            }
            catch (OracleException ex)
            {
                MessageBox.Show("Failed to grant privilege to user/role");
            }
        }

        private void revoke_Click(object sender, EventArgs e)
        {
            string sql = "BEGIN EXECUTE IMMEDIATE 'REVOKE ' || :privis || ' FROM ' || :namesys; END;";
            OracleCommand cmd = new OracleCommand(sql, Program.conn);
            cmd.Parameters.Add(new OracleParameter("privis", OracleDbType.Varchar2)).Value = privis.Text;
            cmd.Parameters.Add(new OracleParameter("namesys", OracleDbType.Varchar2)).Value = name_sys.Text;
            try
            {
                cmd.ExecuteNonQuery();
                MessageBox.Show("Successfully revoke system privilege from user");
            }
            catch (OracleException ex)
            {
                MessageBox.Show("Failed to revoke system privilege");
            }
        }
    }
}

