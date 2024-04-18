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
    public partial class NVCB_MENU : Form
    {
        public NVCB_MENU()
        {
            InitializeComponent();
        }

        private void NV_MENU_Load(object sender, EventArgs e)
        {
            PersonalInformation human = new PersonalInformation();
            human.TopLevel = false;
            panel1.Controls.Add(human);
            human.Show();

            StudentView stu = new StudentView();
            stu.TopLevel = false;
            panel2.Controls.Add(stu);
            stu.Show();


        }
    }
}
