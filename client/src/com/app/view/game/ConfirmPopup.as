package com.app.view.game
{
	import flash.events.*;
	import res.game.ConfirmPopupMC;
	public class ConfirmPopup extends ConfirmPopupMC
	{
		private var main:Object;
		private var mapMain:Object;
		private var yesFunction:Function;
		private var noFunction:Function;
		/**
		 * 
		 * @param param1 父级
		 * @param param2 字符串、提示消息
		 * @param param3 x
		 * @param param4 y
		 * @param param5 点击yes执行的函数
		 * @param param6 点击no 执行的函数
		 * 
		 */		
		public function ConfirmPopup(param1, param2:String, param3:int, param4:int, param5:Function, param6:Function = null)
		{
			this.main = param1;
			//this.main.soundManager.loadSoundEffect("warning");
			x = param3;
			y = param4;
			confirmText.text = param2;
			this.yesFunction = param5;
			this.noFunction = param6;
			this.enableButtons();
			return;
		}// end function
		
		private function disableButtons()
		{
			noBtn.buttonMode = false;
			yesBtn.buttonMode = false;
			noBtn.hitZone.removeEventListener(MouseEvent.CLICK, this.deny);
			noBtn.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			noBtn.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			noBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
			noBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
			yesBtn.hitZone.removeEventListener(MouseEvent.CLICK, this.confirm);
			yesBtn.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			yesBtn.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			yesBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
			yesBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
			return;
		}// end function
		
		private function enableButtons()
		{
			noBtn.buttonMode = true;
			yesBtn.buttonMode = true;
			noBtn.hitZone.addEventListener(MouseEvent.CLICK, this.deny);
			noBtn.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			noBtn.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			yesBtn.hitZone.addEventListener(MouseEvent.CLICK, this.confirm);
			yesBtn.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			yesBtn.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			return;
		}// end function
		/**
		 *关闭窗口 
		 * @param args
		 * 
		 */		
		public function closeWindow(... args):void
		{
			//this.main.buttonSound();
			this.main.confirmWindow = null;
			this.disableButtons();
			parent.removeChild(this);
			return;
		}// end function
		
		private function confirm(... args):void
		{
			this.closeWindow();
			this.yesFunction();
			return;
		}// end function
		
		private function deny(... args):void
		{
			this.closeWindow();
			if (this.noFunction != null)
			{
				this.noFunction();
			}
			return;
		}// end function
		
		private function startFloat(event:MouseEvent):void
		{
			event.currentTarget.parent.buttonAnim.removeEventListener(Event.ENTER_FRAME, this.floatDown);
			event.currentTarget.parent.buttonAnim.addEventListener(Event.ENTER_FRAME, this.floatUp);
			return;
		}// end function
		
		private function stopFloat(event:MouseEvent):void
		{
			event.currentTarget.parent.buttonAnim.addEventListener(Event.ENTER_FRAME, this.floatDown);
			event.currentTarget.parent.buttonAnim.removeEventListener(Event.ENTER_FRAME, this.floatUp);
			return;
		}// end function
		
		private function floatUp(event:Event):void
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
		
		private function floatDown(event:Event):void
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
}
