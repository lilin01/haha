package com.app.view.game
{
	import com.app.config.MainConfig;
	import com.app.config.UrlConfig;
	import com.app.model.UserInfoModel;
	import com.framework.utils.CommonUtils;
	import com.framework.utils.loader.HttpLoader;
	import com.vo.UserInfoVo;
	import com.app.controller.RelicController;
	import com.app.model.RelicModel;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	//import res.game.GoldIcon;
	//import res.game.KarmaIcon;
	import res.game.MainSlotWindowMC;
	public class MainSlotWindow extends MainSlotWindowMC
	{
		private var main:Object;
		private var relic:Object;
		private var equippedRelic:Object = null;
		private var slot:int = 0;
		private var relicButtons:Array;
		private var bmp:Loader;
		private var currentInventoryRelic:int = 0;
		private var inventoryRelicBMP:MainRelic;
		private var sortedRelics:Array;
		private var moneyIcon:Bitmap = null;
		/**
		 * 
		 * @param param1 parent
		 * @param param2 relic信息
		 * @param param3 slot 号
		 * @param param4 x
		 * @param param5 y
		 * 
		 */		
		public function MainSlotWindow(param1:DisplayObject, param2:Object, param3:int, param4:int = 0, param5:int = 0)
		{
			this.relicButtons = new Array(0);
			this.sortedRelics = new Array(0);
			this.main = param1;
			this.relic = param2;
			x = param4;
			y = param5;
			this.slot = param3;
			this.bmp=new Loader();
			relicImageHolder.addChild(bmp);
			this.setEquippedStats();
			this.inventoryRelicBMP=new MainRelic(param1,0, 590, 195, false)
			this.addChild(inventoryRelicBMP);
			if (UserInfoModel.instance.UserInfo.relicInventory.length)
			{
				this.populatePlayerInventory();
			}
			this.setInventoryStats(0);
			if (!this.sortedRelics.length)
			{
				this.disableInventoryButtons();
			}
			if (parseInt(this.relic.iid) == 0)
			{
				unequip.visible = false;
			}
			this.enableButtons();
			//if (UserInfoModel.instance.UserInfo.level == 1 && this.main.tutorial != null)
			/*if (UserInfoModel.instance.UserInfo.level == 1 && this.main.tutorial != null)
			{
				closeBtn.visible = false;
				this.main.tutorial.nextStep();
			}*/
			return;
		}// end function
		
		private function nextRelic(... args):void
		{
			//args = this;
			var _loc_3:* = this.currentInventoryRelic + 1;
			this.currentInventoryRelic = _loc_3;
			if (this.currentInventoryRelic >= this.sortedRelics.length)
			{
				this.currentInventoryRelic = 0;
			}
			this.setInventoryStats(this.currentInventoryRelic);
			return;
		}// end function
		
		private function prevRelic(... args)
		{
			//args = this;
			var _loc_3:* = this.currentInventoryRelic - 1;
			this.currentInventoryRelic = _loc_3;
			if (this.currentInventoryRelic < 0)
			{
				this.currentInventoryRelic = this.sortedRelics.length - 1;
			}
			this.setInventoryStats(this.currentInventoryRelic);
			return;
		}// end function
		
		public function closeWindow(... args)
		{
			this.main.slotWindow = null;
			this.disableButtons();
			this.parent.removeChild(this);
			return;
		}// end function
		
		private function enableButtons()
		{
			this.enableButton(closeBtn, this.closeWindow);
			this.enableButton(unequip, this.clickUnequip);
			if (this.sortedRelics.length && this.sortedRelics[0].length)
			{
				this.enableInventoryButtons();
			}
			return;
		}// end function
		
		private function disableButtons()
		{
			this.disableButton(closeBtn, this.closeWindow);
			this.disableButton(unequip, this.clickUnequip);
			this.disableButton(equip, this.equipRelic);
			this.disableButton(inventoryLeft, this.prevRelic);
			this.disableButton(inventoryRight, this.nextRelic);
			return;
		}// end function
		
		private function enableInventoryButtons()
		{
			equip.visible = true;
			this.enableButton(equip, this.equipRelic);
			if (this.sortedRelics.length > 1)
			{
				inventoryLeft.visible = true;
				inventoryRight.visible = true;
				this.enableButton(inventoryLeft, this.prevRelic);
				this.enableButton(inventoryRight, this.nextRelic);
			}
			else
			{
				inventoryRight.visible = false;
				inventoryLeft.visible = false;
				this.disableButton(inventoryLeft, this.prevRelic);
				this.disableButton(inventoryRight, this.nextRelic);
			}
			this.inventoryRelicBMP.visible = true;
			return;
		}// end function
		
		private function disableInventoryButtons()
		{
			rCount.text = "0";
			equip.visible = false;
			this.disableButton(equip, this.equipRelic);
			inventoryLeft.visible = false;
			inventoryRight.visible = false;
			this.disableButton(inventoryLeft, this.prevRelic);
			this.disableButton(inventoryRight, this.nextRelic);
			this.inventoryRelicBMP.visible = false;
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
		
		private function populatePlayerInventory()
		{
			var _loc_2:Boolean = false;
			var i:int = 0;
			this.sortedRelics = new Array(0);
			var j:int = 0;
			while (j < UserInfoModel.instance.UserInfo.relicInventory.length)
			{
				
				if (UserInfoModel.instance.UserInfo.relicInventory[j] == null)
				{
				}
				else
				{
					_loc_2 = false;
					i = 0;
					while (i < this.sortedRelics.length)
					{
						
						if (UserInfoModel.instance.UserInfo.relicInventory[j].iid == this.sortedRelics[i][0].iid)
						{
							trace(UserInfoModel.instance.UserInfo.relicInventory[j].name);
							this.sortedRelics[i].push(UserInfoModel.instance.UserInfo.relicInventory[j]);
							_loc_2 = true;
							break;
						}
						i++;
					}
					if (!_loc_2)
					{
						this.sortedRelics.push(new Array(UserInfoModel.instance.UserInfo.relicInventory[j]));
					}
				}
				j++;
			}
			return;
		}// end function
		
		private function setInventoryStats(param1:int)
		{
			if (this.moneyIcon != null)
			{
				this.removeChild(this.moneyIcon);
			}
			if (this.sortedRelics.length > 0)
			{
				rCount.text = this.sortedRelics[param1].length;
				rName.text = this.sortedRelics[param1][0].name;
				rDisc.text = this.sortedRelics[param1][0].description;
				if (this.sortedRelics[param1][0].karma_value != "0" && this.sortedRelics[param1][0].karma_value != 0)
				{
					rValue.text = CommonUtils.getFormattedNumber(int(this.sortedRelics[param1][0].karma_value * 0.5));
					
					this.moneyIcon=new Bitmap(new KarmaIcon());
					this.addChild(moneyIcon);
				}
				else
				{
					rValue.text = CommonUtils.getFormattedNumber(int(this.sortedRelics[param1][0].value * MainConfig.SELLRATIO));
					this.moneyIcon=new Bitmap(new GoldIcon());
					this.addChild(moneyIcon);
				}
				this.moneyIcon.x = rValue.x + rValue.textWidth + 10;
				this.moneyIcon.y = rValue.y + rValue.height / 2 - this.moneyIcon.height / 2;
				this.inventoryRelicBMP.setRelic(this.sortedRelics[param1][0]);
			}
			else
			{
				rCount.text = "0";
				rName.text = "";
				rDisc.text = "You have no relics in your inventory";
				rValue.text = "";
				this.inventoryRelicBMP.setRelic(0);
			}
			return;
		}// end function
		
		private function setEquippedStats()
		{
			//trace("setEquippedStats()");
			this.bmp.unload();
			equippedRelicName.text = this.relic.name;
			if (parseInt(this.relic.iid) > 0)
			{
				equippedRelicDisc.text = this.relic.description;
				this.bmp.load(new URLRequest(UrlConfig.RELICIMGURL + this.relic.sprite + ".png"));
				//trace(UrlConfig.RELICIMGURL + this.relic.sprite + ".png");
				this.bmp.contentLoaderInfo.addEventListener(Event.COMPLETE, this.adjustGraphic);
			}
			else
			{
				equippedRelicDisc.text = "Equip a relic from your inventory on the right.";
			}
			this.main.setSlotGraphic(this.slot, this.relic);
			return;
		}// end function
		
		private function clickUnequip(... args)
		{
			if (this.relic.attributes.min_level != null && parseInt(UserInfoModel.instance.UserInfo.level) < parseInt(this.relic.attributes.min_level))
			{
				this.main.confirm("This relic requires you to be a higher level and cannot be re-equipped. Are you sure?", this.unequipRelic, null);
			}
			else
			{
				this.unequipRelic();
			}
			return;
		}// end function
		
		public function unequipRelic(... args):void
		{
			this.disableButtons();
			
			//var urlReq:URLRequest=new URLRequest(this.main.debugPrefix + "/ajax/unequip_relic?PHPSESSID=" + this.main.phpsessid + "");
			//var urlReq:URLRequest=new URLRequest(UrlConfig.HTTPROOT+UrlConfig.UNEQUIPRELIC);
			var _loc_3:URLVariables = new URLVariables();
			_loc_3.iid = this.relic.iid;
			_loc_3.slot = this.slot;
			//urlReq.data = _loc_3;
			//urlReq.method = URLRequestMethod.POST;
			//var _loc_4:URLLoader= new URLLoader();
			/*_loc_4.addEventListener(Event.COMPLETE, this.unequipHandler);
			_loc_4.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			_loc_4.load(urlReq);*/
			//this.main.showWaitSymbol();
			
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.UNEQUIPRELIC,unequipHandler,_loc_3);
			
			return;/**/
		}// end function
		
		public function equipRelic(... args)
		{
			if (!this.main.relicIsEquippable(this.sortedRelics[this.currentInventoryRelic][0], this.slot))
			{
				return;
			}
			this.disableButtons();
			this.equippedRelic = this.sortedRelics[this.currentInventoryRelic][0];
			//args = new URLRequest(this.main.debugPrefix + "/ajax/equip_relic?PHPSESSID=" + this.main.phpsessid + "");
			var _loc_3:URLVariables = new URLVariables();
			_loc_3.iid = this.equippedRelic.iid;
			_loc_3.slot = this.slot;
			//args.data = _loc_3;
			//args.method = URLRequestMethod.POST;
			//this.main.showWaitSymbol();
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.EQUIPRELIC,equipHandler,_loc_3);
			return;/**/
		}// end function
		
		private function finishEquip()
		{
			var _loc_3:int = 0;
			var _loc_1:* = this.relic;
			if (parseInt(_loc_1.iid) > 0)
			{
				UserInfoModel.instance.UserInfo.addRelic(this.relic);
			}
			this.relic = UserInfoModel.instance.UserInfo.removeSelectedRelic(this.equippedRelic);
			this.populatePlayerInventory();
			var _loc_2:Boolean = false;
			while (_loc_3 < this.sortedRelics.length)
			{
				
				if (this.sortedRelics[_loc_3].length > 0 && this.sortedRelics[_loc_3][0].iid == _loc_1.iid)
				{
					_loc_2 = true;
					this.currentInventoryRelic = _loc_3;
					this.setInventoryStats(this.currentInventoryRelic);
					break;
				}
				_loc_3++;
			}
			if (!_loc_2 && this.sortedRelics.length > 0 && this.sortedRelics[0].length > 0)
			{
				this.currentInventoryRelic = 0;
				this.setInventoryStats(this.currentInventoryRelic);
			}
			else if (this.sortedRelics.length <= 0)
			{
				this.setInventoryStats(-1);
				this.disableInventoryButtons();
			}
			unequip.visible = true;
			this.setEquippedStats();
			this.main.adjustNinjaStats();
			//this.main.hideWaitSymbol();
			return;
		}// end function
		
		private function finishUnequip()
		{
			var _loc_2:int = 0;
			unequip.visible = false;
			var _loc_1:* = this.relic;
			UserInfoModel.instance.UserInfo.addRelic(this.relic);
			this.relic = {iid:0, name:"Open", description:"Click here to add a relic from your inventory.", attributes:{}};
			this.populatePlayerInventory();
			while (_loc_2 < this.sortedRelics.length)
			{
				
				if (this.sortedRelics[_loc_2][0].iid == _loc_1.iid)
				{
					this.currentInventoryRelic = _loc_2;
					this.setInventoryStats(this.currentInventoryRelic);
					break;
				}
				_loc_2++;
			}
			this.setEquippedStats();
			this.main.adjustNinjaStats();
			//trace("-------------------------",RelicController.instance.relicview!=null);
			if(RelicController.instance.relicview!=null){
			
				//;
				RelicModel.instance.RefreshData(RelicController.instance.relicview.RelicModel_RefreshData_CalllBack);
			}
			//this.main.hideWaitSymbol();
			return;
		}// end function
		
		public function equipHandler(data:Object) : void
		{
			
			if (data.result == "success")
			{
				this.finishEquip();
				/*if (this.main.level == 1 && this.main.tutorial != null)
				{
					this.main.disableSlots();
					this.main.tutorial.activateBlimp();
					this.main.tutorial.nextStep();
					this.closeWindow();
				}*/
				//trace("success!");
			}
			else
			{
				this.main.alert(data.error);
				//trace("fail ");
			}
			this.enableButtons();
			return;/**/
		}// end function
		
		public function unequipHandler(data:Object) : void
		{
			/*event.currentTarget.removeEventListener(Event.COMPLETE, this.unequipHandler);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			trace("BLAH");
			trace(event.currentTarget.data);
			var _loc_2:* = JSON.deserialize(event.currentTarget.data);*/
			if (data.result == "success")
			{
				this.finishUnequip();
			//	trace("success!");
			}
			else
			{
			//	trace("fail ");
			}
			this.enableButtons();
			return;/**/
		}// end function
		
		public function ioErrorHandler(param1)
		{
			this.enableButtons();
			closeBtn.buttonMode = true;
			closeBtn.addEventListener(MouseEvent.CLICK, this.closeWindow);
			trace(param1);
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
		
		private function adjustGraphic(param1)
		{
			param1.currentTarget.removeEventListener(Event.COMPLETE, this.adjustGraphic);
			this.bmp.x = -(this.bmp.width >> 1);
			this.bmp.y = -(this.bmp.height >> 1);
			return;
		}// end function
		
		//Security.allowDomain("*");
	}
}
