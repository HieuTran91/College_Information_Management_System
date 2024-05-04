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
    public partial class SV_MENU : Form
    {
        public SV_MENU()
        {
            InitializeComponent();
        }

        private void SV_MENU_Load(object sender, EventArgs e)
        {
            StudentInformation stu = new StudentInformation();
            stu.TopLevel = false;
            panel1.Controls.Add(stu);
            stu.Show();

            CourseInformation course = new CourseInformation();
            course.TopLevel = false;
            panel2.Controls.Add(course);
            course.Show();

            CoursePlanInformation coursePlan = new CoursePlanInformation();
            coursePlan.TopLevel = false;
            panel3.Controls.Add(coursePlan);
            coursePlan.Show();

            Registration registration = new Registration();
            registration.TopLevel = false;
            panel4.Controls.Add(registration);
            registration.Show();

            HandleRegistration handleCourse = new HandleRegistration();
            handleCourse.TopLevel = false;
            panel5.Controls.Add(handleCourse);
            handleCourse.Show();

            OLS_Notification notification = new OLS_Notification();
            notification.TopLevel = false;
            panel6.Controls.Add(notification);
            notification.Show();
        }
    }
}
