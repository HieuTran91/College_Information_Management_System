﻿using System;
using Oracle.ManagedDataAccess.Client;
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

            Audit audit = new Audit();
            audit.TopLevel = false;
            panel5.Controls.Add(audit);
            audit.Show();

            ModifyAudit modifyAudit = new ModifyAudit();
            modifyAudit.TopLevel = false;
            panel6.Controls.Add(modifyAudit);
            modifyAudit.Show();

            Recovery recovery = new Recovery();
            recovery.TopLevel = false;
            panel7.Controls.Add(recovery);
            recovery.Show();

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