using System;
using System.Data;
using System.Windows.Forms;
using Oracle.ManagedDataAccess.Client;

namespace ATBM_A_14
{
    public partial class AssignmentProcessing : Form
    {
        public AssignmentProcessing()
        {
            InitializeComponent();


        }
        private void AssignmentProcessing_Load(object sender, EventArgs e)
        {
            // string table = (!Program.human.getName().Contains("Trưởng đơn vị")) ? Program.human.PHANCONG() : ;
            string sql1 = $"select * from {Program.SCHEMA}.{Program.human.PHANCONG()}";
            OracleCommand command = new OracleCommand(sql1, Program.conn);
            try
            {
                DataTable data = new DataTable();
                OracleDataAdapter adapter = new OracleDataAdapter(command);
                adapter.Fill(data);
                dataGridView1.DataSource = data;
            }
            catch (OracleException ex) { MessageBox.Show(ex.Message); }
        }
        // Insert
        private void button2_Click(object sender, EventArgs e)
        {

        }
        // Delete
        private void button3_Click(object sender, EventArgs e)
        {

        }
        // Update
        private void button4_Click(object sender, EventArgs e)
        {

        }
        // Refresh button
        private void button1_Click(object sender, EventArgs e)
        {
            AssignmentProcessing_Load(sender,e);
        }
    }
}