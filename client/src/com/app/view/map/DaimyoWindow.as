package com.app.view.map 
{
    import com.app.config.UrlConfig;
    import com.framework.utils.loader.HttpLoader;
    import com.app.model.UserInfoModel;
	
    import flash.events.*;
    import flash.net.*;
    
    import res.map.*;
    public class DaimyoWindow extends DaimyoWindowMC
    {
        private var main:Object;
        private var mapMain:Object;
        public var popupWindow:Object = null;

        public function DaimyoWindow(param1, param2:int = 0, param3:int = 0)
        {
            this.main = param1;
            x = param2;
            y = param3;
            this.enableButtons();
            return;
        }// end function

        public function closeWindow(... args)
        {
            //this.main.buttonSound();
            this.closePopup();
            this.disableButtons();
            parent.removeChild(this);
            return;
        }// end function

        private function gotoBuy(... args)
        {
            //this.main.buttonSound();
           // this.main.gotoGoldmine();
			trace("buy gold");
            return;
        }// end function

        private function enableButtons()
        {
            this.enableButton(backButton, this.closeWindow);
            this.enableButton(buyButton, this.gotoBuy);
            this.enableButton(karmaGoldButton, this.openConvert);
            this.enableButton(rewardButton, this.daimyoReward);
            return;
        }// end function

        private function disableButtons()
        {
            this.disableButton(backButton, this.closeWindow);
            this.disableButton(buyButton, this.gotoBuy);
            this.disableButton(karmaGoldButton, this.openConvert);
            this.disableButton(rewardButton, this.daimyoReward);
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

        public function daimyoReward(...args)
        {
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.DAIMYOGIFT,daimyoHandler);
            this.main.showWaitSymbol();
            return;
        }// end function

        public function daimyoHandler(data:Object) : void
        {
            this.main.hideWaitSymbol();
           
            if (data.result == "success")
            {
                //this.main.soundManager.loadSoundEffect("daimyo_reward");
				UserInfoModel.instance.adjustStats(parseInt(data.spoils.gold), parseInt(data.spoils.karma));
                this.daimyoAlert("The Diamyo awards you " + data.spoils.gold + " gold and " + data.spoils.karma + " karma.");
				UserInfoModel.instance.UserInfo.daimyo_gift= 14400;
            }
            else
            {
                //this.main.soundManager.loadSoundEffect("daimyo" + int(Math.random() * 2 + 1));
                this.daimyoAlert(data.error);
            }
            return;
        }// end function

        public function daimyoAlert(param1:String, param2:int = 375, param3:int = 250, param4:Function = null)
        {
            this.closePopup();
            this.popupWindow = this.addChild(new DaimyoPopup(this, param1, param2, param3, param4));
            return;
        }// end function

        public function closePopup()
        {
            if (this.popupWindow != null)
            {
                this.popupWindow.closeWindow();
            }
            return;
        }// end function

        public function openConvert(... args)
        {
            this.closePopup();
            this.popupWindow = this.addChild(new KarmaGoldWindow(this.main, this, 375, 250));
            return;
        }// end function

       /* public function unequipRelic(... args)
        {
            this.disableButtons();
            args = new URLRequest(this.main.debugPrefix + "/ajax/unequip_relic?PHPSESSID=" + this.main.phpsessid + "");
            var _loc_3:* = new URLVariables();
            _loc_3.iid = relic.iid;
            _loc_3.slot = slot;
            args.data = _loc_3;
            args.method = URLRequestMethod.POST;
            var _loc_4:* = new URLLoader();
            new URLLoader().addEventListener(Event.COMPLETE, this.unequipHandler);
            _loc_4.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _loc_4.load(args);
            return;
        }// end function

        public function equipRelic(... args)
        {
            this.disableButtons();
            equippedRelic = sortedRelics[currentInventoryRelic][0];
            args = new URLRequest(this.main.debugPrefix + "/ajax/equip_relic?PHPSESSID=" + this.main.phpsessid + "");
            var _loc_3:* = new URLVariables();
            _loc_3.iid = equippedRelic.iid;
            _loc_3.slot = slot;
            args.data = _loc_3;
            args.method = URLRequestMethod.POST;
            var _loc_4:* = new URLLoader();
            new URLLoader().addEventListener(Event.COMPLETE, this.equipHandler);
            _loc_4.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _loc_4.load(args);
            return;
        }// end function

        public function equipHandler(event:Event) : void
        {
            event.currentTarget.removeEventListener(Event.COMPLETE, this.equipHandler);
            event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            trace(event.currentTarget.data);
            var _loc_2:* = JSON.deserialize(event.currentTarget.data);
            if (_loc_2.result == "success")
            {
                trace("success!");
            }
            else
            {
                trace("fail ");
            }
            this.enableButtons();
            return;
        }// end function

        public function unequipHandler(event:Event) : void
        {
            event.currentTarget.removeEventListener(Event.COMPLETE, this.unequipHandler);
            event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            trace(event.currentTarget.data);
            var _loc_2:* = JSON.deserialize(event.currentTarget.data);
            if (_loc_2.result == "success")
            {
                trace("success!");
            }
            else
            {
                trace("fail ");
            }
            this.enableButtons();
            return;
        }// end function

        public function ioErrorHandler(param1)
        {
            this.enableButtons();
            closeBtn.buttonMode = true;
            closeBtn.addEventListener(MouseEvent.CLICK, this.closeWindow);
            trace(param1);
            return;
        }*/// end function

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

      // Security.allowDomain("*");
    }
}
