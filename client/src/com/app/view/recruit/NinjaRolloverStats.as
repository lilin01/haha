package com.app.view.recruit
{
    import flash.display.*;
	import res.recruit.NinjaRolloverStatsMC;
    public class NinjaRolloverStats extends NinjaRolloverStatsMC
    {
        private var main:Object;
        private var dojo:Object;
        private var ninja:Object;
        private var bmp:Bitmap;

        public function NinjaRolloverStats(param1, param2:int = 0, param3:int = 0)
        {
            ninja = param1;
            visible = false;
            x = param2;
            y = param3;
            mouseEnabled = false;
            mouseChildren = false;
            return;
        }// end function

        public function display(param1, param2:int, param3:int)
        {
            ninja = param1;
            if (param3 > 400)
            {
                param3 = 150;
            }
            x = param2;
            y = param3;
            visible = true;
            ninjaName.text = ninja.name;
            ninjaLevel.text = ninja.level;
            ninjaPower.text = ninja.power;
            ninjaHealth.text = ninja.health;
            ninjaBlood.text = ninja.blood_type;
            ninjaPrice.text = ninja.price;
            return;
        }// end function

        public function undisplay()
        {
            visible = false;
            return;
        }// end function

    }
}
