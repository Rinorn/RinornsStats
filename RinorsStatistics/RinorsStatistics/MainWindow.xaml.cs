using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Forms;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

using Color = System.Drawing.Color;
using MessageBox = System.Windows.MessageBox;

namespace RinorsStatistics
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        [DllImport("User32.dll")]
        static extern int SetForegroundWindow(IntPtr point);

        [DllImport("user32.dll")]
        static extern bool PostMessage(IntPtr hWnd, UInt32 Msg, int wParam, int lParam);

        Process pros;
        bool HadTarget = false;

        int xCoord = 0;
        int xCoordDeci = 0;
        int yCoord = 0;
        int yCoordDeci = 0;
        int coordOffset = 0;
        double currentFacIng = 0;

        double turnAngle = 0.0;
        double currentXCord = 0.0;
        double currentYCord = 0.0;

        double targetXCord = 42.27;
        double targetYCord = 71.32;

        double walkpointOffset = 0.20;
        int currentTurnValue = 0;

        #region states
        private enum ProgramState
        {
            ACTIVE,
            INACTIVE
        }
        private ProgramState currentProgramState;

        private enum CurrentSelectedClass
        {
            NONE,
            HUNTER,
            MAGE,
            WARLOCK,
            PRIEST,
            DRUID,
            WARRIOR,
            ROGUE,
            PALADIN
        }
        private CurrentSelectedClass currentClass;

        private enum CharacterState
        {
            NONE,
            ALIVE,
            DEAD            
        }
        private CharacterState currentCharacterState;

        private enum ActionState
        {
            MOVING,
            STANDING,
            DRINKING,
            FIGHTING,
            LOOTING,
            SKINNING
        }
        private ActionState currentActionState;

        private enum TargetState
        {            
            NOTARGET,
            DEADTARGET,
            KILLABLETARGET
        }
        private TargetState currentTargetState;

        private enum RangeState
        {
            NONE,
            OUTOFRANGE,
            MELLE,
            RANGED
        }
        private RangeState currentRangeState;

        private enum PetState
        {
            NONE,
            NOPET,
            ALIVE,
            DEAD
        }
        private PetState currentPetState;

        private enum PetMiscState
        {
            NOACTIONREQ,
            ACTIONREQ
        }
        private PetMiscState currentPetMiscState;
        #endregion

    #region Keys
        const uint WM_KEYDOWN = 0x100;
        const uint WM_KEYUP = 0x101;
        const int VK_W = 0x57;
        const int VK_TAB = 0x09;
        const int VK_Q = 0x51;
        const int VK_E = 0x45;
        const int VK_K = 0x4B;
        const int VK_S = 0x53;
        const int VK_L = 0x4C;
        const int VK_D = 0x44;
        const int VK_A = 0x41;


        #endregion

        public MainWindow()
        {
            InitializeComponent();
            StartProcess();
            
        }

        private void StartProcess()
        {
            pros = Process.Start(@"E:\Games\World of Warcraft\_classic_\WowClassic.exe");
        }

        private void SetStartStates()
        {
            currentProgramState = ProgramState.INACTIVE;
            currentClass = CurrentSelectedClass.NONE;
            currentActionState = ActionState.STANDING;
            currentCharacterState = CharacterState.NONE;
            currentPetMiscState = PetMiscState.NOACTIONREQ;
            currentPetState = PetState.NONE;
            currentRangeState = RangeState.NONE;
            currentTargetState = TargetState.NOTARGET;
        }

        private void OnButtonStartProgram(object sender, RoutedEventArgs e)
        {
            SetStartStates();
            //GetCharacterCoords();
            //ProgramLoop();

            MovementLoop();
        }
        private void ShowDia(object sender, RoutedEventArgs e)
        {
            MessageBox.Show(GetDistance().ToString());
        }

 

        private void CheckTargetState()
        {
            if (SearchPixel("#00B000", 1, 0))
            {
                //MessageBox.Show("Has target");
                currentTargetState = TargetState.KILLABLETARGET;
            }
            else if(SearchPixel("#008C00", 1, 0))
            {
                //MessageBox.Show("TargetDead");
                currentTargetState = TargetState.DEADTARGET;
            }
            else
            {
                //MessageBox.Show("No target");
                currentTargetState = TargetState.NOTARGET;
            }
        }

        private void CheckRangeState()
        {
            if (SearchPixel("#00B000", 2, 0))
            {
                //MessageBox.Show("Has target");
                currentRangeState = RangeState.RANGED;
            }
            else if (SearchPixel("#008C00", 2, 0))
            {
                //MessageBox.Show("TargetDead");
                currentRangeState = RangeState.MELLE;
            }
            else
            {
                //MessageBox.Show("No target");
                currentRangeState = RangeState.OUTOFRANGE;
            }
        }


        private void ProgramLoop()
        {
            CheckTargetState();
            if (currentTargetState == TargetState.NOTARGET)
            {   
                //tabs after a target
                DoAction(VK_TAB, 0);
                Thread.Sleep(333);
                CheckTargetState();
                if (currentTargetState == TargetState.KILLABLETARGET)
                {
                    DoAction(VK_K, 0);
                    currentActionState = ActionState.FIGHTING;
                    CombatLoop();
                }
            }
        }

        private void MovementLoop()
        {

            
            GetCharacterCoords();
            GetTurnValue();
            FaceTargetPoint();
            Move();
            

            if (currentActionState == ActionState.MOVING)
            {
                Thread.Sleep(2000);
                MovementLoop();
            }



        }
        private void Move()
        {
            SetForegroundWindow(pros.MainWindowHandle);
            if (GetDistance() > 0.20 && currentActionState != ActionState.MOVING)
            {
                currentActionState = ActionState.MOVING;
                PostMessage(pros.MainWindowHandle, WM_KEYDOWN, VK_W, 0);
            }
            else if (GetDistance() < 0.20 && currentActionState == ActionState.MOVING)
            {
                currentActionState = ActionState.STANDING;
                PostMessage(pros.MainWindowHandle, WM_KEYUP, VK_W, 0);
            }            
        }


        private void FaceTargetPoint()
        {
            int delayValue = 0;
            if (currentTurnValue < 1000 - 100)
            {
                delayValue = 1000 - currentTurnValue;
                DoAction(VK_D, delayValue);
            }
            else if (currentTurnValue > 1000)
            {
                delayValue = currentTurnValue - 1000;
                DoAction(VK_A, delayValue);
            }
            else
            {
                //Do nothing
            }
        }

        private void DoAction(int key, int delay)
        {
            SetForegroundWindow(pros.MainWindowHandle);
            PostMessage(pros.MainWindowHandle, WM_KEYDOWN, key, 0);
            Thread.Sleep(delay);
            PostMessage(pros.MainWindowHandle, WM_KEYUP, key, 0);

        }

        private void CombatLoop()
        {
            CheckTargetState();
            if (currentTargetState == TargetState.KILLABLETARGET)
            {
                HadTarget = true;
                CheckRangeState();
                if (currentRangeState == RangeState.OUTOFRANGE)
                {
                    DoAction(VK_K,0);
                    DoAction(VK_Q,0);
                }
                else if (currentRangeState == RangeState.RANGED)
                {
                    DoAction(VK_Q,0);
                }
                else if (currentRangeState == RangeState.MELLE)
                {
                    DoAction(VK_E,0);
                }
                Random rnd = new Random();
                Thread.Sleep(rnd.Next(300, 2000));

                CombatLoop();
            }
            else if (currentTargetState == TargetState.NOTARGET && HadTarget)
            {
                HadTarget = false;
                currentActionState = ActionState.LOOTING;
                Random rnd = new Random();
                
                DoAction(VK_L, 0);
                Thread.Sleep(rnd.Next(600, 700));
                DoAction(VK_K, 0);
                Thread.Sleep(rnd.Next(5000, 5300));
                DoAction(VK_K, 0);
                Thread.Sleep(rnd.Next(1000, 1300));
                DoAction(VK_K, 0);
                Thread.Sleep(3500);

            }
        }

        private bool SearchPixel(string color, int xPos, int yPos)
        {
            //bitmap with screen size
            Bitmap bitmap = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height);
            //object that can capture the screen
            Graphics graphics = Graphics.FromImage(bitmap as System.Drawing.Image);
            //Takes the screenshot
            graphics.CopyFromScreen(0, 0, 0, 0, bitmap.Size);

            Color convertedColor = ColorTranslator.FromHtml(color);

            Color currentPixColor = bitmap.GetPixel(xPos, yPos);
            if (currentPixColor == convertedColor)
            {
                return true;
            }
            return false;
        }

        private void GetCharacterCoords()
        {
            //bitmap with screen size
            Bitmap bitmap = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height);

            //object that can capture the screen
            Graphics graphics = Graphics.FromImage(bitmap as System.Drawing.Image);
            //Takes the screenshot
            graphics.CopyFromScreen(0, 0, 0, 0, bitmap.Size);

            //Translate hexcode to Color object
            Color convertedColor = ColorTranslator.FromHtml("#00B000");

            xCoord = 0;
            xCoordDeci = 0;
            yCoord = 0;
            yCoordDeci = 0;
            currentFacIng = 0;

            for (int x = 1; x <= 6; x++)
            {
                for (int y = 0; y <= 100; y++)
                {
                    Color currentPixColor = bitmap.GetPixel(y, x);

                    if (currentPixColor == convertedColor)
                    {
                        if (x == 1)
                        {
                            xCoord = y-5;
                        }
                        else if (x == 2)
                        {
                            DetermineCoordOffset(y);
                            xCoordDeci = y-coordOffset;
                        }
                        else if (x == 3)
                        {
                            yCoord = y-9;
                        }
                        else if (x == 4)
                        {
                            DetermineCoordOffset(y);
                            yCoordDeci = y - coordOffset;
                        }
                        else if (x == 6)
                        {
                            DetermineCoordOffset(y);
                            currentFacIng = y - coordOffset;
                        }
                    }
                }
            }
            currentXCord = Convert.ToDouble(xCoord.ToString() + "." + xCoordDeci.ToString());
            currentYCord = Convert.ToDouble(yCoord.ToString() + "." + yCoordDeci.ToString());
           // MessageBox.Show( currentXCord + "," + currentYCord + " and current facing = " + currentFacIng.ToString());
            //turnAngle = 0.0;
            //turnAngle = DetermineTurnAngle(currentYCord, targetYCord, currentXCord, targetXCord);

            //convert currentFacing to 2000 scale. a 360 turn takes 2000 milisec
            currentFacIng = Math.Round(((255*currentFacIng)/100) * 7.81);

            //MessageBox.Show("current facing = " + currentFacIng.ToString() + ".......Facing needed =" + turnAngle);
            //double test = GetDistance();
            //MessageBox.Show(test.ToString());

        }

        void GetTurnValue()
        {
            double yaw_result;
            double pitch = DetermineTurnAngle(currentYCord, targetYCord, currentXCord, targetXCord); // remember the pixel struct above
            // Calcula angulo necessacio (yaw) 
            if (pitch > currentFacIng) yaw_result = pitch - currentFacIng;
            else if (pitch < currentFacIng) yaw_result = 2000 - currentFacIng + pitch; // I used a 0-2000 range to make stuff easier. 
            else yaw_result = 0;
            currentTurnValue = (int)yaw_result;
        }


        double DetermineTurnAngle(double currentY, double targetY, double currentX, double targetX)
        {
            double ang = Math.Atan2(targetX - currentX, targetY - currentY) / Math.PI;
            if (ang < 0) ang += 2; // this is used to avoind negative numbers. 
            return Math.Round(ang * 1000);
        }

        private double GetDistance()
        {
            double distance = (Math.Sqrt(Math.Pow(Math.Abs(currentXCord - targetXCord), 2) +
                Math.Pow(Math.Abs(currentYCord - targetYCord), 2)));

            return distance;
        }

        void DetermineCoordOffset(int num)
        {
            coordOffset = 0;

            if (num <= 10)
            {
                coordOffset = 0;
            }
            else if (num > 10 && num <= 20)
            {
                coordOffset = 2;
            }
            else if(num > 20 && num <= 30)
            {
                coordOffset = 4;
            }
            else if (num > 30 && num <= 40)
            {
                coordOffset = 5;
            }
            else if (num > 40 && num <= 50)
            {
                coordOffset = 7;
            }
            else if (num > 50 && num <= 60)
            {
                coordOffset = 9;
            }
            else if (num > 60 && num <= 70)
            {
                coordOffset = 10;
            }
            else if (num > 70 && num <= 80)
            {
                coordOffset = 11;
            }
            else if (num > 80)
            {
                coordOffset = 12;
            }
        }

    }
}
