package com.app.view.dojo
{
	import flash.display.*;
	import res.dojo.NinjaRolloverStatsMC;
	public class NinjaRolloverStats extends NinjaRolloverStatsMC
	{
		private var main:Object;
		private var dojo:Object;
		private var ninja:Object;
		private var bmp:Bitmap;
		
		public function NinjaRolloverStats(param1, param2:int = 0, param3:int = 0)
		{
			this.ninja = param1;
			visible = false;
			x = param2;
			y = param3;
			mouseEnabled = false;
			mouseChildren = false;
			return;
		}// end function
		
		public function display(param1, param2:int, param3:int)
		{
			this.ninja = param1;
			if (param3 > 360)
			{
				param3 = 110;
			}
			x = param2;
			y = param3;
			visible = true;
			ninjaName.text = this.ninja.name;
			ninjaLevel.text = this.ninja.level;
			ninjaPower.text = this.ninja.power;
			ninjaHealth.text = this.ninja.health + "/" + this.ninja.modified_max_health;
			ninjaBlood.text = this.ninja.blood_type;
			ninjaWeapon.text = this.ninja.weapon.name;
			return;
		}// end function
		
		public function undisplay()
		{
			visible = false;
			return;
		}// end function
		
	//	Security.allowDomain("*");
	}
}
