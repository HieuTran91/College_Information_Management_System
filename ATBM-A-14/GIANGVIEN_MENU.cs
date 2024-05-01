using System;
using System.Windows.Forms;

namespace ATBM_A_14
{
    public partial class GIANGVIEN_MENU : Form
    {
        public GIANGVIEN_MENU()
        {
            InitializeComponent();
        }
        private void GIANGVIEN_MENU_Load(object sender, EventArgs e)
        {
            PersonalInformation stu = new PersonalInformation();
            stu.TopLevel = false;
            panel1.Controls.Add(stu);
            stu.Show();

            StudentView studentView = new StudentView();
            studentView.TopLevel = false;
            panel2.Controls.Add(studentView);
            studentView.Show();

            DepartmentInformation depart = new DepartmentInformation();
            depart.TopLevel = false;
            panel3.Controls.Add(depart);
            depart.Show();

            CourseInformation course = new CourseInformation();
            course.TopLevel = false;
            panel4.Controls.Add(course);
            course.Show();

            CoursePlanInformation coursePlan = new CoursePlanInformation();
            coursePlan.TopLevel = false;
            panel5.Controls.Add(coursePlan);
            coursePlan.Show();

            Assignment assigment = new Assignment();
            assigment.TopLevel = false;
            panel6.Controls.Add(assigment);
            assigment.Show();

            Registration registration = new Registration();
            registration.TopLevel = false;
            panel7.Controls.Add(registration);
            registration.Show();

            HandleRegistration handleRegistration = new HandleRegistration();
            handleRegistration.TopLevel = false;
            panel8.Controls.Add(handleRegistration);
            handleRegistration.Show();

            OLS_Notification notification = new OLS_Notification();
            notification.TopLevel = false;
            panel9.Controls.Add(notification);
            notification.Show();
        }
    }
}
