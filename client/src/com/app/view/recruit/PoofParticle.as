package com.app.view.recruit 
{

	import res.recruit.PoofParticleMC;
    public class PoofParticle extends PoofParticleMC
    {
        private var life:int;
        private var maxLife:int;
        public var dead:Boolean = false;
        private var speed:Number = 0;
        private var xSpeed:Number = 0;
        private var ySpeed:Number = 0;
        private var direction:Number = 0;
        private var weapon:int = 0;
        private var gravity:Number = 0;
        private var bmp:Object;

        public function PoofParticle(param1:Number, param2:Number)
        {
            life = 10 + Math.random() * 5;
            maxLife = life;
            x = param1 + int(Math.random() * 20 - 10);
            y = param2 + int(Math.random() * 60 - 30);
            speed = Math.random() * 5 + 1;
            direction = int(Math.random() * 360);
            rotation = int(Math.random() * 360);
            xSpeed = speed * Math.cos(direction * (Math.PI / 180));
            ySpeed = speed * Math.sin(direction * (Math.PI / 180));
            return;
        }// end function

        public function update()
        {
            x = x + xSpeed;
            y = y + ySpeed;
            ySpeed = ySpeed + gravity;
            if (life <= 5)
            {
                alpha = life / 5;
            }
            var _loc_2:* = life - 1;
            life = _loc_2;
            if (life <= 0)
            {
                dead = true;
            }
            return;
        }// end function

        public function destroy()
        {
            parent.removeChild(this);
            return;
        }// end function

        public function ioErrorHandler(param1)
        {
            return;
        }// end function

    }
}
