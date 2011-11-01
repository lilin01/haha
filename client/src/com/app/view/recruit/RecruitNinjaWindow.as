package com.app.view.recruit 
{
    import com.app.config.UrlConfig;
    import com.framework.utils.loader.HttpLoader;
    
    import fl.motion.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.*;
    import com.app.model.UserInfoModel;
    import res.recruit.RecruitNinjaWindowMC;
    public class RecruitNinjaWindow extends RecruitNinjaWindowMC
    {
        private var main:Object;
        private var recruitMain:Object;
        private var ninja:Object;
        private var bmp:Bitmap;
        private var bbmp:Bitmap;
        private var abmp:Bitmap;
        private var wbmp:Bitmap;
        private var animations:Array;
        private var currentSprite:int = 0;
        private var idleX:int = 0;
        private var idleY:int = 0;
        private var weaponSheet:int = 0;
        private var ninjaMC:Object;
		private var spriteSheet:BitmapData;
        public function RecruitNinjaWindow(param1, param2, param3, param4, param5:int = 0, param6:int = 0)
        {
            animations = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1);
            main = param1;
            recruitMain = param2;
            ninja = param3;
            x = param5;
            y = param6;
            ninjaMC = param4;
            spriteSheet = recruitMain.ninjaSprites[UserInfoModel.instance.UserInfo.faction][parseInt(ninja.gender)];
            bmp = ninjaImageHolder.addChild(new Bitmap(new BitmapData(100, 130, true, 0) , "always", true))as Bitmap;
            bmp.x = -50;
            bmp.y = -130;
            bbmp = ninjaImageHolder.addChild(new Bitmap(new BitmapData(100, 130, true, 0), "always", true))as Bitmap;
            bbmp.x = -50;
            bbmp.y = -130;
            abmp = ninjaImageHolder.addChild(new Bitmap(new BitmapData(100, 130, true, 0), "always", true))as Bitmap;
            abmp.x = -50;
            abmp.y = -130;
            wbmp = ninjaImageHolder.addChild(new Bitmap(new BitmapData(100, 130, true, 0), "always", true))as Bitmap;
            wbmp.x = -50;
            wbmp.y = -130;
            bmp.bitmapData.copyPixels(spriteSheet, new Rectangle(idleX + animations[currentSprite] * 100, idleY, 100, 130), new Point(0, 0));
            bbmp.bitmapData.copyPixels(spriteSheet, new Rectangle(idleX + animations[currentSprite] * 100, idleY + 130, 100, 130), new Point(0, 0));
            abmp.bitmapData.copyPixels(spriteSheet, new Rectangle(idleX + animations[currentSprite] * 100, idleY + 260, 100, 130), new Point(0, 0));
            currentSprite = int(Math.random() * animations.length);
            var _loc_7:* = new Color();
            var _loc_8:* = new Array(16777215, 16776960, 10053120, 39168, 170, 6710784, 0);
            _loc_7.setTint(_loc_8[Math.min(int(parseInt(ninja.level) / 2), 6)], 0.7);
            bbmp.transform.colorTransform = _loc_7;
            ninjaName.text = ninja.name;
            ninjaPower.text = ninja.power;
            ninjaHealth.text = ninja.health;
            ninjaBlood.text = ninja.blood_type;
            ninjaBirthday.text = ninja.birthdate.pretty;
            ninjaPrice.text = ninja.price + " gold";
            closeBtn.buttonMode = true;
            closeBtn.addEventListener(MouseEvent.CLICK, closeWindow);
            if (UserInfoModel.instance.UserInfo.gold >= parseInt(ninja.price))
            {
                recruit.buttonMode = true;
                recruit.addEventListener(MouseEvent.CLICK, recruitNinja);
            }
            else
            {
                errorText.text = "You don\'t have enough money to hire this ninja!";
                recruit.visible = false;
            }
            this.addEventListener(Event.ENTER_FRAME, updateAnim);
            return;
        }// end function

        private function updateAnim(... args)
        {
            var _loc_3:* = currentSprite + 1;
            currentSprite = _loc_3;
            if (currentSprite >= animations.length)
            {
                currentSprite = 0;
            }
            bmp.bitmapData.copyPixels(spriteSheet, new Rectangle(idleX + animations[currentSprite] * 100, idleY, 100, 130), new Point(0, 0));
            bbmp.bitmapData.copyPixels(spriteSheet, new Rectangle(idleX + animations[currentSprite] * 100, idleY + 130, 100, 130), new Point(0, 0));
            abmp.bitmapData.copyPixels(spriteSheet, new Rectangle(idleX + animations[currentSprite] * 100, idleY + 260, 100, 130), new Point(0, 0));
            if (ninja.weapon.iid)
            {
                wbmp.bitmapData.copyPixels(recruitMain.weaponSprites[weaponSheet], new Rectangle(animations[currentSprite] * 100, 0, 100, 130), new Point(0, 0));
            }
            return;
        }// end function

        private function closeWindow(... args)
        {
            this.removeEventListener(Event.ENTER_FRAME, updateAnim);
            recruit.removeEventListener(MouseEvent.CLICK, recruitNinja);
            closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
            parent.removeChild(this);
            return;
        }// end function

        private function recruitNinja(... args)
        {
            recruit.removeEventListener(MouseEvent.CLICK, recruitNinja);
            recruit.visible = false;
            
            var vari:URLVariables = new URLVariables();
			vari.rnid = ninja.rnid;
			
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.RECRUITNINJA,recruitHandler,vari);
            
           // main.showWaitSymbol();
            return;
        }// end function

        public function recruitHandler(data:Object) : void
        {
           // main.hideWaitSymbol();
           
            
            if (data.result == "success")
            {
                ninja.modified_max_health = ninja.health;
                UserInfoModel.instance.adjustStats(-parseInt(ninja.price), 0);
                ninja.nid = data.spoils.ninja;
                UserInfoModel.instance.UserInfo.addNinja(ninja);
                recruitMain.setPoof(ninjaMC.x, ninjaMC.y - 70);
                ninjaMC.destroy();
                main.setHealthBar();
                recruitMain.adjustPrices();
                closeWindow();
                if (data.spoils.achievements.length > 0)
                {
                    main.setAchievements(data.spoils.achievements);
                    main.alert(ninja.name + " is now in the dojo!", 375, 300, main.nextAch);
                }
                else
                {
                    main.alert(ninja.name + " is now in the dojo!");
                }
          
            }
            return;
        }// end function

        public function ioErrorHandler(param1)
        {
            return;
        }// end function

        //Security.allowDomain("*");
    }
}
