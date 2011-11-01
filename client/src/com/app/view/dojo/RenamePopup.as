package com.app.view.dojo
{

	import fl.managers.*;
	
	import flash.display.*;
	import flash.events.*;
	import com.app.model.UserInfoModel;
	import res.dojo.RenamePopupMC;
	public class RenamePopup extends RenamePopupMC
	{
		private var main:Object;
		private var dojo:Object;
		private var ninja:Object;
		private var ninjaWindow:Object;
		private var bmp:Bitmap;
		private var moneyIcon:Object = null;
		private var backboard:Object = null;
		private var fm:FocusManager;
		
		public function RenamePopup(param1, param2, param3, param4:int = 0, param5:int = 0)
		{
			this.main = param1;
			this.ninja = param2;
			this.ninjaWindow = param3;
			//this.fm = new FocusManager(this.parent);
			//this.fm = new FocusManager(this.main);
			x = param4;
			y = param5;
			nameInput.text = this.ninja.name;
			nameInput.maxChars = 36;
			//this.fm.setFocus(nameInput);
			nameInput.setSelection(0, this.ninja.name.length);
			nameInput.restrict = "a-zA-Z \\-";
			price.weaponPrice.text = 1;
			this.moneyIcon = price.addChild(new Bitmap(new KarmaIcon(1, 1)));
			if (UserInfoModel.instance.UserInfo.karma < 1)
			{
				yesBtn.visible = false;
				price.weaponPrice.textColor = 6684672;
			}
			else
			{
				karmaBtn.visible = false;
				price.weaponPrice.textColor = 2362628;
			}
			this.moneyIcon.x = price.weaponPrice.x + price.weaponPrice.textWidth + 10;
			this.moneyIcon.y = (-this.moneyIcon.height) / 2;
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
			karmaBtn.hitZone.removeEventListener(MouseEvent.CLICK, this.sendToGoldmine);
			karmaBtn.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			karmaBtn.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			karmaBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
			karmaBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
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
			karmaBtn.buttonMode = true;
			karmaBtn.hitZone.addEventListener(MouseEvent.CLICK, this.sendToGoldmine);
			karmaBtn.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			karmaBtn.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			return;
		}// end function
		
		private function deny(event:Event)
		{
			//this.main.buttonSound();
			this.destroy();
			return;
		}// end function
		
		private function confirm(event:Event)
		{
			if (UserInfoModel.instance.UserInfo.karma > 0 && nameInput.text.length > 0 && nameInput.text != this.ninja.name)
			{
				//this.main.buttonSound();
				this.ninjaWindow.renameNinja(nameInput.text);
				this.destroy();
			}
			return;
		}// end function
		
		public function destroy()
		{
			this.ninjaWindow.renamePopup = null;
			this.disableButtons();
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
		
		private function sendToGoldmine(... args)
		{
			trace("renamepopup_sendToGoldmine");
			//this.main.gotoGoldmine();
			return;
		}// end function
		
//		Security.allowDomain("*");
	}
}
