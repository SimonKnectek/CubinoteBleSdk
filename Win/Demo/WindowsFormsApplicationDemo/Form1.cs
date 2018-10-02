using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Management;

using CubinoteBLESdk;
using System.IO;

namespace WindowsFormsApplicationDemo
{
    public partial class Form1 : Form
    {
        public static List<String> allPorts = new System.Collections.Generic.List<String>();

        public System.Collections.Generic.List<string> GetAllPorts()
        {
            //List all com port simulated by Bluetooth that connected with Cubinote
            List<String> allPorts = new System.Collections.Generic.List<String>();
            try
            {
                ManagementObjectSearcher searcher =
                    new ManagementObjectSearcher("root\\CIMV2",
                    "SELECT * FROM Win32_PnPEntity WHERE Caption LIKE '%Bluetooth%'");

                foreach (ManagementObject queryObj in searcher.Get())
                {
                    if (queryObj["Caption"] != null && queryObj["Caption"].ToString().Contains("(COM"))
                    {
                        String portName = queryObj["Caption"].ToString();
                        int ipos = portName.LastIndexOf("COM");
                        if (ipos < 0)
                            continue;
                        portName = portName.Substring(ipos);
                        ipos = portName.IndexOf(")");
                        if (ipos < 0)
                            continue;
                        portName = portName.Substring(0, ipos);
                        if (allPorts.IndexOf(portName) == -1)
                        {
                            CubinoteBLE SDK = new CubinoteBLE();
                            String result = SDK.CubinoteBLE_GetStatus(portName);
                            if (result.StartsWith("1880"))
                            {
                                //Connected with Cubintoe
                                allPorts.Add(portName);
                                comboBox1.Items.Add(portName);
                            }
                        }

                    }
                }
            }
            catch (ManagementException e)
            {
                ;
            }
            return allPorts;
        }

        public Form1()
        {
            InitializeComponent();
            //List all ports connected with Cubinote
            allPorts = GetAllPorts();
            if (allPorts.Count() > 0)
                comboBox1.SelectedIndex = 0;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //Create CubinoteBLE
            CubinoteBLE SDK = new CubinoteBLE();
            //Get status of Cubinote
            String res = SDK.CubinoteBLE_GetStatus(comboBox1.Text);
            textBox1.Clear();
            textBox1.Text = res;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //Create CubinoteBLE
            CubinoteBLE SDK = new CubinoteBLE();
            //Set options of Cubinote
            String res = SDK.CubinoteBLE_Set(comboBox1.Text, Int32.Parse(comboBox2.Text), Int32.Parse(comboBox3.Text), Int32.Parse(comboBox4.Text), Int32.Parse(comboBox5.Text));
            textBox1.Clear();
            textBox1.Text = res;
        }

        public static byte[] ImageToByte(System.Drawing.Bitmap img)
        {
            using (var stream = new MemoryStream())
            {
                img.Save(stream, System.Drawing.Imaging.ImageFormat.Bmp);
                //img.Save("wsq.bmp");
                return stream.ToArray();
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            //Create CubinoteBLE
            CubinoteBLE SDK = new CubinoteBLE();
            //Print Monochrome bitmap
            byte[] pImage = ImageToByte(Properties.Resources.after);
            String res = SDK.CubinoteBLE_Print_BWImage(comboBox1.Text, pImage);
            textBox1.Clear();
            textBox1.Text = res;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            //Create CubinoteBLE
            CubinoteBLE SDK = new CubinoteBLE();
            
            //Create a solid line
            TextItem t1 = new TextItem(41);
            //Create print content with the solid line
            InnerContent inerContent = new InnerContent(t1);

            //Create a regular text and insert it into print content
            String text = "Test Cubinote SDK";
            TextItem t2 = new TextItem(text, 1);
            inerContent.textList.Add(t2);

            //Create a big font, bold and underline text and insert it into print content
            TextItem t3 = new TextItem(text, 1);
            t3.underline = 130;
            t3.bold = 1;
            t3.fontSize = 2;
            inerContent.textList.Add(t3);

            //Create a QR code and insert it into print content
            String qr = "Test QR Code";
            TextItem t4 = new TextItem(qr, 3);
            inerContent.textList.Add(t4);

            //Create a material and insert it into print content
            TextItem t5 = new TextItem(10);
            inerContent.textList.Add(t5);

            //Create a Monochrome bitmap and insert it into print content
            byte[] pImage = ImageToByte(Properties.Resources.after);
            String base64String = Convert.ToBase64String(pImage, 0, pImage.Length);
            TextItem p1 = new TextItem(base64String, 5);
            inerContent.textList.Add(p1);

            //Create a dash line and insert it into print content
            TextItem t6 = new TextItem(42);
            inerContent.textList.Add(t6);

            //Create a Cubinote Logo and insert it into print content
            TextItem t7 = new TextItem(57);
            inerContent.textList.Add(t7);

            //Print the content
            String res = SDK.CubinoteBLE_Print_Content(comboBox1.Text, inerContent);
            textBox1.Clear();
            textBox1.Text = res;
        }

        
    }
}
