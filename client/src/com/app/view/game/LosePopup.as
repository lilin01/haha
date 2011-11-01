package com.app.view.game 
{
    import flash.events.*;
	import res.game.*;
	import flash.display.Loader;
    public class LosePopup extends LosePopupMC
    {
        private var l:Object;
        private var prefix:String = "";
        private var main:Object;
        private var mapMain:Object;
        private var executeFunction:Function;

        public function LosePopup(param1, param2:int = 0, param3:int = 0, param4:Function = null)
        {
            this.l = new Loader();
            this.main = param1;
            x = param2;
            y = param3;
            this.executeFunction = param4;
            okButton.buttonMode = true;
            okButton.hitZone.addEventListener(MouseEvent.CLICK, this.closeWindow);
            okButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            okButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            return;
        }// end function

        public function closeWindow(... args)
        {
            this.main.alertWindow = null;
            okButton.hitZone.removeEventListener(MouseEvent.CLICK, this.closeWindow);
            okButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            okButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            if (this.executeFunction != null)
            {
                this.executeFunction();
            }
            parent.removeChild(this);
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
