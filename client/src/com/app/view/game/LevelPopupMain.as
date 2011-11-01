package com.app.view.game {
	import flash.events.*;
	import flash.display.*;
	import flash.net.*;
	import flash.system.*;
	import flash.external.*;
	import res.game.LevelPopupMainMC;
	import com.app.config.UrlConfig;
	public class LevelPopupMain extends LevelPopupMainMC {
		
		private var l:Object;
		private var prefix:String = "";
		private var main:Object;
		private var mapMain:Object;
		private var level:int = 0;
		private var yesFunction:Function;
		private var noFunction:Function;
		private var imageLoader:Object;
		
		public function LevelPopupMain(param1, param2:Object, param3:int, param4:int, param5:Function, param6:Function = null)
		{
			var _loc_7:int = 0;
			this.l = new Loader();
			this.main = param1;
			this.main.soundManager.loadSoundEffect("daimyo_reward");
			x = param3;
			y = param4;
			if (param2.unlocked && param2.unlocked.length > 0)
			{
				_loc_7 = 0;
				while (_loc_7 < param2.unlocked.length)
				{
					
					if (param2.unlocked[_loc_7].type == "1")
					{
						this.addChild(new Weapon(this.main, param2.unlocked[_loc_7], -45 * (param2.unlocked.length - 1) + 90 * _loc_7, 72));
					}
					else
					{
						this.addChild(new Relic(this.main, param2.unlocked[_loc_7], -45 * (param2.unlocked.length - 1) + 90 * _loc_7, 72));
					}
					_loc_7++;
				}
			}
			else
			{
				newText.visible = false;
			}
			this.imageLoader = levelHolder.addChildAt(new Loader(), 0);
			levelText.text = "You are now level " + (parseInt(param2.level) + 1) + "!";
			karmaText.text = "You gained " + Math.min(Math.ceil((parseInt(param2.level) + 2) / 10) * 5, 15) + " karma!";
			this.level = parseInt(param2.level) + 1;
			this.imageLoader.load(new URLRequest(UrlConfig.LEVELIMGURL + this.level + ".png"));
			this.imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.resizeImage);
			this.yesFunction = param5;
			this.noFunction = param6;
			this.enableButtons();
			return;
		}// end function
		
		private function resizeImage(event:Event)
		{
			if (this.level > 45)
			{
				var _loc_2:* = 90 / this.imageLoader.height;
				this.imageLoader.scaleY = 90 / this.imageLoader.height;
				this.imageLoader.scaleX = _loc_2;
			}
			return;
		}// end function
		
		private function disableButtons()
		{
			noButton.buttonMode = false;
			yesButton.buttonMode = false;
			noButton.hitZone.removeEventListener(MouseEvent.CLICK, this.deny);
			noButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			noButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			noButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
			noButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
			yesButton.hitZone.removeEventListener(MouseEvent.CLICK, this.confirm);
			yesButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			yesButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			yesButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
			yesButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
			return;
		}// end function
		
		private function enableButtons()
		{
			noButton.buttonMode = true;
			noButton.hitZone.addEventListener(MouseEvent.CLICK, this.deny);
			noButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			noButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			yesButton.buttonMode = true;
			yesButton.hitZone.addEventListener(MouseEvent.CLICK, this.confirm);
			yesButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			yesButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			return;
		}// end function
		
		public function closeWindow(... args)
		{
			this.main.alertWindow = null;
			this.disableButtons();
			parent.removeChild(this);
			
			return;
		}// end function
		
		private function confirm(... args)
		{
			trace("share_level");
			/*if (ExternalInterface.available)
			{
			ExternalInterface.call("share_level", (this.main.level + 1));
			}*/
			
			this.yesFunction();
			return;
		}// end function
		
		private function deny(... args)
		{
			if (this.noFunction != null)
			{
				this.noFunction();
			}
			return;
		}// end function
		
		private function startFloat(event:MouseEvent)
		{
			event.currentTarget.parent.buttonAnim.removeEventListener(Event.ENTER_FRAME, this.floatDown);
			event.currentTarget.parent.buttonAnim.addEventListener(Event.ENTER_FRAME, this.floatUp);
			return;
		}// end function
		
		private function stopFloat(event:MouseEvent)
		{
			event.currentTarget.parent.buttonAnim.addEventListener(Event.ENTER_FRAME, this.floatDown);
			event.currentTarget.parent.buttonAnim.removeEventListener(Event.ENTER_FRAME, this.floatUp);
			return;
		}// end function
		
		private function floatUp(event:Event)
		{
			if (event.currentTarget.y < -6)
			{
				event.currentTarget.removeEventListener(Event.ENTER_FRAME, this.floatUp);
			}
			else
			{
				event.currentTarget.y = event.currentTarget.y - 2;
			}
			return;
		}// end function
		
		private function floatDown(event:Event)
		{
			if (event.currentTarget.y >= 0)
			{
				event.currentTarget.removeEventListener(Event.ENTER_FRAME, this.floatDown);
			}
			else
			{
				event.currentTarget.y = event.currentTarget.y + 2;
			}
			return;
		}// end function

	}
}//package 