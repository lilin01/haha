package com.app.view.game  
{
    import com.app.config.UrlConfig;
    
    import flash.display.*;
    import flash.net.URLRequest;
    import flash.events.Event;
	import flash.events.IOErrorEvent;
 
    public class Weapon extends Sprite
    {
        private var main:Object;
        private var weaponMain:Object;
        private var weapon:Object;
        public var iid:String;
        public var value:int = 0;
        private var bmp:Loader;
        public var sprite:int = 0;
        private var clickToBuy:Object;
        private var interactive:Boolean = true;
        private var chains:Object;

        public function Weapon(param1, param2, param3:int, param4:int)
        {
            this.main = param1;
            this.weapon = param2;
            this.iid = "0";
            this.value = 0;
            this.sprite = 0;
            x = param3;
            y = param4;
            var _loc_5:Number = 0.5;
            scaleY = 0.5;
            scaleX = _loc_5;
            this.bmp = this.addChild(new Loader())as Loader;
            trace(UrlConfig.prefix + "weaponshopgfx/" + this.weapon.sprite + ".png");
            this.bmp.load(new URLRequest(UrlConfig.prefix + "weaponshopgfx/" + this.weapon.sprite + ".png"));
            this.bmp.contentLoaderInfo.addEventListener(Event.COMPLETE, this.adjustGraphic);
            this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
            return;
        }// end function

        private function ioError(param1)
        {
            trace(param1);
            return;
        }// end function

        private function adjustGraphic(param1)
        {
            trace("hi there?");
            param1.currentTarget.removeEventListener(Event.COMPLETE, this.adjustGraphic);
            this.bmp.x = -this.bmp.width >> 1;
            this.bmp.y = -this.bmp.height >> 1;
            return;
        }// end function

//        Security.allowDomain("*");
    }
}
