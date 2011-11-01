package com.app.view
{
	
	
	import com.app.config.MainConfig;
	import com.app.config.UrlConfig;
	import com.app.controller.FramebarController;
	import com.app.controller.HomeController;
	import com.app.model.UserInfoModel;
	import com.app.model.WeaponModel;
	import com.framework.utils.CommonUtils;
	import com.framework.view.ViewComponent;
	import com.vo.UserInfoVo;
	import com.vo.WeaponItemVo;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import res.weapons.mcAlert;
	import res.weapons.mcBuyConfirm;
	import res.weapons.mcTip;
	import res.weapons.mcWeaponOwnedItem;
	import res.weapons.mcWeaponPannel;
	import com.app.view.weapon.WeaponItemView;
	import com.framework.utils.loader.HttpLoader;
	public class WeaponView extends ViewComponent
	{
		private var _mcweaponpannel:mcWeaponPannel;
		//存放relicItem对象
		public var weaponObj:Object={};
		//记录当前点击的weaponitem的数据
		private var _currentWeaponItem:WeaponItemVo;
		private var tip:mcTip;
		private var moneyIco:Bitmap;
		private var moneyIcoTip:Bitmap;
		private var buyConfirm:mcBuyConfirm=new mcBuyConfirm();
		private var totalPageWeapon:int;
		private var currentPageWeapon:int;
		private var currentPageWeaponOwned:int;
		private var _weaponOwnedItem:mcWeaponOwnedItem;
		private var alert:mcAlert;
		private var main:FramebarView;
		public function WeaponView()
		{
			init();
		}
		public function init():void{
			main=FramebarController.instance.framebarview;
			_mcweaponpannel=new mcWeaponPannel();
			this.addChild(this._mcweaponpannel); 
			setWeaponList();
			setWeaponOwnedList();
			currentPageWeapon=0;
			currentPageWeaponOwned=0;
			main.showWaitSymbol();
			WeaponModel.instance.RefreshData(WeaponModel_RefreshData_CalllBack);
			initTip();
			initBuyConfirm();
			initBtn();
			initAlert();
			
		}
		//添加_weaponOwnedItem
		private function setWeaponOwnedList():void{
			_weaponOwnedItem=new mcWeaponOwnedItem();
			_weaponOwnedItem.x=530;
			_weaponOwnedItem.y=100;
			this._mcweaponpannel.bg.addChild(_weaponOwnedItem);
		}
		private function initTip():void{
			tip=new mcTip();
			tip.mouseChildren=false;
			tip.mouseEnabled=false;
			addChild(tip);
			tip.visible=false;
		}
		//初始化按钮
		private function initBtn():void{
			this._mcweaponpannel.btnBack.buttonMode = true;
			this._mcweaponpannel.btnBack.addEventListener(MouseEvent.CLICK,btnBack_onclick);
			this._mcweaponpannel.btnPrev.buttonMode = true;
			this._mcweaponpannel.btnPrev.addEventListener(MouseEvent.CLICK,btnPreHandler);
			this._mcweaponpannel.btnNext.buttonMode = true;
			this._mcweaponpannel.btnNext.addEventListener(MouseEvent.CLICK,btnNextHandler);
			this._mcweaponpannel.btnNextArrow.buttonMode=true;
			this._mcweaponpannel.btnNextArrow.addEventListener(MouseEvent.CLICK,btnNextArrowHandler);
			this._mcweaponpannel.btnPrevArrow.buttonMode=true;
			this._mcweaponpannel.btnPrevArrow.addEventListener(MouseEvent.CLICK,btnPrevArrowHandler);
			this._mcweaponpannel.btnSell.buttonMode=true;
			this._mcweaponpannel.btnSell.addEventListener(MouseEvent.CLICK,btnSellHandler);
		}
		private function initBuyConfirm():void{
			addChild(buyConfirm);
			buyConfirm.x=230;
			buyConfirm.y=300;
			buyConfirm.yesBtn.buttonMode=true;
			buyConfirm.noBtn.buttonMode=true;
			buyConfirm.visible=false;
		}
		
		private function initAlert():void{
			
				alert=new mcAlert();
				alert.x=227;
				alert.y=296;
				this.addChild(alert);
				alert.okButton.buttonMode=true;
				alert.visible=false;
			
		}
		private function setWeaponList():void{
			for(var i:int=1;i<=6;i++){
				var item:WeaponItemView=new WeaponItemView();
				item.y=parseInt(((i-1)/3).toString())*220+70;
				item.x=(i-1)%3*147.85+20;
				weaponObj["weaponItem"+i]=item;
				item=null;
				weaponObj["weaponItem"+i].addEventListener(MouseEvent.ROLL_OVER,tipInHandler);
				weaponObj["weaponItem"+i].addEventListener(MouseEvent.ROLL_OUT,tipOutHandler);
				_mcweaponpannel.bg.addChild(weaponObj["weaponItem"+i]);
				
			}
		}
		private function tipInHandler(e:MouseEvent):void{
			
			if(e.currentTarget._weaponItemVo&&e.currentTarget._weaponItem.chain.visible==false){
				e.currentTarget.buttonMode=true;
				if(e.currentTarget==weaponObj["weaponItem1"]||e.currentTarget==weaponObj["weaponItem2"]||e.currentTarget==weaponObj["weaponItem3"]){
					tip.x=75;
					tip.y=280;
				}
				if(e.currentTarget==weaponObj["weaponItem4"]||e.currentTarget==weaponObj["weaponItem5"]||e.currentTarget==weaponObj["weaponItem6"]){
					tip.x=75;
					tip.y=80;
				}
				tip.visible=true;
				var temp:WeaponItemVo=e.currentTarget._weaponItemVo;
				tip.content.weaponName.text=temp.name;
				
				tip.content.desc.text=temp.description;
				//trace(temp.description);
				if(moneyIcoTip!=null)
					moneyIcoTip.parent.removeChild(moneyIcoTip);
				if(temp.karma_value=="0"){
					tip.content.price.weaponPrice.text=CommonUtils.getFormattedNumber(parseInt(temp.value));
					moneyIcoTip=new Bitmap(new GoldIcon());
				}else{
					tip.content.price.weaponPrice.text=temp.karma_value;
					moneyIcoTip=new Bitmap(new KarmaIcon());
				}
				moneyIcoTip.x=tip.content.price.weaponPrice.x+tip.content.price.weaponPrice.textWidth+10;
				moneyIcoTip.y=tip.content.price.weaponPrice.y+5;
				tip.content.price.addChild(moneyIcoTip);
				tip.content.weaponPower.text=temp.dps.toString();
				var temprota:int = 0;
				if (temp.attributes.speed < 100)
				{
					temprota = 85 * (1 - temp.attributes.speed / 100);
				}
				else if (temp.attributes.speed > 100)
				{
					temprota = -85 * (temp.attributes.speed) / 100 / 5;
				}
				tip.content.meter.needle.rotation=270+temprota;
				tip.content.weaponSpeed.text=temp.getSpeed();
				
				e.currentTarget._weaponItem.btnClickToBuy.visible=true;
				e.currentTarget.addEventListener(MouseEvent.CLICK,weaponClickHandler);
			}
			e.currentTarget._weaponItem.buttonMode=false;
		}
		
		private function tipOutHandler(e:MouseEvent):void{
			tip.visible=false;
			e.currentTarget.removeEventListener(MouseEvent.CLICK,weaponClickHandler);
			e.currentTarget._weaponItem.btnClickToBuy.visible=false;
		}
		//点击购买某武器
		private function weaponClickHandler(e:MouseEvent):void{
			buyConfirm.visible=true;
			var temp:WeaponItemVo=e.currentTarget._weaponItemVo;
			
			if(temp.karma_value=="0"){
				buyConfirm.weaponText.text="Would you like to buy "+temp.name+" for "+ temp.value+" gold?";
			}else
				buyConfirm.weaponText.text="Would you like to buy "+temp.name+" for "+ temp.karma_value +" kama?";
			//buyConfirm.yesBtn.addEventListener(MouseEvent.CLICK,buyConfirmYesHandler);
			buyConfirm.yesBtn.addEventListener(MouseEvent.CLICK,buyConfirmYesHandler);
			buyConfirm.noBtn.addEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
			//记录当前点击的  数据
			_currentWeaponItem=e.currentTarget._weaponItemVo;
		}
		//确认购买
		private function buyConfirmYesHandler(e:MouseEvent):void{
			this.buyConfirm.visible=false;
			//this.callMethod("weaponBuy",_currentWeaponItem);
			if(parseInt(_currentWeaponItem.karma_value)<=UserInfoModel.instance.UserInfo.karma&&parseInt(_currentWeaponItem.value)<=UserInfoModel.instance.UserInfo.gold){
				this.showWaitSymbol();
				
				this.callMethodAndCallback("weaponBuy",buyCallback,_currentWeaponItem.iid);
				
				buyConfirm.yesBtn.removeEventListener(MouseEvent.CLICK,buyConfirmYesHandler);
				buyConfirm.noBtn.removeEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
			}
			else{
				
				alert.visible=true;
				alert.alertText.text="You don\'t have enough momey to buy this weapon!";
				alert.okButton.addEventListener(MouseEvent.CLICK,alertOkHandler);
			}
			
		}
		//不购买
		private function buyConfirmNoHandler(e:MouseEvent):void{
			this.buyConfirm.visible=false;
			buyConfirm.yesBtn.removeEventListener(MouseEvent.CLICK,buyConfirmYesHandler);
			buyConfirm.noBtn.removeEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
		}
		
		private function buyCallback(pram:Object):void{
			this.hideWaitSymbol();
			if(pram.result=="success"){
				UserInfoModel.instance.adjustStats(parseInt(_currentWeaponItem.value)*-1,parseInt(_currentWeaponItem.karma_value)*-1);
				UserInfoModel.instance.UserInfo.addWeapon(_currentWeaponItem);
				WeaponModel.instance.populatePlayerInventory();
				var _loc_2:int = 0;
				while (_loc_2 < WeaponModel.instance.sortedWeapons.length)
				{
					
					if (_currentWeaponItem.iid == WeaponModel.instance.sortedWeapons[_loc_2][0].iid)
					{
						break;
					}
					_loc_2++;
				}
				currentPageWeaponOwned = _loc_2;
				renderWeaponOwned();
				
			}
			else{
				
			}
		}
		
		private function btnSellHandler(e:MouseEvent):void{
			//如果武器不能卖出
			if (WeaponModel.instance.sortedWeapons[currentPageWeaponOwned][0].attributes.unsellable != undefined && WeaponModel.instance.sortedWeapons[currentPageWeaponOwned][0].attributes.unsellable == "1")
			{
				
				alert.visible=true;
				alert.alertText.text="You can\'t sell this weapon!  It\'s spiritually important to your whole clan!"
				alert.okButton.addEventListener(MouseEvent.CLICK,alertOkHandler);
				
			}else{
				this.showWaitSymbol();
				this.callMethodAndCallback("weaponSell",btnSellCallback,parseInt(WeaponModel.instance.sortedWeapons[this.currentPageWeaponOwned][0].iid));
			}
		
			
		}
		private function alertOkHandler(e:MouseEvent):void{
			alert.visible=false;
		}
		public function btnSellCallback(pram:Object):void{
			//更新数据
			this.hideWaitSymbol();
			if(pram.result=="success"){
				trace("btnSellCallback");
				var sortedWeapons:Array=WeaponModel.instance.sortedWeapons;
				if (parseInt(sortedWeapons[currentPageWeaponOwned][0].karma_value) > 0)
				{
					UserInfoModel.instance.adjustStats(0, int(parseInt(sortedWeapons[currentPageWeaponOwned][0].karma_value) * MainConfig.SELLRATIO));
				}
				else
				{
					UserInfoModel.instance.adjustStats(int(sortedWeapons[currentPageWeaponOwned][0].value * MainConfig.SELLRATIO), 0);
				}
				var temp:Object=sortedWeapons[currentPageWeaponOwned].pop();
				
				UserInfoModel.instance.removeSelectedWeapon(temp);
				if (!sortedWeapons[currentPageWeaponOwned].length)
				{
					sortedWeapons.splice(currentPageWeaponOwned, 1);
					if (currentPageWeaponOwned >= sortedWeapons.length)
					{
						currentPageWeaponOwned = 0;
					}
				}
				renderWeaponOwned();
			}
			else{
				
				
				alert.visible=true;
				alert.alertText.text="sell failed !"
				alert.okButton.addEventListener(MouseEvent.CLICK,alertOkHandler);
			}
			
			
		}
		
		
		private function btnPreHandler(e:MouseEvent):void{
			main.buttonSound();
			this.currentPageWeapon--;
			renderWeapon();
		}
		
		private function btnNextHandler(e:MouseEvent):void{
			main.buttonSound();
			this.currentPageWeapon++;
			renderWeapon();
		}
		private function btnNextArrowHandler(e:MouseEvent):void{
			main.buttonSound();
			currentPageWeaponOwned++;
			currentPageWeaponOwned=currentPageWeaponOwned%WeaponModel.instance.sortedWeapons.length;
			renderWeaponOwned();
		}
		private function btnPrevArrowHandler(e:MouseEvent):void{
			main.buttonSound();
			if(currentPageWeaponOwned==0)
				currentPageWeaponOwned=WeaponModel.instance.sortedWeapons.length-1;
			else
				currentPageWeaponOwned--;
			renderWeaponOwned();
		}
		//呈现weaponItem
		private function renderWeapon():void{
			//清空
			if(this.currentPageWeapon!=0)
			{
				for(var j:int=1;j<7;j++){
					while(weaponObj["weaponItem"+j]._weaponItem.mc_image.numChildren)
						weaponObj["weaponItem"+j]._weaponItem.mc_image.removeChildAt(0);
					weaponObj["weaponItem"+j]._weaponItemVo=null;
					weaponObj["weaponItem"+j]._weaponItem.newStar.visible = false;
					weaponObj["weaponItem"+j]._weaponItem.btnClickToBuy.visible = false;
					weaponObj["weaponItem"+j].buttonMode=false;
					weaponObj["weaponItem"+j]._weaponItem.chain.visible=false;
					
				}
			}
			var beginNum:int=6*currentPageWeapon;
			var endNum:int=Math.max(1,Math.min(beginNum+6,WeaponModel.instance.weaponItemList.length));
			var temp:int=endNum-beginNum+1;
			for(var i:int=1;i<temp;i++){
				weaponObj["weaponItem"+i].setDate(WeaponModel.instance.weaponItemList[beginNum++]);
				//weaponObj["weaponItem"+i].buttonMode=true;
			}
			btnEnable();
		}
		
		private function renderWeaponOwned():void{
			while(_weaponOwnedItem.numChildren)
				_weaponOwnedItem.removeChildAt(0);
			if(UserInfoModel.instance.UserInfo.weaponInventory.length==0){
				this._mcweaponpannel.btnNextArrow.visible=false;
				this._mcweaponpannel.btnPrevArrow.visible=false;
				this._mcweaponpannel.btnSell.visible=false;
				this._mcweaponpannel.weaponCount.text="";
				_mcweaponpannel.wName.text="";
				_mcweaponpannel.inventoryStats.visible=false;
				
			}else{
				_mcweaponpannel.inventoryStats.visible=true;
				this._mcweaponpannel.btnNextArrow.visible=true;
				this._mcweaponpannel.btnPrevArrow.visible=true;
				this._mcweaponpannel.btnSell.visible=true;
				trace(WeaponModel.instance.sortedWeapons[this.currentPageWeaponOwned][0].iid);
				//var temp:Object=WeaponModel.instance.sortedWeapons[this.currentPageWeaponOwned][0];
				trace("currentPageWeaponOwned="+currentPageWeaponOwned);
				trace(WeaponModel.instance.sortedWeapons[this.currentPageWeaponOwned][0]==null);
				trace(WeaponModel.instance.sortedWeapons[this.currentPageWeaponOwned][0].description);
				var temp:WeaponItemVo=new WeaponItemVo(WeaponModel.instance.sortedWeapons[this.currentPageWeaponOwned][0]);
				this._mcweaponpannel.weaponCount.text=WeaponModel.instance.sortedWeapons[this.currentPageWeaponOwned].length;;
				this._mcweaponpannel.wName.text=temp.name;
				if(moneyIco!=null)
					moneyIco.parent.removeChild(moneyIco);
				if(temp.karma_value!="0"){
					this._mcweaponpannel.inventoryStats.wValue.text=parseInt(temp.karma_value)*com.app.config.MainConfig.SELLRATIO;
					moneyIco=new Bitmap(new KarmaIcon());
				}
				else{
					this._mcweaponpannel.inventoryStats.wValue.text=parseInt(temp.value)*com.app.config.MainConfig.SELLRATIO;
					moneyIco=new Bitmap(new GoldIcon());
				}
					
				
				this._mcweaponpannel.inventoryStats.wSpeed.text=temp.getSpeed();
				
					
				moneyIco.x=this._mcweaponpannel.inventoryStats.wValue.x+this._mcweaponpannel.inventoryStats.wValue.textWidth+10;
				moneyIco.y=this._mcweaponpannel.inventoryStats.wValue.y+5;
				this._mcweaponpannel.inventoryStats.addChild(moneyIco);
				this._mcweaponpannel.inventoryStats.wDamage.text=Math.round(100 / parseInt(temp.attributes.speed) * parseFloat(temp.attributes.damage) * 100) / 100;
				var temprota:int = 0;
				if (temp.attributes.speed < 100)
				{
					temprota = 85 * (1 - temp.attributes.speed / 100);
				}
				else if (temp.attributes.speed > 100)
				{
					temprota = -85 * (temp.attributes.speed) / 100 / 5;
				}
				
				this._mcweaponpannel.inventoryStats.meter.needle.rotation= 270 + temprota;
				this._mcweaponpannel.inventoryStats.wDesc.text=temp.description;
			
				CommonUtils.getImageByUrl(UrlConfig.WEAPONIMGURL+temp.sprite+".png",function(mc:Sprite,url:String):void{
					if(temp!=null&&url==(UrlConfig.WEAPONIMGURL+temp.sprite+".png")){
						while(_weaponOwnedItem.numChildren)
							_weaponOwnedItem.removeChildAt(0);
						mc.y=220-mc.height;
						_weaponOwnedItem.addChild(mc);
					}
				});
				
			}
		}
		
		public function btnBack_onclick(event:MouseEvent):void{
			main.buttonSound();
			HomeController.instance.renderHomeView();
		}
		//判断按钮是否可用
		private function btnEnable():void{
			if(this.currentPageWeapon==this.totalPageWeapon){
				this._mcweaponpannel.btnNext.visible=false;
			}
			else{
				this._mcweaponpannel.btnNext.visible=true;
			}
			if(this.currentPageWeapon!=0)
				this._mcweaponpannel.btnPrev.visible=true;
			else
				this._mcweaponpannel.btnPrev.visible=false;
		}
		
		/**
		 *获取weapon数据 
		 * @param weaponList
		 * 
		 */		
		public function WeaponModel_RefreshData_CalllBack():void{
			main.hideWaitSymbol();
			this.totalPageWeapon=(WeaponModel.instance.weaponItemList.length-1)/6;
			renderWeapon();
			renderWeaponOwned();
		}
		
		private function hideWaitSymbol():void{
			main.hideWaitSymbol();
			this._mcweaponpannel.btnBack.buttonMode = true;
			this._mcweaponpannel.btnBack.addEventListener(MouseEvent.CLICK,btnBack_onclick);
			this._mcweaponpannel.btnNextArrow.buttonMode=true;
			this._mcweaponpannel.btnNextArrow.addEventListener(MouseEvent.CLICK,btnNextArrowHandler);
			this._mcweaponpannel.btnPrevArrow.buttonMode=true;
			this._mcweaponpannel.btnPrevArrow.addEventListener(MouseEvent.CLICK,btnPrevArrowHandler);
			this._mcweaponpannel.btnSell.buttonMode=true;
			this._mcweaponpannel.btnSell.addEventListener(MouseEvent.CLICK,btnSellHandler);/**/
			
		}
		private function showWaitSymbol():void{
			main.showWaitSymbol();
			this._mcweaponpannel.btnBack.buttonMode = false;
			this._mcweaponpannel.btnBack.removeEventListener(MouseEvent.CLICK,btnBack_onclick);
			this._mcweaponpannel.btnNextArrow.buttonMode=false;
			this._mcweaponpannel.btnNextArrow.removeEventListener(MouseEvent.CLICK,btnNextArrowHandler);
			this._mcweaponpannel.btnPrevArrow.buttonMode=false;
			this._mcweaponpannel.btnPrevArrow.removeEventListener(MouseEvent.CLICK,btnPrevArrowHandler);
			this._mcweaponpannel.btnSell.buttonMode=false;
			this._mcweaponpannel.btnSell.removeEventListener(MouseEvent.CLICK,btnSellHandler);
		}
	}
}