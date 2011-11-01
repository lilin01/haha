package com.app.view.game 
{
    import flash.events.*;
    import flash.text.*;
	import res.game.*;

	import flash.display.Loader;
    public class ItemPopup extends ItemPopupMC
    {
        private var l:Object;
        private var prefix:String = "";
        private var main:Object;
        private var mapMain:Object;
        private var level:int = 0;
        private var yesFunction:Function;
        private var noFunction:Function;
        private var imageLoader:Object;
        private var friend:Object;
        private var item:Object;

        public function ItemPopup(param1, param2:Object, param3:int, param4:int, param5:Function, param6:Function = null)
        {
            this.l = new Loader();
            this.main = param1;
            x = param3;
            y = param4;
            this.item = param2.item;
            foundText.text = "you found a " + this.item.name + " on the battlefield!";
            var _loc_7:* = new TextFormat(null, null, 16711680);
            foundText.setTextFormat(_loc_7, foundText.text.indexOf(this.item.name), foundText.text.indexOf(this.item.name) + this.item.name.length);
            if (this.item.type == "1")
            {
                this.addChild(new Weapon(this.main, this.item, 0, 20));
            }
            else
            {
                this.addChild(new Relic(this.main, this.item, 0, 20));
            }
            this.yesFunction = param5;
            this.noFunction = param6;
            cButton.visible = false;
            this.enableButtons();
            return;
        }// end function

        private function resizeImage(event:Event)
        {
            if (this.level > 45)
            {
                var _loc_2:* = 90 / this.imageLoader.height;
                this.imageLoader.scaleY = 90 / this.imageLoader.height;
                this.imageLoader.scaleX = _loc_2;
            }
            return;
        }// end function

        private function disableButtons()
        {
            noButton.buttonMode = false;
            yesButton.buttonMode = false;
            noButton.hitZone.removeEventListener(MouseEvent.CLICK, this.deny);
            noButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            noButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            noButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            noButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            yesButton.hitZone.removeEventListener(MouseEvent.CLICK, this.confirm);
            yesButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            yesButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            yesButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            yesButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            cButton.hitZone.removeEventListener(MouseEvent.CLICK, this.continueWindow);
            cButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            cButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            cButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            cButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            return;
        }// end function

        private function enableButtons()
        {
            noButton.buttonMode = true;
            noButton.hitZone.addEventListener(MouseEvent.CLICK, this.deny);
            noButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            noButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            yesButton.buttonMode = true;
            yesButton.hitZone.addEventListener(MouseEvent.CLICK, this.confirm);
            yesButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            yesButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            cButton.hitZone.buttonMode = true;
            cButton.hitZone.addEventListener(MouseEvent.CLICK, this.continueWindow);
            cButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            cButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            return;
        }// end function

        public function continueWindow(... args)
        {
            if (this.yesFunction != null)
            {
                this.yesFunction();
            }
            return;
        }// end function

        public function closeWindow(... args)
        {
			this.main.alertWindow = null;
			this.disableButtons();
			parent.removeChild(this);
            return;
        }// end function

        private function confirm(... args)
        {
			trace("share_item");
            /*if (ExternalInterface.available)
            {
                ExternalInterface.call("share_item", this.item);
            }*/
            cButton.visible = true;
            noButton.visible = false;
            yesButton.visible = false;
            return;
        }// end function

        private function deny(... args)
        {
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

//        Security.allowDomain("*");
    }
}
