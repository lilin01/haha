package com.app.view.tournyChoose 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.URLRequest;
	import com.app.controller.FramebarController;
    public class TourneyReward extends Sprite
    {
        private var main:*;
        private var obj:Object;
        public var tooltip:MovieClip; 

        public function TourneyReward( param2:Object)
        {
            this.main = FramebarController.instance.framebarview;
            this.obj = param2;
            loadImages();
            return;
        }// end function

        private function loadImages() : void
        {
            var _loc_1:* = new Loader();
            _loc_1.load(new URLRequest(main.prefix + "weaponshopgfx/" + obj.sprite + ".png"));
            _loc_1.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _loc_1.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var _loc_2:Bitmap = null;
            event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            event.currentTarget.removeEventListener(Event.COMPLETE, completeHandler);
            _loc_2 = event.currentTarget.content;
            _loc_2.smoothing = true;
            addChild(_loc_2);
            _loc_2.scaleX = 65 / _loc_2.height;
            _loc_2.height = 65;
            tooltip = addChild(new WeaponRolloverStatsMC())as MovieClip;
            tooltip.weaponName.text = obj.name;
            tooltip.weaponPower.text = Math.round(100 / parseInt(obj.attributes.speed) * parseFloat(obj.attributes.damage) * 100) / 100;
            tooltip.weaponSpeed.text = getSpeed(parseInt(obj.attributes.speed));
            tooltip.desc.text = obj.description;
            var _loc_3:int = 0;
            if (parseInt(obj.attributes.speed) < 100)
            {
                _loc_3 = 85 * (1 - parseInt(obj.attributes.speed) / 100);
            }
            else if (parseInt(obj.attributes.speed) > 100)
            {
                _loc_3 = -85 * (parseInt(obj.attributes.speed) / 100 / 5);
            }
            tooltip.meter.needle.rotation = 270 + _loc_3;
            var _loc_4:* = globalToLocal(new Point(main.stage.stageWidth / 2, main.stage.stageHeight / 2));
            tooltip.x = _loc_4.x;
            tooltip.y = _loc_4.y;
            tooltip.visible = false;
            var _loc_5:* = addChild(new Sprite());
			_loc_5.graphics.beginFill(65280, 0);
            _loc_5.graphics.drawRect(0, 0, 65, 65);
            _loc_5.graphics.endFill();
            _loc_5.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            _loc_5.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            return;
        }// end function

        private function mouseOverHandler(event:MouseEvent) : void
        {
            tooltip.visible = true;
            return;
        }// end function

        private function mouseOutHandler(event:MouseEvent) : void
        {
            tooltip.visible = false;
            return;
        }// end function

        private function getSpeed(param1:Number) : String
        {
            var _loc_2:* = new Array(33, 50, 66, 85, 150, 299, 399, 499, 1000);
            var _loc_3:* = new Array("Ultra Fast", "Fastest", "Faster", "Fast", "Normal", "Slow", "Slower", "Slowest", "Slow Loris");
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                if (param1 < _loc_2[_loc_4])
                {
                    return _loc_3[_loc_4];
                }
                _loc_4++;
            }
            return "";
        }// end function

        private function ioErrorHandler(param1)
        {
            return;
        }// end function

        public function setTooltipVisible(param1:Boolean) : void
        {
            tooltip.visible = param1;
            return;
        }// end function

    }
}
