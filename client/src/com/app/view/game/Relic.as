package com.app.view.game  
{
    import flash.display.*;
    import flash.net.URLRequest;
 
	import flash.events.Event;
	import flash.events.IOErrorEvent;
    public class Relic extends Sprite
    {
        private var main:Object;
        private var relicMain:Object;
        private var relic:Object;
        public var iid:String;
        private var startX:Number;
        private var startY:Number;
        private var radCon:Number = 0.0174533;
        private var bmp:Loader;
        private var sprite:int = 0;

        public function Relic(param1, param2, param3:int, param4:int)
        {
            this.main = param1;
            this.relic = param2;
            this.iid = "0";
            this.sprite = 0;
            
            x = param3;
            this.startX = x;
           
            y = param4;
            this.startY = y;
           
            scaleY = 0.5;
            scaleX = 0.5;
            this.bmp = this.addChild(new Loader())as Loader;
            this.sprite = parseInt(this.relic.sprite);
            this.bmp.load(new URLRequest(this.main.prefix + "relicshopgfx/" + this.relic.sprite + ".png"));
            this.bmp.contentLoaderInfo.addEventListener(Event.COMPLETE, this.adjustGraphic);
            this.bmp.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            return;
        }// end function

        private function adjustGraphic(param1)
        {
            param1.currentTarget.removeEventListener(Event.COMPLETE, this.adjustGraphic);
            this.bmp.x = -this.bmp.width >> 1;
            this.bmp.y = -this.bmp.height >> 1;
            return;
        }// end function

        private function ioErrorHandler(param1)
        {
            return;
        }// end function

//        Security.allowDomain("*");
    }
}
