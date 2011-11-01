package com.app.view.game
{
	import flash.display.Loader;
	import flash.events.*;
	
	import res.game.AlertPopupMC;
	public class AlertPopup extends AlertPopupMC
	{
		private var l:Loader;
		private var prefix:String = "";
		private var main:Object;
		private var mapMain:Object;
		private var executeFunction:Function;
		
		public function AlertPopup(param1, param2:String, param3:int = 0, param4:int = 0, param5:Function = null, param6:Boolean = true)
		{
			this.l = new Loader();
			this.main = param1;
			//this.main.soundManager.loadSoundEffect("warning");
			x = param3;
			y = param4;
			alertText.text = param2;
			alertText.y = alertText.y - (alertText.numLines - 1) * 10;
			this.executeFunction = param5;
			if (param6)
			{
				okButton.hitZone.buttonMode = true;
				okButton.hitZone.addEventListener(MouseEvent.CLICK, this.closeWindow);
				okButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
				okButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			}
			else
			{
				okButton.visible = false;
			}
			return;
		}// end function
		
		public function closeWindow(... args)
		{
			//this.main.buttonSound();
			this.main.alertWindow = null;
			okButton.hitZone.removeEventListener(MouseEvent.CLICK, this.closeWindow);
			okButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			okButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			if (this.executeFunction != null)
			{
				this.executeFunction();
			}
			parent.removeChild(this);
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
		
		//Security.allowDomain("*");
	}
}
