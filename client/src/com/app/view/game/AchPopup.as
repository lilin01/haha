package com.app.view.game 
{
    import flash.events.*;
	import res.game.AchievementPopupMC;
	import com.app.model.UserInfoModel;
	import flash.display.Loader;
    public class AchPopup extends AchievementPopupMC
    {
        private var l:Object;
        private var prefix:String = "";
        private var main:Object;
        private var executeFunction:Function;
        private var achievement:Object;

        public function AchPopup(param1, param2:Object, param3:int = 0, param4:int = 0, param5:Function = null)
        {
            this.l = new Loader();
            this.main = param1;
            //this.main.soundManager.loadSoundEffect("achievement");
            x = param3;
            y = param4;
            this.achievement = param2;
            trace(this.achievement.aid);
            aName.text = param2.achievementName;
            aText.text = param2.aText;
            kText.text = "You gained " + param2.karma + " Karma!";
            UserInfoModel.instance.adjustStats(0, parseInt(param2.karma));
            this.executeFunction = param5;
            this.enableButtons();
            cButton.visible = false;
            return;
        }// end function

        private function disableButtons()
        {
            noButton.buttonMode = false;
            yesButton.buttonMode = false;
            noButton.hitZone.removeEventListener(MouseEvent.CLICK, this.closeWindow);
            noButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            noButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            noButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            noButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            yesButton.hitZone.removeEventListener(MouseEvent.CLICK, this.share);
            yesButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            yesButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            yesButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            yesButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            cButton.hitZone.removeEventListener(MouseEvent.CLICK, this.closeWindow);
            cButton.hitZone.removeEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            cButton.hitZone.removeEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            cButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatUp);
            cButton.buttonAnim.removeEventListener(MouseEvent.CLICK, this.floatDown);
            return;
        }// end function

        private function enableButtons()
        {
            noButton.buttonMode = true;
            noButton.hitZone.addEventListener(MouseEvent.CLICK, this.closeWindow);
            noButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            noButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            yesButton.buttonMode = true;
            yesButton.hitZone.addEventListener(MouseEvent.CLICK, this.share);
            yesButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            yesButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            cButton.buttonMode = true;
            cButton.hitZone.addEventListener(MouseEvent.CLICK, this.closeWindow);
            cButton.hitZone.addEventListener(MouseEvent.ROLL_OVER, this.startFloat);
            cButton.hitZone.addEventListener(MouseEvent.ROLL_OUT, this.stopFloat);
            return;
        }// end function

        private function share(... args)
        {
            yesButton.visible = false;
            noButton.visible = false;
            cButton.visible = true;
          
            trace("share_achievement", {name:this.achievement.achievementName, aid:this.achievement.aid, text:this.achievement.aText});
           
        }// end function

        public function closeWindow(... args)
        {
           // this.main.buttonSound();
            this.main.alertWindow = null;
            if (this.executeFunction != null)
            {
                this.executeFunction();
            }
            this.disableButtons();
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

    }
}
