package com.app.view.dojo
{
	import com.app.config.MainConfig;
	import com.app.config.UrlConfig;
	import com.app.model.UserInfoModel;
	import com.app.view.dojo.DojoWeapon;
	import com.app.view.dojo.WeaponSprites;
	import com.framework.utils.CommonUtils;
	import com.framework.utils.loader.HttpLoader;
	import com.vo.WeaponItemVo;
	
	import fl.motion.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	
	import res.dojo.DojoNinjaWindowMC;

	public class DojoNinjaWindow extends DojoNinjaWindowMC
	{
		private var main:Object;
		private var dojo:Object;
		private var ninja:Object;
		private var currentInventoryWeapon:int = 0;
		private var ninjaMC:Object;
		private var bmp:Bitmap;
		private var bbmp:Bitmap;
		private var abmp:Bitmap;
		private var wbmp:Bitmap;
		private var animations:Array;
		private var currentSprite:int = 0;
		private var idleX:int = 0;
		private var idleY:int = 0;
		private var weaponSheet:int = 0;
		private var moneyIcon:Bitmap = null;
		private var inventoryWeaponBMP:MovieClip;
		private var ninjaWeaponBMP:Object;
		private var sortedWeapons:Array;
		private var moneyPopup:Object = null;
		public var renamePopup:RenamePopup = null;

		/**
		 * 
		 * @param param1 main
		 * @param param2 dojoMain 
		 * @param param3 ninja
		 * @param param4 ninjaMc
		 * @param param5 x
		 * @param param6 y
		 * 
		 */	
		public function DojoNinjaWindow(param1:Object, param2:Object, param3:Object, param4:Object, param5:int = 0, param6:int = 0)
		{
			this.animations = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1);
			this.sortedWeapons = new Array(0);
			this.main = param1;
			this.dojo = param2;
			this.ninja = param3;
			x = param5;
			y = param6;
			this.ninjaMC = param4;
			getKarma.visible = false;
			this.currentSprite = 0;
			var spriteSheet:BitmapData = this.dojo.ninjaSprites[parseInt(UserInfoModel.instance.UserInfo.faction)][parseInt(this.ninja.gender)];
			this.bmp =new Bitmap(new BitmapData(100, 130, true, 0),"always", true);
			 ninjaImageHolder.addChild(bmp);
			this.bmp.x = -50;
			this.bmp.y = -130;
			this.setWeaponGraphics();
			this.updateStats();
			this.inventoryWeaponBMP=new DojoWeapon(this.main, this.dojo, 0, 560, 320, false);
			inventoryLayer.addChild(inventoryWeaponBMP);
			if (UserInfoModel.instance.UserInfo.weaponInventory.length)
			{
				this.populatePlayerInventory();
				if (this.sortedWeapons.length > 0)
				{
					this.setInventoryStats(0);
				}
			}
			if (!this.sortedWeapons.length)
			{
				this.disableInventoryButtons();
			}
			this.ninjaWeaponBMP = this.addChild(new DojoWeapon(this.main, this.dojo, 0, 125, 495, false));
			var _loc_7:Number = 0.6;
			this.ninjaWeaponBMP.scaleY = 0.6;
			this.ninjaWeaponBMP.scaleX = _loc_7;
			if (parseInt(this.ninja.weapon.iid) == 0)
			{
				unequip.visible = false;
			}
			this.setWeapon(this.ninja.weapon);
			if (this.ninja.level >= 35)
			{
				train.visible = false;
				cannotTrain.text = "Your ninja has mastered the art and cannot be trained any more.";
			}
			else if (UserInfoModel.instance.UserInfo.karma < Math.ceil(this.ninja.level / 5))
			{
				train.visible = false;
				if (parseInt(UserInfoModel.instance.UserInfo.level) > 1)
				{
					getKarma.visible = true;
				}
			}
			this.enableButtons();
			/*if (UserInfoModel.instance.UserInfo.level == 1 && this.main.tutorial != null)
			{
				this.main.tutorial.currentWindow = this;
				if (parseInt(this.ninja.level) == 1)
				{
					this.main.tutorial.setStep(6);
					equip.visible = false;
				}
				else
				{
					equip.visible = true;
					this.main.tutorial.setStep(8);
				}
				closeBtn.visible = false;
			}*/
			nameHitZone.addEventListener(MouseEvent.CLICK, this.clickRename);
			this.addEventListener(Event.ENTER_FRAME, this.updateAnim);
			return;
		}// end function
		
		public function showEquip()
		{
			equip.visible = true;
			return;
		}// end function
		//设置腰带颜色
		private function setBeltColor()
		{
			var cl:Color = new Color();
			var colorArr:Array = new Array(16777215, 16776960, 16737792, 39168, 170, 6697728, 0);
			cl.setTint(colorArr[Math.min(int(Math.max((this.ninja.level - 1)/ 5, 0)), 6)], 0.8);
			this.bbmp.transform.colorTransform = cl;
			return;
		}// end function
		
		private function populatePlayerInventory()
		{
			this.sortedWeapons = new Array(0);
			var _loc_1:int = 0;
		/*	while (_loc_1 < UserInfoModel.instance.UserInfo.weaponInventory.length)
			{
				
				UserInfoModel.instance.UserInfo.weaponInventory[_loc_1].dps = Math.round(100 / parseInt(UserInfoModel.instance.UserInfo.weaponInventory[_loc_1].attributes.speed) * parseFloat(this.main.weaponInventory[_loc_1].attributes.damage) * 100) / 100;
				_loc_1++;
			}*/
			UserInfoModel.instance.UserInfo.weaponInventory = UserInfoModel.instance.UserInfo.weaponInventory.sortOn("dps", Array.NUMERIC);
			this.sortWeapons();
			return;
		}// end function
		
		public function sortWeapons()
		{
			var flag:Boolean = false;
			var j:int = 0;
			this.sortedWeapons = [];
			var i:int = 0;
			while (i <UserInfoModel.instance.UserInfo.weaponInventory.length)
			{
				
				if (UserInfoModel.instance.UserInfo.weaponInventory[i] == null)
				{
				}
				else
				{
					flag = false;
					j = 0;
					while (j < this.sortedWeapons.length)
					{
						
						if (UserInfoModel.instance.UserInfo.weaponInventory[i].iid == this.sortedWeapons[j][0].iid)
						{
							this.sortedWeapons[j].push(UserInfoModel.instance.UserInfo.weaponInventory[i]);
							flag = true;
							break;
						}
						j++;
					}
					if (!flag)
					{
						this.sortedWeapons.push(new Array(UserInfoModel.instance.UserInfo.weaponInventory[i]));
					}
				}
				
				i++;
			}
			return;
		}// end function
		
		public function setWeapon(weapon:Object):void
		{
			this.ninja.weapon = weapon;
			if (this.ninja.weapon.attributes.base_speed)
			{
				wSpeed.text = this.getSpeed(parseInt(this.ninja.weapon.attributes.base_speed));
				wDamage.text =( Math.round(100 / parseInt(this.ninja.weapon.attributes.base_speed) * parseFloat(this.ninja.weapon.attributes.base_damage) * 100) / 100).toString();
			}
			else
			{
				wSpeed.text = this.getSpeed(parseInt(this.ninja.weapon.attributes.speed));
				wDamage.text = (Math.round(100 / parseInt(this.ninja.weapon.attributes.speed) * parseFloat(this.ninja.weapon.attributes.damage) * 100) / 100).toString();
			}
			var _loc_2:int = 0;
			if (parseInt(this.ninja.weapon.attributes.speed) < 100)
			{
				_loc_2 = 85 * (1 - parseInt(this.ninja.weapon.attributes.speed) / 100);
			}
			else if (parseInt(this.ninja.weapon.attributes.speed) > 100)
			{
				_loc_2 = -85 * (parseInt(this.ninja.weapon.attributes.speed) / 100 / 5);
			}
			meter.needle.rotation = 270 + _loc_2;
			this.ninjaWeaponBMP.setWeapon(parseInt(this.ninja.weapon.iid) > 0 ? (this.ninja.weapon) : (0));
			this.setWeaponGraphics();
			return;
		}// end function
		
		private function setWeaponGraphics()
		{
			return;
		}// end function
		
		private function updateStats()
		{
			ninjaName.text = this.ninja.name;
			ninjaLevel.text = this.ninja.level;
			ninjaBirthday.text = this.ninja.birthdate.pretty;
			ninjaPower.text = this.ninja.power;
			ninjaHealth.text = this.ninja.health + "/" + this.ninja.modified_max_health;
			ninjaBlood.text = this.ninja.blood_type;
			ninjaWeapon.text = this.ninja.weapon.name;
			train.buttonAnim.karma.text = Math.ceil(this.ninja.level / 5);
			return;
		}// end function
		
		private function getDismissGold() : int
		{
			var _loc_1:Array = null;
			if (UserInfoModel.instance.UserInfo.ninjas.length <= 20)
			{
				return int(1000 * (UserInfoModel.instance.UserInfo.ninjas.length - 1) * (UserInfoModel.instance.UserInfo.ninjas.length - 1) * 0.5);
			}
			_loc_1 = [1000000, 3000000, 7000000, 15000000, 25000000];
			var basePrice:int = _loc_1[UserInfoModel.instance.UserInfo.ninjas.length - 21];
			return int(basePrice * 0.5);
		}// end function
		
		private function getDismissKarma() : int
		{
			var _loc_1:int = 0;
			var _loc_2:int = 0;
			while (_loc_2 < this.ninja.level)
			{
				
				_loc_1 = _loc_1 + Math.ceil(_loc_2 / 5);
				_loc_2++;
			}
			return Math.ceil(_loc_1 * MainConfig.SELLRATIO);
		}// end function
		
		private function updateAnim(... args)
		{
			this.bmp.bitmapData.copyPixels(this.ninjaMC.bmp.bitmapData, new Rectangle(0, 0, 100, 130), new Point(0, 0));
			if (parseInt(this.ninja.health) < parseInt(this.ninja.modified_max_health))
			{
				ninjaHealth.text = this.ninja.health + "/" + this.ninja.modified_max_health;
			}
			if (train.visible && UserInfoModel.instance.UserInfo.karma < Math.ceil(this.ninja.level / 5))
			{
				train.visible = false;
				if (parseInt(UserInfoModel.instance.UserInfo.level) > 1)
				{
					getKarma.visible = true;
				}
			}
			return;
		}// end function
		
		private function disableButtons()
		{
			this.disableButton(rename, this.clickRename);
			this.disableButton(getKarma, this.sendToGoldmine);
			this.disableButton(closeBtn, this.closeWindow);
			this.disableButton(dismiss, this.clickDismiss);
			dismiss.removeEventListener(MouseEvent.ROLL_OUT, this.removeMoneyPopup);
			dismiss.removeEventListener(MouseEvent.ROLL_OVER, this.addDismissPopup);
			this.disableButton(train, this.trainNinja);
			this.disableButton(inventoryLeft, this.prevWeapon);
			this.disableButton(inventoryRight, this.nextWeapon);
			this.disableButton(equip, this.equipNinja);
			unequip.removeEventListener(MouseEvent.ROLL_OUT, this.removeMoneyPopup);
			unequip.removeEventListener(MouseEvent.ROLL_OVER, this.addEquipPopup);
			this.disableButton(unequip, this.clickUnequip);
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
		
		private function enableButtons()
		{
			this.enableButton(closeBtn, this.closeWindow);
			this.enableButton(dismiss, this.clickDismiss);
			this.enableButton(rename, this.clickRename);
			dismiss.addEventListener(MouseEvent.ROLL_OUT, this.removeMoneyPopup);
			dismiss.addEventListener(MouseEvent.ROLL_OVER, this.addDismissPopup);
			dismiss.visible = UserInfoModel.instance.UserInfo.ninjas.length > 1;
			this.enableButton(train, this.trainNinja);
			if (parseInt(UserInfoModel.instance.UserInfo.level) > 1)
			{
				this.enableButton(getKarma, this.sendToGoldmine);
			}
			if (parseInt(UserInfoModel.instance.UserInfo.level) > 1 && parseInt(this.ninja.weapon.iid) > 0)
			{
				unequip.visible = true;
				this.enableButton(unequip, this.clickUnequip);
			}
			if (this.sortedWeapons.length > 0)
			{
				this.enableInventoryButtons();
			}
			return;
		}// end function
		
		private function enableInventoryButtons()
		{
			if (this.sortedWeapons.length > 1)
			{
				inventoryLeft.visible = true;
				inventoryRight.visible = true;
				this.enableButton(inventoryLeft, this.prevWeapon);
				this.enableButton(inventoryRight, this.nextWeapon);
			}
			else
			{
				inventoryLeft.visible = false;
				inventoryRight.visible = false;
				this.disableButton(inventoryLeft, this.prevWeapon);
				this.disableButton(inventoryRight, this.nextWeapon);
			}
			equip.visible = true;
			this.enableButton(equip, this.equipNinja);
			return;
		}// end function
		
		private function addDismissPopup(event:Event)
		{
			this.moneyPopup = this.addChild(new GoldKarmaPopup(this.main, "Dismiss for:", this.getDismissGold(), this.getDismissKarma(), 200, 100));
			return;
		}// end function
		
		private function addEquipPopup(event:Event)
		{
			return;
		}// end function
		
		public function clickRename(event:Event)
		{
			if (!this.renamePopup)
			{
				//this.main.buttonSound();
				this.renamePopup = new RenamePopup(this.main, this.ninja, this, 360, 300);
				this.addChild(renamePopup);
			}
			return;
		}// end function
		
		private function removeMoneyPopup(event:Event = null)
		{
			if (this.moneyPopup)
			{
				this.moneyPopup.destroy();
			}
			return;
		}// end function
		
		private function disableInventoryButtons()
		{
			wCount.text = "0";
			inventoryLeft.visible = false;
			inventoryRight.visible = false;
			this.disableButton(inventoryLeft, this.prevWeapon);
			this.disableButton(inventoryRight, this.nextWeapon);
			equip.visible = false;
			this.disableButton(equip, this.equipNinja);
			inventoryStats.meter.needle.rotation = 185;
			wName.text = "You have no weapons in your inventory.";
			inventoryStats.visible = false;
			this.inventoryWeaponBMP.setWeapon(0);
			return;
		}// end function
		
		private function setInventoryStats(param1:int)
		{
			wCount.text = this.sortedWeapons[param1].length;
			wName.text = this.sortedWeapons[param1][0].name;
			inventoryStats.visible = true;
			if (this.sortedWeapons[param1][0].attributes.base_speed)
			{
				inventoryStats.wSpeed.text = this.getSpeed(parseInt(this.sortedWeapons[param1][0].attributes.base_speed));
				inventoryStats.wDamage.text = Math.round(100 / parseInt(this.sortedWeapons[param1][0].attributes.base_speed) * parseFloat(this.sortedWeapons[param1][0].attributes.base_damage) * 100) / 100;
			}
			else
			{
				inventoryStats.wSpeed.text = this.getSpeed(parseInt(this.sortedWeapons[param1][0].attributes.speed));
				inventoryStats.wDamage.text = Math.round(100 / parseInt(this.sortedWeapons[param1][0].attributes.speed) * parseFloat(this.sortedWeapons[param1][0].attributes.damage) * 100) / 100;
			}
			if (this.moneyIcon != null)
			{
				inventoryStats.removeChild(this.moneyIcon);
			}
			if (this.sortedWeapons[param1][0].karma_value != "0" && this.sortedWeapons[param1][0].karma_value != 0)
			{
				inventoryStats.wValue.text = CommonUtils.getFormattedNumber(int(this.sortedWeapons[param1][0].karma_value * 0.5));
				this.moneyIcon = new Bitmap(new KarmaIcon(1, 1));
					inventoryStats.addChild(moneyIcon);
			}
			else
			{
				inventoryStats.wValue.text = CommonUtils.getFormattedNumber(int(this.sortedWeapons[param1][0].value * MainConfig.SELLRATIO));
				this.moneyIcon = new Bitmap(new GoldIcon(1, 1));
				inventoryStats.addChild(moneyIcon);
			}
			this.moneyIcon.x = inventoryStats.wValue.x + inventoryStats.wValue.textWidth + 10;
			this.moneyIcon.y = inventoryStats.wValue.y + inventoryStats.wValue.height / 2 - this.moneyIcon.height / 2;
			inventoryStats.wDesc.text = this.sortedWeapons[param1][0].description;
			this.inventoryWeaponBMP.setWeapon(this.sortedWeapons[param1][0]);
			var _loc_2:int = 0;
			if (parseInt(this.sortedWeapons[param1][0].attributes.speed) < 100)
			{
				_loc_2 = 85 * (1 - parseInt(this.sortedWeapons[param1][0].attributes.speed) / 100);
			}
			else if (parseInt(this.sortedWeapons[param1][0].attributes.speed) > 100)
			{
				_loc_2 = -85 * (parseInt(this.sortedWeapons[param1][0].attributes.speed) / 100 / 5);
			}
			inventoryStats.meter.needle.rotation = 270 + _loc_2;
			return;
		}// end function
		
		private function getSpeed(param1:Number) : String
		{
			var _loc_2:* = new Array(33, 50, 66, 85, 150, 299, 399, 499, 1000);
			var _loc_3:* = new Array("Ultra Fast", "Fastest", "Faster", "Fast", "Normal", "Slow", "Slower", "Slowest", "Slow Loris");
			var _loc_4:int = 0;
			while (_loc_4 < _loc_2.length)
			{
				
				if (param1 < _loc_2[_loc_4])
				{
					return _loc_3[_loc_4];
				}
				_loc_4++;
			}
			return "";
		}// end function
		
		private function nextWeapon(... args)
		{
			//this.main.buttonSound();
			
			
			this.currentInventoryWeapon =currentInventoryWeapon + 1;
			if (this.currentInventoryWeapon >= this.sortedWeapons.length)
			{
				this.currentInventoryWeapon = 0;
			}
			this.setInventoryStats(this.currentInventoryWeapon);
			return;
		}// end function
		
		private function prevWeapon(... args)
		{
			//this.main.buttonSound();
			
			currentInventoryWeapon = currentInventoryWeapon - 1;
			if (this.currentInventoryWeapon < 0)
			{
				this.currentInventoryWeapon = this.sortedWeapons.length - 1;
			}
			this.setInventoryStats(this.currentInventoryWeapon);
			return;
		}// end function
		
		private function sendToGoldmine(... args)
		{
			trace("getMore karma");
			/*if (ExternalInterface.available)
			{
				ExternalInterface.call("credits_packages");
			}
			return;*/
		}// end function
		
		private function closeWindow(... args)
		{
			//this.main.buttonSound();
			nameHitZone.removeEventListener(MouseEvent.CLICK, this.clickRename);
			this.disableButtons();
			this.removeEventListener(Event.ENTER_FRAME, this.updateAnim);
			closeBtn.removeEventListener(MouseEvent.CLICK, this.closeWindow);
			parent.removeChild(this);
			return;
		}// end function
		
		private function equipNinja(... args)
		{
			this.disableButtons();
			
			
			var data:URLVariables = new URLVariables();
			data.nid = this.ninja.nid;
			data.iid = this.sortedWeapons[this.currentInventoryWeapon][0].iid;
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.EQUIPWEAPON,equipHandler, data,null,URLRequestMethod.POST);
			return;
		}// end function
		
		private function clickUnequip(... args)
		{
			if (this.ninja.weapon.attributes.min_level != null && parseInt(UserInfoModel.instance.UserInfo.level) < parseInt(this.ninja.weapon.attributes.min_level))
			{
				this.main.confirm("This weapon requires you to be a higher level and cannot be re-equipped. Are you sure?", this.unequipNinja, null);
			}
			else
			{
				this.unequipNinja();
			}
			return;
		}// end function
		
		private function unequipNinja(... args)
		{
			this.disableButtons();
			var data:URLVariables = new URLVariables();
			data.nid = this.ninja.nid;
			data.iid = this.sortedWeapons[this.currentInventoryWeapon][0].iid;
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.UNEQUIPWEAPON,unequipHandler, data,null,URLRequestMethod.POST);
		}// end function
		
		private function trainNinja(... args)
		{
			this.disableButtons();
		
			var data:URLVariables = new URLVariables();
			data.nid = this.ninja.nid;
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.TRAINNINJA,trainHandler, data,null,URLRequestMethod.POST);
			return;
		}// end function
		
		private function clickDismiss(... args)
		{
			//this.main.buttonSound();
			this.disableButtons();
			this.main.confirm("Do you really want to dismiss this ninja?", this.dismissNinja, this.enableButtons);
			return;
		}// end function
		
		private function dismissNinja(... args)
		{
			var data:URLVariables = new URLVariables();
			data.nid = this.ninja.nid;
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.DISMISSNINJA ,dismissHandler, data,null,URLRequestMethod.POST);
			
			return;
		}// end function
		
		public function dismissHandler(data:Object) : void
		{
			
			
			if (data.result == "success")
			{
				if (parseInt(this.ninja.weapon.iid) > 0)
				{
					UserInfoModel.instance.UserInfo.addWeapon(this.ninja.weapon);
					this.currentInventoryWeapon = 0;
					if (UserInfoModel.instance.UserInfo.weaponInventory.length)
					{
						this.populatePlayerInventory();
						if (this.sortedWeapons.length > 0)
						{
							this.setInventoryStats(0);
						}
					}
				}
				UserInfoModel.instance.adjustStats(this.getDismissGold(), this.getDismissKarma());
				this.dojo.setPoof(this.ninjaMC.x, this.ninjaMC.y - 70);
				this.ninjaMC.destroy();
				this.closeWindow();
				
			}
			else
			{
				this.enableButtons();
				this.main.alert(data.error);
			}
			return;
		}// end function
		
		public function equipHandler(data:Object) : void
		{
			
			
			if (data.result == "success")
			{
				if (parseInt(this.ninja.weapon.iid) > 0)
				{
					UserInfoModel.instance.UserInfo.addWeapon(this.ninja.weapon);
				}
				this.setWeapon(this.sortedWeapons[this.currentInventoryWeapon][0]);
				this.ninjaMC.setWeapon(this.sortedWeapons[this.currentInventoryWeapon][0]);
				UserInfoModel.instance.UserInfo.removeSelectedWeapon(this.sortedWeapons[this.currentInventoryWeapon][0]);
				this.sortWeapons();
				this.currentInventoryWeapon = 0;
				this.populatePlayerInventory();
				if (this.sortedWeapons.length > 0)
				{
					this.setInventoryStats(0);
				}
				else
				{
					this.disableInventoryButtons();
				}
				this.updateStats();
				/*if (UserInfoModel.instance.UserInfo.level == 1 && this.main.tutorial != null)
				{
					this.main.tutorial.setStep(10);
				}*/
			}
			else
			{
				this.main.alert(data.error);
			}
			this.enableButtons();
			return;
		}// end function
		
		public function unequipHandler(data:Object) : void
		{
			
			if (data.result == "success")
			{
				UserInfoModel.instance.UserInfo.addWeapon(this.ninja.weapon);
				if (UserInfoModel.instance.UserInfo.weaponInventory.length)
				{
					this.populatePlayerInventory();
					if (this.sortedWeapons.length > 0)
					{
						this.setInventoryStats(0);
					}
				}
				this.setWeapon({iid:"0", name:"fists", animation:"0", runanimation:"0", attributes:{speed:"100", damage:"2"}});
				this.ninjaMC.setWeapon({iid:"0", name:"fists", animation:"0", runanimation:"0", attributes:{speed:"100", damage:"2"}});
				this.sortWeapons();
				this.currentInventoryWeapon = 0;
				this.updateStats();
				unequip.visible = false;
			
			}
			this.enableButtons();
			return;
		}// end function
		
		public function trainHandler(data:Object) : void
		{
			this.enableButtons();
			
			if (data.result == "success")
			{
				this.ninja.level = parseInt(this.ninja.level);
				var _loc_3:* = this.ninja;
				var _loc_4:* = this.ninja.level + 1;
				_loc_3.level = _loc_4;
				this.ninja.power = parseInt(this.ninja.power) + parseInt(data.spoils.strength);
				if (!(this.ninja.level % 5 - 1))
				{
					//this.main.soundManager.loadSoundEffect("beltUpgrade" + int(Math.random() * 5 + 1));
				}
				else
				{
					//this.main.buttonSound(3);
				}
				this.ninja.max_health = "" + (parseInt(this.ninja.max_health) + parseInt(data.spoils.health));
				this.ninjaMC.resetGraphics();
				this.ninjaMC.updateHealthBar();
				UserInfoModel.instance.adjustStats(0, -Math.ceil((this.ninja.level - 1) / 5));
				this.updateStats();
				if (data.spoils.achievements.length > 0)
				{
					this.main.setAchievements(data.spoils.achievements);
					this.main.nextAch();
				}
				if (this.ninja.level >= 35)
				{
					train.visible = false;
					cannotTrain.text = "Your ninja has mastered the art and cannot be trained any more.";
				}
				else if (UserInfoModel.instance.UserInfo.karma < Math.ceil(this.ninja.level / 5))
				{
					train.visible = false;
					if (parseInt(UserInfoModel.instance.UserInfo.level)> 1)
					{
						getKarma.visible = true;
					}
				}
				/*if (this.main.level == 1 && this.main.tutorial != null)
				{
					train.buttonMode = false;
					train.removeEventListener(MouseEvent.CLICK, this.trainNinja);
					equip.visible = false;
					this.main.tutorial.nextStep();
				}*/
				this.main.adjustNinjaStats();
				this.ninja.health = parseInt(this.ninja.modified_max_health);
				this.main.setHealthBar();
				;
			}
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
		
		public function renameNinja(name:String)
		{
			this.disableButtons();
			
			var data:URLVariables = new URLVariables();
			data.nid = this.ninja.nid;
			data.name = name;
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.RENAMENINJA ,renameHandler, data,null,URLRequestMethod.POST);
			this.ninja.name = name;
			ninjaName.text = name;
			UserInfoModel.instance.adjustStats(0, -1);
			return;
		}// end function
		
		public function renameHandler(data:Object) : void
		{
			
			if (data.result == "success")
			{
			}
			else
			{
				this.main.alert(data.error);
			}
			this.enableButtons();
			return;
		}// end function
		
		//Security.allowDomain("*");
	}
}
