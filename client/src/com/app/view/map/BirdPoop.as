package com.app.view.map 
{
    import flash.display.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
    public class BirdPoop extends MovieClip
    {
        private var life:int = 30;
        private var maxLife:int;
        public var dead:Boolean = false;
        private var speed:Number = 0;
        private var xSpeed:Number = 0;
        private var ySpeed:Number = 0;
        private var direction:Number = 0;
        private var weapon:int = 0;
        private var gravity:Number = 0.1;
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

        public function BirdPoop(param1, param2, param3:Number, param4:Number, param5:Boolean = false)
        {
            this.maxLife = this.life;
            this.frames = new Array(0, 1, 2, 3, 4, 5, 6, 7);
            this.type = int(Math.random() * 2);
            this.birdY = this.type * 20;
            this.soaring = int(Math.random() * 2) == 0;
            mouseEnabled = false;
            mouseChildren = false;
            x = param3;
            y = param4;
            this.main = param1;
            this.mapMain = param2;
            this.speed = (Math.random() * 2 + 1) * this.scale;
            this.direction = param5 ? (int(Math.random() * 45 + 90)) : (90);
            this.xSpeed = this.speed * Math.cos(this.direction * (Math.PI / 180));
            this.ySpeed = this.speed * Math.sin(this.direction * (Math.PI / 180)) + 1;
            this.frame = int(Math.random() * this.frames.length);
            this.bmp = this.addChild(new Bitmap(new BitmapData(4, 6, true, 0), "always", true));
            this.bmp.bitmapData.copyPixels(this.mapMain.poopSheet, new Rectangle(0, 0, 4, 6), new Point(0, 0));
            this.bmp.x = -2;
            this.bmp.y = -3;
            return;
        }// end function

        public function update()
        {
            x = x + this.xSpeed;
            y = y + this.ySpeed;
            this.ySpeed = this.ySpeed + this.gravity;
            
            this.life--;
            if (this.life-- < 0 && this.mapMain.hitIsland(x, y))
            {
                this.mapMain.stainIsland(x, y + 20);
                this.dead = true;
            }
            if (y > 550)
            {
                this.dead = true;
            }
            return;
        }// end function

        public function disable()
        {
            return;
        }// end function

        public function destroy()
        {
            parent.removeChild(this);
            return;
        }// end function

        public function ioErrorHandler(param1)
        {
            trace(param1);
            return;
        }// end function

    }
}
