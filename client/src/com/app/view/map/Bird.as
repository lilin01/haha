package com.app.view.map 
{
    import flash.display.*;
	import res.map.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.MouseEvent;
    public class Bird extends MovieClip
    {
        private var life:int;
        private var maxLife:int;
        public var dead:Boolean = false;
        private var speed:Number = 0;
        private var xSpeed:Number = 0;
        private var ySpeed:Number = 0;
        private var direction:Number = 0;
        private var weapon:int = 0;
        private var gravity:Number = 0.05;
        private var bmp:Object;
        private var main:Object;
        private var mapMain:Object;
        private var clickedOn:Boolean = false;
        private var frame:Object = 0;
        private var frames:Array;
        private var type:int;
        private var birdY:int;
        private var soaring:Boolean;
        private var scale:Number = 1;
        private var poopTimer:int;
        private var shitStorm:Boolean = false;
        private var clickCount:int = 0;

        public function Bird(param1, param2, param3:Number, param4:Number, param5:Number = 1, param6:Boolean = true)
        {
            this.life = 10 + Math.random() * 40;
            this.maxLife = this.life;
            this.frames = new Array(0, 1, 2, 3, 4, 5, 6, 7);
            this.type = int(Math.random() * 2);
            this.birdY = this.type * 20;
            this.soaring = int(Math.random() * 2) == 0;
            this.poopTimer = 10 + int(Math.random() * 800);
            x = param3;
            y = param4;
            this.main = param1;
            this.mapMain = param2;
            this.speed = (Math.random() * 2 + 1) * this.scale;
            this.direction = 0;
            this.scale = param5;
            var _loc_7:* = this.scale;
            scaleY = this.scale;
            scaleX = _loc_7;
            this.xSpeed = this.speed * Math.cos(this.direction * (Math.PI / 180));
            this.ySpeed = this.speed * Math.sin(this.direction * (Math.PI / 180));
            this.frame = int(Math.random() * this.frames.length);
            if (!param6)
            {
                x = param3;
            }
            this.bmp = this.addChild(new Bitmap(new BitmapData(20, 20, true, 0), "always", true));
            this.bmp.bitmapData.copyPixels(this.mapMain.smallBirdSheet, new Rectangle(0, this.birdY, 20, 20), new Point(0, 0));
            this.bmp.x = -10;
            this.bmp.y = -10;
            this.addEventListener(MouseEvent.MOUSE_DOWN, this.poopies);
            return;
        }// end function

        public function update()
        {
            x = x + this.xSpeed;
            y = y + this.ySpeed;
            if (this.shitStorm)
            {
                this.poopTimer = 200 + int(Math.random() * 800);
                this.mapMain.poop(x, y + 2, true);
            }
            if (this.soaring)
            {
                this.ySpeed = this.ySpeed + this.gravity * this.scale;
                if (this.ySpeed > this.scale)
                {
                    this.soaring = false;
                }
            }
            else
            {
                this.frame = this.frame + 1
                if (this.frame == 2)
                {
                    this.ySpeed = this.ySpeed - 0.15 * this.scale;
                }
                if (this.frame > (this.frames.length - 1))
                {
                    this.frame = 0;
                    if (this.ySpeed < -1 * this.scale)
                    {
                        this.soaring = true;
                    }
                }
                if (x > -20)
                {
                    this.bmp.bitmapData.copyPixels(this.mapMain.smallBirdSheet, new Rectangle(this.frames[this.frame] * 20, this.birdY, 20, 20), new Point(0, 0));
                }
            }
            if (x > 800)
            {
                this.dead = true;
            }
            if (this.clickedOn)
            {
                rotation = rotation + 15;
                alpha = alpha - 0.02;
                if (alpha <= 0)
                {
                    this.dead = true;
                }
                var _loc_1:* = alpha;
                scaleY = alpha;
                scaleX = _loc_1;
            }
            return;
        }// end function

        public function disable()
        {
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.poopies);
            return;
        }// end function

        public function destroy()
        {
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.poopies);
            parent.removeChild(this);
            return;
        }// end function

        private function poopies(... args)
        {
            this.clickCount++;
            if (this.clickCount >= 20)
            {
                this.shitStorm = true;
            }
            if (this.scale >= 0.7 && x > 0 && x < 750)
            {
                this.mapMain.poop(x, y + 2);
            }
            return;
        }// end function

        public function ioErrorHandler(param1)
        {
            trace(param1);
            return;
        }// end function

    }
}
