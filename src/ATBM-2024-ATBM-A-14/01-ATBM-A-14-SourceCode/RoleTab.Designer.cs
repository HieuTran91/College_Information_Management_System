using System.Drawing;
using System.Windows.Forms;

namespace ATBM_A_14
{
    partial class RoleTab
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
            this.role = new System.Windows.Forms.GroupBox();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.privileges = new System.Windows.Forms.GroupBox();
            this.dataGridView2 = new System.Windows.Forms.DataGridView();
            this.search = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.role.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.privileges.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView2)).BeginInit();
            this.SuspendLayout();
            // 
            // role
            // 
            this.role.Controls.Add(this.dataGridView1);
            this.role.Location = new System.Drawing.Point(12, 12);
            this.role.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.role.Name = "role";
            this.role.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.role.Size = new System.Drawing.Size(1006, 204);
            this.role.TabIndex = 0;
            this.role.TabStop = false;
            this.role.Text = "ROLE";
            // 
            // dataGridView1
            // 
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(69, 15);
            this.dataGridView1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.RowHeadersWidth = 51;
            this.dataGridView1.Size = new System.Drawing.Size(931, 180);
            this.dataGridView1.TabIndex = 0;
            // 
            // privileges
            // 
            this.privileges.Controls.Add(this.button1);
            this.privileges.Controls.Add(this.dataGridView2);
            this.privileges.Controls.Add(this.search);
            this.privileges.Controls.Add(this.textBox1);
            this.privileges.Controls.Add(this.label1);
            this.privileges.Location = new System.Drawing.Point(12, 252);
            this.privileges.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.privileges.Name = "privileges";
            this.privileges.Padding = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.privileges.Size = new System.Drawing.Size(1006, 282);
            this.privileges.TabIndex = 1;
            this.privileges.TabStop = false;
            this.privileges.Text = "PRIVILEGES";
            // 
            // dataGridView2
            // 
            this.dataGridView2.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView2.Location = new System.Drawing.Point(69, 92);
            this.dataGridView2.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.dataGridView2.Name = "dataGridView2";
            this.dataGridView2.RowHeadersWidth = 51;
            this.dataGridView2.Size = new System.Drawing.Size(931, 185);
            this.dataGridView2.TabIndex = 3;
            // 
            // search
            // 
            this.search.Font = new System.Drawing.Font("Segoe UI", 7F);
            this.search.Location = new System.Drawing.Point(431, 20);
            this.search.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.search.Name = "search";
            this.search.Size = new System.Drawing.Size(91, 34);
            this.search.TabIndex = 2;
            this.search.Text = "SEARCH";
            this.search.UseVisualStyleBackColor = true;
            this.search.Click += new System.EventHandler(this.search_Click);
            // 
            // textBox1
            // 
            this.textBox1.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.textBox1.Location = new System.Drawing.Point(235, 20);
            this.textBox1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(163, 27);
            this.textBox1.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.label1.Location = new System.Drawing.Point(108, 22);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(104, 20);
            this.label1.TabIndex = 0;
            this.label1.Text = "Enter user role";
            // 
            // button1
            // 
            this.button1.Font = new System.Drawing.Font("Segoe UI", 7F);
            this.button1.Location = new System.Drawing.Point(559, 20);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 34);
            this.button1.TabIndex = 10;
            this.button1.Text = "REFRESH";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // RoleTab
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1071, 538);
            this.Controls.Add(this.privileges);
            this.Controls.Add(this.role);
            this.Font = new System.Drawing.Font("Segoe UI", 9F);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "RoleTab";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "RoleTab";
            this.Load += new System.EventHandler(this.RoleTab_Load);
            this.role.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.privileges.ResumeLayout(false);
            this.privileges.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView2)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private GroupBox role;
        private DataGridView dataGridView1;
        private GroupBox privileges;
        private Label label1;
        private DataGridView dataGridView2;
        private Button search;
        private TextBox textBox1;
        private Button button1;
    }
}