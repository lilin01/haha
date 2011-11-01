package com.app.view.map
{
	import com.app.config.UrlConfig;
	import com.app.controller.DojoController;
	import com.app.controller.FramebarController;
	import com.app.controller.MagicController;
	import com.app.controller.RecruitController;
	import com.app.controller.RelicController;
	import com.app.controller.StagingController;
	import com.app.controller.WeaponController;
	import com.app.model.UserInfoModel;
	import com.app.view.tournyChoose.TournyChooseMain;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	
	import res.map.*;

    public class MapMain extends MapMainMC
    {
      
        //public var wordEffectLayer:MovieClip;
       // public var lowClouds:MovieClip;
 		private var tournamentAvailable:int;
        //public var highClouds:MovieClip;
     	private var genbuLoader:Loader;
        private var l:Object;
        private var prefix:String = "";
        public var main:Object;
        private var radCon:Number = 0.0174533;
        private var islandYStep:Number = 0;
        private var islandXStep:Number = 0;
        private var blimpYStep:Number = 0;
        private var blimpX:Number = 0;
        private var blimpY:Number = 0;
        private var hordeY:Number = 0;
        private var magicX:Number = 0;
        private var magicY:Number = 0;
        public var cloudSheet:CloudSheet;
        public var smallBirdSheet:SmallBirdSprites;
        public var poopSheet:PoopSprites;
        public var particleList:Array;
        public var cloudTimer:int = 30;
        private var statsWindow:Object;
        public var yesNoWindow:Object = null;
        private var canActivateBlimp:Boolean = true;
        private var attacking:Boolean = false;
      //  private var keyPresses:Array;
       // private var kCode:Array;
        private var islandBMP:Bitmap;
        private var islandZones:Array;
        private var idleSprites:IdleSprites;
        private var mapFightCloud:Object = null;
        private var helpBubble:Object;
        private var cloudSprite:int = 0;
        public var fightCloudSprites:FightCloudSprites;
        private var daimyoGlow:int = 0;
        public var loadedAchievementProgress:Object = null;

        public function MapMain()
        {
            this.l = new Loader();
            this.cloudSheet = new CloudSheet();
            this.smallBirdSheet = new SmallBirdSprites();
            this.poopSheet = new PoopSprites();
            this.particleList = new Array(0);
           // this.keyPresses = new Array(0);
          //  this.kCode = new Array(38, 38, 40, 40, 37, 39, 37, 39, 66, 65, 13);
            this.islandZones = new Array({x:24, y:124, h:10, w:131}, {x:50, y:124, h:38, w:105}, {x:53, y:140, h:13, w:119}, {x:383, y:158, h:176, w:120}, {x:263, y:169, h:183, w:170}, {x:231, y:177, h:151, w:303}, {x:203, y:194, h:134, w:366}, {x:173, y:212, h:54, w:461}, {x:150, y:222, h:9, w:531}, {x:137, y:231, h:71, w:459}, {x:119, y:253, h:25, w:495});
            this.idleSprites = new IdleSprites();
            this.fightCloudSprites = new FightCloudSprites();
            this.horde.visible = false;
            this.w8.visible = false;
            this.islandBMP = this.island.addChildAt(new Bitmap(new IslandGraphic(750, 500), "never", true), 0)as Bitmap;
            this.islandBMP.smoothing = true;
            var _loc_2:Number = 0.999;
            this.islandBMP.scaleY = 0.999;
            this.islandBMP.scaleX = _loc_2;
            this.toolTip.visible = false;
            this.island.mouseEnabled = false;
            this.island.mouseChildren = false;
            this.attack.blimp.snake.visible = false;
            this.buildings.swords.visible = false;
            this.magicX = this.tournament.x;
            this.magicY = this.tournament.y;
            this.hordeY = this.horde.y;
            
			
            this.addEventListener(Event.ENTER_FRAME, this.init);
            return;
        }// end function

        private function init(... args)
        {
			//wordEffectLayer=new MovieClip();
			//lowClouds=new MovieClip();
			//this.addChild(lowClouds);
			//highClouds=new MovieClip();
			//this.addChild(highClouds);
            this.removeEventListener(Event.ENTER_FRAME, this.init);
            this.main = FramebarController.instance.framebarview;
			trace(FramebarController.instance.framebarview);
			var _loc_1:int = 0;
            while (_loc_1 < 7)
            {
                if (int(Math.random() * 2))
                {
                    this.particleList.push(this.lowClouds.addChild(new CloudParticle(this.main, this, int(Math.random() * 700), 50 + int(Math.random() * 400), false)));
                }
                else if (int(Math.random() * 2))
                {
                    this.particleList.push(this.highClouds.addChild(new CloudParticle(this.main, this, int(Math.random() * 700), 60 + int(Math.random() * 40), false)));
                }
                else
                {
                    this.particleList.push(this.highClouds.addChild(new CloudParticle(this.main, this, int(Math.random() * 700), 450 - int(Math.random() * 60), false)));
                }
                _loc_1++;
            }
           /* if (!this.main.bookmarked)
            {
                this.enableBookmark();
            }
            else
            {*/
                this.bookmarkButton.visible = false;
           // }
            this.main.showAllies();
			initBoss();
           // this.addChild(this.main.genbuLoader);
            
            this.attack.blimp.snake.visible =UserInfoModel.instance.UserInfo.defeated_genbu;
            this.buildings.swords.visible =UserInfoModel.instance.UserInfo.defeated_girl;
            this.main.checkForTrain();
            /*if (this.main.tutorial != null && this.main.tutorial.currentStep < 18)
            {
                trace(this.main.tutorial.currentStep);
                this.main.tutorial.currentScreen = this;
                if (this.main.level < 2)
                {
                    if (this.main.tutorial.currentStep <= 1 && this.main.ninjaList.length == 0)
                    {
                        this.main.tutorial.showArrow();
                        this.main.disableSlots();
                        this.enableRecruit();
                        this.buildings.dojo.alpha = 0.5;
                        this.attack.alpha = 0.5;
                    }
                    else if (this.main.tutorial.currentStep <= 10 && (parseInt(this.main.ninjaList[0].level) == 1 || parseInt(this.main.ninjaList[0].weapon.iid) == 0))
                    {
                        this.main.disableSlots();
                        this.main.tutorial.setStep(4);
                        this.enableDojo();
                        this.buildings.recruit.alpha = 0.5;
                        this.attack.alpha = 0.5;
                    }
                    else if (this.main.tutorial.currentStep <= 12 && parseInt(this.main.activeRelics[0].iid) == 0)
                    {
                        this.main.reenableSlot(0);
                        this.main.tutorial.setStep(11);
                        this.buildings.recruit.alpha = 0.5;
                        this.buildings.dojo.alpha = 0.5;
                        this.attack.alpha = 0.5;
                    }
                    else if (this.main.tutorial.currentStep == 13 || this.main.activeRelics.length)
                    {
                        this.main.disableSlots();
                        this.canActivateBlimp = false;
                        this.main.tutorial.setStep(13);
                        this.enableFight();
                        this.buildings.recruit.alpha = 0.5;
                        this.buildings.dojo.alpha = 0.5;
                    }
                    this.buildings.weapons.alpha = 0.5;
                }
                this.horde.visible = false;
                this.buildings.daimyo.alpha = 0.5;
                this.buildings.todoList.alpha = 0.5;
                this.buildings.magic.alpha = 0.5;
                this.buildings.relics.alpha = 0.5;
                this.buildings.hospital.alpha = 0.5;
                this.tournament.building.alpha = 0.5;
                this.tournament.building.gotoAndStop(2);
            }
            else
            {*/
                this.enableAll();
           /* }*/
            this.addEventListener(Event.ENTER_FRAME, this.update);
            this.blimpX = this.attack.x;
            this.blimpY = this.attack.y;
            this.statsWindow = this.addChild(new BuildingRolloverStats(0));
            args = this.main.getToolTip();
            if (args[0])
            {
                this.toolTip.tipTitle.text = args[0];
                this.toolTip.tipSteps.text = args[1];
                this.toolTip.visible = true;
            }
            //stage.addEventListener(KeyboardEvent.KEY_DOWN, this.checkKeyPresses);
            return;
        }// end function

		private function initBoss():void{
			genbuLoader=new Loader();
			if (parseInt(UserInfoModel.instance.UserInfo.level) >= 5 && !UserInfoModel.instance.UserInfo.defeated_small_girl)
			{
				this.genbuLoader.load(new URLRequest(UrlConfig.HTTPROOT + UrlConfig.GIRL1 ));
				trace(UrlConfig.HTTPROOT + UrlConfig.GIRL1 );
				this.addChild(this.genbuLoader);
			}
			else if (parseInt(UserInfoModel.instance.UserInfo.level) >= 15 && !UserInfoModel.instance.UserInfo.defeated_genbu)
			{
				this.genbuLoader.load(new URLRequest(UrlConfig.HTTPROOT + UrlConfig.GENBU));
				this.addChild(this.genbuLoader);
			}
			else if (parseInt(UserInfoModel.instance.UserInfo.level) >= 25 && !UserInfoModel.instance.UserInfo.defeated_girl)
			{
				this.genbuLoader.load(new URLRequest(UrlConfig.HTTPROOT + UrlConfig.GIRL));
				this.addChild(this.genbuLoader);
			}
			else if (parseInt(UserInfoModel.instance.UserInfo.level) >= 35 && !UserInfoModel.instance.UserInfo.defeated_mechagenbu)
			{
				this.genbuLoader.load(new URLRequest(UrlConfig.HTTPROOT + UrlConfig.MECHGENBU ));
				this.addChild(this.genbuLoader);
			}
		}
		
		public function loadFight(param1:String)
		{
			FramebarController.instance.framebarview.loadFight(param1);
		}
        /*private function checkKeyPresses(event:KeyboardEvent)
        {
            this.keyPresses.push(event.keyCode);
            if (this.keyPresses.length < this.kCode.length)
            {
                return;
            }
            if (this.keyPresses.length > this.kCode.length)
            {
                this.keyPresses.shift();
            }
            var _loc_2:int = 0;
            while (_loc_2 < this.keyPresses.length)
            {
                
                if (this.keyPresses[_loc_2] != this.kCode[_loc_2])
                {
                    return;
                }
                _loc_2++;
            }
           // this.konamiCode();
            return;
        }*/// end function

        private function enableToDoList()
        {
            this.buildings.todoList.alpha = 1;
            this.buildings.todoList.hitZone.buttonMode = true;
            this.buildings.todoList.hitZone.n = 11;
            this.buildings.todoList.hitZone.addEventListener(MouseEvent.CLICK, this.gotoToDo);
            this.buildings.todoList.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            this.buildings.todoList.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        private function enableDojo()
        {
            this.buildings.dojo.alpha = 1;
            this.buildings.dojo.hitZone.buttonMode = true;
            this.buildings.dojo.hitZone.n = 0;
            this.buildings.dojo.hitZone.addEventListener(MouseEvent.CLICK, this.gotoDojo);
            this.buildings.dojo.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            this.buildings.dojo.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        private function enableRecruit()
        {
            this.buildings.recruit.alpha = 1;
            this.buildings.recruit.hitZone.buttonMode = true;
            this.buildings.recruit.hitZone.n = 1;
            this.buildings.recruit.hitZone.addEventListener(MouseEvent.CLICK, this.gotoRecruit);
            this.buildings.recruit.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            this.buildings.recruit.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        private function enableRelics()
        {
            this.buildings.relics.alpha = 1;
            this.buildings.relics.hitZone.buttonMode = true;
            this.buildings.relics.hitZone.n = 2;
            this.buildings.relics.hitZone.addEventListener(MouseEvent.CLICK, this.gotoRelics);
            this.buildings.relics.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            this.buildings.relics.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        private function enableHospital()
        {
            this.buildings.hospital.alpha = 1;
            this.buildings.hospital.hitZone.buttonMode = true;
            this.buildings.hospital.hitZone.n = 3;
            this.buildings.hospital.hitZone.addEventListener(MouseEvent.CLICK, this.gotoHospital);
            this.buildings.hospital.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            this.buildings.hospital.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        private function enableWeapons()
        {
            this.buildings.weapons.alpha = 1;
            this.buildings.weapons.hitZone.buttonMode = true;
            this.buildings.weapons.hitZone.n = 4;
            this.buildings.weapons.hitZone.addEventListener(MouseEvent.CLICK, this.gotoWeapons);
            this.buildings.weapons.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            this.buildings.weapons.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        /*private function enableBookmark()
        {
            this.bookmarkButton.hitZone.buttonMode = true;
            this.bookmarkButton.hitZone.addEventListener(MouseEvent.CLICK, this.bookmarkNinjawarz);
            this.bookmarkButton.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat2);
            this.bookmarkButton.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat2);
            return;
        }*/// end function

       /* private function bookmarkNinjawarz(... args)
        {
            this.bookmarkButton.visible = false;
            this.main.bookmarkNinjawarz();
            return;
        }*/// end function

        private function enableDaimyo()
        {
            this.buildings.daimyo.alpha = 1;
            this.buildings.daimyo.hitZone.buttonMode = true;
            this.buildings.daimyo.hitZone.n = 6;
            this.buildings.daimyo.hitZone.addEventListener(MouseEvent.CLICK, this.gotoDaimyo);
            this.buildings.daimyo.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            this.buildings.daimyo.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        private function enableFight()
        {
            this.attack.alpha = 1;
            this.attack.hitZone.buttonMode = true;
            this.attack.hitZone.n = 5;
            this.attack.hitZone.addEventListener(MouseEvent.CLICK, this.gotoAttack);
            this.attack.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloatRight);
            this.attack.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloatRight);
            return;
        }// end function

        private function enableHorde()
        {
            this.horde.alpha = 1;
            this.horde.hitZone.buttonMode = true;
            this.horde.hitZone.n = -1;
            this.horde.hitZone.addEventListener(MouseEvent.CLICK, this.gotoHorde);
            this.horde.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloatRight);
            this.horde.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloatRight);
            return;
        }// end function

        private function enableTournament()
        {
			this.tournamentAvailable=main.tournamentAvailable;
			this.tournament.alpha = 1;
			this.tournament.hitZone.n = 7;
			//trace(this.main.tournamentAvailable,"-----------1111111111111111111111111");
			switch(this.main.tournamentAvailable)
			{
				
				case 0:
				{
					this.tournament.building.gotoAndStop(2);
					this.tournament.hitZone.buttonMode = false;
					this.tournament.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.displayTourneyText);
					this.tournament.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.removeTourneyText);
					break;
				}
				case 1:
				{
					this.tournament.building.gotoAndStop(2);
					this.tournament.hitZone.buttonMode = false;
					this.tournament.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.displayTourneyText);
					this.tournament.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.removeTourneyText);
					break;
				}
				case 2:
				{
					this.tournament.building.gotoAndStop(1);
					this.tournament.hitZone.buttonMode = true;
					this.tournament.hitZone.addEventListener(MouseEvent.CLICK, this.gotoTournament);
					this.tournament.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
					this.tournament.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
					break;
				}
				default:
				{
					
					break;
				}
			}
			return;
        }// end function

        private function enableMagic()
        {
            this.buildings.magic.alpha = 1;
            this.buildings.magic.hitZone.buttonMode = true;
            this.buildings.magic.hitZone.n = 9;
            this.buildings.magic.hitZone.addEventListener(MouseEvent.CLICK, this.gotoMagic);
            this.buildings.magic.hitZone.addEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            this.buildings.magic.hitZone.addEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        private function displayTourneyText(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            if (this.main.tournamentAvailable == 0)
            {
                this.statsWindow.display(8, 300, 300, "ARENA CLOSED!\n\nYou must be level 5 to enter a tournament.");
            }
            else if (this.main.tournamentAvailable == 1)
            {
                _loc_2 = this.main.tournamentTimer.repeatCount - this.main.tournamentTimer.currentCount;
                if (_loc_2 > 3600)
                {
                    this.statsWindow.display(8, 300, 300, "ARENA CLOSED!\n\nA new tournament will begin in\n" + int(_loc_2 / 3600) + " hrs, " + int(_loc_2 % 3600 / 60) + " min");
                }
                else
                {
                    this.statsWindow.display(8, 300, 300, "ARENA CLOSED!\n\nA new tournament will begin in\n" + int(_loc_2 % 3600 / 60 + 1) + " min");
                }
            }
            else if (this.main.tournamentAvailable == 2)
            {
                this.tournament.hitZone.removeEventListener(MouseEvent.MOUSE_OVER, this.displayTourneyText);
                this.tournament.hitZone.removeEventListener(MouseEvent.MOUSE_OUT, this.removeTourneyText);
                this.enableTournament();
            }
            return;
        }// end function

        private function removeTourneyText(event:MouseEvent) : void
        {
            this.hideStats();
            return;
        }// end function

        private function overInvite(... args)
        {
            this.wordEffect(7);
            return;
        }// end function

        private function update(... args)
        {
			
            var _loc_3:Boolean = false;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:* = undefined;
			if(this.tournamentAvailable!=main.tournamentAvailable)
				this.enableTournament();
            if (this.mapFightCloud != null)
            {
               
                this.cloudSprite++;
                if (this.cloudSprite == 30)
                {
                    this.cloudSprite = 0;
                }
                this.mapFightCloud.bitmapData.copyPixels(this.fightCloudSprites, new Rectangle(130 * (this.cloudSprite % 6), 0, 130, 130), new Point(0, 0));
                if (!this.cloudSprite)
                {
                    if (this.helpBubble.visible)
                    {
                        this.helpBubble.visible = false;
                    }
                    else
                    {
                        this.helpBubble.visible = true;
                    }
                }
            }
            if (!UserInfoModel.instance.UserInfo.daimyo_gift)
            {
                this.daimyoGlow = (this.daimyoGlow + 9) % 360;
                this.buildings.daimyo.building.getChildAt(0).filters = [new GlowFilter(16776960, 1, 10 + 10 * Math.sin(this.daimyoGlow * this.radCon), 10 + 10 * Math.sin(this.daimyoGlow * this.radCon))];
                this.buildings.daimyo.building.smoothing = true;
            }
            else
            {
                this.buildings.daimyo.building.getChildAt(0).filters = [];
                this.buildings.daimyo.building.smoothing = true;
            }
            if (!this.horde.visible && parseInt(UserInfoModel.instance.UserInfo.level) >= 18 && !UserInfoModel.instance.UserInfo.horde_in)
            {
                this.horde.x = -100;
                this.horde.visible = true;
            }
            (this.islandYStep + 1);
            this.blimpYStep = this.blimpYStep + 3;
            this.islandXStep = this.islandXStep + 2.5;
            if (this.islandYStep >= 360)
            {
                this.islandYStep = this.islandYStep - 360;
            }
            if (this.blimpYStep >= 360)
            {
                this.blimpYStep = this.blimpYStep - 360;
            }
            if (this.islandXStep >= 360)
            {
                this.islandXStep = this.islandXStep - 360;
            }
            this.attack.y = this.blimpY + 5 * Math.sin(this.blimpYStep * this.radCon);
            this.horde.x = 74 + (this.horde.x - 74) / 1.05;
            this.horde.y = this.hordeY + 5 * Math.sin((this.blimpYStep - 180) * this.radCon);
            this.tournament.y = this.magicY + 2 * Math.sin((this.blimpYStep - 115) * this.radCon);
            this.tournament.x = this.magicX + 3 * Math.cos((this.blimpYStep - 115) * this.radCon);
            var _loc_7:Number = 3 * Math.cos(this.islandXStep * this.radCon);
            this.island.x = 3 * Math.cos(this.islandXStep * this.radCon);
            this.buildings.x = _loc_7;
            var _loc_7:Number = 4 * Math.sin(this.islandYStep * this.radCon);
            this.island.y = 4 * Math.sin(this.islandYStep * this.radCon);
            this.buildings.y = _loc_7;
            this.islandBMP.smoothing = true;
            this.islandBMP.pixelSnapping = "never";
           
            //this.cloudTimer = this.cloudTimer - 1;
            if (!this.cloudTimer--)
            {
                this.cloudTimer = 150;
                if (int(Math.random() * 2))
                {
                    this.particleList.push(this.lowClouds.addChild(new CloudParticle(this.main, this, -200, int(Math.random() * 400))));
                }
                else
                {
                    _loc_3 = !UserInfoModel.instance.UserInfo.cloud && parseInt(UserInfoModel.instance.UserInfo.level) > 1 && int(Math.random() * 60) == 0;
					
                    if (int(Math.random() * 2))
                    {
                        this.particleList.push(this.highClouds.addChild(new CloudParticle(this.main, this, -200, 60 + int(Math.random() * 40), true, _loc_3)));
                    }
                    else
                    {
                        this.particleList.push(this.highClouds.addChild(new CloudParticle(this.main, this, -200, 450 - int(Math.random() * 60), true, _loc_3)));
                    }
                }
                if (!int(Math.random() * 7))
                {
                    _loc_4 = int(Math.random() * 2) + 1;
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4)
                    {
                        
                        this.particleList.push(this.highClouds.addChild(new Bird(this.main, this, -300 + Math.random() * 280, 50 + Math.random() * 400, 0.7 + Math.random() * 0.3)));
                        this.particleList.push(this.lowClouds.addChild(new Bird(this.main, this, -300 + Math.random() * 280, 50 + Math.random() * 400, 0.35 + Math.random() * 0.35)));
                        _loc_5++;
                    }
                }
            }
            var i:int = 0;
            while (i < this.particleList.length)
            {
                
                this.particleList[i].update();
                if (this.particleList[i].dead)
                {
                    _loc_6 = this.particleList[i];
                    _loc_6.destroy();
                    this.particleList[i] = this.particleList[(this.particleList.length - 1)];
                    this.particleList[(this.particleList.length - 1)] = _loc_6;
                    delete this[this.particleList.pop()];
                    i = i - 1;
                }
                i++;
            }
            if (this.attacking)
            {
                this.attack.x = this.attack.x + 0.5;
            }
            return;
        }// end function

        public function poop(param1:Number, param2:Number, param3:Boolean = false)
        {
            this.particleList.push(this.highClouds.addChild(new BirdPoop(this.main, this, param1, param2, param3)));
            return;
        }// end function

        public function hitIsland(param1:Number, param2:Number) : Boolean
        {
            var _loc_3:int = 0;
            while (_loc_3 < this.islandZones.length)
            {
                
                if (param1 >= this.islandZones[_loc_3].x + this.island.x && param2 >= this.islandZones[_loc_3].y + this.island.y && param1 <= this.islandZones[_loc_3].x + this.islandZones[_loc_3].w + this.island.x && param2 <= this.islandZones[_loc_3].y + this.islandZones[_loc_3].h + this.island.y + 20)
                {
                    return true;
                }
                _loc_3++;
            }
            return false;
        }// end function

        public function stainIsland(param1:Number, param2:Number)
        {
            this.islandBMP.bitmapData.copyPixels(this.poopSheet, new Rectangle(6, 0, 10, 8), new Point(int(param1 - this.island.x - 5), int(param2 - this.island.y - 4 - 20)), null, null, true);
            this.islandBMP.smoothing = true;
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

        private function floatRight(event:Event)
        {
            if (event.currentTarget.x >= 6)
            {
                event.currentTarget.removeEventListener(Event.ENTER_FRAME, this.floatUp);
            }
            else
            {
                event.currentTarget.x = event.currentTarget.x + 2;
            }
            return;
        }// end function

        private function floatLeft(event:Event)
        {
            if (event.currentTarget.x <= 0)
            {
                event.currentTarget.removeEventListener(Event.ENTER_FRAME, this.floatDown);
            }
            else
            {
                event.currentTarget.x = event.currentTarget.x - 2;
            }
            return;
        }// end function

        private function startFloatRight(event:MouseEvent)
        {
            this.wordEffect(event.currentTarget.n);
            if (parseInt(UserInfoModel.instance.UserInfo.level) <= 2)
            {
                this.showStats(event.currentTarget.n);
            }
            event.currentTarget.parent.blimp.removeEventListener(Event.ENTER_FRAME, this.floatLeft);
            event.currentTarget.parent.blimp.addEventListener(Event.ENTER_FRAME, this.floatRight);
            return;
        }// end function

        private function stopFloatRight(event:MouseEvent)
        {
            this.hideStats();
            event.currentTarget.parent.blimp.addEventListener(Event.ENTER_FRAME, this.floatLeft);
            event.currentTarget.parent.blimp.removeEventListener(Event.ENTER_FRAME, this.floatRight);
            return;
        }// end function

        private function startFloat(event:MouseEvent)
        {
            this.wordEffect(event.currentTarget.n);
            if (parseInt(UserInfoModel.instance.UserInfo.level) <= 2 || event.currentTarget.n == 7)
            {
                this.showStats(event.currentTarget.n);
            }
            event.currentTarget.parent.building.removeEventListener(Event.ENTER_FRAME, this.floatDown);
            event.currentTarget.parent.building.addEventListener(Event.ENTER_FRAME, this.floatUp);
            return;
        }// end function

        private function stopFloat(event:MouseEvent)
        {
            this.hideStats();
            event.currentTarget.parent.building.addEventListener(Event.ENTER_FRAME, this.floatDown);
            event.currentTarget.parent.building.removeEventListener(Event.ENTER_FRAME, this.floatUp);
            return;
        }// end function

        private function startFloat2(event:MouseEvent)
        {
            event.currentTarget.parent.buttonAnim.removeEventListener(Event.ENTER_FRAME, this.floatDown);
            event.currentTarget.parent.buttonAnim.addEventListener(Event.ENTER_FRAME, this.floatUp);
            return;
        }// end function

        private function stopFloat2(event:MouseEvent) : void
        {
            event.currentTarget.parent.buttonAnim.addEventListener(Event.ENTER_FRAME, this.floatDown);
            event.currentTarget.parent.buttonAnim.removeEventListener(Event.ENTER_FRAME, this.floatUp);
            return;
        }// end function

        public function showStats(param1:int) : void
        {
            if (param1 == 7)
            {
                this.statsWindow.display(param1, 300, 300);
            }
            else
            {
                this.statsWindow.display(param1, 170, 400);
            }
            return;
        }// end function

        public function hideStats() : void
        {
            this.statsWindow.undisplay();
            return;
        }// end function

        private function wordEffect(param1:int) : void
        {
            if (param1 < 0)
            {
                return;
            }
            if (param1 != 5 && param1 != 7 && param1 != 8)
            {
                this.particleList.push(this.island.effects.addChild(new WordPlosion(this, this.island["w" + param1].x, this.island["w" + param1].y, param1)));
            }
            else
            {
                this.particleList.push(this.wordEffectLayer.addChild(new WordPlosion(this, this["w" + param1].x, this["w" + param1].y, param1)));
            }
            return;
        }// end function

        public function disableScreen()
        {
            this.removeEventListener(Event.ENTER_FRAME, this.update);
            this.disableButton(this.buildings.dojo.hitZone, this.gotoDojo);
            this.disableButton(this.buildings.recruit.hitZone, this.gotoRecruit);
            this.disableButton(this.buildings.hospital.hitZone, this.gotoHospital);
            this.disableButton(this.buildings.relics.hitZone, this.gotoRelics);
            this.disableButton(this.buildings.weapons.hitZone, this.gotoWeapons);
            this.disableButton(this.buildings.daimyo.hitZone, this.gotoDaimyo);
            this.disableButton(this.buildings.magic.hitZone, this.gotoMagic);
            this.disableButton(this.attack.hitZone, this.gotoAttack);
            this.disableButton(this.tournament.hitZone, this.gotoTournament);
            this.disableButton(this.tournament.hitZone, this.displayTourneyText);
            this.attack.hitZone.removeEventListener(MouseEvent.MOUSE_OVER, this.startFloatRight);
            this.attack.hitZone.removeEventListener(MouseEvent.MOUSE_OUT, this.stopFloatRight);
            var _loc_1:int = 0;
            while (_loc_1 < this.particleList.length)
            {
                
                this.particleList[_loc_1].disable();
                _loc_1++;
            }
            return;
        }// end function

        private function disableButton(param1, param2:Function)
        {
            param1.buttonMode = false;
            param1.removeEventListener(MouseEvent.CLICK, param2);
            param1.removeEventListener(MouseEvent.MOUSE_OVER, this.startFloat);
            param1.removeEventListener(MouseEvent.MOUSE_OUT, this.stopFloat);
            return;
        }// end function

        private function gotoToDo(... args)
        {
            this.main.buttonSound();
            this.main.addChild(new ToDoWindow(this.main, this));
            return;
        }// end function

        private function gotoDojo(... args)
        {
            this.main.soundManager.loadSoundEffect("doorOpen");
          //  this.disableScreen();
			DojoController.instance.renderDojoView();
            return;
        }// end function

        private function gotoRecruit(... args)
        {
            this.main.soundManager.loadSoundEffect("doorOpen");
         //   this.disableScreen();
			RecruitController.instance.renderRecruitView();
            return;
        }// end function

        private function gotoAttack(... args)
        {
           this.main.soundManager.loadSoundEffect("fight_button");
            this.main.hideAllies();
            this.attack.hitZone.removeEventListener(MouseEvent.MOUSE_OUT, this.stopFloatRight);
            this.gotoStaging();
            return;
        }// end function

        private function gotoHorde(... args)
        {
            this.main.soundManager.loadSoundEffect("fight_button");
            //this.main.hideAllies();
            this.main.loadFight("zombiefight");
            return;
        }// end function

        private function gotoTournament(event:MouseEvent) : void
        {
            this.main.soundManager.loadSoundEffect("doorOpen");
         //   this.disableScreen();
           // this.main.hideAllies();
			main.hideAllies();
			main._mcFramebar.btnTrain.visible=false;
			var t:TournyChooseMain=new TournyChooseMain();
			
			this.addChild(t);
            //this.main.loadTournamentFile("tournyChoose");
            return;
        }// end function

        private function gotoInvite(... args)
        {
            this.main.gotoInvite();
            //this.main.showFauxPreloader(50);
            return;
        }// end function

        private function gotoRelics(... args)
        {
            this.main.soundManager.loadSoundEffect("doorOpen");
        //    this.disableScreen();
			RelicController.instance.renderRelicView();
            return;
        }// end function

        private function gotoWeapons(... args)
        {
            this.main.soundManager.loadSoundEffect("doorOpen");
         //   this.disableScreen();
			WeaponController.instance.renderWeaponView();
            return;
        }// end function

        private function gotoStaging(... args)
        {
         //   this.disableScreen();
			StagingController.instance.renderStagingView();
            return;
        }// end function

        private function gotoMagic(... args)
        {
            this.main.soundManager.loadSoundEffect("magicshop_open");
         //   this.disableScreen();
			MagicController.instance.renderMagicView();
            return;
        }// end function

        private function gotoHospital(... args)
        {
            if (this.yesNoWindow != null)
            {
                this.yesNoWindow.closeWindow();
            }
            if (this.main.getHospitalCost() > 0)
            {
                this.main.confirm("Would you like to heal your ninjas for " + this.main.getHospitalCost() + " gold?", this.main.healNinjas, null);
            }
            else
            {
                this.main.alert("You are already at full health!");
            }
            return;
        }// end function

        private function gotoDaimyo(... args)
        {
            //this.main.soundManager.loadSoundEffect("daimyo");
            this.addChild(new DaimyoWindow(this.main));
            return;
        }// end function

        public function activateBlimpAndCloseWindow()
        {
            if (this.canActivateBlimp)
            {
                this.attack.alpha = 1;
                this.enableFight();
            }
            return;
        }// end function

        public function enableAll()
        {
            this.enableToDoList();
            this.enableDojo();
            this.enableRecruit();
            this.enableRelics();
            this.enableHospital();
            this.enableWeapons();
            this.enableDaimyo();
            this.enableFight();
            this.enableTournament();
            this.enableMagic();
            this.enableHorde();
            return;
        }// end function

        /*private function konamiCode(... args)
        {
            this.main.showWaitSymbol();
            args = new URLRequest(this.main.debugPrefix + "/ajax/konami_code?PHPSESSID=" + this.main.phpsessid + "");
            args.method = URLRequestMethod.POST;
            var _loc_3:* = new URLLoader();
            _loc_3.addEventListener(Event.COMPLETE, this.kHandler);
            _loc_3.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _loc_3.load(args);
            return;
        }*/// end function

       /* public function kHandler(event:Event) : void
        {
            this.main.hideWaitSymbol();
            event.currentTarget.removeEventListener(Event.COMPLETE, this.kHandler);
            event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            var _loc_2:* = JSON.deserialize(event.currentTarget.data);
            trace(event.currentTarget.data);
            if (_loc_2.result == "success")
            {
                if (_loc_2.spoils.achievements.length > 0)
                {
                    this.main.setAchievements(_loc_2.spoils.achievements);
                    this.main.nextAch();
                }
                this.main.relicInventory.push(_loc_2.spoils.items[0]);
                trace("success!");
            }
            else
            {
                this.main.alert(_loc_2.error);
                trace("fail ");
            }
            return;
        }*/// end function

        public function ioErrorHandler(param1)
        {
            trace(param1);
            return;
        }// end function

     //   Security.allowDomain("*");
    }
}
