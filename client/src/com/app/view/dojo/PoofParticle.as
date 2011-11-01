package com.app.view.dojo
{
	import res.dojo.PoofParticleMC;
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
		
		public function PoofParticle(x:Number, y:Number)
		{
			this.life = 10 + Math.random() * 5;
			this.maxLife = this.life;
			this.x = x + int(Math.random() * 20 - 10);
			this.y = y + int(Math.random() * 60 - 30);
			this.speed = Math.random() * 5 + 1;
			this.direction = int(Math.random() * 360);
			rotation = int(Math.random() * 360);
			this.xSpeed = this.speed * Math.cos(this.direction * (Math.PI / 180));
			this.ySpeed = this.speed * Math.sin(this.direction * (Math.PI / 180));
			return;
		}// end function
		
		public function update()
		{
			x = x + this.xSpeed;
			y = y + this.ySpeed;
			this.ySpeed = this.ySpeed + this.gravity;
			if (this.life <= 5)
			{
				alpha = this.life / 5;
			}
			
			life = life - 1;
			if (this.life <= 0)
			{
				this.dead = true;
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
