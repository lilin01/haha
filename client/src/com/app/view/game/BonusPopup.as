package com.app.view.game 
{
    import flash.display.*;
    import flash.events.*;
	import res.game.*;
    public class BonusPopup extends BonusPopupMC
    {
        private var l:Object;
        private var prefix:String = "";
        private var main:Object;
        private var mapMain:Object;
        private var executeFunction:Function;

        public function BonusPopup(param1, param2:String, param3:String, param4:int = 0, param5:int = 0, param6:Function = null, param7:Boolean = true)
        {
            var _loc_8:Bitmap = null;
            this.l = new Loader();
            this.main = param1;
            x = param4;
            y = param5;
            if (param3.length > 0)
            {
                alertText.text = param3 + " karma!";
                _loc_8 = new Bitmap(new KarmaBonusBG(1, 1));
            }
            else
            {
                alertText.text = param2 + " gold!";
                _loc_8 = new Bitmap(new GoldBonusBG(1, 1));
            }
            this.addChildAt(_loc_8, 0);
            _loc_8.x = (-_loc_8.width) / 2;
            _loc_8.y = (-_loc_8.height) / 2;
            this.executeFunction = param6;
            if (param7)
            {
                okButton.hitZone.buttonMode = true;
                okButton.hitZone.addEventListener(MouseEvent.CLICK, this.closeWindow);
                okButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
                okButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            }
            else
            {
                okButton.visible = false;
            }
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

        Security.allowDomain("*");
    }
}
