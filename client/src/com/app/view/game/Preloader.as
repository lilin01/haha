package com.app.view.game
{
	import flash.events.*;
	import res.game.PreloaderMC;
	public class Preloader extends PreloaderMC
	{
		private var main:Object;
		private var speed:Number = 0;
		private var faux:Boolean = false;
		
		public function Preloader(param1, param2:Boolean = false, param3:String = "", param4:int = 0, param5:int = 0)
		{
			this.main = param1;
			x = param4;
			y = param5;
			preText.text = param3;
			barMask.scaleX = 0;
			this.faux = param2;
			this.addEventListener(Event.ENTER_FRAME, this.update);
			return;
		}// end function
		
		private function update(... args)
		{
			shuriken.rotation = shuriken.rotation + this.speed;
			if (this.faux)
			{
				this.setPercent(this.speed + 0.5);
			}
			return;
		}// end function
		
		public function setText(param1:String)
		{
			preText.text = param1;
			return;
		}// end function
		
		public function setPercent(param1:Number)
		{
			this.speed = param1;
			barMask.scaleX = Math.min(param1 / 100, 1);
			return;
		}// end function
		
		public function closeWindow(... args)
		{
			this.removeEventListener(Event.ENTER_FRAME, this.update);
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
		
	}
}
