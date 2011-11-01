package com.app.view
{
	
	
	import com.app.config.MainConfig;
	import com.app.config.UrlConfig;
	import com.app.controller.FramebarController;
	import com.app.controller.HomeController;
	import com.app.model.RelicModel;
	import com.app.model.UserInfoModel;
	import com.framework.utils.CommonUtils;
	import com.framework.view.ViewComponent;
	import com.vo.RelicItemVo;
	import com.vo.UserInfoVo;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import res.relics.mcAlert;
	import res.relics.mcBuyConfirm;
	import res.relics.mcRelicOwnedItem;
	import res.relics.mcRelicPannel;
	import res.relics.mcTip;
	public class RelicView extends ViewComponent
	{
		private var _mcrelicpannel:mcRelicPannel;
		//存放relicItem对象
		public var relicObj:Object={};
		//记录当前点击的relicitem的数据
		private var _currentRelicItem:RelicItemVo;
		private var tip:mcTip;
		private var moneyIco:Bitmap;
		private var moneyIcoTip:Bitmap;
		private var buyConfirm:mcBuyConfirm=new mcBuyConfirm();
		private var totalPageRelic:int;
		private var currentPageRelic:int;
		private var currentPageRelicOwned:int;
		private var _relicOwnedItem:mcRelicOwnedItem;
		private var alert:mcAlert;
		private var main:FramebarView;
		public function RelicView()
		{
			init();
		}
		public function init():void{
			main=FramebarController.instance.framebarview;
			main.showWaitSymbol();
			_mcrelicpannel=new mcRelicPannel();
			this.addChild(this._mcrelicpannel); 
			setRelicList();
			setRelicOwnedList();
			currentPageRelic=0;
			currentPageRelicOwned=0;
			RelicModel.instance.RefreshData(RelicModel_RefreshData_CalllBack);
			initTip();
			initBuyConfirm();
			initBtn();
			initAlert();
			
		}
		//添加_relicOwnedItem
		private function setRelicOwnedList():void{
			_relicOwnedItem=new mcRelicOwnedItem();
			_relicOwnedItem.x=550;
			_relicOwnedItem.y=100;
			this._mcrelicpannel.bg.addChild(_relicOwnedItem);
		}
		private function initTip():void{
			tip=new mcTip()
			addChild(tip);
			tip.visible=false;
		}
		//初始化按钮
		private function initBtn():void{
			this._mcrelicpannel.btnBack.buttonMode = true;
			this._mcrelicpannel.btnBack.addEventListener(MouseEvent.CLICK,btnBack_onclick);
			this._mcrelicpannel.btnPrev.buttonMode = true;
			this._mcrelicpannel.btnPrev.addEventListener(MouseEvent.CLICK,btnPreHandler);
			this._mcrelicpannel.btnNext.buttonMode = true;
			this._mcrelicpannel.btnNext.addEventListener(MouseEvent.CLICK,btnNextHandler);
			this._mcrelicpannel.btnNextArrow.buttonMode=true;
			this._mcrelicpannel.btnNextArrow.addEventListener(MouseEvent.CLICK,btnNextArrowHandler);
			this._mcrelicpannel.btnPrevArrow.buttonMode=true;
			this._mcrelicpannel.btnPrevArrow.addEventListener(MouseEvent.CLICK,btnPrevArrowHandler);
			this._mcrelicpannel.btnSell.buttonMode=true;
			this._mcrelicpannel.btnSell.addEventListener(MouseEvent.CLICK,btnSellHandler);
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
		private function setRelicList():void{
			for(var i:int=1;i<=6;i++){
				var item:RelicItemView=new RelicItemView();
				item.y=parseInt(((i-1)/3).toString())*220+70;
				item.x=(i-1)%3*147.85+20;
				relicObj["relicItem"+i]=item;
				item=null;
				relicObj["relicItem"+i].addEventListener(MouseEvent.ROLL_OVER,tipInHandler);
				relicObj["relicItem"+i].addEventListener(MouseEvent.ROLL_OUT,tipOutHandler);
				_mcrelicpannel.bg.addChild(relicObj["relicItem"+i]);
				
			}
		}
		private function tipInHandler(e:MouseEvent):void{
			
			if(e.currentTarget._relicItem.lblOwned.visible==false&&e.currentTarget._relicItemVo&&e.currentTarget._relicItem.chain.visible==false){
				e.currentTarget.buttonMode=true;
				if(e.currentTarget==relicObj["relicItem1"]||e.currentTarget==relicObj["relicItem2"]||e.currentTarget==relicObj["relicItem3"]){
					tip.x=80;
					tip.y=313;
				}
				if(e.currentTarget==relicObj["relicItem4"]||e.currentTarget==relicObj["relicItem5"]||e.currentTarget==relicObj["relicItem6"]){
					tip.x=80;
					tip.y=110;
				}
				tip.visible=true;
				var temp:RelicItemVo=e.currentTarget._relicItemVo;
				tip.relicName.text=temp.name;
				
				tip.relicDesc.text=temp.description;
				//trace(temp.description);
				if(moneyIcoTip!=null)
					moneyIcoTip.parent.removeChild(moneyIcoTip);
				if(temp.karma_value=="0"){
					tip.relicPrice.text=CommonUtils.getFormattedNumber(parseInt(temp.value));
					moneyIcoTip=new Bitmap(new GoldIcon());
				}else{
					tip.relicPrice.text=temp.karma_value;
					moneyIcoTip=new Bitmap(new KarmaIcon());
				}
				moneyIcoTip.x=tip.relicPrice.x+tip.relicPrice.textWidth+10;
				moneyIcoTip.y=tip.relicPrice.y+5;
				tip.addChild(moneyIcoTip);
				//tip.content.relicPower.text=temp.dps.toString();
				
				
				e.currentTarget._relicItem.btnClickToBuy.visible=true;
				e.currentTarget.addEventListener(MouseEvent.CLICK,relicClickHandler);
			}
			e.currentTarget._relicItem.buttonMode=false;
		}
		
		private function tipOutHandler(e:MouseEvent):void{
			tip.visible=false;
			e.currentTarget.removeEventListener(MouseEvent.CLICK,relicClickHandler);
			e.currentTarget._relicItem.btnClickToBuy.visible=false;
		}
		//点击购买某武器
		private function relicClickHandler(e:MouseEvent):void{
			buyConfirm.visible=true;
			var temp:RelicItemVo=e.currentTarget._relicItemVo;
			
			if(temp.karma_value=="0"){
				buyConfirm.relicText.text="Would you like to buy "+temp.name+" for "+ temp.value+" gold?";
			}else
				buyConfirm.relicText.text="Would you like to buy "+temp.name+" for "+ temp.karma_value +" kama?";
			//buyConfirm.yesBtn.addEventListener(MouseEvent.CLICK,buyConfirmYesHandler);
			buyConfirm.yesBtn.addEventListener(MouseEvent.CLICK,buyConfirmYesHandler);
			buyConfirm.noBtn.addEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
			//记录当前点击的  数据
			_currentRelicItem=e.currentTarget._relicItemVo;
		}
		//确认购买
		private function buyConfirmYesHandler(e:MouseEvent):void{
			this.buyConfirm.visible=false;
			//this.callMethod("relicBuy",_currentRelicItem);
			if(parseInt(_currentRelicItem.karma_value)<=UserInfoModel.instance.UserInfo.karma&&parseInt(_currentRelicItem.value)<=UserInfoModel.instance.UserInfo.gold){
				this.showWaitSymbol();
				this.callMethodAndCallback("relicBuy",buyCallback,_currentRelicItem.iid);
				
				buyConfirm.yesBtn.removeEventListener(MouseEvent.CLICK,buyConfirmYesHandler);
				buyConfirm.noBtn.removeEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
			}
			else{
				
				alert.visible=true;
				alert.alertText.text="You don\'t have enough momey to buy this relic!";
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
				UserInfoModel.instance.adjustStats(parseInt(_currentRelicItem.value)*-1,parseInt(_currentRelicItem.karma_value)*-1);
				UserInfoModel.instance.UserInfo.addRelic(_currentRelicItem);
				RelicModel.instance.populatePlayerInventory();
				var _loc_2:int = 0;
				while (_loc_2 < RelicModel.instance.sortedRelics.length)
				{
					
					if (_currentRelicItem.iid == RelicModel.instance.sortedRelics[_loc_2][0].iid)
					{
						break;
					}
					_loc_2++;
				}
				currentPageRelicOwned = _loc_2;
				renderRelicOwned();
				renderRelic();
				
			}
			else{
				
			}
		}
		
		private function btnSellHandler(e:MouseEvent):void{
			//如果武器不能卖出
			if (RelicModel.instance.sortedRelics[currentPageRelicOwned][0].attributes.unsellable != undefined && RelicModel.instance.sortedRelics[currentPageRelicOwned][0].attributes.unsellable == "1")
			{
				
				alert.visible=true;
				alert.alertText.text="You can\'t sell this relic!  It\'s spiritually important to your whole clan!"
				alert.okButton.addEventListener(MouseEvent.CLICK,alertOkHandler);
				
			}else{
				this.showWaitSymbol();
				this.callMethodAndCallback("relicSell",btnSellCallback,parseInt(RelicModel.instance.sortedRelics[this.currentPageRelicOwned][0].iid));
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
				var sortedRelics:Array=RelicModel.instance.sortedRelics;
				if (parseInt(sortedRelics[currentPageRelicOwned][0].karma_value) > 0)
				{
					UserInfoModel.instance.adjustStats(0, int(parseInt(sortedRelics[currentPageRelicOwned][0].karma_value) * MainConfig.SELLRATIO));
				}
				else
				{
					UserInfoModel.instance.adjustStats(int(sortedRelics[currentPageRelicOwned][0].value * MainConfig.SELLRATIO), 0);
				}
				var temp:Object=sortedRelics[currentPageRelicOwned].pop();
				
				UserInfoModel.instance.removeSelectedRelic(temp);
				if (!sortedRelics[currentPageRelicOwned].length)
				{
					sortedRelics.splice(currentPageRelicOwned, 1);
					if (currentPageRelicOwned >= sortedRelics.length)
					{
						currentPageRelicOwned = 0;
					}
				}
				renderRelicOwned();
				renderRelic();
			}
			else{
				
				
				alert.visible=true;
				alert.alertText.text="sell failed !"
				alert.okButton.addEventListener(MouseEvent.CLICK,alertOkHandler);
			}
			
			
		}
		
		
		private function btnPreHandler(e:MouseEvent):void{
			main.buttonSound();
			this.currentPageRelic--;
			renderRelic();
		}
		
		private function btnNextHandler(e:MouseEvent):void{
			main.buttonSound();
			this.currentPageRelic++;
			renderRelic();
		}
		private function btnNextArrowHandler(e:MouseEvent):void{
			main.buttonSound();
			currentPageRelicOwned++;
			currentPageRelicOwned=currentPageRelicOwned%RelicModel.instance.sortedRelics.length;
			renderRelicOwned();
		}
		private function btnPrevArrowHandler(e:MouseEvent):void{
			main.buttonSound();
			if(currentPageRelicOwned==0)
				currentPageRelicOwned=RelicModel.instance.sortedRelics.length-1;
			else
				currentPageRelicOwned--;
			renderRelicOwned();
		}
		//呈现relicItem
		private function renderRelic():void{
			//清空
			if(this.currentPageRelic!=0)
			{
				for(var j:int=1;j<7;j++){
					while(relicObj["relicItem"+j]._relicItem.mc_image.numChildren)
						relicObj["relicItem"+j]._relicItem.mc_image.removeChildAt(0);
					relicObj["relicItem"+j]._relicItemVo=null;
					relicObj["relicItem"+j]._relicItem.newStar.visible = false;
					relicObj["relicItem"+j]._relicItem.btnClickToBuy.visible = false;
					relicObj["relicItem"+j].buttonMode=false;
					relicObj["relicItem"+j]._relicItem.chain.visible=false;
					
				}
			}
			var beginNum:int=6*currentPageRelic;
			var endNum:int=Math.max(1,Math.min(beginNum+6,RelicModel.instance.relicItemList.length));
			var temp:int=endNum-beginNum+1;
			for(var i:int=1;i<temp;i++){
				relicObj["relicItem"+i].setDate(RelicModel.instance.relicItemList[beginNum++]);
				//relicObj["relicItem"+i].buttonMode=true;
			}
			btnEnable();
		}
		
		private function renderRelicOwned():void{
			while(_relicOwnedItem.numChildren)
				_relicOwnedItem.removeChildAt(0);
			if(UserInfoModel.instance.UserInfo.relicInventory.length==0){
				this._mcrelicpannel.btnNextArrow.visible=false;
				this._mcrelicpannel.btnPrevArrow.visible=false;
				this._mcrelicpannel.btnSell.visible=false;
				this._mcrelicpannel.relicCount.text="";
				_mcrelicpannel.wName.text="";
				_mcrelicpannel.inventoryStats.visible=false;
				
			}else{
				_mcrelicpannel.inventoryStats.visible=true;
				this._mcrelicpannel.btnNextArrow.visible=true;
				this._mcrelicpannel.btnPrevArrow.visible=true;
				this._mcrelicpannel.btnSell.visible=true;
				//trace(RelicModel.instance.sortedRelics[this.currentPageRelicOwned][0].iid);
				//var temp:Object=RelicModel.instance.sortedRelics[this.currentPageRelicOwned][0];
				//trace("currentPageRelicOwned="+currentPageRelicOwned);
				//trace(RelicModel.instance.sortedRelics[this.currentPageRelicOwned][0]==null);
				//trace(RelicModel.instance.sortedRelics[this.currentPageRelicOwned][0].description);
				var temp:RelicItemVo=new RelicItemVo(RelicModel.instance.sortedRelics[this.currentPageRelicOwned][0]);
				this._mcrelicpannel.relicCount.text=RelicModel.instance.sortedRelics[this.currentPageRelicOwned].length;;
				this._mcrelicpannel.inventoryStats.rName.text=temp.name;
				//trace(temp.name);
				if(moneyIco!=null)
					moneyIco.parent.removeChild(moneyIco);
				if(temp.karma_value!="0"){
					this._mcrelicpannel.inventoryStats.rValue.text=parseInt(temp.karma_value)*com.app.config.MainConfig.SELLRATIO;
					moneyIco=new Bitmap(new KarmaIcon());
				}
				else{
					this._mcrelicpannel.inventoryStats.rValue.text=parseInt(temp.value)*com.app.config.MainConfig.SELLRATIO;
					moneyIco=new Bitmap(new GoldIcon());
				}
				
				
				//this._mcrelicpannel.inventoryStats.wSpeed.text=temp.getSpeed();
				
				
				moneyIco.x=this._mcrelicpannel.inventoryStats.rValue.x+this._mcrelicpannel.inventoryStats.rValue.textWidth+10;
				moneyIco.y=this._mcrelicpannel.inventoryStats.rValue.y+5;
				this._mcrelicpannel.inventoryStats.addChild(moneyIco);
				//this._mcrelicpannel.inventoryStats.rDamage.text=Math.round(100 / parseInt(temp.attributes.speed) * parseFloat(temp.attributes.damage) * 100) / 100;
				
				this._mcrelicpannel.inventoryStats.rDesc.text=temp.description;
				
				//trace(UrlConfig.RELICIMGURL+temp.sprite+".png");
				CommonUtils.getImageByUrl(UrlConfig.RELICIMGURL+temp.sprite+".png",function(mc:Sprite,url:String):void{
					if(temp!=null&&url==(UrlConfig.RELICIMGURL+temp.sprite+".png")){
						while(_relicOwnedItem.numChildren)
							_relicOwnedItem.removeChildAt(0);
						mc.y=150-mc.height;
						_relicOwnedItem.addChild(mc);
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
			if(this.currentPageRelic==this.totalPageRelic){
				this._mcrelicpannel.btnNext.visible=false;
			}
			else{
				this._mcrelicpannel.btnNext.visible=true;
			}
			if(this.currentPageRelic!=0)
				this._mcrelicpannel.btnPrev.visible=true;
			else
				this._mcrelicpannel.btnPrev.visible=false;
		}
		
		/**
		 *获取relic数据 
		 * @param relicList
		 * 
		 */		
		public function RelicModel_RefreshData_CalllBack():void{
			main.hideWaitSymbol();
			this.totalPageRelic=(RelicModel.instance.relicItemList.length-1)/6;
			renderRelic();
			renderRelicOwned();
			
		}
		
		private function hideWaitSymbol():void{
			main.hideWaitSymbol();
			this._mcrelicpannel.btnBack.buttonMode = true;
			this._mcrelicpannel.btnBack.addEventListener(MouseEvent.CLICK,btnBack_onclick);
			this._mcrelicpannel.btnNextArrow.buttonMode=true;
			this._mcrelicpannel.btnNextArrow.addEventListener(MouseEvent.CLICK,btnNextArrowHandler);
			this._mcrelicpannel.btnPrevArrow.buttonMode=true;
			this._mcrelicpannel.btnPrevArrow.addEventListener(MouseEvent.CLICK,btnPrevArrowHandler);
			this._mcrelicpannel.btnSell.buttonMode=true;
			this._mcrelicpannel.btnSell.addEventListener(MouseEvent.CLICK,btnSellHandler);/**/
			
		}
		private function showWaitSymbol():void{
			main.showWaitSymbol();
			this._mcrelicpannel.btnBack.buttonMode = false;
			this._mcrelicpannel.btnBack.removeEventListener(MouseEvent.CLICK,btnBack_onclick);
			this._mcrelicpannel.btnNextArrow.buttonMode=false;
			this._mcrelicpannel.btnNextArrow.removeEventListener(MouseEvent.CLICK,btnNextArrowHandler);
			this._mcrelicpannel.btnPrevArrow.buttonMode=false;
			this._mcrelicpannel.btnPrevArrow.removeEventListener(MouseEvent.CLICK,btnPrevArrowHandler);
			this._mcrelicpannel.btnSell.buttonMode=false;
			this._mcrelicpannel.btnSell.removeEventListener(MouseEvent.CLICK,btnSellHandler);
		}
	}
}