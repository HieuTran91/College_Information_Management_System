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
    public partial class GIAOVU_MENU : Form
    {
        public GIAOVU_MENU()
        {
            InitializeComponent();
        }
        private void GIAOVU_MENU_Load(object sender, EventArgs e)
        {
            PersonalInformation stu = new PersonalInformation();
            stu.TopLevel = false;
            panel1.Controls.Add(stu);
            stu.Show();

            StudentView studentView = new StudentView();
            studentView.TopLevel = false;
            panel2.Controls.Add(studentView);
            studentView.Show();

            HandleStudent handleStudent = new HandleStudent();
            handleStudent.TopLevel = false;
            panel3.Controls.Add(handleStudent);
            handleStudent.Show();

            CourseInformation course = new CourseInformation();
            course.TopLevel = false;
            panel4.Controls.Add(course);
            course.Show();

            HandleCourse handleCourse = new HandleCourse();
            handleCourse.TopLevel = false;
            panel5.Controls.Add(handleCourse);
            handleCourse.Show();

            AssignmentProcessing assignmentProcessing = new AssignmentProcessing();
            assignmentProcessing.TopLevel = false;
            panel7.Controls.Add(assignmentProcessing);
            assignmentProcessing.Show();

            CoursePlanInformation coursePlanInformation = new CoursePlanInformation();
            coursePlanInformation.TopLevel = false;
            panel8.Controls.Add(coursePlanInformation);
            coursePlanInformation.Show();

            HandleCoursePlan coursePlan = new HandleCoursePlan();
            coursePlan.TopLevel = false;
            panel12.Controls.Add(coursePlan);
            coursePlan.Show();

            DepartmentInformation departmentInformation = new DepartmentInformation();
            departmentInformation.TopLevel = false;
            panel10.Controls.Add(departmentInformation);
            departmentInformation.Show();

            HandlingDepartment handlingDepartment = new HandlingDepartment();
            handlingDepartment.TopLevel = false;
            panel6.Controls.Add(handlingDepartment);
            handlingDepartment.Show();
        }
    }
}