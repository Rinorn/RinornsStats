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
            ProgramLoop();
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
                DoAction(VK_TAB);
                Thread.Sleep(333);
                CheckTargetState();
                if (currentTargetState == TargetState.KILLABLETARGET)
                {
                    DoAction(VK_K);
                    currentActionState = ActionState.FIGHTING;
                    CombatLoop();
                }
            }
        }



        private void DoAction(int key)
        {
            SetForegroundWindow(pros.MainWindowHandle);
            PostMessage(pros.MainWindowHandle, WM_KEYDOWN, key, 0);
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
                    DoAction(VK_K);
                    DoAction(VK_Q);
                }
                else if (currentRangeState == RangeState.RANGED)
                {
                    DoAction(VK_Q);
                }
                else if (currentRangeState == RangeState.MELLE)
                {
                    DoAction(VK_E);
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
                
                DoAction(VK_L);
                Thread.Sleep(rnd.Next(600, 700));
                DoAction(VK_K);
                Thread.Sleep(rnd.Next(5000, 5300));
                DoAction(VK_K);
                Thread.Sleep(rnd.Next(1000, 1300));
                DoAction(VK_K);
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
    }
}
