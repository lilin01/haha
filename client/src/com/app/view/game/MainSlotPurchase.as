package com.app.view.game
{
import com.app.config.UrlConfig;
import com.app.model.UserInfoModel;
import com.framework.utils.loader.HttpLoader;

import flash.display.DisplayObject;
import flash.events.*;
import flash.net.*;

import res.game.MainSlotPurchaseMC;
	
	public class MainSlotPurchase extends MainSlotPurchaseMC
	{
		private var main:Object;
		private var relicMain:Object;
		private var relic:Object;
		private var purchasepedRelic:Object = null;
		private var slot:int = 0;
		private var price:int = 0;
		private var relicButtons:Array;
		
		public function MainSlotPurchase(param1:DisplayObject, param2:DisplayObject, param3:Object, param4:int, param5:int = 0, param6:int = 0)
		{
			this.relicButtons = new Array(0);
			this.main = param1;
			this.relic = param3;
			x = param5;
			y = param6;
			this.price = param4;
			priceText.text = "Purchase this slot for " + this.price + " Karma?";
			this.enableButtons();
			return;
		}// end function
		
		public function closeWindow(... args):void
		{
			this.disableButtons();
			if(parent)
				this.parent.removeChild(this);
			return;
		}// end function
		
		private function disableButtons():void
		{
			closeBtn.hitZone.buttonMode = false;
			purchase.hitZone.buttonMode = false;
			closeBtn.hitZone.removeEventListener(MouseEvent.CLICK, this.closeWindow);
			closeBtn.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			closeBtn.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			purchase.hitZone.removeEventListener(MouseEvent.CLICK, this.purchaseSlot);
			purchase.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			purchase.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			return;
		}// end function
		
		private function enableButtons():void
		{
			closeBtn.hitZone.buttonMode = true;
			purchase.hitZone.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.CLICK, this.closeWindow);
			closeBtn.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			closeBtn.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			purchase.addEventListener(MouseEvent.CLICK, this.purchaseSlot);
			purchase.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			purchase.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			return;
		}// end function
		
		public function purchaseSlot(... args):void
		{
			this.disableButtons();
			/*args = new URLRequest(this.main.debugPrefix + "/ajax/purchase_relic_slot?PHPSESSID=" + this.main.phpsessid + "");
			args.method = URLRequestMethod.POST;
			var _loc_3:* = new URLLoader();
			_loc_3.addEventListener(Event.COMPLETE, this.purchaseHandler);
			_loc_3.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			_loc_3.load(args);*/
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.PURCHASERELICSLOT,purchaseHandler);
			/*return;*/
			//测试用
			
			
		}// end function
		
		private function finishBuy():void
		{
			this.main.addSlot();
			UserInfoModel.instance.adjustStats(0, -this.price);
			return;
		}// end function
		
		public function purchaseHandler(data:Object) : void
		{
			
			if (data.result == "success")
			{
				this.finishBuy();
			}
			else
			{
				this.main.alert(data.error);
			}
			this.main.yesNoWindow = null;
			this.closeWindow();
			return;/**/
		}// end function
		
		public function ioErrorHandler(param1):void
		{
			this.enableButtons();
			trace(param1);
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
		
		//Security.allowDomain("*");
	}
}
