package com.app.view
{
	import com.app.SoundManager;
	import com.app.config.UrlConfig;
	import com.app.controller.DojoController;
	import com.app.controller.FramebarController;
	import com.app.controller.HomeController;
	import com.app.model.UserInfoModel;
	import com.app.view.game.*;
	import com.app.view.game.AchPopup;
	import com.app.view.game.AlertPopup;
	import com.app.view.game.AllyHead;
	import com.app.view.game.ConfirmPopup;
	import com.app.view.game.MainRelicRolloverStats;
	import com.app.view.game.MainRelicSlot;
	import com.app.view.game.MainSlotPurchase;
	import com.app.view.game.MainSlotWindow;
	import com.app.view.game.MuteButton;
	import com.app.view.game.MuteSfxButton;
	import com.app.view.game.Preloader;
	import com.app.view.game.Wait;
	import com.framework.utils.CommonUtils;
	import com.framework.view.ViewComponent;
	import com.vo.RelicItemVo;
	import com.vo.UserInfoVo;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;
	
	import org.osmf.net.StreamingURLResource;
	
	import res.game.*;
	import res.game.mcFramebar;
	public class FramebarView extends ViewComponent
	{
		public var faction:int;
		public var myName:String="";
		private var startAlly:int=0;
		private var allyBtnArr:Array=[];
		public var userInfo:Object;
		public var _mcFramebar:mcFramebar= new mcFramebar();
		public var updateHealthTimer:int = 30;
		public var currentAlly:Object;
		private var slotButtons:Array=[];
		private var waitSymbol:Wait;
		public var maxSlots:int = 6;
		//public var confirmWindow:ConfirmPopup;
		public var confirmWindow:Object;
		//显示slot中relic信息
		private var relicStatsWindow:MainRelicRolloverStats;
		public var slotWindow:MainSlotWindow=null;
		public var yesNoWindow:MainSlotPurchase=null;
		public var alertWindow:Object=null;
		public var slotPrices:Array;
		private var bonusTimer:Timer;
		public var magicTime:int;
		private var magicIcon:Loader;
		public var preloader:Preloader = null;
		private var loaderArray:Array;
		public var ninjaList:Array;
		public var achievementProgress:Array = null;
		public var removedMissions:Array=[];
		public var debugPrefix:String;
		public var prefix:String;
		public var phpsessid:String;
		public var opponent:Object=null;
		/*比赛场数4,5,6*/
		public var tourneySize:int;
		public var tourneyType:String;
		public var tournament:int;
		public var tournamentAvailable:int = 0;
		public var tournamentTimer:Timer;
		public var soundManager:SoundManager;
		public var settings:SharedObject;
		private var sfxChannels:Array;
		private var musicChannel:SoundChannel;
		private var currentSong:String = "menu30";
		private var bgMusic:Sound = null;
		private var currentSfxChannel:int = 0;
		private var mute:Object = null;
		private var sfxmute:Object = null;
		private var musicVolume:Number = 0.5;
		//通过网页传参
		public var pendingGifts:int = 0;
		public function FramebarView() 
		{
			if(stage)
				init();
			else 
				this.addEventListener(Event.ADDED_TO_STAGE,init);
		}//Home
		
		public function init(event:Event = null):void{ 
			
			this.prefix=UrlConfig.PREFIX;
			//this.debugPrefix = "http://ninjawarzdev.brokenbulbstudios.com";
			this.phpsessid="gfb00njecqfuabbc95p9j3osp15ie346";
			this.removeEventListener(Event.ADDED_TO_STAGE,init);	
			 
			this._mcFramebar.mcDubExp.visible = false;
			
			this._mcFramebar.mcFriendPannel.options.visible = false;
			this._mcFramebar.mcBuyLevelPannel.visible = false;
			showWaitSymbol();
			UserInfoModel.instance.RefreshData(this.initData);
			UserInfoModel.instance.addDataHandler("dataChange",null,_updData);
			//UserInfoModel.instance.addDataHandler(
			this.addChild(this._mcFramebar);    
			  
			
			//this._mcFramebar.bg.btnrecruit.buttonMode = true;  
			//this._mcFramebar.btnrecruit.addEventListener(MouseEvent.CLICK,onButtonClicked);
			addAllyBtn();
			this.relicStatsWindow =new MainRelicRolloverStats(null);
			addChild(relicStatsWindow);
			this.slotPrices = new Array(0, 2, 5, 10, 20, 50);
			this._mcFramebar.askForMore.visible=false;
			
			this._mcFramebar.askForMore.addEventListener(MouseEvent.ROLL_OUT,askForMoreHide);
			this._mcFramebar.tokenButton.addEventListener(MouseEvent.MOUSE_OVER,askForMoreShow);
			this.magicIcon = new Loader();
			this.preloader = this.addChild(new Preloader(this)) as Preloader;
			preloader.visible=false;
			this._mcFramebar.btnTrain.buttonMode=true;
			this._mcFramebar.btnTrain.addEventListener(MouseEvent.CLICK,btnTrainHandler);
			this.loaderArray = new Array();
			this.settings = SharedObject.getLocal("ninjawarz");
			this.sfxChannels = new Array(new SoundChannel(), new SoundChannel());
			this.soundManager = new SoundManager("sfx/");
			this.mute = this._mcFramebar.addChild(new MuteButton(this, "menu30", 723, 10, this.toggleMusic));
			this.sfxmute = this._mcFramebar.addChild(new MuteSfxButton(this, 723, 28, this.toggleSoundEffects));
		}//init
		
		private function btnTrainHandler(e:MouseEvent):void{
			DojoController.instance.renderDojoView();
		}
		
		public function childRemoveRefresh():void{
			showWaitSymbol();
			UserInfoModel.instance.RefreshData(this.initData);
		
		}
		//初始化数据，第一次加载游戏时调用
		private function initData(dr:UserInfoVo):void{
			trace("this.parent",this.parent,this);
			//如果获取数据成功
			if(dr!=null){
				this._mcFramebar.txtGold.text = CommonUtils.getFormattedNumber(dr.gold);
				this._mcFramebar.txtLevel.text = dr.level;
				this._mcFramebar.txtRmb.text = dr.karma.toString();
				this._mcFramebar.txtToken.text = dr.gift_currency;
				this.myName =UserInfoModel.instance.UserInfo.name;
				//根据健康状况计算出healthMask的位置
				setHealthBar(false);
				allyBtnRender();
				addSlots();
				checkForTrain();
				initDoubleExp();
				setLevelBar();
				this.magicTime=UserInfoModel.instance.UserInfo.seconds_of_magic;
				if (UserInfoModel.instance.UserInfo.magic.sid != 0)
				{
					//this.loadMagicIcon();
					this.setMagic(false);
				}
				var timer:Timer  = new Timer(1000);
				timer.addEventListener(TimerEvent.TIMER, this.doCountdowns);
				timer.start();
				this.checkForTrain();
				if (parseInt(UserInfoModel.instance.UserInfo.level) > 4)
				{
					if (UserInfoModel.instance.UserInfo.tournament_in > 0)
					{
						this.tournamentAvailable = 1;
						this.tournamentTimer = new Timer(1000, UserInfoModel.instance.UserInfo.tournament_in);
						this.tournamentTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.enableTournament);
						this.tournamentTimer.start();
					
					}
					else
					{
						this.tournamentAvailable = 2;
					}
				}
				else
				{
					this.tournamentAvailable = 0;
				}
				HomeController.instance.renderHomeView();
				//传参使用
				ninjaList=UserInfoModel.instance.UserInfo.ninjas;
				userInfo=UserInfoModel.instance.UserInfo;
				faction=parseInt(UserInfoModel.instance.UserInfo.faction);
				this.hideWaitSymbol();
				if (this.settings.data.music == undefined)
				{
					this.settings.data.music = 1;
					this.settings.data.sfx = 1;
					this.settings.data.bmTime = 0;
				}
				if (this.settings.data.bmTime == undefined)
				{
					this.settings.data.bmTime = 0;
				}
				this.soundManager.setPrefix(UrlConfig.PREFIX);
				if (!this.settings.data.sfx)
				{
					this.soundManager.muted = true;
				}
				if (this.settings.data.music == 1)
				{
					this.startBGMusic("menu30");
				}
				//this.addEventListener(Event.ENTER_FRAME, healthCountdown);
				/*var da:Object;
				HttpLoader.getInstance().httpJson("http://127.0.0.1/horde.json",function (data:Object):void{
					da=data;
				})*/
			}
			
		}
		
		//数据更新
		private function _updData(dr:UserInfoVo):void{
			//trace(dr==null);
			//如果获取数据成功
			if(dr!=null){
				this._mcFramebar.txtGold.text = CommonUtils.getFormattedNumber(dr.gold);
				this._mcFramebar.txtLevel.text = dr.level;
				this._mcFramebar.txtRmb.text = dr.karma.toString();
				this._mcFramebar.txtToken.text = dr.token.toString();
				if(dr.karma)
					//根据健康状况计算出healthMask的位置
					setHealthBar(false);
				checkForTrain();
				setLevelBar();
			}
		}
		private function addAllyBtn():void{
			for(var i:int=0;i<7;i++){
				var allyBtn:AllyHead=new AllyHead();
				allyBtn.y=490;
				allyBtn.x=40+90*i;
				//allyBtn.buttonMode=true;
				//allyBtn.addEventListener(MouseEvent.ROLL_OVER,showOptionhandler);
				allyBtn.visible=false;
				allyBtnArr.push(allyBtn);
				this._mcFramebar.mcFriendPannel.addChild(allyBtn);
			}
			this._mcFramebar.mcFriendPannel.shiftLeft.addEventListener(MouseEvent.CLICK,shiftLefthandler);
			this._mcFramebar.mcFriendPannel.oneLeft.addEventListener(MouseEvent.CLICK,oneLefthandler);
			this._mcFramebar.mcFriendPannel.shiftRight.addEventListener(MouseEvent.CLICK,shiftRighthandler);
			this._mcFramebar.mcFriendPannel.oneRight.addEventListener(MouseEvent.CLICK,oneRighthandler);
			
		}
		
		public function showOptionhandler(e:MouseEvent):void{
			this._mcFramebar.mcFriendPannel.addEventListener(MouseEvent.ROLL_OUT,hideOpetionHandler);
			var item:AllyHead=e.currentTarget as AllyHead;
			if(parseInt(item.data.cid)==0){
				
				item.addEventListener(MouseEvent.CLICK,addAllyhandler);
			}
			if (parseInt(item.data.cid) > 0)
			{//记录当前指向的ally
				
				currentAlly=item.data;
				item.removeEventListener(MouseEvent.CLICK,addAllyhandler);//确保不是cid==0时去除监听
				//trace(item.data.cid);
				_mcFramebar.mcFriendPannel.options.assist.removeEventListener(MouseEvent.CLICK,gotoOtherMap);
				if (parseInt(item.data.needs_assistance))
				{
					_mcFramebar.mcFriendPannel.options.assist.alpha = 1;
					_mcFramebar.mcFriendPannel.options.assist.buttonMode=true;
					_mcFramebar.mcFriendPannel.options.assist.addEventListener(MouseEvent.CLICK,gotoOtherMap);
					_mcFramebar.mcFriendPannel.options.viewProfile.buttonMode=true;
					_mcFramebar.mcFriendPannel.options.viewProfile.addEventListener(MouseEvent.CLICK,viewProfilehandler);
					//this.enableButton(options.assist, this.gotoOtherMap, false);
				}
				else
				{
					
					//this.disableButton(options.assist, this.gotoOtherMap, false);
					_mcFramebar.mcFriendPannel.options.assist.alpha = 0.5;
					_mcFramebar.mcFriendPannel.options.assist.buttonMode=false;
				}
				_mcFramebar.mcFriendPannel.options.x = Math.min(Math.max(item.x - 80, 30), 533);
				_mcFramebar.mcFriendPannel.options.visible = true;
			}
			else
			{
				_mcFramebar.mcFriendPannel.options.visible = false;
			}
		}
		
		private function addAllyhandler(e:MouseEvent):void{
			trace("添加同盟");
		}
		private function gotoOtherMap(e:MouseEvent):void{
			trace("goto other map "+ currentAlly.cid);
			for(var i:int=0;i<7;i++){
				allyBtnArr[i].disable();
			}
			//e.currentTarget.disable();
			this.loadFile("allymap");
		}
		public function loadFile(param1:String)
		{
		
			if (this._mcFramebar.mcDubExp != null)
			{
				this._mcFramebar.mcDubExp.visible = false;
			}
			this._mcFramebar.btnTrain.visible=false;
			if (this.alertWindow != null)
			{
				this.alertWindow.closeWindow();
			}
			/*if (this.tutorial != null)
			{
				this.tutorial.hideArrow();
			}*/
			this.preloader = this.addChild(new Preloader(this)) as Preloader;
			this.loaderArray.unshift(new Loader());
			this.loaderArray[0].load(new URLRequest(UrlConfig.PREFIX + param1 + "/" + param1 + ".swf" ));
			this.loaderArray[0].contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.plLoading);
			this.loaderArray[0].contentLoaderInfo.addEventListener(Event.COMPLETE, this.completer);
			this.loaderArray[0].y=60;
			this.addChildAt(this.loaderArray[0], 0);
			return;
		}
		private function hideOpetionHandler(e:MouseEvent):void{
			_mcFramebar.mcFriendPannel.options.assist.removeEventListener(MouseEvent.CLICK,gotoOtherMap);
			_mcFramebar.mcFriendPannel.options.visible = false;
		}
		
		private function viewProfilehandler(e:MouseEvent):void{
			trace("查看属性");
		}
		
		private function shiftLefthandler(e:MouseEvent):void{
			//startAlly=startAlly-7;
			startAlly=Math.max(0,startAlly-7);
			allyBtnRender();
		}
		private function oneLefthandler(e:MouseEvent):void{
			startAlly--;
			allyBtnRender();
		}
		private function shiftRighthandler(e:MouseEvent):void{
			startAlly=startAlly+7;
			if(startAlly>UserInfoModel.instance.UserInfo.allies.length-7)
			startAlly=UserInfoModel.instance.UserInfo.allies.length-7;
			//trace(UserInfoModel.instance.UserInfo.allies.length);
			allyBtnRender();
		}
		private function oneRighthandler(e:MouseEvent):void{
			startAlly++;
			allyBtnRender();
		}
		//根据activerelics调整健康状况
		public function adjustNinjaStats():void
		{
			var addHealthNum:Number = NaN;
			var j:int = 0;
			var i:int = 0;
			while (i < UserInfoModel.instance.UserInfo.ninjas.length)
			{
				
				addHealthNum = 0;
				j = 0;
				while (j < UserInfoModel.instance.UserInfo.activeRelics.length)
				{
					if(UserInfoModel.instance.UserInfo.activeRelics[j]!=null){
						if (UserInfoModel.instance.UserInfo.activeRelics[j].attributes.clan_health_pct != null)
						{
							addHealthNum = addHealthNum + parseInt(UserInfoModel.instance.UserInfo.activeRelics[j].attributes.clan_health_pct) / 100 * parseInt(UserInfoModel.instance.UserInfo.ninjas[i].max_health);
						}
						if (UserInfoModel.instance.UserInfo.activeRelics[j].attributes.clan_health != null)
						{
							addHealthNum = addHealthNum + parseInt(UserInfoModel.instance.UserInfo.activeRelics[j].attributes.clan_health);
						}
					}
					
					j++;
				}
				UserInfoModel.instance.UserInfo.ninjas[i].modified_max_health = "" + (parseInt(UserInfoModel.instance.UserInfo.ninjas[i].max_health) + Math.floor(addHealthNum));
				if (parseInt(UserInfoModel.instance.UserInfo.ninjas[i].health) > parseInt(UserInfoModel.instance.UserInfo.ninjas[i].modified_max_health))
				{
					//UserInfoModel.instance.UserInfo.ninjas[i].recoverHealth = parseInt(UserInfoModel.instance.UserInfo.ninjas.modified_max_health);
					UserInfoModel.instance.UserInfo.ninjas[i].health =UserInfoModel.instance.UserInfo.ninjas[i].modified_max_health;
				}
				i++;
			}
			this.setHealthBar();
			return;
		}// end function
		//好友头像呈现
		private function allyBtnRender():void{
			_mcFramebar.mcFriendPannel.options.visible = false;
			var allyList:Array=UserInfoModel.instance.UserInfo.allies;
			
			for(var i:int=0;i<7;i++){
				allyBtnArr[i].visible=true;
				allyBtnArr[i].setData(allyList[startAlly+i]);
			}
			_mcFramebar.mcFriendPannel.shiftLeft.buttonMode=true;
			_mcFramebar.mcFriendPannel.oneLeft.buttonMode=true;
			_mcFramebar.mcFriendPannel.shiftRight.buttonMode=true;
			_mcFramebar.mcFriendPannel.oneRight.buttonMode=true;
			_mcFramebar.mcFriendPannel.shiftLeft.visible=true;
			_mcFramebar.mcFriendPannel.oneLeft.visible=true;
			_mcFramebar.mcFriendPannel.shiftRight.visible=true;
			_mcFramebar.mcFriendPannel.oneRight.visible=true;
			if(allyList.length==7){
				_mcFramebar.mcFriendPannel.shiftLeft.visible=false;
				_mcFramebar.mcFriendPannel.oneLeft.visible=false;
				_mcFramebar.mcFriendPannel.shiftRight.visible=false;
				_mcFramebar.mcFriendPannel.oneRight.visible=false;
			}else{
				if(startAlly==0){
					_mcFramebar.mcFriendPannel.shiftLeft.visible=false;
					_mcFramebar.mcFriendPannel.oneLeft.visible=false;
				}else{
					if(!(startAlly+7<allyList.length)){
						_mcFramebar.mcFriendPannel.shiftRight.visible=false;
						_mcFramebar.mcFriendPannel.oneRight.visible=false;
					}
				}
				
				
			}
		}
		
		
		private function setLevelBar():void{
			var exp:int=UserInfoModel.instance.UserInfo.exp_to_level;
			var totalExp:int=UserInfoModel.instance.UserInfo.total_exp_to_level;
			this._mcFramebar.LevelBar.levelMask.x=57.3-566+(exp/totalExp)*566;
			this._mcFramebar.LevelBar.txtLevel.text=exp+"/"+totalExp.toString();
			this._mcFramebar.LevelBar.level1.text=UserInfoModel.instance.UserInfo.level;
			this._mcFramebar.LevelBar.level2.text=(parseInt(UserInfoModel.instance.UserInfo.level)+1).toString();
		}
		/**
		 *是否显示train按钮 
		 * 
		 */		
		public function checkForTrain():void
		{
			var user:UserInfoVo=UserInfoModel.instance.UserInfo;
			if (user.level == "1" || user.ninjas.length == 0)
			{
				this._mcFramebar.btnTrain.visible = false;
				return;
			}
			var minLevel:int = parseInt(user.ninjas[0].level);
			var i:int = 0;
			while (i < user.ninjas.length)
			{
				
				if (parseInt(user.ninjas[i].level) < minLevel)
				{
					minLevel = user.ninjas[i].level;
				}
				i++;
			}
			if (minLevel == 35)
			{
				this._mcFramebar.btnTrain.visible = false;
				return;
			}
			this._mcFramebar.btnTrain.visible = Math.ceil(minLevel / 5) <= user.karma;
			return;
		}
		/**
		 *设置健康条 
		 * @param param1 为true时 健康状态为满 默认为false
		 * 
		 */		
		public function setHealthBar(param1:Boolean = false):void
		{
			var max_health:int = 0;
			var health:int = 0;
			var i:int = 0;
			while (i < UserInfoModel.instance.UserInfo.ninjas.length)
			{
				
				if (param1)
				{
					UserInfoModel.instance.UserInfo.ninjas[i].health = UserInfoModel.instance.UserInfo.ninjas[i].modified_max_health;
				}
				health = health + parseInt(UserInfoModel.instance.UserInfo.ninjas[i].health);
				max_health = max_health + parseInt(UserInfoModel.instance.UserInfo.ninjas[i].modified_max_health);
				
				i++;
			}
			this._mcFramebar.healthMask.x = health / max_health*260-260;
			this._mcFramebar.health.text = health + "/" + max_health;
			return;
		}
		//每30帧更新一次健康条
		/*private function healthCountdown(e:Event):void
		{
			updateHealthTimer = updateHealthTimer - 1;
			if (this.updateHealthTimer <= 0)
			{
				this.updateHealthTimer = 30;
				this.ninjaHealthRecover();
			}
		}*/
		//忍者健康值恢复，同时更新健康条
		private function ninjaHealthRecover():void
		{
			var i:int = 0;
			var recoverHealth:int=parseInt(UserInfoModel.instance.UserInfo.ninjas[i].health);
			while (i < UserInfoModel.instance.UserInfo.ninjas.length)
			{
				
				if (parseInt(UserInfoModel.instance.UserInfo.ninjas[i].health) < parseInt(UserInfoModel.instance.UserInfo.ninjas[i].modified_max_health))
				{
					recoverHealth = recoverHealth + parseInt(UserInfoModel.instance.UserInfo.ninjas[i].max_health) * 0.0025;
					UserInfoModel.instance.UserInfo.ninjas[i].health = "" + int(recoverHealth);
					if (parseInt(UserInfoModel.instance.UserInfo.ninjas[i].health) >= parseInt(UserInfoModel.instance.UserInfo.ninjas[i].modified_max_health))
					{
						UserInfoModel.instance.UserInfo.ninjas[i].health = "" + parseInt(UserInfoModel.instance.UserInfo.ninjas[i].modified_max_health);
					}
				}
				i++;
			}
			this.setHealthBar();
			return;
		}
		
		/**
		 *打开slot装备界面 
		 * @param param1 relic信息
		 * @param param2 slot id
		 * 
		 */		
		public function openSlotWindow(relicItem:Object, slotId:int):void
		{
			if (this.slotWindow != null)
			{
				this.slotWindow.closeWindow();
			}
			this.slotWindow = new MainSlotWindow(this, relicItem, slotId, 0, 60);
			this.addChild(slotWindow);
			/*if (UserInfoModel.instance.userInfo.level == 1 && this.tutorial != null)
			{
				this.tutorial.setStep(12);
			}*/
			return;
		}
		/**
		 *显示slot中relic信息的提示窗 
		 * @param param1 relic 信息
		 * @param param2 x
		 * @param param3 y
		 * 
		 */		
		public function showRelicStats(param1:Object, param2:int, param3:int):void
		{
			//trace("showRelicStats");
			this.addChildAt(this.relicStatsWindow, 2);
			this.relicStatsWindow.display(param1, param2, param3);
			return;
		}
		/**
		 * 隐藏slot中relic信息的提示窗
		 * 
		 */		
		public function hideRelicStats():void
		{
			this.relicStatsWindow.undisplay();
			return;
		}
		/**
		 * 在slot上装备relic
		 * @param param1 装备的slot id
		 * @param param2 relic信息
		 * 
		 */		
		public function setSlotGraphic(slotId:int, relicItem:Object):void
		{
			//trace("setSlotGraphic(param1:int, param2:Object)");
			//trace("activeRelics.length="+UserInfoModel.instance.UserInfo.activeRelics.length);
			UserInfoModel.instance.UserInfo.activeRelics[slotId] = relicItem;
			this.slotButtons[slotId].setRelic(relicItem);
			return;
		}
		
		public function confirm(param1:String, param2:Function, param3:Function, param4:int = 375, param5:int = 300):void
		{
			if (this.confirmWindow != null)
			{
				this.confirmWindow.closeWindow();
			}
			this.confirmWindow=this.addChild(new ConfirmPopup(this, param1, param4, param5, param2, param3));
			//this.addChild(confirmWindow);
			return;
		}
		
		public function openPurchaseWindow(param1:Object, param2:int):void
		{
			//trace("openPurchaseWindow");
			if (this.yesNoWindow != null)
			{
				this.yesNoWindow.closeWindow();
			}
			this.yesNoWindow=new MainSlotPurchase(this, this, param1, this.slotPrices[param2], 375, 250)
			this.addChild(yesNoWindow);
			return;/**/
		}
		public function addSlot():void
		{
			//trace("addSlot()");
			var relicSlots:int=parseInt(UserInfoModel.instance.UserInfo.relic_slots);
			this.slotButtons[relicSlots].enable();
			relicSlots++;
			UserInfoModel.instance.UserInfo.relic_slots=relicSlots.toString();
			if (relicSlots < 6)
			{
				this.slotButtons[relicSlots].queueUp();
			}
			return;
		}
		//检查是否可以装备
		public function relicIsEquippable(param1:Object, param2:int) : Boolean
		{
			//trace("relicIsEquippable()");
			var i:int = 0;
			var j:int = 0;
			var arr:Array=UserInfoModel.instance.UserInfo.activeRelics;
			while (j <UserInfoModel.instance.UserInfo.activeRelics.length-1)
			{
				//trace("---------j"+j);
				//trace("UserInfoModel.instance.UserInfo.activeRelics.length===="+UserInfoModel.instance.UserInfo.activeRelics.length);
				//trace("UserInfoModel.instance.UserInfo.activeRelics[j].attributes.karma_bonus != undefined"+(UserInfoModel.instance.UserInfo.activeRelics[j].attributes.karma_bonus != undefined));
				
				if(UserInfoModel.instance.UserInfo.activeRelics[j]!=null&&UserInfoModel.instance.UserInfo.activeRelics[j].iid!="0"){
					if (UserInfoModel.instance.UserInfo.activeRelics[j].attributes.karma_bonus != undefined && parseFloat(UserInfoModel.instance.UserInfo.activeRelics[j].attributes.karma_bonus) > 0)
					{
						if (j == param2 && param1.attributes.karma_bonus != undefined)
						{
						}
						else
						{
							i++;
						}
					}
					if (UserInfoModel.instance.UserInfo.activeRelics[j].iid == param1.iid)
					{
						this.alert("You may only equip one of any relic.");
						return false;
					}
				}
				
				j++;
			}
			if (i > 1 && param1.attributes.karma_bonus != undefined && parseFloat(param1.attributes.karma_bonus) > 0)
			{
				this.alert("You may only equip up to 2 Karma Relics at a time.");
				return false;
			}
			return true;
		}
		public function secondsToString(param1:int, param2:Array = null, param3:Array = null, param4:Boolean = false, param5:String = "", param6:Boolean = false):String
		{
			var _loc_10:uint = 0;
			var _loc_7:Array = [];
			var _loc_8:* = param1 < 0 ? ("-") : ("");
			if (!param2)
			{
				param2 = [1, 60, 3600, 86400];
			}
			if (!param3)
			{
				param3 = ["s", "m", "h", "d"];
			}
			param1 = Math.abs(param1);
			var _loc_9:* = param2.length - 1;
			while (_loc_9--)
			{
				
				_loc_10 = Math.floor(param1 / param2[_loc_9]);
				_loc_7.push((_loc_10 < 10 ? ("0") : ("")) + _loc_10 + (_loc_9 > 0 ? (":") : ("")));
				param1 = param1 % param2[_loc_9];
			}
			return (param6 ? (_loc_8) : ("")) + _loc_7.join("");
		}// end function

		/**
		 *警告窗口 
		 * @param param1 消息
		 * @param param2 x 
		 * @param param3 y
		 * @param param4 回调
		 * @param param5 ok按钮动画效果 
		 * 
		 */		
		public function alert(param1:Object, param2:int = 375, param3:int = 300, param4:Function = null, param5:Boolean = true):void
		{
			if (this.alertWindow != null)
			{
				this.alertWindow.closeWindow();
			}
			if(param1 is String){
				this.alertWindow=this.addChild(new AlertPopup(this, param1 as String, param2, param3, param4, param5));
				
			}else{
				switch(param1.type)
				{
					case 1:
					{
						this.alertWindow = this.addChild(new WinPopup(this, param1, param2, param3, param4, param5));
						break;
					}
					case 2:
					{
						this.alertWindow = this.addChild(new LevelPopupMain(this, param1, param2, param3, param4, param4));
						break;
					}
					case 3:
					{
						this.alertWindow = this.addChild(new ItemPopup(this, param1, param2, param3, param4, param4));
						break;
					}
					case 4:
					{
						this.alertWindow = this.addChild(new AchPopup(this, param1, param2, param3, param4));
						break;
					}
					case 5:
					{
						this.alertWindow = this.addChild(new TweetPopupMC());
						break;
					}
					case 6:
					{
						this.alertWindow = this.addChild(new LosePopup(this, param2, param3, param4));
						break;
					}
					case 7:
					{
						this.alertWindow = this.addChild(new FriendWeaponPopup(this, param1.destined.friend, param1.destined.item, param2, param3, param4, param4));
						break;
					}
					
					default:
					{
						this.alertWindow = this.addChild(new AlertPopup(this, param1.message, param2, param3, param4));
						break;
					}
				}
			}
			
			
		}
		
		
		private function initDoubleExp():void{
			
			if (UserInfoModel.instance.UserInfo.seconds_of_bonus_exp > 0)
			{
				bonusTimer = new Timer(1000);
				this.bonusTimer.start();
				this.bonusTimer.addEventListener(TimerEvent.TIMER, this.bonusCountdown);
				this._mcFramebar.mcDubExp.visible=true;
				this._mcFramebar.mcDubExp.time.text = "" + int(UserInfoModel.instance.UserInfo.seconds_of_bonus_exp / 60) + ":" + (UserInfoModel.instance.UserInfo.seconds_of_bonus_exp % 60 < 10 ? ("0") : ("")) + UserInfoModel.instance.UserInfo.seconds_of_bonus_exp % 60;
			}
			else
				this._mcFramebar.mcDubExp.visible=false;
		}

		private function bonusCountdown(event:TimerEvent):void
		{
			
			var user:UserInfoVo=UserInfoModel.instance.UserInfo;
			user.seconds_of_bonus_exp--;
			this._mcFramebar.mcDubExp.time.text = "" + int(UserInfoModel.instance.UserInfo.seconds_of_bonus_exp / 60) + ":" + (UserInfoModel.instance.UserInfo.seconds_of_bonus_exp % 60 < 10 ? ("0") : ("")) + UserInfoModel.instance.UserInfo.seconds_of_bonus_exp % 60;
			if (!user.seconds_of_bonus_exp)
			{
				this._mcFramebar.mcDubExp.visible=false;
				this.bonusTimer.stop();
			}
			
		}
		
		private function askForMoreShow(e:MouseEvent):void{
			this._mcFramebar.askForMore.visible=true;
			this._mcFramebar.askForMore.btnAskFor.buttonMode=true;
			this._mcFramebar.askForMore.btnAskFor.addEventListener(MouseEvent.CLICK,askForMoreHandler);
			this._mcFramebar.askForMore.btnSkip.buttonMode=true;
			this._mcFramebar.askForMore.btnSkip.addEventListener(MouseEvent.CLICK,askForMoreHide);
		}
		private function askForMoreHandler(e:MouseEvent):void{
			askForMoreHide(e);
			this.callMethod("askformore");
		}
		private function askForMoreHide(e:MouseEvent):void{
			this._mcFramebar.askForMore.visible=false;
		}
		
		private function doCountdowns(... args):void
		{
			this.daimyoCountdown();
			this.cloudCountdown();
			if (parseInt(UserInfoModel.instance.UserInfo.level) >= 18)
			{
				this.zombieCountdown();
			}/**/
			ninjaHealthRecover();
			if (UserInfoModel.instance.UserInfo.magic.sid != 0)
			{
				this.magicCountdown();
			}
			return;
		}
		private function daimyoCountdown(... args)
		{
			if (UserInfoModel.instance.UserInfo.daimyo_gift > 0)
			{
				UserInfoModel.instance.UserInfo.daimyo_gift--;
			}
			return;
		}
		private function cloudCountdown(... args)
		{
			if (UserInfoModel.instance.UserInfo.cloud > 0)
			{
				UserInfoModel.instance.UserInfo.cloud--;
			}
			return;
		}
		private function zombieCountdown(... args)
		{
			if (UserInfoModel.instance.UserInfo.horde_in > 0)
			{
				UserInfoModel.instance.UserInfo.horde_in--;
			}
			return;
		}
		/**
		 * 
		 * @param flag true time=magic.duration false time= seconds_of_magic
		 * 
		 */		
		public function setMagic(flag:Boolean=true) : void
		{
			
			this.loadMagicIcon();
			if(flag==true)
				this.magicTime = UserInfoModel.instance.UserInfo.magic.duration;
			else
				this.magicTime=UserInfoModel.instance.UserInfo.seconds_of_magic;
			this.magicCountdown();
			return;
		}
		private function magicCountdown(... args) : void
		{
			if (magicTime > 0)
			{
				
				
				this.magicTime =magicTime-1;
				this._mcFramebar.magicTimer.text = this.secondsToString(this.magicTime);
				//trace(this.secondsToString(magicTime));
				if (!this.magicTime)
				{
					this.magicIcon.unload();
					UserInfoModel.instance.UserInfo.magic = {sid:0};
					this._mcFramebar.magicTimer.text = "No Magic";
				}
			}
			return;
		}
		private function loadMagicIcon():void
		{
			while(_mcFramebar.magicHolder.numChildren){
				_mcFramebar.magicHolder.removeChildAt(0);
			}
			//this.magicIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, this.magicIconLoaded);
			//this.magicIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			this.magicIcon.load(new URLRequest("http://ninjawarzdev.brokenbulbstudios.com/swf/magicthumbs/" + UserInfoModel.instance.UserInfo.magic.sprite + ".png"));
			this._mcFramebar.magicHolder.addChild(this.magicIcon);
			return;
		}
		public function hideTrain()
		{
			this._mcFramebar.btnTrain.visible = false;
			return;
		}
		
		public function setAchievements(param1:Array)
		{
			 var bestAchievement:Object;
			bestAchievement = param1[0];
			var _loc_2:int = 0;
			while (_loc_2 < param1.length)
			{
				
				if (param1[_loc_2].karma > bestAchievement.karma)
				{
					bestAchievement = param1[_loc_2];
				}
				UserInfoModel.instance.UserInfo.achievements.push({aid:param1[_loc_2].aid, achievementName:param1[_loc_2].name, aText:param1[_loc_2].text, karma:param1[_loc_2].karma});
				_loc_2++;
			}
			return;
		}
		
		public function nextAch()
		{
			if (UserInfoModel.instance.UserInfo.achievements.length > 0)
			{
				this.displayAch(UserInfoModel.instance.UserInfo.achievements.shift(), 375, 355, this.nextAch);
			}
			return;
		}
		
		public function displayAch(param1, param2:int = 375, param3:int = 355, param4:Function = null)
		{
			if (this.alertWindow != null)
			{
				this.alertWindow.closeWindow();
			}
			this.alertWindow = this.addChild(new AchPopup(this, param1, param2, param3, param4))as AlertPopup;
			return;
		}
		public function addPreloader(param1:String = "") : Preloader
		{
			if (this.preloader != null)
			{
				this.preloader.closeWindow();
				this.preloader = null;
			}
			this.preloader = this.addChild(new Preloader(this, false, param1))as Preloader;
			return this.preloader;
		}// end function
		
		public function removePreloader() : void
		{
			if (this.preloader != null)
			{
				this.preloader.closeWindow();
				this.preloader = null;
			}
			return;
		}// end function
		
		public function showWaitSymbol():void
		{
			if (this.waitSymbol)
			{
				this.waitSymbol.destroy();
				this.waitSymbol = null;
			}
			this.waitSymbol = this.addChild(new Wait(this, 0, 529))as Wait;
			return;
		}
		public function hideWaitSymbol():void
		{
			if (this.waitSymbol)
			{
				this.waitSymbol.destroy();
				this.waitSymbol = null;
			}
			return;
		}
		
		public function hideAllies()
		{
			if (this._mcFramebar.mcDubExp.visible==true)
			{
				this._mcFramebar.mcDubExp.visible = false;
			}
			if (this._mcFramebar.mcFriendPannel.visible==true)
			{
				this._mcFramebar.mcFriendPannel.visible= false;
			}
			return;
		}// end function
		
		public function showAllies()
		{
			this._mcFramebar.mcFriendPannel.visible= true;
			this._mcFramebar.mcFriendPannel.alpha=1;
		}
		
		public function gotoFight(param1:String, param2:String)
		{
			
			this.opponent = param1;
			//this.fighting = true;
			//var fightMain:FightMain=new FightMain();
			//this.addChild(fightMain);
			this.loadFight(param2);
			if (this.alertWindow != null)
			{
				this.alertWindow.closeWindow();
			}
			return;
		}
		
		
		public function loadMinigame(param1:String)
		{
			if (this._mcFramebar.mcDubExp != null)
			{
				this._mcFramebar.mcDubExp.visible = false;
			}
			this._mcFramebar.btnTrain.visible = false;
			if (this.alertWindow != null)
			{
				this.alertWindow.closeWindow();
			}
			/*if (this.tutorial != null)
			{
				this.tutorial.hideArrow();
			}*/
			this._mcFramebar.mcFriendPannel.alpha=0.5;
			//this._mcFramebar.mcFriendPannel.enabled=false;
			this.preloader = this.addChild(new Preloader(this))as Preloader;
			this.loaderArray.unshift(new Loader());
			this.loaderArray[0].load(new URLRequest(UrlConfig.PREFIX + "minigames/" + param1 + ".swf" ));
			trace(param1);
			this.loaderArray[0].contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.plLoading);
			this.loaderArray[0].contentLoaderInfo.addEventListener(Event.COMPLETE, this.completer);
			this.addChildAt(this.loaderArray[0], 1);
			this.loaderArray[0].y = 60;
			return;
		}// end function

		public function loadFight(param1:String)
		{
			trace("loadFight",param1);
			//var zombieFightMain:ZombieFightMain=new ZombieFightMain();
			//this.addChild(zombieFightMain);
			//this.statTest.train.visible = false;
			//this.statTest.visible = false;
			if (this.alertWindow != null)
			{
				this.alertWindow.closeWindow();
			}/**/
			/*if (this.tutorial != null)
			{
				this.tutorial.hideArrow();
			}*/
			this.preloader = this.addChild(new Preloader(this)) as Preloader;
			
			this.loaderArray.unshift(new Loader());
			this.loaderArray[0].load(new URLRequest(UrlConfig.HTTPROOT + "fight/" + param1 + ".swf" ));/**/
			//this.loaderArray[0].load(new URLRequest(UrlConfig.HTTPROOT + "fight/" + param1 + ".swf" + (this.revision.length > 0 ? ("?" + this.revision) : (""))));
			
			this.loaderArray[0].contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.plLoading);
			this.loaderArray[0].contentLoaderInfo.addEventListener(Event.COMPLETE, this.completer);
			this.addChildAt(this.loaderArray[0], 1);/**/
			//this.contentY = 0;
			/*this.removeSlots();
			if (this.doubleExperienceTimer != null)
			{
				this.doubleExperienceTimer.visible = false;
			}
			this.fighting = true;*/
			return;
		}
		private function completer(event:Event) : void
		{
			/*if (!this.fighting && this.alliesWindow == null)
			{
				this.alliesWindow = this.addChildAt(new AlliesWindow(this, this), 1);
			}*/
			if (this.preloader != null)
			{
				this.preloader.closeWindow();
				this.preloader = null;
			}
			if (this.loaderArray.length > 1)
			{
				this.loaderArray.pop().unload();
			}
			this.loaderArray[0].contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.plLoading);
			this.loaderArray[0].contentLoaderInfo.removeEventListener(Event.COMPLETE, this.completer);
			if(this.loaderArray[0].y!=60)
				this.loaderArray[0].y = 0;
			return;
		}
		
		public function gotoInvite(... args)
		{
			trace("gotoInvite");
			/*if (this.facebookApp)
			{
				if (ExternalInterface.available)
				{
					ExternalInterface.call("nav", this.fbRedirectPrefix + "/invite");
				}
			}
			else
			{
				navigateToURL(new URLRequest("/invite"), "_top");
			}
			return;*/
		}
		
		private function plLoading(event:ProgressEvent) : void
		{
			var _loc_2:* = event.bytesLoaded / event.bytesTotal * 100;
			if (this.preloader != null)
			{
				this.preloader.setPercent(_loc_2);
			}
			return;
		}/**/
		
		
		
		public function giftPopup(param1:Function, param2:Function, param3:int = 375, param4:int = 300)
		{
			if (this.confirmWindow != null)
			{
				this.confirmWindow.closeWindow();
			}
			this.confirmWindow = this.addChild(new GiftPopup(this, this.pendingGifts, param3, param4, param1, param2));
			return;
		}// end function
		
		public function openCreditsWindow(param1:Object, param2:Function, param3:Function = null, param4:int = 375, param5:int = 300)
		{
			if (this.confirmWindow != null)
			{
				this.confirmWindow.closeWindow();
			}
			this.confirmWindow = this.addChild(new CreditsPopup(this, param1, param4, param5, param2, param3));
			return;
		}
		
		public function loadTournamentFile(param1:String)
		{
			if (this.alertWindow != null)
			{
				this.alertWindow.closeWindow();
			}
			/*if (this.tutorial != null)
			{
				this.tutorial.hideArrow();
			}*/
			this.preloader = this.addChild(new Preloader(this)) as Preloader;
			this.loaderArray.unshift(new Loader()); 
			var loaderContext:LoaderContext=new LoaderContext();
			loaderContext.applicationDomain=ApplicationDomain.currentDomain;
			this.loaderArray[0].load(new URLRequest(UrlConfig.PREFIX + "tournament/" + param1 + ".swf" ),loaderContext);
			//this.loaderArray[0].load(new URLRequest(param1 + ".swf" ),loaderContext);
			//this.loaderArray[0].load(new URLRequest( param1 + ".swf" ));
			this.loaderArray[0].contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.plLoading);
			this.loaderArray[0].contentLoaderInfo.addEventListener(Event.COMPLETE, this.completer);
			
			
			/*FramebarController.instance.renderFrameBarView();*/
			if (param1 == "tournament")
			{
				this.addChild(this.loaderArray[0]);
				
				this.loaderArray[0].y=0;
				//this.statTest.train.visible = false;
				//this.statTest.visible = false;
				//this.contentY = 0;
				//this.removeSlots();
			}else
			{
				this._mcFramebar.btnTrain.visible=false;
				this.addChildAt(this.loaderArray[0], 0);
				this.loaderArray[0].y=60;
			}
			return;
		}
		
		public function getToolTip() : Array
		{
			if (parseInt(UserInfoModel.instance.UserInfo.level) == 1 || parseInt(UserInfoModel.instance.UserInfo.level) > 10)
			{
				return ["", ""];
			}
			var _loc_1:int = parseInt(UserInfoModel.instance.UserInfo.ninjas[0].level);
			var _loc_2:int = 0;
			var _loc_3:Object = UserInfoModel.instance.UserInfo.ninjas[0].weapon;
			var _loc_4:Object = UserInfoModel.instance.UserInfo.ninjas[0].weapon;
			var _loc_5:int = 0;
			while (_loc_5 < UserInfoModel.instance.UserInfo.ninjas.length)
			{
				
				if (parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_5].level) < _loc_1)
				{
					_loc_1 = UserInfoModel.instance.UserInfo.ninjas[_loc_5].level;
				}
				if (parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_5].level) < 35 && parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_5].level) > _loc_2)
				{
					_loc_2 = UserInfoModel.instance.UserInfo.ninjas[_loc_5].level;
				}
				if (parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_5].weapon.iid) > 0 && parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_5].weapon.value) > parseInt(_loc_3.value))
				{
					_loc_3 = UserInfoModel.instance.UserInfo.ninjas[_loc_5].weapon;
				}
				if (parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_5].weapon.iid) == 0 || parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_5].weapon.value) < parseInt(_loc_4.value))
				{
					_loc_4 = UserInfoModel.instance.UserInfo.ninjas[_loc_5].weapon;
				}
				_loc_5++;
			}
			if (_loc_2 > 0 && parseInt(UserInfoModel.instance.UserInfo.level) < 10 && Math.ceil(_loc_2 / 5) * 2 <= UserInfoModel.instance.UserInfo.karma)
			{
				return ["You\'ve got Karma! Train your Ninja!", "Click the Dojo - Click your Ninja - Click Train"];
			}
			var _loc_6:int = 0;
			_loc_5 = 0;
			while (_loc_5 < UserInfoModel.instance.UserInfo.activeRelics.length)
			{
				
				if (parseInt(UserInfoModel.instance.UserInfo.activeRelics[_loc_5].iid) == 0)
				{
					_loc_6 = 1;
					break;
				}
				_loc_5++;
			}
			if (UserInfoModel.instance.UserInfo.relicInventory.length > 0 && _loc_6 > 0 && this.haveEquippableRelic())
			{
				return ["You have an empty relic slot!", "Click the Empty Slot - Click Equip"];
			}
			if (UserInfoModel.instance.UserInfo.gold >= 1350 && (parseInt(_loc_3.iid) == 0 || parseInt(_loc_3.value) < 500))
			{
				return ["You have enough gold for a better weapon!", "Click the Weapon Shop - Click a Weapon"];
			}
			_loc_5 = 0;
			while (_loc_5 < UserInfoModel.instance.UserInfo.weaponInventory.length)
			{
				
				if (parseInt(_loc_3.value) < parseInt(UserInfoModel.instance.UserInfo.weaponInventory[_loc_5].value) &&parseInt(UserInfoModel.instance.UserInfo.level) >= parseInt(UserInfoModel.instance.UserInfo.weaponInventory[_loc_5].attributes.min_level))
				{
					return ["You have a better weapon to equip!", "Click the Dojo - Click your Ninja - Click Equip"];
				}
				_loc_5++;
			}
			return ["", ""];
		}
		
		private function haveEquippableRelic() : Boolean
		{
			var _loc_1:int = 0;
			while (_loc_1 < UserInfoModel.instance.UserInfo.relicInventory.length)
			{
				
				if (UserInfoModel.instance.UserInfo.relicInventory[_loc_1].attributes.min_level != null && parseInt(UserInfoModel.instance.UserInfo.level) < parseInt(UserInfoModel.instance.UserInfo.relicInventory[_loc_1].attributes.min_level))
				{
					return false;
				}
				_loc_1++;
			}
			return true;
		}
		private function enableTournament(event:TimerEvent) : void
		{
			this.tournamentTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.enableTournament);
			this.tournamentAvailable = 2;
			
			return;
		}
		public function getHospitalCost() : int
		{
			var _loc_1:int = 0;
			var _loc_2:int = 0;
			var _loc_3:int = 0;
			while (_loc_3 < UserInfoModel.instance.UserInfo.ninjas.length)
			{
				
				_loc_2 = _loc_2 + parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_3].health);
				_loc_1 = _loc_1 + parseInt(UserInfoModel.instance.UserInfo.ninjas[_loc_3].modified_max_health);
				_loc_3++;
			}
			return this._gold_per_fight(parseInt(UserInfoModel.instance.UserInfo.level)) * 3.2 * (1 * (_loc_1 - _loc_2) / _loc_1);
		}
		public function _gold_per_fight(param1)
		{
			return Math.floor(22000 / (1 + 88 * Math.exp(-1 * 0.2098 * param1)));
		}
		public function gotoAchievements()
		{
			trace("gotoAchievements");
			/*if (this.facebookApp)
			{
				navigateToURL(new URLRequest("http://apps.facebook.com/ninja-warz/p/" + this.loadedInfo.cid), "_top");
			}
			else
			{
				navigateToURL(new URLRequest("http://ninjawarz.com/p/" + this.loadedInfo.cid));
			}
			return;*/
		}
		
		public function buttonSound(param1:int = 2) : void
		{
			this.soundManager.loadSoundEffect("button_" + param1);
			return;
		}
		public function startBGMusic(param1:String)
		{
			var song:* = param1;
			this.currentSong = song;
			if (!this.settings.data.music)
			{
				return;
			}
			if (this.bgMusic != null)
			{
				this.stopBGMusic();
				try
				{
					this.bgMusic.close();
					this.bgMusic = null;
				}
				catch (error:IOError)
				{
					trace(error);
				}
			}
			this.bgMusic = new Sound(new URLRequest(this.prefix + "music/" + song + ".mp3"));
			trace(this.prefix + "music/" + song + ".mp3");
			this.musicChannel = null;
			this.musicChannel = this.bgMusic.play(0, 9999, new SoundTransform(0.5));
			this.musicVolume = 0.5;
			return;
		}// end function
		
		public function stopBGMusic()
		{
			if (this.musicChannel != null)
			{
				this.musicChannel.stop();
			}
			return;
		}// end function
		
		public function fadeOutMusic()
		{
			if (this.settings.data.music && this.musicVolume > 0)
			{
				this.musicVolume = this.musicVolume - 0.01;
				this.musicChannel.soundTransform = new SoundTransform(this.musicVolume);
			}
			return;
		}// end function
		
		public function toggleMusic()
		{
			if (this.settings.data.music)
			{
				this.settings.data.music = 0;
				this.stopBGMusic();
			}
			else
			{
				this.settings.data.music = 1;
				this.startBGMusic(this.currentSong);
			}
			return;
		}// end function
		
		public function toggleSoundEffects()
		{
			if (this.settings.data.sfx)
			{
				this.settings.data.sfx = 0;
				this.soundManager.muted = true;
			}
			else
			{
				this.settings.data.sfx = 1;
				this.soundManager.muted = false;
			}
			return;
		}// end function
		
		private function loopSong(event:Event)
		{
			this.musicChannel.removeEventListener(Event.SOUND_COMPLETE, this.loopSong);
			this.musicChannel = this.bgMusic.play(0, 0, new SoundTransform(0.8));
			this.musicChannel.addEventListener(Event.SOUND_COMPLETE, this.loopSong);
			return;
		}// end function
		
		public function playSfx(param1)
		{
			this.sfxChannels[this.currentSfxChannel] = param1.play(0, 0, this.sfxChannels[this.currentSfxChannel].soundTransform);
			this.currentSfxChannel = this.currentSfxChannel == 0 ? (1) : (0);
			return;
		}// end function
		
		public function startSfx()
		{
			this.settings.data.sfx = 1;
			var _loc_1:int = 0;
			while (_loc_1 < this.sfxChannels.length)
			{
				
				this.sfxChannels[_loc_1].soundTransform = new SoundTransform(1);
				_loc_1++;
			}
			return;
		}// end function
		
		public function stopSfx()
		{
			this.settings.data.sfx = 0;
			var _loc_1:int = 0;
			while (_loc_1 < this.sfxChannels.length)
			{
				
				this.sfxChannels[_loc_1].soundTransform = new SoundTransform(0);
				this.sfxChannels[_loc_1].stop();
				_loc_1++;
			}
			return;
		}
		//购买升级
		public function levelUp(param1:Object) : void
		{
			/*UserInfoModel.instance.UserInfo.level=(parseInt(UserInfoModel.instance.UserInfo.level)+1).toString();
			var _loc_4:* = this.level + 1;
			this.level = _loc_4;
			this.statTest.level.text = this.level;
			this.statTest.currentLevel.text = this.level;
			this.statTest.nextLevel.text = this.level + 1;
			this.loadedInfo.exp_to_level = param1.exp_to_level;
			this.experience = 0;
			var _loc_2:* = parseInt(param1.exp_to_level);
			this.statTest.experience.text = "0/" + _loc_2;
			this.showFbCredits();
			this.statTest.levelMask.scaleX = 0;
			confirmPopup = this.addChild(new LevelPopupMain(this, {level:this.level, unlocked:param1.unlocked}, stage.stageWidth / 2, stage.stageHeight / 2, null, null));*/
			/*if (this.level >= 3)
			{
				this.bonusTimer.start();
				this.bonusTimer.addEventListener(TimerEvent.TIMER, this.bonusCountdown);
				this.addEventListener(Event.ENTER_FRAME, this.bonusMode);
				this.secondsInBonus = Math.min((this.level - 2) * 60, 600);
				this.doubleExperienceTimer = this.addChild(new DoubleExperienceTimer());
				this.doubleExperienceTimer.timer.text = "" + int(this.secondsInBonus / 60) + ":" + (this.secondsInBonus % 60 < 10 ? ("0") : ("")) + this.secondsInBonus % 60;
				this.doubleExperienceTimer.y = 80;
				this.doubleExperienceTimer.x = 280;
			}
			return;*/
		}
		
		/**
		 * 根据用户信息添加slot
		 * 
		 */
		public function addSlots():void
		{
			trace("addSlots()");
			var relicItem:Object;
			var slotItem:MainRelicSlot;
			var i:int = 0;
			var slotPrices:Array = new Array(0, 2, 5, 10, 20, 50);
			while (i < this.maxSlots)
			{
				if (i < UserInfoModel.instance.UserInfo.activeRelics.length)
				{
					relicItem = UserInfoModel.instance.UserInfo.activeRelics[i];
				}
				else if (i < 5 && i == UserInfoModel.instance.UserInfo.activeRelics.length){
					relicItem = { name:"New Slot", description:"Would you like to purchase this relic slot for " + slotPrices[i] + " Karma?", slot:i, iid:-1, attributes:{ } };
				}
				else{
					relicItem = {name:"New Slot", description:"Would you like to purchase this relic slot for " + slotPrices[i] + " Karma?", slot:i, iid:-1, attributes:{ } };
				}
				slotItem=new MainRelicSlot(this, i, relicItem, 500 + i * 36, 9);
				trace("i="+i);
				this.slotButtons.push(slotItem);
				this._mcFramebar.addChild(slotItem);
				
				i++;
			}
		}
	}//Home
}//package