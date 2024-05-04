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
    public partial class Admin_Menu : Form
    {
        public Admin_Menu()
        {
            InitializeComponent();
        }
        private void TabControlTest_Load(object sender, EventArgs e)
        {
            GrantPrivileges sup = new GrantPrivileges();
            sup.TopLevel = false;
            panel2.Controls.Add(sup);
            sup.Show();

            UserTab us = new UserTab();
            us.TopLevel = false;
            panel1.Controls.Add(us);
            us.Show();

            Create_Delete_Update modification = new Create_Delete_Update();
            modification.TopLevel = false;
            panel3.Controls.Add(modification);
            modification.Show();

            RoleTab role = new RoleTab();
            role.TopLevel = false;
            panel4.Controls.Add(role);
            role.Show();
        }
        private void button1_Click(object sender, EventArgs e)
        {
            panel1.Controls.Clear();
            UserTab us = new UserTab();
            us.TopLevel = false;
            panel1.Controls.Add(us);
            us.Show();
        }
    }
}
