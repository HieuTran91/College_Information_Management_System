using System.Drawing;
using System.Windows.Forms;

namespace ATBM_A_14
{
    partial class GrantPrivileges
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.revoke = new System.Windows.Forms.Button();
            this.grant = new System.Windows.Forms.Button();
            this.role_name = new System.Windows.Forms.TextBox();
            this.user_name = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.revoke_user = new System.Windows.Forms.Button();
            this.grant_user = new System.Windows.Forms.Button();
            this.grant_option = new System.Windows.Forms.CheckBox();
            this.Delete = new System.Windows.Forms.CheckBox();
            this.Update = new System.Windows.Forms.CheckBox();
            this.Insert = new System.Windows.Forms.CheckBox();
            this.Select = new System.Windows.Forms.CheckBox();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.column = new System.Windows.Forms.TextBox();
            this.name = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.BackColor = System.Drawing.SystemColors.ControlLight;
            this.groupBox1.Controls.Add(this.revoke);
            this.groupBox1.Controls.Add(this.grant);
            this.groupBox1.Controls.Add(this.role_name);
            this.groupBox1.Controls.Add(this.user_name);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.groupBox1.Size = new System.Drawing.Size(321, 220);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "GRANT ROLE TO USER";
            // 
            // revoke
            // 
            this.revoke.Location = new System.Drawing.Point(166, 160);
            this.revoke.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.revoke.Name = "revoke";
            this.revoke.Size = new System.Drawing.Size(120, 28);
            this.revoke.TabIndex = 5;
            this.revoke.Text = "REVOKE";
            this.revoke.UseVisualStyleBackColor = true;
            this.revoke.Click += new System.EventHandler(this.revoke_Click);
            // 
            // grant
            // 
            this.grant.Location = new System.Drawing.Point(27, 160);
            this.grant.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grant.Name = "grant";
            this.grant.Size = new System.Drawing.Size(120, 28);
            this.grant.TabIndex = 4;
            this.grant.Text = "GRANT";
            this.grant.UseVisualStyleBackColor = true;
            this.grant.Click += new System.EventHandler(this.grant_Click);
            // 
            // role_name
            // 
            this.role_name.Location = new System.Drawing.Point(109, 96);
            this.role_name.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.role_name.Name = "role_name";
            this.role_name.Size = new System.Drawing.Size(182, 27);
            this.role_name.TabIndex = 3;
            // 
            // user_name
            // 
            this.user_name.Location = new System.Drawing.Point(109, 51);
            this.user_name.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.user_name.Name = "user_name";
            this.user_name.Size = new System.Drawing.Size(182, 27);
            this.user_name.TabIndex = 2;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(20, 99);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(83, 20);
            this.label2.TabIndex = 1;
            this.label2.Text = "Role Name";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(20, 54);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(82, 20);
            this.label1.TabIndex = 0;
            this.label1.Text = "User Name";
            // 
            // groupBox2
            // 
            this.groupBox2.BackColor = System.Drawing.SystemColors.ControlLight;
            this.groupBox2.Controls.Add(this.revoke_user);
            this.groupBox2.Controls.Add(this.grant_user);
            this.groupBox2.Controls.Add(this.grant_option);
            this.groupBox2.Controls.Add(this.Delete);
            this.groupBox2.Controls.Add(this.Update);
            this.groupBox2.Controls.Add(this.Insert);
            this.groupBox2.Controls.Add(this.Select);
            this.groupBox2.Controls.Add(this.comboBox1);
            this.groupBox2.Controls.Add(this.column);
            this.groupBox2.Controls.Add(this.name);
            this.groupBox2.Controls.Add(this.label5);
            this.groupBox2.Controls.Add(this.label4);
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Location = new System.Drawing.Point(353, 12);
            this.groupBox2.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.groupBox2.Size = new System.Drawing.Size(689, 220);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "GRANT/REVOKE";
            // 
            // revoke_user
            // 
            this.revoke_user.Location = new System.Drawing.Point(288, 160);
            this.revoke_user.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.revoke_user.Name = "revoke_user";
            this.revoke_user.Size = new System.Drawing.Size(120, 28);
            this.revoke_user.TabIndex = 7;
            this.revoke_user.Text = "REVOKE";
            this.revoke_user.UseVisualStyleBackColor = true;
            this.revoke_user.Click += new System.EventHandler(this.revoke_user_Click);
            // 
            // grant_user
            // 
            this.grant_user.Location = new System.Drawing.Point(149, 160);
            this.grant_user.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grant_user.Name = "grant_user";
            this.grant_user.Size = new System.Drawing.Size(120, 28);
            this.grant_user.TabIndex = 6;
            this.grant_user.Text = "GRANT";
            this.grant_user.UseVisualStyleBackColor = true;
            this.grant_user.Click += new System.EventHandler(this.grant_user_Click);
            // 
            // grant_option
            // 
            this.grant_option.AutoSize = true;
            this.grant_option.Location = new System.Drawing.Point(449, 122);
            this.grant_option.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.grant_option.Name = "grant_option";
            this.grant_option.Size = new System.Drawing.Size(152, 24);
            this.grant_option.TabIndex = 11;
            this.grant_option.Text = "With Grant Option";
            this.grant_option.UseVisualStyleBackColor = true;
            // 
            // Delete
            // 
            this.Delete.AutoSize = true;
            this.Delete.Location = new System.Drawing.Point(540, 84);
            this.Delete.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Delete.Name = "Delete";
            this.Delete.Size = new System.Drawing.Size(75, 24);
            this.Delete.TabIndex = 10;
            this.Delete.Text = "Delete";
            this.Delete.UseVisualStyleBackColor = true;
            // 
            // Update
            // 
            this.Update.AutoSize = true;
            this.Update.Location = new System.Drawing.Point(423, 84);
            this.Update.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Update.Name = "Update";
            this.Update.Size = new System.Drawing.Size(80, 24);
            this.Update.TabIndex = 9;
            this.Update.Text = "Update";
            this.Update.UseVisualStyleBackColor = true;
            // 
            // Insert
            // 
            this.Insert.AutoSize = true;
            this.Insert.Location = new System.Drawing.Point(540, 46);
            this.Insert.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Insert.Name = "Insert";
            this.Insert.Size = new System.Drawing.Size(67, 24);
            this.Insert.TabIndex = 8;
            this.Insert.Text = "Insert";
            this.Insert.UseVisualStyleBackColor = true;
            // 
            // Select
            // 
            this.Select.AutoSize = true;
            this.Select.Location = new System.Drawing.Point(423, 46);
            this.Select.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Select.Name = "Select";
            this.Select.Size = new System.Drawing.Size(71, 24);
            this.Select.TabIndex = 7;
            this.Select.Text = "Select";
            this.Select.UseVisualStyleBackColor = true;
            // 
            // comboBox1
            // 
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(189, 80);
            this.comboBox1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(172, 28);
            this.comboBox1.TabIndex = 6;
            // 
            // column
            // 
            this.column.Location = new System.Drawing.Point(189, 119);
            this.column.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.column.Name = "column";
            this.column.Size = new System.Drawing.Size(172, 27);
            this.column.TabIndex = 5;
            // 
            // name
            // 
            this.name.Location = new System.Drawing.Point(189, 42);
            this.name.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.name.Name = "name";
            this.name.Size = new System.Drawing.Size(172, 27);
            this.name.TabIndex = 4;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(23, 122);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(60, 20);
            this.label5.TabIndex = 2;
            this.label5.Text = "Column";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(23, 82);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(44, 20);
            this.label4.TabIndex = 1;
            this.label4.Text = "Table";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(23, 40);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(118, 20);
            this.label3.TabIndex = 0;
            this.label3.Text = "User/Role Name";
            // 
            // dataGridView1
            // 
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(12, 258);
            this.dataGridView1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.RowHeadersWidth = 51;
            this.dataGridView1.Size = new System.Drawing.Size(1030, 278);
            this.dataGridView1.TabIndex = 2;
            // 
            // GrantPrivileges
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1071, 571);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "GrantPrivileges";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "GrantPrivileges";
            this.Load += new System.EventHandler(this.GrantPrivileges_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private GroupBox groupBox1;
        private TextBox role_name;
        private TextBox user_name;
        private Label label2;
        private Label label1;
        private Button revoke;
        private Button grant;
        private GroupBox groupBox2;
        private Label label5;
        private Label label4;
        private Label label3;
        private TextBox name;
        private TextBox column;
        private ComboBox comboBox1;
        private Button revoke_user;
        private Button grant_user;
        private CheckBox grant_option;
        private CheckBox Delete;
        private CheckBox Update;
        private CheckBox Insert;
        private CheckBox Select;
        private DataGridView dataGridView1;
    }
}