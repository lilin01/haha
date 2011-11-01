package com.app.view.game  
{
    import flash.events.*;
 	import res.game.*;
	import flash.display.Loader;
    public class WinPopup extends WinPopupMC
    {
        private var l:Object;
        private var prefix:String = "";
        private var main:Object;
        private var mapMain:Object;
        private var executeFunction:Function;

        public function WinPopup(param1, param2:Object, param3:int = 0, param4:int = 0, param5:Function = null, param6:Boolean = true)
        {
            this.l = new Loader();
            this.main = param1;
            x = param3;
            y = param4;
            experienceText.text = "you gained " + param2.exp + " experience!";
            goldText.text = "you gained " + param2.gold + " gold!";
            this.executeFunction = param5;
            this.enableButtons();
            cButton.visible = false;
            return;
        }// end function

        private function disableButtons()
        {
			trace("disableButtons()");
            noButton.buttonMode = false;
            yesButton.buttonMode = false;
            noButton.hitZone.removeEventListener(MouseEvent.CLICK, this.dontShare);
            noButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            noButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            noButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            noButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            yesButton.hitZone.removeEventListener(MouseEvent.CLICK, this.share);
            yesButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            yesButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            yesButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            yesButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            cButton.hitZone.removeEventListener(MouseEvent.CLICK, this.dontShare);
            cButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            cButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            cButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            cButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            return;
        }// end function

        private function enableButtons()
        {
            noButton.buttonMode = true;
            noButton.hitZone.addEventListener(MouseEvent.CLICK, this.dontShare);
            noButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            noButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            yesButton.buttonMode = true;
            yesButton.hitZone.addEventListener(MouseEvent.CLICK, this.share);
            yesButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            yesButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            cButton.buttonMode = true;
            cButton.hitZone.addEventListener(MouseEvent.CLICK, this.dontShare);
            cButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            cButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            return;
        }// end function

        private function share(... args)
        {
            yesButton.visible = false;
            noButton.visible = false;
            cButton.visible = true;
           /* if (ExternalInterface.available)
            {
                ExternalInterface.call("share_fight");
            }*/
			trace("share_fight");
            return;
        }// end function

        private function dontShare(... args)
        {
            if (this.executeFunction != null)
            {
                this.executeFunction();
            }
			//closeWindow();
            return;
        }// end function

        public function closeWindow(... args)
        {
			trace(" closeWindow()1	`	");
			this.disableButtons();
			trace(this.parent);
			parent.removeChild(this);
            main.alertWindow = null;
            
			
            return;
        }// end function

        public function ioErrorHandler(param1)
        {
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

//        Security.allowDomain("*");
    }
}
