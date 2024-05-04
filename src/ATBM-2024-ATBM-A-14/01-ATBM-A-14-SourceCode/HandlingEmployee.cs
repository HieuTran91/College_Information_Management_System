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
    public partial class HandlingEmployee : Form
    {
        public HandlingEmployee()
        {
            InitializeComponent();
        }
        private void HandlingEmployee_Load(object sender, EventArgs e)
        {
            comboBox2.Items.Add("Nhân viên cơ bản");
            comboBox2.Items.Add("Giảng viên");
            comboBox2.Items.Add("Giáo vụ");
            comboBox2.Items.Add("Trưởng đơn vị");
            comboBox2.Items.Add("Trưởng khoa");

        }
        // insert
        private void button3_Click(object sender, EventArgs e)
        {

        }
        // delete
        private void button4_Click(object sender, EventArgs e)
        {

        }
        // update
        private void button5_Click(object sender, EventArgs e)
        {

        }
    }
}
