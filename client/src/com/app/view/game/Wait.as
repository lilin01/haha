package com.app.view.game 
{
	import flash.events.*;
	import res.game.mcWait;
	public class Wait extends mcWait
	{
		private var main:Object;
		
		public function Wait(param1, param2:int = 0, param3:int = 0)
		{
			this.main = param1;
			x = param2;
			y = param3;
			mouseEnabled = false;
			mouseChildren = false;
			this.addEventListener(Event.ENTER_FRAME, this.update);
			return;
		}// end function
		
		private function update(event:Event)
		{
			shuriken.rotation = shuriken.rotation + 2;
			return;
		}// end function
		
		public function destroy(... args)
		{
			this.removeEventListener(Event.ENTER_FRAME, this.update);
			parent.removeChild(this);
			return;
		}// end function
		
	}
}
