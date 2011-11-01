package com.app.view.map 
{
    import com.app.config.UrlConfig;
    import com.framework.utils.loader.HttpLoader;
    import com.framework.utils.CommonUtils;
    import flash.display.Loader;
    import flash.events.*;
    import flash.net.*;
    
    import res.map.*;
    public class ToDoWindow extends ToDoWindowMC
    {
        private var main:Object;
        private var mapMain:Object;
        public var popupWindow:Object = null;
        private var toolTip:Object = null;
        private var imageLoaders:Array;
        private var rollover:ToDoRolloverMC = null;

        public function ToDoWindow(param1, param2, param3:int = 0, param4:int = 0)
        {
            this.imageLoaders = new Array(0);
            this.main = param1;
            this.mapMain = param2;
            x = param3;
            y = param4;
            var _loc_5:int = 0;
            while (_loc_5 < 3)
            {
                
                this["name" + _loc_5].text = "";
                this["desc" + _loc_5].text = "";
                this["bar" + _loc_5].visible = false;
                this["reward" + _loc_5].visible = false;
                this["remove" + _loc_5].visible = false;
                _loc_5++;
            }
            this.main.showWaitSymbol();
           
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.GETACHIEVEMENTPROGRESS,aHandler);
            return;
        }// end function

        public function aHandler(data:Object) : void
        {
            this.main.hideWaitSymbol();
            
            this.main.achievementProgress = data.data as Array;
            this.init(data.data);
            return;
        }// end function

        private function init(param1:Object) : void
        {
            var _loc_3:int = 0;
            this.main.achievementProgress = param1;
            var _loc_2:int = 0;
            if (param1 != null)
            {
                _loc_2 = this.main.achievementProgress.length - 1;
                while (_loc_2 >= 0)
                {
                    
                    _loc_3 = 0;
                    while (_loc_3 < this.main.removedMissions.length)
                    {
                        
                        if (this.main.achievementProgress[_loc_2].aid == this.main.removedMissions[_loc_3])
                        {
                            this.main.achievementProgress.splice(_loc_2--, 1);
                            break;
                        }
                        _loc_3++;
                    }
                    _loc_2 = _loc_2 - 1;
                }
            }
            _loc_2 = 0;
            while (_loc_2 < 3)
            {
                
                if (_loc_2 < this.main.achievementProgress.length)
                {
                    this["remove" + _loc_2].n = _loc_2;
                    this["remove" + _loc_2].alpha = 0.5;
                    this["remove" + _loc_2].buttonMode = true;
                    this["remove" + _loc_2].addEventListener(MouseEvent.CLICK, this.removeMission);
                    this["remove" + _loc_2].addEventListener(MouseEvent.ROLL_OVER, this.startFade);
                    this["remove" + _loc_2].addEventListener(MouseEvent.ROLL_OUT, this.stopFade);
                    this.imageLoaders.push(this["img" + _loc_2].holder.addChild(new Loader()));
                    this.imageLoaders[_loc_2].contentLoaderInfo.addEventListener(Event.COMPLETE, this.resizeImage);
                    this.imageLoaders[_loc_2].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
                    this["bar" + _loc_2].addEventListener(MouseEvent.ROLL_OUT, this.hideRollover);
                    this["bar" + _loc_2].addEventListener(MouseEvent.ROLL_OVER, this.showRollover);
                    this["bar" + _loc_2].n = _loc_2;
                    this["bar" + _loc_2].visible = false;
                    this["reward" + _loc_2].visible = true;
                    this["remove" + _loc_2].visible = true;
                }
                _loc_2++;
            }
            this.populate();
            this.enableButtons();
            return;
        }// end function

        private function populate() : void
        {
            var _loc_1:* = this.main.achievementProgress;
            var _loc_2:int = 0;
            while (_loc_2 < 3)
            {
                
                this.imageLoaders[_loc_2].unload();
                if (_loc_2 < _loc_1.length)
                {
                    this.imageLoaders[_loc_2].load(new URLRequest(this.main.prefix.split("swf/")[0] + "images/achievements/" + _loc_1[_loc_2].aid + ".png"));
                    this["name" + _loc_2].text = _loc_1[_loc_2].name;
                    this["desc" + _loc_2].text = _loc_1[_loc_2].text;
                    this["reward" + _loc_2].bp.text = _loc_1[_loc_2].karma;
                    this["bar" + _loc_2].barMask.scaleX = parseInt(_loc_1[_loc_2].progress) / parseInt(_loc_1[_loc_2].max_progress);
                    this["bar" + _loc_2].visible = _loc_1[_loc_2].max_progress != "1";
                }
                else
                {
                    this["name" + _loc_2].text = "";
                    this["desc" + _loc_2].text = "";
                    this["bar" + _loc_2].visible = false;
                    this["reward" + _loc_2].visible = false;
                    this["remove" + _loc_2].visible = false;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function showRollover(event:MouseEvent) : void
        {
            if (this.rollover != null)
            {
                this.removeChild(this.rollover);
                this.rollover = null;
            }
            this.rollover = this.addChild(new ToDoRolloverMC())as ToDoRolloverMC;
            this.rollover.x = event.currentTarget.x - 20;
            this.rollover.y = event.currentTarget.y + 20;
            if (this.main.achievementProgress[event.currentTarget.n].max_progress == "1000000000")
            {
                this.rollover.stat.text = CommonUtils.getFormattedNumber(parseInt(this.main.achievementProgress[event.currentTarget.n].progress)) + "/ 1 Billion";
            }
            else if (this.main.achievementProgress[event.currentTarget.n].max_progress == "100000000")
            {
                this.rollover.stat.text = CommonUtils.getFormattedNumber(parseInt(this.main.achievementProgress[event.currentTarget.n].progress)) + "/ 100 Million";
            }
            else if (this.main.achievementProgress[event.currentTarget.n].max_progress == "10000000")
            {
                this.rollover.stat.text = CommonUtils.getFormattedNumber(parseInt(this.main.achievementProgress[event.currentTarget.n].progress)) + "/ 10 Million";
            }
            else if (this.main.achievementProgress[event.currentTarget.n].max_progress == "1000000")
            {
                this.rollover.stat.text = CommonUtils.getFormattedNumber(parseInt(this.main.achievementProgress[event.currentTarget.n].progress)) + "/ 1 Million";
            }
            else
            {
                this.rollover.stat.text = CommonUtils.getFormattedNumber(parseInt(this.main.achievementProgress[event.currentTarget.n].progress)) + "/" + CommonUtils.getFormattedNumber(parseInt(this.main.achievementProgress[event.currentTarget.n].max_progress));
            }
            return;
        }// end function

        private function hideRollover(event:MouseEvent) : void
        {
            if (this.rollover != null)
            {
                this.removeChild(this.rollover);
                this.rollover = null;
            }
            return;
        }// end function

        private function removeMission(event:MouseEvent) : void
        {
            //this.main.buttonSound();
            this.main.removedMissions.push(this.main.achievementProgress.splice(event.currentTarget.n, 1)[0].aid);
            this.populate();
            return;
        }// end function

        public function closeWindow(... args)
        {
            this.closePopup();
            this.disableButtons();
            parent.removeChild(this);
            return;
        }// end function

        private function enableButtons()
        {
            this.enableButton(backButton, this.closeWindow);
            this.enableButton(seeAll, this.gotoProfile);
            backButton.hitZone.n = 0;
            return;
        }// end function

        private function disableButtons()
        {
            this.disableButton(backButton, this.closeWindow);
            this.disableButton(seeAll, this.gotoProfile);
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

        private function gotoProfile(event:Event = null)
        {
            this.main.gotoAchievements();
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

        public function ioErrorHandler(param1)
        {
            this.enableButtons();
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

        private function startFade(event:MouseEvent)
        {
            event.currentTarget.removeEventListener(Event.ENTER_FRAME, this.fadeDown);
            event.currentTarget.addEventListener(Event.ENTER_FRAME, this.fadeUp);
            return;
        }// end function

        private function stopFade(event:MouseEvent)
        {
            event.currentTarget.addEventListener(Event.ENTER_FRAME, this.fadeDown);
            event.currentTarget.removeEventListener(Event.ENTER_FRAME, this.fadeUp);
            return;
        }// end function

        private function fadeUp(event:Event)
        {
            if (event.currentTarget.alpha >= 1)
            {
                event.currentTarget.removeEventListener(Event.ENTER_FRAME, this.fadeUp);
            }
            else
            {
                event.currentTarget.alpha = event.currentTarget.alpha + 0.02;
            }
            return;
        }// end function

        private function fadeDown(event:Event)
        {
            if (event.currentTarget.alpha <= 0.5)
            {
                event.currentTarget.removeEventListener(Event.ENTER_FRAME, this.fadeDown);
            }
            else
            {
                event.currentTarget.alpha = event.currentTarget.alpha - 0.02;
            }
            return;
        }// end function

        private function resizeImage(event:Event)
        {
            event.currentTarget.content.smoothing = true;
            return;
        }// end function

    //    Security.allowDomain("*");
    }
}
