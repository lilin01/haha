package com.app.view.dojo
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	public class HealthBar extends MovieClip
	{
		public var dead:Boolean = false;
		private var main:Object;
		private var percentToBattle:Number = 0;
		private var radCon:Number = 0.0174533;
		private var ninja:Array;
		private var timer:int = 30;
		private var currentStep:int = 0;
		private var battleArray:Array;
		private var currentSprite:int = 0;
		private var maxSprite:int = 6;
		private var bmp:Object;
		private var barData:Object;
		
		public function HealthBar(param1:int, param2:int, param3)
		{
			this.ninja = new Array(0);
			x = param1;
			y = param2;
			this.barData = param3;
			this.bmp = this.addChild(new Bitmap(new BitmapData(3, 64, false, 0), "always", true));
			this.bmp.y = -64;
			this.bmp.bitmapData.copyPixels(this.barData, new Rectangle(0, 0, 3, 64), new Point(0, 0));
			return;
		}// end function
		
		public function setHealthBar(param1:int, param2:int)
		{
			this.bmp.bitmapData.dispose();
			this.bmp.bitmapData = new BitmapData(3, 64, false, 0);
			var _loc_3:* = 64 - int(64 * (param1 / param2));
			this.bmp.bitmapData.copyPixels(this.barData, new Rectangle(0, _loc_3, 3, int(64 * (param1 / param2))), new Point(0, _loc_3));
			return;
		}// end function
		
		public function update()
		{
			return;
		}// end function
		
		public function destroy()
		{
			parent.removeChild(this);
			return;
		}// end function
		
	}
}
