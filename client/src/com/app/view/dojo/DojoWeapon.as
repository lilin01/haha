package com.app.view.dojo 
{
	import flash.display.*;
	import flash.net.URLRequest;
	import com.app.config.UrlConfig;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.app.model.UserInfoModel;
	import com.app.config.UrlConfig;
	public class DojoWeapon extends MovieClip
	{
		private var main:Object;
		private var dojoMain:Object;
		private var weapon:Object;
		public var iid:String;
		public var value:int = 0;
		private var bmp:Object;
		public var sprite:int = 0;
		private var chains:Object;
		
		public function DojoWeapon(param1, param2, param3, param4:int, param5:int, param6:Boolean = true)
		{
			this.main = param1;
			this.dojoMain = param2;
			this.weapon = param3;
			this.iid ="0";
			this.value = 0;
			this.sprite = 0;
			x = param4;
			y = param5;
			this.bmp = this.addChild(new Loader());
			if (param3 == 0)
			{
			}
			else
			{
				this.value = parseInt(this.weapon.value);
				this.sprite = this.weapon.sprite;
				this.bmp.load(new URLRequest(UrlConfig.prefix + "weaponshopgfx/" + this.weapon.sprite + ".png"));
				this.bmp.contentLoaderInfo.addEventListener(Event.COMPLETE, this.adjustGraphic);
			}
			this.chains = this.addChild(new SmallChains());
			this.chains.y = 0;
			this.chains.x = 25;
			this.chains.visible = false;
			
			if (param3 != 0 && parseInt(this.weapon.attributes.min_level) > parseInt(UserInfoModel.instance.UserInfo.level))
			{
				trace(UserInfoModel.instance.UserInfo.level);
			trace(this.weapon.attributes.min_level);
				this.chains.lockText.text = "Unlock at level " + param3.attributes.min_level;
				this.chains.visible = true;
			}
			if (param6)
			{
				buttonMode = true;
				this.addEventListener(MouseEvent.CLICK, this.openWeaponWindow);
				this.addEventListener(MouseEvent.ROLL_OVER, this.showStats);
				this.addEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			}
			return;
		}// end function
		
		private function openWeaponWindow(... args)
		{
			this.dojoMain.openWeaponWindow(this.weapon);
			return;
		}// end function
		
		private function showStats(... args)
		{
			this.dojoMain.showStats(this.weapon, x, y);
			return;
		}// end function
		
		private function hideStats(... args)
		{
			this.dojoMain.hideStats();
			return;
		}// end function
		
		public function setWeapon(param1)
		{
			this.bmp.unload();
			if (param1 != 0)
			{
				this.visible = true;
				this.weapon = param1;
				if (parseInt(param1.attributes.min_level) > parseInt(UserInfoModel.instance.UserInfo.level))
				{
					this.chains.lockText.text = "Unlock at level " + param1.attributes.min_level;
					this.chains.visible = true;
				}
				else
				{
					this.chains.visible = false;
				}
				this.bmp.load(new URLRequest(UrlConfig.prefix + "weaponshopgfx/" + this.weapon.sprite + ".png"));
				
				this.bmp.contentLoaderInfo.addEventListener(Event.COMPLETE, this.adjustGraphic);
			}
			else
			{
				this.visible = false;
			}
			return;
		}// end function
		
		private function adjustGraphic(param1)
		{
			param1.currentTarget.removeEventListener(Event.COMPLETE, this.adjustGraphic);
			this.bmp.x = -this.bmp.width >> 2;
			this.bmp.y = -this.bmp.height;
			param1.currentTarget.content.smoothing = true;
			return;
		}// end function
		
//		Security.allowDomain("*");
	}
}
