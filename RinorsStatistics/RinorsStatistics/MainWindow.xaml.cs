using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
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
using Application = System.Windows.Forms.Application;
using Color = System.Drawing.Color;
using MessageBox = System.Windows.MessageBox;
using Path = System.IO.Path;

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

        static Process pros;
        bool HadTarget = false;
        int jumper = 0;
        int newFacing;
        double dist = 0;


        static Bitmap bitmap;
        static Color convertedColor;
        static double PixelSizeWidth = 1.123595505617978;

        static int xCoord = 0;
        static int xCoordDeci = 0;
        static int yCoord = 0;
        static int yCoordDeci = 0;
        static int coordOffset = 0;
        static double currentFacIng = 0;
        bool IsTurning = false;

        double turnAngle = 0.0;
        static double currentXCord = 0.0;
        static double currentYCord = 0.0;
        double pitch = 0;

        double targetXCord = 0;
        double targetYCord = 0;

        //double targetXCord = 43.81;
        //double targetYCord = 69.8;

        double walkpointOffset = 0.20;
        int currentTurnValue = 0;

        static List<string> Route = new List<string>();
        static List<string> ActiveRoute = new List<string>();


        #region RegionRecording

        static string filename = "";
        static string folderPath = Application.StartupPath + "\\Routes\\";
        private static int WH_KEYBOARD_LL = 13;

        private static IntPtr hook = IntPtr.Zero;
        private static LowLevelKeyboardProc llkProcedure = HookCallback;
        private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

        [DllImport("User32.dll")]
        private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

        [DllImport("User32.dll")]
        private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

        [DllImport("User32.dll")]
        private static extern bool UnhookWindowsHookEx(IntPtr hhk);

        [DllImport("kernel32.dll")]
        private static extern IntPtr GetModuleHandle(String lpModuleName);

        #endregion

        #region states
        private enum ProgramState
        {
            ACTIVE,
            INACTIVE,
            RECORDING
        }
        private static ProgramState currentProgramState;

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
        const int VK_J = 0x4A;
        const int VK_Space = 0x20;


        #endregion

        public MainWindow()
        {
            InitializeComponent();
            StartProcess();

        }

        private static void StartProcess()
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
            ReadRoute();
            //GetCharacterCoords();
            //ProgramLoop();

            MovementLoop();

        }
        private void ShowDia(object sender, RoutedEventArgs e)
        {
            //MessageBox.Show(GetDistance().ToString());
            ReadRoute();
            CheckForPoint();
            //CheckTargetState();
        }

        #region recordingRouteFunctions

        private void InitRecording(object sender, RoutedEventArgs e)
        {
            filename = TextFileName.Text;
            currentProgramState = ProgramState.RECORDING;
            hook = SetHook(llkProcedure);
        }
        private void StopRecording(object sender, RoutedEventArgs e)
        {
            RemoveHook();
        }

        private static IntPtr SetHook(LowLevelKeyboardProc proc)
        {
            //Henter nåværende prosess
            Process currentProcess = Process.GetCurrentProcess();
            ProcessModule currentModule = currentProcess.MainModule;
            String moduleName = currentModule.ModuleName;
            IntPtr moduleHandle = GetModuleHandle(moduleName);

            return SetWindowsHookEx(WH_KEYBOARD_LL, llkProcedure, moduleHandle, 0);
        }

        private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN)
            {
                int vkCode = Marshal.ReadInt32(lParam);
                Console.Out.Write((Keys)vkCode);
                if (currentProgramState == ProgramState.RECORDING && vkCode == VK_J)
                {
                    //MessageBox.Show("Record");

                    GetImage();
                    GetCharacterCoords();
                    WriteToFile();
                }

            }
            return CallNextHookEx(IntPtr.Zero, nCode, wParam, lParam);
        }

        private void RemoveHook()
        {
            //Removes the hook
            UnhookWindowsHookEx(hook);
        }

        private static void WriteToFile()
        {
            string newText = currentXCord + "," + currentYCord;
            using (StreamWriter outputFile = File.AppendText(folderPath + filename))
            {
                outputFile.WriteLine(newText);
            }
        }

        #endregion

        private void ReadRoute()
        {
            if (Route.Count <= 0)
            {
                filename = TextFileName.Text;
                Route = new List<string>();
                using (StreamReader file = new StreamReader(folderPath + filename))
                {
                    string ln;

                    while ((ln = file.ReadLine()) != null)
                    {
                        Route.Add(ln);
                    }
                    file.Close();
                }
            }
        
        }

        private void GetNextCoords()
        {
            if (ActiveRoute.Count <= 0)
            {
                foreach (string item in Route)
                {
                    ActiveRoute.Add(item);
                }
            }
            
            string[] coord = ActiveRoute[0].Split(',');
            if (coord[0] != "")
            {
                targetXCord = Convert.ToDouble(coord[0]);
                targetYCord = Convert.ToDouble(coord[1]);
                ActiveRoute.RemoveAt(0);
            }
            else
            {
                StopMovement();
            }
            
            
        }

        private void CheckTargetState()
        {
            if (SearchPixel("#00B000", 1, 0))
            {
               MessageBox.Show("Has target");
                currentTargetState = TargetState.KILLABLETARGET;
            }
            else if(SearchPixel("#008C00", 1, 0))
            {
                MessageBox.Show("TargetDead");
                currentTargetState = TargetState.DEADTARGET;
            }
            else
            {
                MessageBox.Show("No target");
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
                DoWait(333);
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
            if (targetXCord == 0 && targetYCord == 0)
            {
                GetNextCoords();
            }
            else if (GetDistance() < 0.60)
            {
                GetNextCoords();
            }

            GetImage();
            GetCharacterCoords();
            GetCharacterFacing();
            GetTurnValue();

            if (currentActionState != ActionState.MOVING)
            {
                FaceTargetPoint();
                StartMovement();
            }
            CheckForPoint();
        }

        private void StartMovement()
        {
            SetForegroundWindow(pros.MainWindowHandle);
            currentActionState = ActionState.MOVING;
            PostMessage(pros.MainWindowHandle, WM_KEYDOWN, VK_W, 0);

        }

        private void StopMovement()
        {
            SetForegroundWindow(pros.MainWindowHandle);

            currentActionState = ActionState.STANDING;
            PostMessage(pros.MainWindowHandle, WM_KEYUP, VK_W, 0);

        }



        void CheckForPoint()
        {
            
            GetImage();
            GetCharacterCoords();
            GetCharacterFacing();
            GetTurnValue();
            dist = GetDistance();

            FaceTargetPoint();

            DebugCurTurn.Text = currentFacIng.ToString();
            DebugWantTurn.Text = pitch.ToString();
            DebugTurnValue.Text = currentTurnValue.ToString();
            DebugText.Text = dist.ToString();
            DebugCurrXcord.Text = currentXCord.ToString();
            DebugCurrYcord.Text = currentYCord.ToString();
            DebugTarXcord.Text = targetXCord.ToString();
            DebugTarYcord.Text = targetYCord.ToString(); 
            if (dist < 0.60)
            {
                
                //StopMovement();
                MovementLoop();
            }
            else
            {
                 DoWait(2500);
                 CheckForPoint();
            }
        }

        private void FaceTargetPoint()
        {
            int delayTime = 0;

            /*if (currentTurnValue < 1000)
            {
                DoAction(VK_A, currentTurnValue);
            }
            else
            {
                delayTime = 2000 - currentTurnValue;
                DoAction(VK_D, delayTime);
            }*/

            if (pitch > currentFacIng)
            {
                //yaw_result = pitch - currentFacIng;
                if (currentTurnValue < 1000)
                {
                    DoAction(VK_A, currentTurnValue);
                }
                else
                {
                    delayTime = 2000 - currentTurnValue;
                    DoAction(VK_D, delayTime);
                }
            }
            else if (pitch < currentFacIng)
            {
                if (currentTurnValue > 1000)
                {
                    delayTime = 2000 - currentTurnValue;
                    DoAction(VK_D, delayTime);
                }
                else
                {
                    DoAction(VK_A, currentTurnValue);
                }
                //yaw_result = (2000 - currentFacIng) + pitch; // I used a 0-2000 range to make stuff easier. 
            }
            else
            {
                //yaw_result = 0;
            }


        }

        private void DoAction(int key, int delay)
        {
            SetForegroundWindow(pros.MainWindowHandle);
            PostMessage(pros.MainWindowHandle, WM_KEYDOWN, key, 0);
            DoWait(delay);
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
                DoWait(rnd.Next(300, 2000));

                CombatLoop();
            }
            else if (currentTargetState == TargetState.NOTARGET && HadTarget)
            {
                HadTarget = false;
                currentActionState = ActionState.LOOTING;
                Random rnd = new Random();
                
                DoAction(VK_L, 0);
                DoWait(rnd.Next(600, 700));
                DoAction(VK_K, 0);
                DoWait(rnd.Next(5000, 5300));
                DoAction(VK_K, 0);
                DoWait(rnd.Next(1000, 1300));
                DoAction(VK_K, 0);
                DoWait(3500);

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
            int ConvXPos = Convert.ToInt32(xPos * PixelSizeWidth);

            Color currentPixColor = bitmap.GetPixel(ConvXPos, yPos);
            if (currentPixColor == convertedColor)
            {
                return true;
            }
            return false;
        }

        private static void GetImage()
        {
            //bitmap with screen size
            bitmap = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height);

            //object that can capture the screen
            Graphics graphics = Graphics.FromImage(bitmap as System.Drawing.Image);
            //Takes the screenshot
            graphics.CopyFromScreen(0, 0, 0, 0, bitmap.Size);

            //Translate hexcode to Color object
            convertedColor = ColorTranslator.FromHtml("#00B000");
            
        }

        static void GetCharacterCoords()
        {
            xCoord = 0;
            xCoordDeci = 0;
            yCoord = 0;
            yCoordDeci = 0;

            for (int y = 1; y <= 2; y++)
            {
                for (int x = 0; x <= 100; x++)
                {
                    Color currentPixColor = bitmap.GetPixel(x, y);

                    if (currentPixColor == convertedColor)
                    {
                        if (y == 1)
                        {
                            xCoord = Convert.ToInt32(x/ PixelSizeWidth);

                        }
                        else if (y == 2)
                        {

                            yCoord = Convert.ToInt32(x / PixelSizeWidth);
                            
                        }
                    }
                }
            }
            string xcordBuilder = "";
            string ycordBuilder = "";

            int x1 = 0;
            int x2 = 0;
            int x3 = 0;
            int x4 = 0;
            int x5 = 0;
            int y1 = 0;
            int y2 = 0;
            int y3 = 0;
            int y4 = 0;
            int y5 = 0;


            for (int y = 3; y <= 12; y++)
            {
                for (int x = 0; x <= 9; x++)
                {
                    int ConvXPos = Convert.ToInt32(x * PixelSizeWidth);
                    int ConvyPos = Convert.ToInt32(y * PixelSizeWidth);
                    Color currentPixColor = bitmap.GetPixel(ConvXPos, ConvyPos);

                    if (currentPixColor == convertedColor)
                    {
                        if (y == 3)
                        {
                            x1 = Convert.ToInt32(x);
                        }
                        else if(y == 4)
                        {
                            x2 = Convert.ToInt32(x);
                        }
                        else if (y == 5)
                        {
                            x3 = Convert.ToInt32(x);
                        }
                        else if (y == 6)
                        {
                            x4 = Convert.ToInt32(x);
                        }
                        else if (y == 7)
                        {
                            x5 = Convert.ToInt32(x);
                        }
                        else if (y == 8)
                        {
                            y1 = Convert.ToInt32(x);
                        }
                        else if (y == 9)
                        {
                            y2 = Convert.ToInt32(x);
                        }
                        else if (y == 10)
                        {
                            y3 = Convert.ToInt32(x);
                        }
                        else if (y == 11)
                        {
                            y4 = Convert.ToInt32(x);
                        }
                        else if (y == 12)
                        {
                            y5 = Convert.ToInt32(x);
                        }

                    }
                }
            }
            xcordBuilder = x1.ToString() + x2.ToString() + x3.ToString() + x4.ToString() + x5.ToString();
            ycordBuilder = y1.ToString() + y2.ToString() + y3.ToString() + y4.ToString() + y5.ToString();

            xCoordDeci = Convert.ToInt32(xcordBuilder);
            yCoordDeci = Convert.ToInt32(ycordBuilder);

            currentXCord = Convert.ToDouble(xCoord.ToString() + "." + xcordBuilder);
            currentYCord = Convert.ToDouble(yCoord.ToString() + "." + ycordBuilder);
        }

        void GetCharacterFacing()
        {
            newFacing = 0;

            for (int x = 0; x < 1500; x++)
            {
                int ConvXPos = Convert.ToInt32(x * PixelSizeWidth);
                int ConvyPos = Convert.ToInt32(13 * PixelSizeWidth);

                Color currentPixColor = bitmap.GetPixel(ConvXPos, ConvyPos);

                if (currentPixColor == convertedColor)
                {
                    newFacing = Convert.ToInt32(x);
                }
            }
            currentFacIng = newFacing * 2;
            
        }

        void GetTurnValue()
        {
            double yaw_result;
            pitch = DetermineTurnAngle(currentYCord, targetYCord, currentXCord, targetXCord);

            if (currentFacIng == 0)
            {
                currentFacIng = pitch;
            }

            if (currentFacIng != pitch)
            {
                if (pitch > currentFacIng)
                {
                    yaw_result = pitch - currentFacIng;
                }
                else if (pitch < currentFacIng)
                {
                    yaw_result = (2000 - currentFacIng) + pitch; // I used a 0-2000 range to make stuff easier. 
                }
                else
                {
                    yaw_result = 0;
                }
                currentTurnValue = (int)yaw_result;
            }
            else
            {
                currentTurnValue = 0;
            }
            
        }


        double DetermineTurnAngle(double currentY, double targetY, double currentX, double targetX)
        {
            double ang = Math.Atan2(currentX - targetX, currentY - targetY) / Math.PI;
            if (ang < 0) ang += 2; // this is used to avoind negative numbers. 
            return Math.Round(ang * 1000);
            

        }

        private double GetDistance()
        {
            double distance = Math.Sqrt((Math.Pow(targetXCord - currentXCord, 2) + Math.Pow(targetYCord - currentYCord, 2)));
            return distance;
        }

        public void DoWait(int milliseconds) // It will wait number of miliseconds. 
        {
            Stopwatch sw = Stopwatch.StartNew();
            while (sw.ElapsedMilliseconds <= milliseconds)
            {
                Application.DoEvents();
            }
        }

    }
}
