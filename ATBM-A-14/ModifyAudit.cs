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
        // toggle audit
        private void button3_Click(object sender, EventArgs e)
        {

        }
        // set audit
        private void button1_Click(object sender, EventArgs e)
        {

        }
        // cancel audit
        private void button2_Click(object sender, EventArgs e)
        {

        }
    }
}
