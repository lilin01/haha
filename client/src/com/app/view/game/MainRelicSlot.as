package com.app.view.game
{
	import com.app.model.UserInfoModel;
	
	import flash.display.*;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import com.app.config.UrlConfig;
	public class MainRelicSlot extends MovieClip
	{
		private var main:Object;
		private var relic:Object;
		public var iid:String;
		private var bmp:Loader;
		private var sprite:int = 0;
		private var relicMain:Object;
		private var slot:int = 0;
		private var possiblePrices:Array;
		/**
		 * 
		 * @param param1 parent
		 * @param param2 slot编号
		 * @param param3 relic
		 * @param param4 x
		 * @param param5 y
		 * 
		 */		
		public function MainRelicSlot(param1:DisplayObject, param2:int, param3:Object, param4:int, param5:int):void
		{
			this.possiblePrices = new Array(0, 2, 5, 10, 20, 50);
			this.main = param1;
			this.relic = param3;
			this.slot = param2;
			this.sprite = parseInt(this.relic.sprite);
			//this.bmp = this.addChild(new Loader());
			this.bmp = new Loader();
			this.addChild(bmp);
			buttonMode = true;
			if (this.slot == parseInt(UserInfoModel.instance.UserInfo.relic_slots))
			{
				this.bmp.load(new URLRequest(UrlConfig.RELICSTINY+"buy.png"));
				this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
				this.sprite = -2;
			}
			else if (this.slot > parseInt(UserInfoModel.instance.UserInfo.relic_slots))
			{
				visible = false;
				buttonMode = false;
			}
			else
			{
				if (parseInt(this.relic.iid) > 0)
				{
					this.bmp.load(new URLRequest(UrlConfig.RELICSTINY + this.relic.sprite + ".png"));
				}
				else
				{
					this.enable();
					this.bmp.load(new URLRequest(UrlConfig.RELICSTINY  + "empty" + ".png"));
				}
				this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			}
			x = param4;
			y = param5;
			this.addEventListener(MouseEvent.CLICK, this.openRelicWindow);
			this.addEventListener(MouseEvent.ROLL_OVER, this.showStats);
			this.addEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			return;
		}// end function
		/**
		 *设置数据 
		 * @param param1 relic信息
		 * 
		 */		
		public function setRelic(param1:Object):void
		{
			trace("setRelic");
			this.relic = param1;
			if (parseInt(this.relic.iid) > 0)
			{
				this.sprite = parseInt(this.relic.sprite);
				this.setGraphic(parseInt(this.relic.sprite));
			}
			else
			{
				this.bmp.load(new URLRequest(UrlConfig.RELICSTINY +"empty" + ".png"));
				this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			}
			return;
		}// end function
		
		public function enable():void
		{
			trace("enable()");
			this.sprite = -1;
			this.relic = {name:"Open Relic Slot", description:"Click here to add a relic from your inventory.", iid:"0"};
			this.bmp.load(new URLRequest(UrlConfig.RELICSTINY +"empty" + ".png"));
			this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			this.addEventListener(MouseEvent.CLICK, this.openRelicWindow);
			this.addEventListener(MouseEvent.ROLL_OVER, this.showStats);
			this.addEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			return;
		}// end function
		/**
		 *slot设为buy 
		 * 
		 */		
		public function queueUp():void
		{
			this.sprite = -2;
			this.relic = {name:"Add Relic Slot", description:"Purchase for " + this.possiblePrices[this.slot] + " Karma?", slot:this.slot, iid:-1};
			visible = true;
			buttonMode = true;
			this.bmp.load(new URLRequest(UrlConfig.RELICSTINY + "buy" + ".png"));
			this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			this.addEventListener(MouseEvent.CLICK, this.openRelicWindow);
			this.addEventListener(MouseEvent.ROLL_OVER, this.showStats);
			this.addEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			return;
		}// end function
		
		private function openRelicWindow(... args):void
		{
			if (this.sprite == -2)
			{
				this.main.openPurchaseWindow(this.relic, this.slot);
			}
			else
			{
				this.main.openSlotWindow(this.relic, this.slot);
			}
			return;
		}// end function
		
		private function showStats(... args):void
		{
			trace("showStats");
			this.main.showRelicStats(this.relic ? (this.relic) : ({name:"Add Relic Slot", description:"Purchase for " + this.possiblePrices[this.slot] + " Karma?"}), 590, 50);
			return;
		}// end function
		
		private function hideStats(... args):void
		{
			this.main.hideRelicStats();
			return;
		}// end function
		/**
		 *设置relic图片 
		 * @param param1
		 * @return 
		 * 
		 */		
		public function setGraphic(param1:int):void
		{
			trace("setGraphic()");
			this.bmp.unload();
			this.sprite = param1;
			if (parseInt(this.relic.iid) > 0)
			{
				this.bmp.load(new URLRequest(UrlConfig.RELICSTINY + this.relic.sprite + ".png"));
				this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			}
			else
			{
				this.relic = {name:"Open Relic Slot", description:"Click here to add a relic from your inventory.", iid:"0"};
				this.bmp.load(new URLRequest(UrlConfig.RELICSTINY + "empty" + ".png"));
				this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			}
			return;
		}// end function
		
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			return;
		}// end function
		
		public function disable():void
		{
			this.removeEventListener(MouseEvent.CLICK, this.openRelicWindow);
			this.removeEventListener(MouseEvent.ROLL_OVER, this.showStats);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			buttonMode = false;
			return;
		}// end function
		
		public function reenable():void
		{
			this.addEventListener(MouseEvent.CLICK, this.openRelicWindow);
			this.addEventListener(MouseEvent.ROLL_OVER, this.showStats);
			this.addEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			buttonMode = true;
			return;
		}// end function
		
		public function destroy():void
		{
			this.removeEventListener(MouseEvent.CLICK, this.openRelicWindow);
			this.removeEventListener(MouseEvent.ROLL_OVER, this.showStats);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			parent.removeChild(this);
			return;
		}// end function
		
		//Security.allowDomain("*");
	}
}
