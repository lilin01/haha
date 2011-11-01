package com.app.view.game
{
	import flash.display.*;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import com.app.config.UrlConfig;
	public class MainRelic extends MovieClip
	{
		private var main:Object;
		private var relic:Object;
		public var iid:String;
		private var startX:Number;
		private var startY:Number;
		private var radCon:Number = 0.0174533;
		private var currentStep:Number;
		private var floatSpeed:Object;
		private var bmp:Loader;
		private var sprite:int = 0;
		/**
		 *relic yuanjian 
		 * @param param1 父级
		 * @param param2 relic信息 为0表示没有relic
		 * @param param3 x
		 * @param param4 y
		 * @param param5 是否可用
		 * 
		 */		
		public function MainRelic(param1:DisplayObject, param2:Object, param3:int, param4:int, param5:Boolean = true)
		{
			this.currentStep = int(Math.random() * 360);
			this.floatSpeed = int(Math.random() * 3) + 2;
			this.main = param1;
			this.relic = param2;
			this.iid = "0";
			this.sprite = 0;
			//var _loc_6:int = param3;
			x = param3;
			this.startX = x;
			//_loc_6:int = param4;
			y = param4;
			this.startY = y;
			this.bmp=new Loader()
			this.addChild(bmp);
			if (param2 == 0)
			{
			}
			else
			{
				this.iid = this.relic.iid;
				this.sprite = parseInt(this.relic.sprite);
				this.bmp.load(new URLRequest(UrlConfig.RELICIMGURL+ this.relic.sprite + ".png"));
				this.bmp.contentLoaderInfo.addEventListener(Event.COMPLETE, this.adjustGraphic);
			}
			if (param5)
			{
				buttonMode = true;
				this.addEventListener(MouseEvent.CLICK, this.openRelicWindow);
				this.addEventListener(MouseEvent.ROLL_OVER, this.showStats);
				this.addEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			}
			this.addEventListener(Event.ENTER_FRAME, this.update);
			return;
		}// end function
		/**
		 *relic 上下浮动 
		 * @param e
		 * 
		 */	
		public function update(e:Event):void
		{
			this.currentStep = this.currentStep + this.floatSpeed;
			if (this.currentStep >= 360)
			{
				this.currentStep = this.currentStep - 360;
			}
			y = this.startY + 4 * Math.sin(this.currentStep * this.radCon);
			return;
		}// end function
		
		private function openRelicWindow(... args):void
		{
			this.main.openRelicWindow(this.relic);
			return;
		}// end function
		
		private function showStats(... args):void
		{
			this.main.showStats(this.relic, x, y);
			return;
		}// end function
		
		private function hideStats(... args):void
		{
			this.main.hideStats();
			return;
		}// end function
		/**
		 * 
		 * @param param1 为0 relic设为空 否则加载relic图片
		 * @return 
		 * 
		 */		
		public function setRelic(param1:Object):void
		{
			this.bmp.unload();
			if (param1 != 0)
			{
				this.relic = param1;
				this.sprite = parseInt(this.relic.sprite);
				this.bmp.load(new URLRequest(UrlConfig.RELICIMGURL + this.relic.sprite + ".png"));
				//trace("http://ninjawarzdev.brokenbulbstudios.com/swf/relicshopgfx/" + this.relic.sprite + ".png");
				this.bmp.contentLoaderInfo.addEventListener(Event.COMPLETE, this.adjustGraphic);
			}
			return;
		}// end function
		
		private function adjustGraphic(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, this.adjustGraphic);
			this.bmp.x = -(this.bmp.width >> 1);
			this.bmp.y = -(this.bmp.height >> 1);
			return;
		}// end function
		
		//Security.allowDomain("*");
	}
}
