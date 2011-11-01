package com.app.view.recruit 
{
    import fl.motion.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.*;
    import com.app.model.UserInfoModel;
    import res.recruit.RecruitNinjaMC;
    public class RecruitNinja extends RecruitNinjaMC
    {
        private var main:Object;
        private var recruitMain:Object;
        private var ninja:Object;
        private var spriteSheet:Object;
        private var bmp:Bitmap;
        private var bbmp:Bitmap;
        private var abmp:Bitmap;
        private var wbmp:Bitmap;
        private var animations:Array;
        private var currentSprite:int = 0;
        private var idleX:int = 0;
        private var idleY:int = 0;
        private var weaponSheet:int = 0;

        public function RecruitNinja(param1, param2, param3, param4:int, param5:int, param6:Boolean = false)
        {
            animations = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1);
            main = param1;
            recruitMain = param2;
            ninja = param3;
            x = param4;
            y = param5;
            spriteSheet = recruitMain.ninjaSprites[UserInfoModel.instance.UserInfo.faction][parseInt(ninja.gender)];
            bmp = this.addChild(new Bitmap(new BitmapData(100, 130, true, 0), "always", true)) as Bitmap;
            bmp.x = -50;
            bmp.y = -130;
            bbmp = this.addChild(new Bitmap(new BitmapData(100, 130, true, 0), "always", true)) as Bitmap;
            bbmp.x = -50;
            bbmp.y = -130;
            abmp = this.addChild(new Bitmap(new BitmapData(100, 130, true, 0), "always", true)) as Bitmap;
            abmp.x = -50;
            abmp.y = -130;
            wbmp = this.addChild(new Bitmap(new BitmapData(100, 130, true, 0), "always", true)) as Bitmap;
            wbmp.x = -50;
            wbmp.y = -130;
            bmp.bitmapData.copyPixels(spriteSheet as BitmapData, new Rectangle(idleX + animations[currentSprite] * 100, idleY, 100, 130), new Point(0, 0));
            bbmp.bitmapData.copyPixels(spriteSheet as BitmapData, new Rectangle(idleX + animations[currentSprite] * 100, idleY + 130, 100, 130), new Point(0, 0));
            abmp.bitmapData.copyPixels(spriteSheet as BitmapData, new Rectangle(idleX + animations[currentSprite] * 100, idleY + 260, 100, 130), new Point(0, 0));
            currentSprite = int(Math.random() * animations.length);
            var _loc_7:* = new Color();
            var _loc_8:* = new Array(16777215, 16776960, 10053120, 39168, 170, 6710784, 0);
            _loc_7.setTint(_loc_8[Math.min(int(parseInt(ninja.level) / 2), 6)], 0.7);
            bbmp.transform.colorTransform = _loc_7;
            buttonMode = true;
            /*if (main.level == 1 && main.tutorial != null)
            {
                if (!param6)
                {
                    buttonMode = false;
                    alpha = 0.5;
                }
                else
                {
                    main.tutorial.setArrow(x - 50, y);
                    this.addEventListener(MouseEvent.CLICK, recruitNinja);
                }
            }*/
           /* else
            {*/
                this.addEventListener(MouseEvent.CLICK, openNinjaWindow);
                this.addEventListener(MouseEvent.ROLL_OVER, showStats);
                this.addEventListener(MouseEvent.ROLL_OUT, hideStats);
           /* }*/
            return;
        }// end function

        public function update()
        {
            var _loc_2:* = currentSprite + 1;
            currentSprite = _loc_2;
            if (currentSprite >= animations.length)
            {
                currentSprite = 0;
            }
            bmp.bitmapData.copyPixels(spriteSheet as BitmapData, new Rectangle(idleX + animations[currentSprite] * 100, idleY, 100, 130), new Point(0, 0));
            bbmp.bitmapData.copyPixels(spriteSheet as BitmapData, new Rectangle(idleX + animations[currentSprite] * 100, idleY + 130, 100, 130), new Point(0, 0));
            abmp.bitmapData.copyPixels(spriteSheet as BitmapData, new Rectangle(idleX + animations[currentSprite] * 100, idleY + 260, 100, 130), new Point(0, 0));
            return;
        }// end function

        private function openNinjaWindow(... args)
        {
            if (UserInfoModel.instance.UserInfo.ninjas.length < 25)
            {
                recruitMain.openNinjaWindow(ninja, this);
            }
            return;
        }// end function

        private function showStats(... args)
        {
            recruitMain.showStats(ninja, 375, y > 250 ? (125) : (375));
            return;
        }// end function

        private function hideStats(... args)
        {
            recruitMain.hideStats();
            return;
        }// end function

        public function setPrice()
        {
            var _loc_1:* = undefined;
            var _loc_2:Array = null;
            var _loc_3:* = undefined;
            if (UserInfoModel.instance.UserInfo.ninjas.length < 25)
            {
                _loc_1 = 1000 * (UserInfoModel.instance.UserInfo.ninjas.length * UserInfoModel.instance.UserInfo.ninjas.length);
                _loc_2 = [1000000, 3000000, 7000000, 15000000, 25000000];
                if (UserInfoModel.instance.UserInfo.ninjas.length > 19)
                {
                    _loc_1 = _loc_2[UserInfoModel.instance.UserInfo.ninjas.length - 20];
                }
                _loc_3 = (parseInt(ninja.power) + parseInt(ninja.health) - 90) * (_loc_1 * 0.05);
                ninja.price = "" + (_loc_1 + _loc_3);
            }
            else
            {
                ninja.price = "Your clan is full!";
            }
            return;
        }// end function

        public function destroy()
        {
            this.removeEventListener(MouseEvent.CLICK, openNinjaWindow);
            this.removeEventListener(MouseEvent.ROLL_OVER, showStats);
            this.removeEventListener(MouseEvent.ROLL_OUT, hideStats);
            parent.removeChild(this);
            return;
        }// end function

        /*private function recruitNinja(... args)
        {
            args = new URLRequest(main.debugPrefix + "/ajax/recruit_ninja?PHPSESSID=" + main.phpsessid + "");
            var _loc_3:* = new URLVariables();
            _loc_3.rnid = ninja.rnid;
            args.data = _loc_3;
            args.method = URLRequestMethod.POST;
            var _loc_4:* = new URLLoader();
            new URLLoader().addEventListener(Event.COMPLETE, recruitHandler);
            _loc_4.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _loc_4.load(args);
            main.showWaitSymbol();
            return;
        }*/// end function

        /*public function recruitHandler(event:Event) : void
        {
            main.hideWaitSymbol();
            event.currentTarget.removeEventListener(Event.COMPLETE, recruitHandler);
            event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            var _loc_2:* = JSON.deserialize(event.currentTarget.data);
            if (_loc_2.result == "success")
            {
                if (main.level == 1 && main.tutorial != null)
                {
                    main.tutorial.nextStep();
                }
                ninja.modified_max_health = ninja.health;
                main.adjustStats(-parseInt(ninja.price), 0);
                ninja.nid = _loc_2.spoils.ninja;
                main.addNinja(ninja);
                main.setHealthBar();
                destroy();
                ;
            }
            return;
        }*/// end function

        public function ioErrorHandler(param1)
        {
            return;
        }// end function

        //Security.allowDomain("*");
    }
}
