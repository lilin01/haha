package com.app.view.map 
{
    import com.app.config.UrlConfig;
    import com.app.model.UserInfoModel;
    import com.framework.utils.CommonUtils;
    import com.framework.utils.loader.HttpLoader;
    
    import flash.events.*;
    import flash.net.*;
    
    import res.map.*;
    public class KarmaGoldWindow extends KarmaGoldPopupMC
    {
        private var main:Object;
        private var mapMain:Object;
        private var karma:int = 0;
        private var gold:int = 0;

        public function KarmaGoldWindow(param1, param2, param3:int = 0, param4:int = 0)
        {
            this.main = param1;
            this.mapMain = param2;
            x = param3;
            y = param4;
            karmaText.text ="0";
            goldText.text ="0";
            this.enableButtons();
            return;
        }// end function

        private function incKarma(... args)
        {
            //this.main.buttonSound();
            if (this.karma < UserInfoModel.instance.UserInfo.karma)
            {
               
                this.karma++;
                this.gold = this.main._gold_per_fight(parseInt(UserInfoModel.instance.UserInfo.level)) * 5 * this.karma;
            }
            goldText.text = "" + CommonUtils.getFormattedNumber(this.gold);
            karmaText.text = "" + this.karma;
            return;
        }// end function

        private function decKarma(... args)
        {
            //this.main.buttonSound();
            if (this.karma > 0)
            {
              
                args.karma--;
                this.gold = this.main._gold_per_fight(parseInt(UserInfoModel.instance.UserInfo.level)) * 5 * this.karma;
            }
            goldText.text =  CommonUtils.getFormattedNumber(this.gold);
            karmaText.text = this.karma.toString();
            return;
        }// end function

        public function closeWindow(... args)
        {
           // this.main.buttonSound();
            this.mapMain.popupWindow = null;
            this.disableButtons();
            parent.removeChild(this);
            return;
        }// end function

        private function enableButtons()
        {
            this.enableButton(cancelButton, this.closeWindow);
            this.enableButton(convertButton, this.convertKarma);
            this.enableButton(upArrow, this.incKarma);
            this.enableButton(downArrow, this.decKarma);
            return;
        }// end function

        private function disableButtons()
        {
            this.disableButton(cancelButton, this.closeWindow);
            this.disableButton(convertButton, this.convertKarma);
            this.disableButton(upArrow, this.incKarma);
            this.disableButton(downArrow, this.decKarma);
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

        public function convertKarma(... args)
        {
            this.disableButton(upArrow, this.incKarma);
            this.disableButton(downArrow, this.decKarma);
            
            var data:URLVariables= new URLVariables();
            data.karma = this.karma;
            
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.KARMATOGOLD,convertHandler,data);
            this.main.showWaitSymbol();
            return;
        }// end function

        public function convertHandler(data:Object) : void
        {
            this.enableButton(upArrow, this.incKarma);
            this.enableButton(downArrow, this.decKarma);
            this.main.hideWaitSymbol();
            
            
            if (data.result == "success")
            {
				UserInfoModel.instance.adjustStats(this.gold, -this.karma);
                this.karma = 0;
                karmaText.text ="0";
                this.gold = 0;
                goldText.text ="0";
            }
            else
            {
                this.main.alert(data.error);
            }
            return;
        }// end function

       /* public function ioErrorHandler(param1)
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

        //Security.allowDomain("*");
    }
}
