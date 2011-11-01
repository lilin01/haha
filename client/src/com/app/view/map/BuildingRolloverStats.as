package com.app.view.map 
{
    import flash.display.*;
	import res.map.*;
    public class BuildingRolloverStats extends BuildingRolloverStatsMC
    {
        private var main:Object;
        private var number:int = 0;
        private var bmp:Bitmap;

        public function BuildingRolloverStats(param1:int, param2:int = 0, param3:int = 0)
        {
            this.number = param1;
            visible = false;
            x = param2;
            y = param3;
            mouseEnabled = false;
            mouseChildren = false;
            return;
        }// end function

        public function display(param1:int, param2:int, param3:int, param4:String = "")
        {
            x = param2;
            y = param3;
            visible = true;
            switch(param1)
            {
                case 0:
                {
                    info.text = "Manage the ninjas already in your clan. You can train them, equip their weapons, or even dismiss them here.";
                    break;
                }
                case 1:
                {
                    info.text = "Hire another ninja to join your clan and fight for you.";
                    break;
                }
                case 2:
                {
                    info.text = "Relics are powerful magical items to help you in battle. Buy and sell them here.";
                    break;
                }
                case 3:
                {
                    info.text = "Heal your ninjas... for a fee.";
                    break;
                }
                case 4:
                {
                    info.text = "Weapons give your ninja considerably more powerful attacks. Buy and sell them here.";
                    break;
                }
                case 5:
                {
                    info.text = "Take off to battle another clan for gold and experience!";
                    break;
                }
                case 6:
                {
                    info.text = "Leader of your island and master of Karma and gold. Visit him daily for a special reward.";
                    break;
                }
                case 7:
                {
                    info.text = "ARENA OPEN!\n\nEnter here to join a tournament.";
                    break;
                }
                case 8:
                {
                    info.text = param4;
                    break;
                }
                default:
                {
                    info.text = "Ally with other clans to help them and have them help you!";
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function undisplay()
        {
            visible = false;
            return;
        }// end function

  //      Security.allowDomain("*");
    }
}
