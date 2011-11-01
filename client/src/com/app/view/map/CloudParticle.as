package com.app.view.map 
{
    import com.app.config.UrlConfig;
    import com.app.model.UserInfoModel;
    import com.framework.utils.loader.HttpLoader;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.*;
    
    import res.map.*;
    public class CloudParticle extends MovieClip
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
        private var bmp:Bitmap;
        private var main:Object;
        private var mapMain:Object;
        private var clickedOn:Boolean = false;
		/**
		 * 
		 * @param main
		 * @param mapMain
		 * @param x
		 * @param y
		 * @param param5
		 * @param param6 金云彩
		 * 
		 */
        public function CloudParticle(main, mapMain, x:Number, y:Number, param5:Boolean = true, param6:Boolean = false)
        {
			
            this.life = 10 + Math.random() * 40;
            this.maxLife = this.life;
            this.y = y;
            this.main = main;
            this.mapMain = mapMain;
            this.speed = Math.random() * 0.5 + 0.5;
            this.direction = 0;
            this.xSpeed = this.speed * Math.cos(this.direction * (Math.PI / 180));
            this.ySpeed = this.speed * Math.sin(this.direction * (Math.PI / 180));
         
           
            var _loc_7:int = param6 ? (4 + int(Math.random() * 2)) : (int(Math.random() * 4));
           // switch(_loc_7 === 0 ? (1) : (_loc_7 === 1 ? (2) : (_loc_7 === 2 ? (3) : (_loc_7 === 3 ? (4) : (_loc_7 === 4 ? (5) : (_loc_7 === 5 ? (6) : (// Jump to 955, // Jump to 957, 6))))))) branch count is:<6>[-822, -715, -607, -493, -378, -263, -154] default offset is:<-154>;
           switch(_loc_7){
			   case 0:
				   this.x = -100;
				   this.bmp = this.addChild(new Bitmap(new BitmapData(100, 50, true, 0), "always", true))as Bitmap;
				   this.bmp.bitmapData.copyPixels(this.mapMain.cloudSheet, new Rectangle(0, 0, 100, 50), new Point(0, 0));
				   this.bmp.x = -50;
				   this.bmp.y = -25;
				   break;
			   case 1:
				   this.x = -70;
				   this.bmp = this.addChild(new Bitmap(new BitmapData(60, 50, true, 0), "always", true))as Bitmap;
				   this.bmp.bitmapData.copyPixels(this.mapMain.cloudSheet, new Rectangle(100, 0, 60, 50), new Point(0, 0));
				   this.bmp.x = -30;
				   this.bmp.y = -25;
				   break;
			   case 2:
				   this.x = -180;
				   this.bmp = this.addChild(new Bitmap(new BitmapData(180, 80, true, 0), "always", true))as Bitmap;
				   this.bmp.bitmapData.copyPixels(this.mapMain.cloudSheet, new Rectangle(0, 50, 180, 80), new Point(0, 0));
				   this.bmp.x = -90;
				   this.bmp.y = -40;
				   break;
			   case 3:
				   this.x = -180;
				   this.bmp = this.addChild(new Bitmap(new BitmapData(180, 80, true, 0), "always", true))as Bitmap;
				   this.bmp.bitmapData.copyPixels(this.mapMain.cloudSheet, new Rectangle(0, 130, 180, 80), new Point(0, 0));
				   this.bmp.x = -90;
				   this.bmp.y = -40;
				   break;
			   case 4:
				   this.x = -180;
				   this.bmp = this.addChild(new Bitmap(new BitmapData(180, 80, true, 0), "always", true))as Bitmap;
				   this.bmp.bitmapData.copyPixels(this.mapMain.cloudSheet, new Rectangle(0, 130, 180, 80), new Point(0, 0));
				   this.bmp.x = -90;
				   this.bmp.y = -40;
				   break;
			   case 5:
				   this.x = -180;
				   this.bmp = this.addChild(new Bitmap(new BitmapData(180, 80, true, 0), "always", true))as Bitmap;
				   this.bmp.bitmapData.copyPixels(this.mapMain.cloudSheet, new Rectangle(0, 267, 180, 83), new Point(0, 0));
				   this.bmp.x = -90;
				   this.bmp.y = -41;
				   break;
			   case 6:
				   this.x = -100;
				   this.bmp = this.addChild(new Bitmap(new BitmapData(100, 51, true, 0), "always", true))as Bitmap;
				   this.bmp.bitmapData.copyPixels(this.mapMain.cloudSheet, new Rectangle(0, 216, 100, 51), new Point(0, 0));
				   this.bmp.x = -50;
				   this.bmp.y = -25;
				   break;
			   default :
				   break;
		   }
		   
		  
			if (!param5)
            {
                this.x = x;
            }
            if (param6)
            {
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.cloudReward);
            }
            else
            {
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.killCloud);
            }
            return;
        }// end function

        public function update()
        {
			
            x = x + this.xSpeed;
            y = y + this.ySpeed;
            this.ySpeed = this.ySpeed + this.gravity;
            if (x > 850)
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
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.killCloud);
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.cloudReward);
            return;
        }// end function

        public function destroy()
        {
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.killCloud);
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.cloudReward);
            parent.removeChild(this);
            return;
        }// end function

        private function killCloud(... args)
        {
            //this.mapMain.main.soundManager.loadSoundEffect("cloudClick");
            mouseEnabled = false;
            mouseChildren = false;
            this.clickedOn = true;
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.killCloud);
            return;
        }// end function

        private function cloudReward(... args)
        {
            mouseEnabled = false;
            mouseChildren = false;
            this.clickedOn = true;
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.cloudReward);
			
          
            
			
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT+UrlConfig.GOLDENCLOUD,cloudHandler);
			
            this.main.showWaitSymbol();
            return;
        }// end function

        public function cloudHandler(data:Object) : void
        {
            this.main.hideWaitSymbol();
            
           
            if (data.result == "success")
            {
				UserInfoModel.instance.adjustStats(parseInt(data.spoils.gold), parseInt(data.spoils.karma));
                this.main.alert("You got " + data.spoils.gold + " gold.");
				UserInfoModel.instance.UserInfo.cloud = 14400;
            }
            else
            {
                this.addEventListener(MouseEvent.MOUSE_DOWN, this.cloudReward);
                this.main.alert(data.error);
            }
            return;
        }// end function

       /* public function ioErrorHandler(param1)
        {
            trace(param1);
            return;
        }*/// end function

    }
}
