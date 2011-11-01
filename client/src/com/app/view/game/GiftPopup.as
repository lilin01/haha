package com.app.view.game 
{
    import flash.events.*;
	import res.game.*;
    public class GiftPopup extends GiftPopupMC
    {
        private var main:Object;
        private var mapMain:Object;
        private var yesFunction:Function;
        private var noFunction:Function;

        public function GiftPopup(param1, param2:int, param3:int, param4:int, param5:Function, param6:Function = null)
        {
            this.main = param1;
            this.main.soundManager.loadSoundEffect("warning");
            x = param3;
            y = param4;
            confirmText.text = "You have " + param2 + " new gift" + (param2 > 1 ? ("s") : ("")) + " from " + (param2 > 1 ? ("your allies") : ("an ally")) + " since you last played.";
            this.yesFunction = param5;
            this.noFunction = param6;
            this.enableButtons();
            return;
        }// end function

        private function disableButtons()
        {
            noBtn.buttonMode = false;
            noBtn.hitZone.removeEventListener(MouseEvent.CLICK, this.deny);
            noBtn.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            noBtn.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            noBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            noBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            yesBtn.buttonMode = false;
            yesBtn.hitZone.removeEventListener(MouseEvent.CLICK, this.confirm);
            yesBtn.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            yesBtn.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            yesBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            yesBtn.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            return;
        }// end function

        private function enableButtons()
        {
            noBtn.buttonMode = true;
            noBtn.hitZone.addEventListener(MouseEvent.CLICK, this.deny);
            noBtn.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            noBtn.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            yesBtn.buttonMode = true;
            yesBtn.hitZone.addEventListener(MouseEvent.CLICK, this.confirm);
            yesBtn.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            yesBtn.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            return;
        }// end function

        public function closeWindow(... args)
        {
            this.main.buttonSound();
            this.main.confirmWindow = null;
            this.disableButtons();
            parent.removeChild(this);
            return;
        }// end function

        private function confirm(... args)
        {
            this.closeWindow();
            return;
        }// end function

        private function deny(... args)
        {
            this.closeWindow();
            if (this.noFunction != null)
            {
                this.noFunction();
            }
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

    }
}
