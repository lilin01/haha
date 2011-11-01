package com.app.view.staging 
{
    import com.app.config.UrlConfig;
    import com.app.controller.FramebarController;
    import com.app.controller.StagingController;
    import com.framework.utils.loader.HttpLoader;
    
	import com.app.model.UserInfoModel;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    
    import res.staging.mcStadingMain;
    public class StagingMain extends mcStadingMain
    {
       
        private var enemies:Array;
        private var friends:Array;
        private var loadedInfo:Object;
        private var enemyButtons:Array;
        private var friendButtons:Array;
        private var startEnemy:int = 0;
        private var startFriend:int = 0;
        private var enemyLevel:int = 0;
        private var main:Object;

        public function StagingMain()
        {
            enemies = new Array(0);
            friends = new Array(0);
            enemyButtons = new Array(0);
            friendButtons = new Array(0);
            girl.visible = false;
            genbu.visible = false;
            mechaGenbu.visible = false;
            this.addEventListener(Event.ENTER_FRAME, startLoad);
            return;
        }// end function

        private function startLoad(... args)
        {
            this.removeEventListener(Event.ENTER_FRAME, startLoad);
            main = FramebarController.instance.framebarview;
			
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.STAGE,loadInfoHandler);
           
            main.showWaitSymbol();
            return;
        }// end function

        private function init(... args)
        {
            enemies = loadedInfo.other;
            friends = loadedInfo.playing_friends;
            main.hideWaitSymbol();
            this.removeEventListener(Event.ENTER_FRAME, init);
            enableBosses();
            enableButton(mapButton, gotoMap);
            makeButtons();
            friendsUp.arrow.alpha = 0.1;
            enemiesUp.arrow.alpha = 0.1;
            if (friends.length >= 8)
            {
                friendsDown.addEventListener(MouseEvent.CLICK, downShiftFriends);
                friendsDown.buttonMode = true;
            }
            else
            {
                friendsDown.arrow.alpha = 0.1;
            }
            if (enemies.length >= 8)
            {
                enemiesDown.addEventListener(MouseEvent.CLICK, downShiftEnemies);
                enemiesDown.buttonMode = true;
            }
            else
            {
                enemiesDown.arrow.alpha = 0.1;
            }
            if (parseInt(UserInfoModel.instance.UserInfo.level) > 1)
            {
                enemiesWeaker.addEventListener(MouseEvent.CLICK, weakerClans);
                enemiesStronger.addEventListener(MouseEvent.CLICK, strongerClans);
                enemiesWeaker.buttonMode = true;
                enemiesStronger.buttonMode = true;
            }
            else
            {
                invite.visible = false;
               /* if (main.tutorial != null)
                {
                    main.tutorial.setStep(14);
                }*/
            }
            enableButton(invite, main.gotoInvite);
            return;
        }// end function

        private function weakerClans(... args)
        {
            if (enemyLevel > -10 && parseInt(UserInfoModel.instance.UserInfo.level) + enemyLevel > 1)
            {
                //main.buttonSound();
                var _loc_3:* = enemyLevel - 1;
                enemyLevel = _loc_3;
            }
            getMoreClans();
            return;
        }// end function

        private function strongerClans(... args)
        {
           // main.buttonSound();
            var _loc_3:* = enemyLevel + 1;
            enemyLevel = _loc_3;
            getMoreClans();
            return;
        }// end function

        private function getMoreClans(... args)
        {
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.GETOPPONENTS ,enemiesHandler);
			//HttpLoader.getInstance().httpJson("http://ninjawarz.brokenbulbstudios.com/ajax/get_opponents/" + enemyLevel + "/0/50",enemiesHandler);
           
            main.showWaitSymbol();
            return;
        }// end function

        private function makeButtons()
        {
            createEnemyButtons();
            createFriendButtons();
            return;
        }// end function

        private function createEnemyButtons()
        {
            var _loc_1:* = startEnemy;
            while (_loc_1 < enemies.length && _loc_1 < startEnemy + 9)
            {
                
                enemyButtons.push(new PlayerSlat(main, enemies[_loc_1], 20, 160 + 53 * (_loc_1 - startEnemy)));
                this.addChild(enemyButtons[_loc_1 - startEnemy]);
                _loc_1++;
            }
            return;
        }// end function

        private function destroyEnemyButtons()
        {
            while (enemyButtons.length > 0)
            {
                
                enemyButtons.pop().destroy();
            }
            return;
        }// end function

        private function createFriendButtons()
        {
            var i:int = startFriend;
            while (i < friends.length && i < startFriend + 8)
            {
                
                friendButtons.push(new PlayerSlat(main, friends[i], 390, 160 + 53 * (i - startFriend)));
                this.addChild(friendButtons[i - startFriend]);
                if (parseInt(UserInfoModel.instance.UserInfo.level) == 1)
                {
                    friendButtons[i - startFriend].disableFight();
                }
                var _loc_2:* = i + 1;
                i = _loc_2;
            }
            return;
        }// end function

        private function downShiftEnemies(... args)
        {
            startEnemy = startEnemy + 9;
            main.buttonSound();
            if (startEnemy >= enemies.length - 9)
            {
                startEnemy = enemies.length - 9;
                enemiesDown.arrow.alpha = 0.1;
                enemiesDown.buttonMode = false;
                enemiesDown.removeEventListener(MouseEvent.CLICK, downShiftEnemies);
            }
            enemiesUp.arrow.alpha = 1;
            enemiesUp.buttonMode = true;
            enemiesUp.addEventListener(MouseEvent.CLICK, upShiftEnemies);
            destroyEnemyButtons();
            createEnemyButtons();
            return;
        }// end function

        private function upShiftEnemies(... args)
        {
            startEnemy = startEnemy - 9;
            //main.buttonSound();
            if (startEnemy <= 0)
            {
                startEnemy = 0;
                enemiesUp.arrow.alpha = 0.1;
                enemiesUp.buttonMode = false;
                enemiesUp.removeEventListener(MouseEvent.CLICK, upShiftEnemies);
            }
            enemiesDown.arrow.alpha = 1;
            enemiesDown.buttonMode = true;
            enemiesDown.addEventListener(MouseEvent.CLICK, downShiftEnemies);
            destroyEnemyButtons();
            createEnemyButtons();
            return;
        }// end function

        private function downShiftFriends(... args)
        {
            startFriend = startFriend + 8;
           // main.buttonSound();
            if (startFriend >= friends.length - 8)
            {
                startFriend = friends.length - 8;
                friendsDown.arrow.alpha = 0.1;
                friendsDown.buttonMode = false;
                friendsDown.removeEventListener(MouseEvent.CLICK, downShiftFriends);
            }
            friendsUp.addEventListener(MouseEvent.CLICK, upShiftFriends);
            friendsUp.arrow.alpha = 1;
            friendsUp.buttonMode = true;
            destroyFriendButtons();
            createFriendButtons();
            return;
        }// end function

        private function upShiftFriends(... args)
        {
            startFriend = startFriend - 8;
           // main.buttonSound();
            if (startFriend <= 0)
            {
                startFriend = 0;
                friendsUp.arrow.alpha = 0.1;
                friendsUp.buttonMode = false;
                friendsUp.removeEventListener(MouseEvent.CLICK, upShiftFriends);
            }
            friendsDown.addEventListener(MouseEvent.CLICK, downShiftFriends);
            friendsDown.arrow.alpha = 1;
            friendsDown.buttonMode = true;
            destroyFriendButtons();
            createFriendButtons();
            return;
        }// end function

        private function destroyFriendButtons()
        {
            while (friendButtons.length > 0)
            {
                
                friendButtons.pop().destroy();
            }
            return;
        }// end function

        private function enableBosses()
        {
            if (loadedInfo.bosses == false)
            {
                return;
            }
            if (loadedInfo.bosses.genbu != undefined)
            {
                genbu.buttonMode = true;
                genbu.visible = true;
                genbu.addEventListener(MouseEvent.CLICK, gotoGenbu);
            }
            if (loadedInfo.bosses.girl != undefined || loadedInfo.bosses.small_girl != undefined)
            {
                girl.buttonMode = true;
                girl.visible = true;
                girl.addEventListener(MouseEvent.CLICK, gotoGirl);
            }
            if (loadedInfo.bosses.mechagenbu != undefined)
            {
                mechaGenbu.buttonMode = true;
                mechaGenbu.visible = true;
                mechaGenbu.addEventListener(MouseEvent.CLICK, gotoMechaGenbu);
            }
            return;
        }// end function

        private function gotoGirl(... args)
        {
            disableButton(mapButton, gotoMap);
          //  main.buttonSound();
            if (loadedInfo.bosses.girl != undefined)
            {
                main.loadFight("epicbattlegirl");
            }
            else if (loadedInfo.bosses.small_girl != undefined)
            {
                main.loadFight("epicbattlegirl1");
            }
            return;
        }// end function

        private function gotoGenbu(... args)
        {
           // main.buttonSound();
            disableButton(mapButton, gotoMap);
            main.loadFight("epicbattlegenbu");
            return;
        }// end function

        private function gotoMechaGenbu(... args)
        {
           // main.buttonSound();
            disableButton(mapButton, gotoMap);
            main.loadFight("epicbattlemechagenbu");
            return;
        }// end function

        private function update(... args)
        {
            return;
        }// end function

        public function gotoMap(... args)
        {
            main.buttonSound();
            /*disableButton(mapButton, gotoMap);
            parent.parent.loadFile("map");*/
			
			StagingController.instance.renderHome();
            return;
        }// end function

        public function loadInfoHandler(data:Object) : void
        {
			main.hideWaitSymbol();
           loadedInfo = data;
          
           init();
            
            return;
        }// end function

        public function enemiesHandler(data:Object) : void
        {
           
            main.hideWaitSymbol();
           
            
            enemies = data as Array;
            //trace(enemies==null,"-----------------",data==null);
            destroyEnemyButtons();
            createEnemyButtons();
            return;
        }// end function

        private function closeWindow(... args)
        {
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

      //  Security.allowDomain("*");
    }
}
