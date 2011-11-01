package com.app.view.dojo
{
	import com.app.config.UrlConfig;
	import com.app.controller.FramebarController;
	import com.app.controller.DojoController;
	import com.app.model.UserInfoModel;
	import com.app.view.dojo.DojoNinja;
	import com.app.view.dojo.NinjaRolloverStats;
	import com.app.view.dojo.PoofParticle;
	import com.app.view.dojo.DojoNinjaWindow;
	import flash.display.*;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLRequest;
	
	import res.dojo.DojoMainMc;
	import res.dojo.HealthBarGraphic;
	public class DojoMain extends DojoMainMc
	{
		
		//private var DojoNinjaWindow:Object;
		private var ninjaList:Array;
		private var ninjaButtons:Array;
		private var statsWindow:NinjaRolloverStats;
		public var largeWeaponsSprites:com.app.view.dojo.WeaponSprites;
		public var healthBar:HealthBarGraphic;
		public var weaponSprites:Array;
		public var ninjaSprites:Array;
		private var particleList:Array;
		private var poofX:int = 375;
		private var poofY:int = 250;
		private var poofTimer:int = 0;
		private var weaponsLoaded:int = 0;
		private var ninjasLoaded:int = 0;
		private var ninjasToLoad:Array;
		private var loadAttempts:int = 0;
		private var preloader:Object;
		private var main:Object;
		public function DojoMain()
		{
			this.ninjaList = new Array(0);
			this.ninjaButtons = new Array(0);
			this.largeWeaponsSprites = new WeaponSprites(400, 300);
			this.healthBar = new HealthBarGraphic(2, 64);
			this.weaponSprites = new Array(0);
			this.ninjaSprites = new Array([null, null], [null, null], [null, null]);
			this.particleList = new Array();
			this.ninjasToLoad = new Array();
			this.enableButton(this.mapButton, this.gotoMap);
			this.addEventListener(Event.ENTER_FRAME, this.loadWeapons);
			return;
		}// end function
		
		public function loadWeapons(... args)
		{
			this.removeEventListener(Event.ENTER_FRAME, this.loadWeapons);
			this.main = FramebarController.instance.framebarview;
			this.preloader = this.main.addPreloader("weapons");
			this.main.hideTrain();
			this.ninjaList =UserInfoModel.instance.UserInfo.ninjas;
			var i = 0;
			while (i < this.ninjaList.length)
			{
				
				this.addWeapon(this.ninjaList[i].weapon);
				i++;
			}
			var _loc_3:int = 0;
			while (_loc_3 < UserInfoModel.instance.UserInfo.weaponInventory.length)
			{
				
				this.addWeapon(UserInfoModel.instance.UserInfo.weaponInventory[_loc_3]);
				_loc_3++;
			}
			if (this.weaponSprites.length > 0)
			{
				this.loadWeapon(0);
			}
			else
			{
				this.getNinjasToLoad();
			}
			return;
		}// end function
		
		private function addWeapon(param1:Object) : void
		{
			if (parseInt(param1.iid) == 0)
			{
				return;
			}
			var _loc_2:int = 0;
			while (_loc_2 < this.weaponSprites.length)
			{
				
				if (param1.iid == "0" || this.weaponSprites[_loc_2][0] == param1.iid)
				{
					return;
				}
				_loc_2++;
			}
			this.weaponSprites.push([param1.iid, param1.sprite, null]);
			return;
		}// end function
		
		public function getWeaponSprite(param1:Object) : BitmapData
		{
			var _loc_2:int = 0;
			while (_loc_2 < this.weaponSprites.length)
			{
				
				if (this.weaponSprites[_loc_2][0] == param1.iid)
				{
					return this.weaponSprites[_loc_2][2];
				}
				_loc_2++;
			}
			return new BitmapData(1, 1, true, 0);
		}// end function
		
		private function loadWeapon(param1:int)
		{
			var _loc_2:Loader = new Loader();
			_loc_2.load(new URLRequest(UrlConfig.prefix + "weaponsheet/" + this.weaponSprites[param1][1] + ".png"));
			_loc_2.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.weaponLoading);
			_loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadWeaponHandler);
			_loc_2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.weaponFail);
			return;
		}// end function
		
		private function weaponLoading(event:ProgressEvent) : void
		{
			var _loc_2:* = event.bytesLoaded / event.bytesTotal * (1 / this.weaponSprites.length) * 100 + this.weaponsLoaded * (1 / this.weaponSprites.length) * 100;
			if (this.preloader != null)
			{
				this.preloader.setPercent(_loc_2);
			}
			return;/**/
		}// end function
		
		private function weaponFail(... args)
		{
			
			args.loadAttempts = loadAttempts + 1;
			if (this.loadAttempts < -5)
			{
				this.loadWeapon(this.weaponsLoaded);
			}
			else
			{
				this.weaponSprites[this.weaponsLoaded][2] = new BitmapData(300, 200, true, 0);
				this.loadAttempts = 0;
				
				this.weaponsLoaded = weaponsLoaded + 1;
				if (this.weaponsLoaded < this.weaponSprites.length)
				{
					this.loadWeapon(this.weaponsLoaded);
				}
				else
				{
					this.preloader.setText("ninjas");
					this.getNinjasToLoad();
				}
			}
			return;
		}// end function
		
		public function loadWeaponHandler(event:Event) : void
		{
			this.weaponSprites[this.weaponsLoaded][2] = event.currentTarget.content.bitmapData;
			event.currentTarget.removeEventListener(ProgressEvent.PROGRESS, this.weaponLoading);
			event.currentTarget.removeEventListener(Event.COMPLETE, this.loadWeaponHandler);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.weaponFail);
			
			this.weaponsLoaded =weaponsLoaded + 1;
			this.loadAttempts = 0;
			if (this.weaponsLoaded < this.weaponSprites.length)
			{
				this.loadWeapon(this.weaponsLoaded);
			}
			else
			{
				this.preloader.setText("ninjas");
				this.getNinjasToLoad();
			}
			return;
		}// end function
		
		private function getNinjasToLoad()
		{
			this.ninjasToLoad.push(parseInt(UserInfoModel.instance.UserInfo.faction));
			this.ninjasToLoad.push(parseInt(UserInfoModel.instance.UserInfo.faction));
			this.loadNinjas(0);
			return;
		}// end function
		
		private function loadNinjas(param1:int)
		{
			var _loc_2:* = new Loader();
			_loc_2.load(new URLRequest(UrlConfig.prefix + "ninjas/clan" + (this.ninjasLoaded % 2 == 0 ? ("girl") : ("guy")) + this.ninjasToLoad[param1] + ".png"));
			_loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadNinjaHandler);
			_loc_2.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.ninjasLoading);
			_loc_2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			return;
		}// end function
		
		private function ninjasLoading(event:ProgressEvent) : void
		{
			var _loc_2:* = event.bytesLoaded / event.bytesTotal * (1 / this.ninjasToLoad.length) * 100 + this.ninjasLoaded * (1 / this.ninjasToLoad.length) * 100;
			if (this.preloader != null)
			{
				this.preloader.setPercent(_loc_2);
			}
			return;
		}// end function
		
		public function loadNinjaHandler(event:Event) : void
		{
			this.ninjaSprites[this.ninjasToLoad[this.ninjasLoaded]][this.ninjasLoaded % 2] = event.currentTarget.content.bitmapData;
			event.currentTarget.removeEventListener(ProgressEvent.PROGRESS, this.ninjasLoading);
			event.currentTarget.removeEventListener(Event.COMPLETE, this.loadWeaponHandler);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			
			this.ninjasLoaded = ninjasLoaded + 1;
			if (this.ninjasLoaded < this.ninjasToLoad.length)
			{
				this.loadNinjas(this.ninjasLoaded);
			}
			else
			{
				this.main.removePreloader();
				this.init();
			}
			return;
		}// end function
		
		private function plLoading(event:ProgressEvent) : void
		{
			var _loc_2:* = event.bytesLoaded / event.bytesTotal * 100;
			if (this.preloader != null)
			{
				this.preloader.setPercent(_loc_2);
			}
			return;
		}// end function
		
		private function completer(event:Event) : void
		{
			return;
		}// end function
		
		private function init(... args)
		{
			var _loc_6:* = undefined;
			this.removeEventListener(Event.ENTER_FRAME, this.init);
			var args1 = 160;
			var _loc_3:int = 105;
			var _loc_4:int = args1 + 525;
			var _loc_5:int = 0;
			while (_loc_5 < this.ninjaList.length)
			{
				
				_loc_6 = this.addChild(new DojoNinja(parent.parent, this, this.ninjaList[_loc_5], args1 + _loc_5 % 5 * _loc_3, 190 + Math.floor(_loc_5 / 5) * 84));
				this.ninjaButtons.push(_loc_6);
				_loc_6.scaleX = Math.round(Math.random()) ? (-1) : (1);
				args1 = args1 - 3;
				_loc_4 = _loc_4 + 3;
				_loc_3 = int((_loc_4 - args1) / 5);
				_loc_5++;
			}
			/*if (UserInfoModel.instance.UserInfo.tutorial)
			{
				this.mapButton.visible = false;
				if (UserInfoModel.instance.UserInfo.level == 1)
				{
					UserInfoModel.instance.UserInfo.tutorial.setStep(5);
				}
				else if (UserInfoModel.instance.UserInfo.level == 2)
				{
					UserInfoModel.instance.UserInfo.tutorial.setStep(15);
				}
			}*/
			this.statsWindow=new NinjaRolloverStats(null)
			this.addChild(statsWindow);
			this.addEventListener(Event.ENTER_FRAME, this.update);
			return;
		}// end function
		
		public function setPoof(param1:int, param2:int)
		{
			this.poofX = param1;
			this.poofY = param2;
			this.poofTimer = 15;
			return;
		}// end function
		
		private function update(... args)
		{
			
			var i = 0;
			var _loc_3:* = undefined;
			i = 0;
			while (i < this.ninjaButtons.length)
			{
				
				this.ninjaButtons[i].update();
				i++;
			}
			if (this.poofTimer > 0)
			{
				poofTimer =poofTimer-1;
				this.particleList.push(this.addChild(new PoofParticle(this.poofX, this.poofY)));
				this.particleList.push(this.addChild(new PoofParticle(this.poofX, this.poofY)));
			}
			i = 0;
			while (i < this.particleList.length)
			{
				
				this.particleList[i].update();
				if (this.particleList[i].dead)
				{
					_loc_3 = this.particleList[i];
					_loc_3.destroy();
					this.particleList[i] = this.particleList[(this.particleList.length - 1)];
					this.particleList[(this.particleList.length - 1)] = _loc_3;
					delete this[this.particleList.pop()];
					i = i - 1;
				}
				i++;
			}
			return;
		}// end function
		
		public function openNinjaWindow(param1, param2)
		{
			//this.main.buttonSound();
			var win:DojoNinjaWindow=new DojoNinjaWindow(main, this, param1, param2);
			this.addChild(win);
			return;
		}// end function
		
		public function showStats(param1, param2:int, param3:int)
		{
			this.statsWindow.display(param1, param2, param3);
			return;
		}// end function
		
		public function hideStats()
		{
			this.statsWindow.undisplay();
			return;
		}// end function
		
		public function gotoMap(... args)
		{
			main.buttonSound();
			DojoController.instance.renderHome();
			//parent.parent.loadFile("map");
			return;
		}// end function
		
		private function disableButton(param1, param2:Function)
		{
			param1.hitZone.buttonMode = false;
			param1.hitZone.removeEventListener(MouseEvent.CLICK, param2);
			param1.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			param1.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			param1.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
			param1.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
			return;
		}// end function
		
		private function enableButton(param1, param2:Function)
		{
			param1.hitZone.buttonMode = true;
			param1.hitZone.addEventListener(MouseEvent.CLICK, param2);
			param1.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
			param1.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
			param1.buttonAnim.addEventListener(MouseEvent.CLICK, this.floatUp);
			param1.buttonAnim.addEventListener(MouseEvent.CLICK, this.floatDown);
			return;
		}// end function
		
		public function ioErrorHandler(param1)
		{
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
		
//		Security.allowDomain("*");
	}
}
