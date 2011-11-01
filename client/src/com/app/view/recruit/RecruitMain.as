package com.app.view.recruit 
{
	import com.app.config.UrlConfig;
	import com.app.controller.FramebarController;
	import com.app.controller.RecruitController;
	import com.app.model.UserInfoModel;
	import com.app.view.recruit.NinjaRolloverStats;
	import com.framework.utils.loader.HttpLoader;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import res.recruit.IdleBlackGirl;
	import res.recruit.IdleBlackGuy;
	import res.recruit.IdleRedGirl;
	import res.recruit.IdleRedGuy;
	import res.recruit.IdleWhiteGirl;
	import res.recruit.IdleWhiteGuy;
	import res.recruit.RecruitMainMc;
	public class RecruitMain extends RecruitMainMc
	{
		
		private var ninjaList:Array;
		private var ninjaButtons:Array;
		private var loadedInfo:Object;
		private var statsWindow:NinjaRolloverStats;
		public var ninjaSprites:Array;
		private var main:Object;
		private var particleList:Array;
		private var poofX:int = 375;
		private var poofY:int = 250;
		private var poofTimer:int = 0;
		
		public function RecruitMain()
		{
			ninjaList = new Array(0);
			ninjaButtons = new Array(0);
			ninjaSprites = new Array([new IdleBlackGirl(1, 1), new IdleBlackGuy(1, 1)], [new IdleWhiteGirl(1, 1), new IdleWhiteGuy(1, 1)], [new IdleRedGirl(1, 1), new IdleRedGuy(1, 1)]);
			particleList = new Array();
			enableButton(mapButton, gotoMap);
			this.addEventListener(Event.ENTER_FRAME, startLoad);
			return;
		}// end function
		
		private function startLoad(... args)
		{
			this.removeEventListener(Event.ENTER_FRAME, startLoad);
			main = FramebarController.instance.framebarview;
			main.checkForTrain();
			/*if (main.tutorial != null && main.level == 1)
			{
				main.tutorial.setCurrentScreen(this);
				main.tutorial.setStep(2);
			}*/
			
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.RECRUITABLENINJAS,loadInfoHandler);
			/*args = new URLRequest(UrlConfig.HTTPROOT+UrlConfig.RECRUITABLENINJAS);
			args.method = URLRequestMethod.POST;
			var _loc_3:* = new URLLoader();
			_loc_3.addEventListener(Event.COMPLETE, loadInfoHandler);
			_loc_3.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loc_3.load(args);*/
			main.showWaitSymbol();
			return;
		}// end function
		
		private function init(... args)
		{
			var _loc_5:Object;
			main.hideWaitSymbol();
			this.removeEventListener(Event.ENTER_FRAME, init);
			var i:int = 0;
			var _loc_3:int = 0;
			while (_loc_3 < 10)
			{
				
				i = tutorialPick(i, _loc_3);
				_loc_3++;
			}
			var _loc_4:int = 0;
			while (_loc_4 < ninjaList.length)
			{
				
				_loc_5 = this.addChild(new RecruitNinja(main, this, ninjaList[_loc_4], 150 + _loc_4 % 5 * 105, 150 + Math.floor(_loc_4 / 5) * 90, _loc_4 == i));
				ninjaButtons.push(_loc_5);
				_loc_5.scaleX = Math.round(Math.random()) ? (-1) : (1);
				_loc_4++;
			}
			statsWindow = this.addChild(new NinjaRolloverStats(null)) as NinjaRolloverStats;
			this.addEventListener(Event.ENTER_FRAME, update);
			/*if (main.level == 1 && main.tutorial != null)
			{
				mapButton.visible = false;
			}*/
			return;
		}// end function
		
		private function tutorialPick(param1:int, param2:int) : int
		{
			var _loc_3:* = ninjaList[param1];
			var _loc_4:* = ninjaList[param2];
			switch(UserInfoModel.instance.UserInfo.faction)
			{
				case 0:
				{
					if (Math.abs(parseInt(_loc_3.power) - parseInt(_loc_3.health)) <= Math.abs(parseInt(_loc_4.power) - parseInt(_loc_4.health)))
					{
						return param1;
					}
					return param2;
				}
				case 1:
				{
					if (parseInt(_loc_3.health) >= parseInt(_loc_4.health))
					{
						return param1;
					}
					return param2;
				}
				case 2:
				{
					if (parseInt(_loc_3.power) >= parseInt(_loc_4.power))
					{
						return param1;
					}
					return param2;
				}
				default:
				{
					
					break;
				}
			}
		return 0;
		}// end function
		
		public function setPoof(param1:int, param2:int)
		{
			poofX = param1;
			poofY = param2;
			poofTimer = 15;
			return;
		}// end function
		
		private function update(... args)
		{
			var i:int = 0;
			var _loc_3:* = undefined;
			i = 0;
			while (i < ninjaButtons.length)
			{
				
				ninjaButtons[i].update();
				i++;
			}
			if (poofTimer > 0)
			{
				var _loc_5:* = poofTimer - 1;
				poofTimer = _loc_5;
				particleList.push(this.addChild(new PoofParticle(poofX, poofY)));
				particleList.push(this.addChild(new PoofParticle(poofX, poofY)));
			}
			i = 0;
			while (i < particleList.length)
			{
				
				particleList[i].update();
				if (particleList[i].dead)
				{
					_loc_3 = particleList[i];
					_loc_3.destroy();
					particleList[i] = particleList[(particleList.length - 1)];
					particleList[(particleList.length - 1)] = _loc_3;
					delete this[particleList.pop()];
					i = i - 1;
				}
				i++;
			}
			return;
		}// end function
		
		public function openNinjaWindow(param1, param2)
		{
			this.addChild(new RecruitNinjaWindow(main, this, param1, param2));
			return;
		}// end function
		
		public function showStats(param1, param2:int, param3:int)
		{
			statsWindow.display(param1, param2, param3);
			return;
		}// end function
		
		public function hideStats()
		{
			statsWindow.undisplay();
			return;
		}// end function
		
		public function gotoMap(... args)
		{
			main.buttonSound();
			RecruitController.instance.renderHome();
			return;
		}// end function
		
		public function loadInfoHandler(data:Object) : void
		{
			
			if (data!=null)
			{
				ninjaList = data as Array;
			}
			init();
			
		}// end function
		
		public function adjustPrices()
		{
			var _loc_1:int = 0;
			while (_loc_1 < ninjaButtons.length)
			{
				
				ninjaButtons[_loc_1].setPrice();
				_loc_1++;
			}
			return;
		}// end function
		
		public function ioErrorHandler(param1)
		{
			return;
		}// end function
		
		private function disableButton(param1, param2:Function)
		{
			param1.hitZone.buttonMode = false;
			param1.hitZone.removeEventListener(MouseEvent.CLICK, param2);
			param1.hitZone.removeEventListener(MouseEvent.ROLL_OVER, startFloat);
			param1.hitZone.removeEventListener(MouseEvent.ROLL_OUT, stopFloat);
			param1.buttonAnim.removeEventListener(MouseEvent.CLICK, floatUp);
			param1.buttonAnim.removeEventListener(MouseEvent.CLICK, floatDown);
			return;
		}// end function
		
		private function enableButton(param1, param2:Function)
		{
			param1.hitZone.buttonMode = true;
			param1.hitZone.addEventListener(MouseEvent.CLICK, param2);
			param1.hitZone.addEventListener(MouseEvent.ROLL_OVER, startFloat);
			param1.hitZone.addEventListener(MouseEvent.ROLL_OUT, stopFloat);
			param1.buttonAnim.addEventListener(MouseEvent.CLICK, floatUp);
			param1.buttonAnim.addEventListener(MouseEvent.CLICK, floatDown);
			return;
		}// end function
		
		private function startFloat(event:MouseEvent)
		{
			event.currentTarget.parent.buttonAnim.removeEventListener(Event.ENTER_FRAME, floatDown);
			event.currentTarget.parent.buttonAnim.addEventListener(Event.ENTER_FRAME, floatUp);
			return;
		}// end function
		
		private function stopFloat(event:MouseEvent)
		{
			event.currentTarget.parent.buttonAnim.addEventListener(Event.ENTER_FRAME, floatDown);
			event.currentTarget.parent.buttonAnim.removeEventListener(Event.ENTER_FRAME, floatUp);
			return;
		}// end function
		
		private function floatUp(event:Event)
		{
			if (event.currentTarget.y < -6)
			{
				event.currentTarget.removeEventListener(Event.ENTER_FRAME, floatUp);
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
				event.currentTarget.removeEventListener(Event.ENTER_FRAME, floatDown);
			}
			else
			{
				event.currentTarget.y = event.currentTarget.y + 2;
			}
			return;
		}// end function
		
		//Security.allowDomain("*");
	}
}
