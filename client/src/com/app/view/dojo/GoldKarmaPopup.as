package com.app.view.dojo
{
	import flash.display.*;
	import res.dojo.GoldKarmaPopupMC;
	import com.framework.utils.CommonUtils;
	public class GoldKarmaPopup extends GoldKarmaPopupMC
	{
		private var main:Object;
		private var dojo:Object;
		private var bmp:Bitmap;
		
		public function GoldKarmaPopup(param1, param2:String, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0)
		{
			this.main = param1;
			messageText.text = param2;
			if (!param3)
			{
				gold.visible = false;
				karma.y = karma.y - 20;
			}
			else
			{
				gold.gold.text = String(CommonUtils.getFormattedNumber(param3));
			}
			if (!param4)
			{
				karma.visible = false;
				gold.y = gold.y + 15;
			}
			else
			{
				karma.karma.text = String(CommonUtils.getFormattedNumber(param4));
			}
			x = param5;
			y = param6;
			mouseEnabled = false;
			mouseChildren = false;
			return;
		}// end function
		
		public function destroy()
		{
			parent.removeChild(this);
			return;
		}// end function
		
//		Security.allowDomain("*");
	}
}
