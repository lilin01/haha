package com.app.view.staging
{
    import flash.display.*;
    import flash.events.*;
	import res.staging.PlayerSlatMC;
	import flash.net.URLRequest;
	import res.staging.*;
    public class PlayerSlat extends PlayerSlatMC
    {
        private var main:Object;
        private var pictureLoader:Loader;
        private var emblem:Object;
        private var player:Object;
        private var retryCount:int = 0;

		
        public function PlayerSlat(param1, param2, param3:int, param4:int)
        {
            main = param1;
            x = param3;
            y = param4;
            player = param2;
            playerName.text = param2.name;
            info.text = "Level: " + param2.level + " Ninjas: " + param2.num_ninjas + " Allies: " + (param2.ally_count != undefined ? (param2.ally_count) : ("0"));
            var _loc_5:* = new Loader();
            pictureLoader = new Loader();
            this.addChild(pictureLoader);
            pictureLoader.load(new URLRequest(param2.avatar));
			
            pictureLoader.addEventListener(MouseEvent.CLICK, gotoProfile);
            pictureLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            playerName.addEventListener(MouseEvent.CLICK, gotoProfile);
            enableButton(fight, gotoFight);
            switch(parseInt(param2.faction))
            {
                case 0:
                {
                    emblem = this.addChild(new Bitmap(new Shadow(1, 1)));
                    break;
                }
                case 1:
                {
                    emblem = this.addChild(new Bitmap(new Lotus(1, 1)));
                    break;
                }
                case 2:
                {
                    emblem = this.addChild(new Bitmap(new Fire(1, 1)));
                    break;
                }
                default:
                {
                    break;
                }
            }
            emblem.x = 55;
            emblem.y = 32;
            return;
        }// end function

        public function destroy(... args)
        {
            playerName.removeEventListener(MouseEvent.CLICK, gotoProfile);
            pictureLoader.removeEventListener(MouseEvent.CLICK, gotoProfile);
            pictureLoader.unload();
            disableButton(fight, gotoFight);
            parent.removeChild(this);
            return;
        }// end function

        private function gotoFight(... args)
        {
            //main.buttonSound();
            main.gotoFight(player.cid, "fight");
            return;
        }// end function

        private function gotoProfile(... args)
        {
            /*if (main.facebookApp)
            {
                if (ExternalInterface.available)
                {
                    ExternalInterface.call("nav", "http://apps.facebook.com/ninja-warz/p/" + player.cid);
                }
                navigateToURL(new URLRequest("http://apps.facebook.com/ninja-warz/p/" + player.cid), "_top");
            }
            else
            {
                navigateToURL(new URLRequest("http://ninjawarz.com/p/" + player.cid));
            }*/
			
			trace("gotoProfile");
            return;
        }// end function

        public function ioErrorHandler(param1)
        {
            var _loc_3:* = retryCount + 1;
            retryCount = _loc_3;
            if (retryCount < 2)
            {
                pictureLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                pictureLoader.load(new URLRequest("http://ninjacdn.brokenbulbstudios.com" + "/images/default_av_fac_" + player.faction + ".png"));
                pictureLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            }
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

        public function disableFight()
        {
            fight.visible = false;
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

    }
}
