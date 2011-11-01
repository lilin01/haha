package com.app.view.game
{
	import flash.display.*;
	import res.game.MainRelicRolloverStatsMC;
	public class MainRelicRolloverStats extends MainRelicRolloverStatsMC
	{
		private var main:Object;
		private var dojo:Object;
		private var relic:Object;
		private var bmp:Bitmap;
		/**
		 * 
		 * @param param1 relic信息
		 * @param param2 x
		 * @param param3 y
		 * 
		 */		
		public function MainRelicRolloverStats(param1, param2:int = 0, param3:int = 0)
		{
			this.relic = param1;
			visible = false;
			x = param2;
			y = param3;
			mouseEnabled = false;
			mouseChildren = false;
			return;
		}// end function
		
		public function display(param1, param2:int, param3:int)
		{
			this.relic = param1;
			x = param2;
			y = param3;
			visible = true;
			relicName.text = this.relic.name;
			relicDisc.text = this.relic.description;
			return;
		}// end function
		
		public function undisplay()
		{
			visible = false;
			return;
		}// end function
		
		//Security.allowDomain("*");
	}
}
