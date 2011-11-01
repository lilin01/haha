package com.app.view
{
	
	
	import com.app.config.MainConfig;
	import com.app.config.UrlConfig;
	import com.app.controller.FramebarController;
	import com.app.controller.HomeController;
	import com.app.model.MagicModel;
	import com.app.model.UserInfoModel;
	import com.app.view.FramebarView;
	import com.framework.utils.CommonUtils;
	import com.framework.view.ViewComponent;
	import com.vo.MagicItemVo;
	import com.vo.UserInfoVo;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import res.magics.mcBuyConfirm;
	import res.magics.mcMagicPannel;
	import res.magics.mcTip;

	public class MagicView extends ViewComponent
	{
		private var _mcmagicpannel:mcMagicPannel;
		//存放magicItem对象
		public var magicObj:Object={};
		//记录当前点击的magicitem的数据
		private var _currentMagicItem:MagicItemVo;
		private var tip:mcTip;
		
		private var buyConfirm:mcBuyConfirm=new mcBuyConfirm();
		private var totalPageMagic:int;
		private var currentPageMagic:int;
		private var currentPageMagicOwned:int;
		private var _magicOwnedItem:Sprite;
		private var timer:Timer;
		private var main:FramebarView;
		//private var _magicOwnedItem:mcMagicOwnedItem;
		//private var alert:mcAlert;
		public function MagicView(main:FramebarView)
		{
			this.main=main;
			init();
		}
		public function init():void{
			main=FramebarController.instance.framebarview;
			_mcmagicpannel=new mcMagicPannel();
			this.addChild(this._mcmagicpannel); 
			setMagicList();
			//setMagicOwnedList();
			currentPageMagic=0;
			currentPageMagicOwned=0;
			main.showWaitSymbol();
			MagicModel.instance.RefreshData(MagicModel_RefreshData_CalllBack);
			initTip();
			initBuyConfirm();
			initBtn();
			initAlert();
			setMagicOwned();
			timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,timerhandler);
			this._mcmagicpannel.getMoreButton.buttonMode=true;
			this._mcmagicpannel.getMoreButton.addEventListener(MouseEvent.CLICK,getMorehandler);
		}

		//添加_relicOwnedItem
		private function setMagicOwned():void{
			_magicOwnedItem=new Sprite();
			_magicOwnedItem.x=550;
			_magicOwnedItem.y=100;
			this._mcmagicpannel.bg.addChild(_magicOwnedItem);
		}
	
		private function initTip():void{
			tip=new mcTip()
			addChild(tip);
			tip.visible=false;
		}
		//初始化按钮
		private function initBtn():void{
			this._mcmagicpannel.btnBack.buttonMode = true;
			this._mcmagicpannel.btnBack.addEventListener(MouseEvent.CLICK,btnBack_onclick);
			this._mcmagicpannel.btnPrev.buttonMode = true;
			this._mcmagicpannel.btnPrev.addEventListener(MouseEvent.CLICK,btnPreHandler);
			this._mcmagicpannel.btnNext.buttonMode = true;
			this._mcmagicpannel.btnNext.addEventListener(MouseEvent.CLICK,btnNextHandler);
			/*this._mcmagicpannel.btnNextArrow.buttonMode=true;
			this._mcmagicpannel.btnNextArrow.addEventListener(MouseEvent.CLICK,btnNextArrowHandler);
			this._mcmagicpannel.btnPrevArrow.buttonMode=true;
			this._mcmagicpannel.btnPrevArrow.addEventListener(MouseEvent.CLICK,btnPrevArrowHandler);
			this._mcmagicpannel.btnSell.buttonMode=true;
			this._mcmagicpannel.btnSell.addEventListener(MouseEvent.CLICK,btnSellHandler);*/
		}
		private function initBuyConfirm():void{
			addChild(buyConfirm);
			buyConfirm.x=230;
			buyConfirm.y=300;
			buyConfirm.buyKarma.buttonMode=true;
			buyConfirm.buyTokens.buttonMode=true;
			buyConfirm.noBtn.buttonMode=true;
			buyConfirm.visible=false;
		}
		
		private function initAlert():void{
			
			/*alert=new mcAlert();
			alert.x=227;
			alert.y=296;
			this.addChild(alert);
			alert.okButton.buttonMode=true;
			alert.visible=false;*/
			
		}
		private function setMagicList():void{
			for(var i:int=1;i<=6;i++){
				var item:MagicItemView=new MagicItemView();
				item.y=parseInt(((i-1)/3).toString())*220+50;
				item.x=(i-1)%3*147.85+30;
				magicObj["magicItem"+i]=item;
				item=null;
				magicObj["magicItem"+i].addEventListener(MouseEvent.ROLL_OVER,tipInHandler);
				magicObj["magicItem"+i].addEventListener(MouseEvent.ROLL_OUT,tipOutHandler);
				_mcmagicpannel.bg.addChild(magicObj["magicItem"+i]);
				
			}
		}
		private function tipInHandler(e:MouseEvent):void{
			
			if(e.currentTarget._magicItem.lblOwned.visible==false&&e.currentTarget._magicItemVo&&e.currentTarget._magicItem.chain.visible==false){
				e.currentTarget.buttonMode=true;
				if(e.currentTarget==magicObj["magicItem1"]||e.currentTarget==magicObj["magicItem2"]||e.currentTarget==magicObj["magicItem3"]){
					tip.x=80;
					tip.y=288;
				}
				if(e.currentTarget==magicObj["magicItem4"]||e.currentTarget==magicObj["magicItem5"]||e.currentTarget==magicObj["magicItem6"]){
					tip.x=80;
					tip.y=80;
				}
				tip.visible=true;
				var temp:MagicItemVo=e.currentTarget._magicItemVo;
				tip.magicName.text=temp.name;
				tip.damage.text=temp.damage.toString();
				tip.duration.text=main.secondsToString(parseInt(temp.duration));
				tip.desc.text=temp.description;
				//trace(temp.description);
			
				if(temp.karma_value==0){
					tip.giftPrice.text=CommonUtils.getFormattedNumber(temp.gift_currency_value);
					
				}else{
					tip.price.text=temp.karma_value.toString();
				}
				e.currentTarget._magicItem.btnClickToBuy.visible=true;
				e.currentTarget.addEventListener(MouseEvent.CLICK,magicClickHandler);
			}
			e.currentTarget._magicItem.buttonMode=false;
		}
		
		private function tipOutHandler(e:MouseEvent):void{
			tip.visible=false;
			e.currentTarget.removeEventListener(MouseEvent.CLICK,magicClickHandler);
			e.currentTarget._magicItem.btnClickToBuy.visible=false;
		}
		//点击购买某武器
		private function magicClickHandler(e:MouseEvent):void{
				buyConfirm.visible=true;
				var temp:MagicItemVo=e.currentTarget._magicItemVo;
				buyConfirm.karmaPrice.text=temp.karma_value.toString();
				buyConfirm.giftPrice.text=temp.gift_currency_value.toString();
				buyConfirm.magicText.text="Would you like to buy the "+temp.name+" ?";
				//buyConfirm.yesBtn.addEventListener(MouseEvent.CLICK,buyConfirmYesHandler);
				//buyConfirm.buyKarma.addEventListener(MouseEvent.CLICK,buyConfirmKarmaHandler);
				buyConfirm.buyKarma.addEventListener(MouseEvent.CLICK,buyClickHandler);
				buyConfirm.buyTokens.addEventListener(MouseEvent.CLICK,buyClickHandler);
				buyConfirm.noBtn.addEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
				//记录当前点击的  数据
				_currentMagicItem=e.currentTarget._magicItemVo;
		}
		
		private function buyClickHandler(e:MouseEvent):void{
			if(UserInfoModel.instance.UserInfo.magic.sid!=0){
				main.buttonSound();
				main.confirm("Buying this will destroy your current magic!  Are you sure?", e.currentTarget.name=="buyKarma"?buyConfirmKarmaHandler:buyConfirmTokensHandler,closeWindow);
			}else{
				main.soundManager.loadSoundEffect("magic_buy");
				if(e.currentTarget.name=="buyKarma")
					buyConfirmKarmaHandler();
				else
					buyConfirmTokensHandler();
			}
			//trace(e.currentTarget.name=="buyKarma");
		}
		
		private function closeWindow():void{
			this.buyConfirm.visible=false;
		}
		
		//确认购买
		private function buyConfirmKarmaHandler():void{
			
			this.buyConfirm.visible=false;
			//this.callMethod("magicBuy",_currentMagicItem);
			if(_currentMagicItem.karma_value<=UserInfoModel.instance.UserInfo.karma){
				this.showWaitSymbol();
				this.callMethodAndCallback("magicKarmaBuy",buyCallback,_currentMagicItem);
				//buyConfirm.buyKarma.removeEventListener(MouseEvent.CLICK,buyConfirmKarmaHandler);
				//buyConfirm.buyTokens.removeEventListener(MouseEvent.CLICK,buyConfirmTokensHandler);
				buyConfirm.noBtn.removeEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
			}
			else{
				main.alert("You don\'t have enough momey to buy this magic!");
				/*alert.visible=true;
				alert.alertText.text="You don\'t have enough momey to buy this magic!";
				alert.okButton.addEventListener(MouseEvent.CLICK,alertOkHandler);*/
			}
			
		}
		
		private function buyConfirmTokensHandler():void{
			this.buyConfirm.visible=false;
			//this.callMethod("magicBuy",_currentMagicItem);
			if(_currentMagicItem.gift_currency_value<=parseInt(UserInfoModel.instance.UserInfo.gift_currency)){
				this.showWaitSymbol();
				this.callMethodAndCallback("magicTokensBuy",tokenBuyCallback,_currentMagicItem);
				
				//buyConfirm.buyKarma.removeEventListener(MouseEvent.CLICK,buyConfirmKarmaHandler);
				//buyConfirm.buyTokens.removeEventListener(MouseEvent.CLICK,buyConfirmTokensHandler);
				buyConfirm.noBtn.removeEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
			}
			else{
				main.alert("You don\'t have enough momey to buy this magic!");
				/*alert.visible=true;
				alert.alertText.text="You don\'t have enough momey to buy this magic!";
				alert.okButton.addEventListener(MouseEvent.CLICK,alertOkHandler);*/
			}
			
		}
		//不购买
		private function buyConfirmNoHandler(e:MouseEvent):void{
			this.buyConfirm.visible=false;
			buyConfirm.buyKarma.removeEventListener(MouseEvent.CLICK,buyConfirmKarmaHandler);
			buyConfirm.buyTokens.removeEventListener(MouseEvent.CLICK,buyConfirmTokensHandler);
			buyConfirm.noBtn.removeEventListener(MouseEvent.CLICK,buyConfirmNoHandler);
		}
		private function tokenBuyCallback(pram:Object):void{
			this.hideWaitSymbol();
			if(pram.result=="success"){
				UserInfoModel.instance.adjustStats(0,0,_currentMagicItem.gift_currency_value*-1);
				UserInfoModel.instance.UserInfo.magic=_currentMagicItem;
				main.setMagic();
				renderMagicOwned();
				renderMagic();
			}
			else{
				main.alert(pram.error);
			}
		}
		
		private function buyCallback(pram:Object):void{
			this.hideWaitSymbol();
			if(pram.result=="success"){
				UserInfoModel.instance.adjustStats(0,_currentMagicItem.karma_value*-1);
				UserInfoModel.instance.UserInfo.magic=_currentMagicItem;
				main.setMagic();
				renderMagicOwned();
				//_currentMagicItem.
				renderMagic();
			}
			else{
				main.alert(pram.error);
			}
		}
		
		
		
		
		
		
		private function btnPreHandler(e:MouseEvent):void{
			main.buttonSound();
			this.currentPageMagic--;
			renderMagic();
		}
		
		private function btnNextHandler(e:MouseEvent):void{
			main.buttonSound();
			this.currentPageMagic++;
			renderMagic();
		}
		
		//呈现magicItem
		private function renderMagic():void{
			//清空
			if(this.currentPageMagic!=0)
			{
				for(var j:int=1;j<7;j++){
					while(magicObj["magicItem"+j]._magicItem.mc_image.numChildren)
						magicObj["magicItem"+j]._magicItem.mc_image.removeChildAt(0);
					magicObj["magicItem"+j]._magicItemVo=null;
					magicObj["magicItem"+j]._magicItem.newStar.visible = false;
					magicObj["magicItem"+j]._magicItem.btnClickToBuy.visible = false;
					magicObj["magicItem"+j].buttonMode=false;
					magicObj["magicItem"+j]._magicItem.chain.visible=false;
					
				}
			}
			var beginNum:int=6*currentPageMagic;
			var endNum:int=Math.max(1,Math.min(beginNum+6,MagicModel.instance.magicItemList.length));
			var temp:int=endNum-beginNum+1;
			for(var i:int=1;i<temp;i++){
				magicObj["magicItem"+i].setDate(MagicModel.instance.magicItemList[beginNum++]);
				//magicObj["magicItem"+i].buttonMode=true;
			}
			btnEnable();
		}
		
		private function renderMagicOwned():void{
			var magic:MagicItemVo=new MagicItemVo(UserInfoModel.instance.UserInfo.magic);
			while(_magicOwnedItem.numChildren)
				_magicOwnedItem.removeChildAt(0);
			if(UserInfoModel.instance.UserInfo.magic.sid==0){
				
				timer.stop();
				_mcmagicpannel.inventoryStats.visible=false;
				
			}else{
				
				timer.start();
				_mcmagicpannel.inventoryStats.visible=true;
				var temp:MagicItemVo=new MagicItemVo(UserInfoModel.instance.UserInfo.magic);
				this._mcmagicpannel.inventoryStats.wName.text=temp.name;
				this._mcmagicpannel.inventoryStats.wDamage.text=temp.damage;
				this._mcmagicpannel.inventoryStats.timeRemaining.text=main.secondsToString(main.magicTime);
				this._mcmagicpannel.inventoryStats.wDesc.text=temp.description;
				CommonUtils.getImageByUrl(UrlConfig.MAGICIMGURL+temp.sprite+".png",function(mc:Sprite,url:String):void{
					if(temp!=null&&url==(UrlConfig.MAGICIMGURL+temp.sprite+".png")){
						while(_magicOwnedItem.numChildren)
							_magicOwnedItem.removeChildAt(0);
						mc.y=150-mc.height;
						_magicOwnedItem.addChild(mc);
					}
				});
				
			}
		}
		private function timerhandler(e:TimerEvent):void{
			this._mcmagicpannel.inventoryStats.timeRemaining.text=main.secondsToString(main.magicTime);
			if(main.magicTime==0){
				this.renderMagicOwned();
				renderMagic();
			}
		}
		
		public function btnBack_onclick(event:MouseEvent):void{
			main.buttonSound();
			HomeController.instance.renderHomeView();
		}
		//判断按钮是否可用
		private function btnEnable():void{
			if(this.currentPageMagic==this.totalPageMagic){
				this._mcmagicpannel.btnNext.visible=false;
			}
			else{
				this._mcmagicpannel.btnNext.visible=true;
			}
			if(this.currentPageMagic!=0)
				this._mcmagicpannel.btnPrev.visible=true;
			else
				this._mcmagicpannel.btnPrev.visible=false;
		}
		private function getMorehandler(e:MouseEvent):void{
			this.callMethod("askformore");
		}
		
		/**
		 *获取magic数据 
		 * @param magicList
		 * 
		 */		
		public function MagicModel_RefreshData_CalllBack():void{
			main.hideWaitSymbol();
			this.totalPageMagic=(MagicModel.instance.magicItemList.length-1)/6;
			renderMagic();
			renderMagicOwned();
			
		}
		
		private function hideWaitSymbol():void{
			main.hideWaitSymbol();
			this._mcmagicpannel.btnBack.buttonMode = true;
			this._mcmagicpannel.btnBack.addEventListener(MouseEvent.CLICK,btnBack_onclick);
			
		}
		private function showWaitSymbol():void{
			main.showWaitSymbol();
			this._mcmagicpannel.btnBack.buttonMode = false;
			this._mcmagicpannel.btnBack.removeEventListener(MouseEvent.CLICK,btnBack_onclick);
			
		}
	}
}