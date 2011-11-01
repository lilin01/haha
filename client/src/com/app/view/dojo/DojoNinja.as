package com.app.view.dojo 
{
	import com.app.model.UserInfoModel;
	
	import fl.motion.*;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import res.dojo.DojoNinjaMC;
	public class DojoNinja extends DojoNinjaMC
	{
		private var main:Object;
		private var dojo:Object;
		private var ninja:Object;
		private var spriteSheet:Object;
		//显示ninja
		public var bmp:Bitmap;
		private var bbmp:Bitmap;
		private var abmp:Bitmap;
		private var wbmp:Bitmap;
		private var bwbmp:Bitmap;
		/**
		 *0-1:站 2：跳 3：倒 
		 */		
		private var animations:Array;
		private var currentSprite:int = 0;
		private var idleX:int = 0;
		private var idleY:int = 0;
		private var runX:int = 0;
		private var runY:int = 0;
		private var weaponSprites:Object;
		private var weapon:Object;
		private var idleFrames:Array;
		private var runningFrames:Array;
		private var healthBar:Object;
		
		public function DojoNinja(main:Object, dojo:Object, ninja:Object, x:int, y:int)
		{
			this.animations = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1);
			//this.animations = new Array(0, 0, 1, 1,2, 2,3, 3, 4, 4, 5, 5);
			this.idleFrames = new Array();
			this.runningFrames = new Array();
			this.main = main;
			this.dojo = dojo;
			this.ninja = ninja;
			this.weapon = this.ninja.weapon;
			this.x = x;
			this.y = y;
			this.spriteSheet = this.dojo.ninjaSprites[parseInt(UserInfoModel.instance.UserInfo.faction)][parseInt(this.ninja.gender)];
			this.weaponSprites = this.dojo.getWeaponSprite(this.weapon);
			this.bmp = this.addChild(new Bitmap(new BitmapData(100, 130, true, 0), "always", true))as Bitmap;
			this.bmp.x = -50;
			this.bmp.y = -130;
			this.createFrames();
			this.currentSprite = int(Math.random() * this.animations.length);
			this.healthBar = this.addChild(new HealthBar(-35, -35, this.dojo.healthBar));
			this.healthBar.setHealthBar(parseInt(this.ninja.health), parseInt(this.ninja.modified_max_health));
			buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, this.openNinjaWindow);
			this.addEventListener(MouseEvent.ROLL_OVER, this.showStats);
			this.addEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			return;
		}// end function
		
		private function createFrames():void
		{
			if (parseInt(this.weapon.iid))
			{
				//weaponTest = this.weapon.runanimation;
				//weaponSheet = this.weapon.animation;
				switch(parseInt(this.weapon.standanimation))
				{
					case 1:
					{
						this.idleX = 300;
						this.idleY = 0;
						break;
					}
					case 2:
					{
						this.idleX = 0;
						this.idleY = 1170;
						break;
					}
					case 3:
					{
						this.idleX = 300;
						this.idleY = 1170;
						this.runY = 1950;
						break;
					}
					default:
					{
						break;
					}
				}
				switch(parseInt(this.weapon.runanimation))
				{
					case 1:
					{
						this.runY = 780;
						break;
					}
					case 2:
					{
						this.runY = 1560;
						break;
					}
					case 3:
					{
						this.runY = 1950;
						break;
					}
					default:
					{
						break;
					}
				}
			}
			//标识是否有武器
			var flag:Boolean = parseInt(this.weapon.iid) > 0;
			var _loc_2:Color = new Color();
			var _loc_3:Array = new Array(16777215, 16776960, 16737792, 39168, 170, 6697728, 0);
			_loc_2.setTint(_loc_3[Math.min(int(Math.max((parseInt(this.ninja.level )- 1) / 5, 0)), 6)], 0.8);
			//var beltMc:Sprite = new Sprite();//腰带movie
			var beltBmData:BitmapData = new BitmapData(100, 130, true, 0);//腰带bitmapdata
			//var beltBm:Bitmap = new Bitmap();//腰带bitmap
			//	beltBm.transform.colorTransform = _loc_2;
			//beltBm.bitmapData = beltBmData;
			//var bmpd:BitmapData = new BitmapData(100, 130, true, 0);
			var frame:int = 0;//帧
			while (frame < 3)
			{
				
				this.idleFrames.push(new BitmapData(100, 130, true, 0));
				if (flag)
				{
					//复制武器（里面一侧的武器）
					this.idleFrames[frame].copyPixels(this.weaponSprites, new Rectangle(300 + frame * 100, 0, 100, 130), new Point(0, 0));
				}
				//复制人物
				this.idleFrames[frame].copyPixels(this.spriteSheet, new Rectangle(this.idleX + frame * 100, this.idleY, 100, 130), new Point(0, 0), null, null, true);
				beltBmData.dispose();
				beltBmData = new BitmapData(100, 130, true, 0);
				//复制腰带
				beltBmData.copyPixels(this.spriteSheet as BitmapData, new Rectangle(this.idleX + frame * 100, this.idleY + 130, 100, 130), new Point(0, 0));
				
				beltBmData.colorTransform(beltBmData.rect, _loc_2);
				//beltBm.bitmapData = beltBmData;
				//bmpd.dispose();
				//bmpd = new BitmapData(100, 130, true, 0);
				//bmpd.draw(beltMc);
				//this.idleFrames[frame].copyPixels(bmpd, new Rectangle(0, 0, 100, 130), new Point(0, 0), null, null, true);
				this.idleFrames[frame].copyPixels(beltBmData, new Rectangle(0, 0, 100, 130), new Point(0, 0), null, null, true);
				//复制胳膊
				this.idleFrames[frame].copyPixels(this.spriteSheet, new Rectangle(this.idleX + frame * 100, this.idleY + 260, 100, 130), new Point(0, 0), null, null, true);
				if (flag)
				{//复制武器（外面一侧的武器）
					this.idleFrames[frame].copyPixels(this.weaponSprites, new Rectangle(frame * 100, 0, 100, 130), new Point(0, 0), null, null, true);
				}
				frame++;
			}
			this.idleFrames.push(new BitmapData(100, 130, true, 0));
			//frame此时已经为3
			//复制人物战败图片
			this.idleFrames[frame].copyPixels(this.spriteSheet, new Rectangle(0, 2340, 100, 130), new Point(0, 0));
			beltBmData.dispose();
			beltBmData = new BitmapData(100, 130, true, 0);
			//复制战败时腰带
			beltBmData.copyPixels(this.spriteSheet as BitmapData, new Rectangle(100, 2340, 100, 130), new Point(0, 0));
			beltBmData.colorTransform(beltBmData.rect, _loc_2);
			//beltBm.bitmapData = beltBmData;
			//bmpd.dispose();
			//bmpd = new BitmapData(100, 130, true, 0);
			//bmpd.draw(beltMc);
			this.idleFrames[frame].copyPixels(beltBmData, new Rectangle(0, 0, 100, 130), new Point(0, 0), null, null, true);
			//复制胳膊
			this.idleFrames[frame].copyPixels(this.spriteSheet, new Rectangle(200, 260, 100, 130), new Point(0, 0), null, null, true);
			frame = 0;
			while (frame < 6)
			{
				
				this.runningFrames.push(new BitmapData(100, 130, true, 0));
				if (flag)
				{//复制内侧武器
					this.runningFrames[frame].copyPixels(this.weaponSprites, new Rectangle(frame * 100, 260, 100, 130), new Point(0, 0));
				}
				//复制人物跑动图片
				this.runningFrames[frame].copyPixels(this.spriteSheet, new Rectangle(this.runX + frame * 100, this.runY, 100, 130), new Point(0, 0), null, null, true);
				beltBmData.dispose();
				beltBmData = new BitmapData(100, 130, true, 0);
				beltBmData.copyPixels(this.spriteSheet as BitmapData, new Rectangle(this.runX + frame * 100, this.runY + 130, 100, 130), new Point(0, 0));
				beltBmData.colorTransform(beltBmData.rect, _loc_2);
				//beltBm.bitmapData = beltBmData;
				//bmpd.dispose();
				//bmpd = new BitmapData(100, 130, true, 0);
				//bmpd.draw(beltMc);
				//复制腰带
				this.runningFrames[frame].copyPixels(beltBmData, new Rectangle(0, 0, 100, 130), new Point(0, 0), null, null, true);
				//复制胳膊
				this.runningFrames[frame].copyPixels(this.spriteSheet, new Rectangle(this.runX + frame * 100, this.runY + 260, 100, 130), new Point(0, 0), null, null, true);
				if (flag)
				{//复制外侧武器
					this.runningFrames[frame].copyPixels(this.weaponSprites, new Rectangle(frame * 100, 130, 100, 130), new Point(0, 0), null, null, true);
				}
				frame++;
			}
			this.bmp.bitmapData = this.idleFrames[0];
			return;
		}// end function
		
		public function update()
		{
			
			currentSprite = currentSprite + 1;
			if (this.currentSprite >= this.animations.length)
			{
				this.currentSprite = 0;
			}
			this.bmp.bitmapData = this.idleFrames[this.animations[this.currentSprite]];
			this.updateHealthBar();
			return;
		}// end function
		
		public function updateHealthBar()
		{
			this.healthBar.setHealthBar(parseInt(this.ninja.health), parseInt(this.ninja.modified_max_health));
			return;
		}// end function
		
		private function openNinjaWindow(... args)
		{
			this.dojo.openNinjaWindow(this.ninja, this);
			return;
		}// end function
		
		private function showStats(... args)
		{
			this.dojo.showStats(this.ninja, x, y);
			return;
		}// end function
		
		private function hideStats(... args)
		{
			this.dojo.hideStats();
			return;
		}// end function
		
		public function setBeltColor()
		{
			var _loc_1:* = new Color();
			var _loc_2:* = new Array(16777215, 16776960, 16737792, 39168, 170, 6697728, 0);
			_loc_1.setTint(_loc_2[Math.min(int(Math.max((parseInt(this.ninja.level) - 1) / 5, 0)), 6)], 0.8);
			this.bbmp.transform.colorTransform = _loc_1;
			return;
		}// end function
		
		public function destroy()
		{
			this.removeEventListener(MouseEvent.CLICK, this.openNinjaWindow);
			this.removeEventListener(MouseEvent.ROLL_OVER, this.showStats);
			this.removeEventListener(MouseEvent.ROLL_OUT, this.hideStats);
			parent.removeChild(this);
			UserInfoModel.instance.UserInfo.removeNinja(this.ninja);
			
			return;
		}// end function
		
		public function setWeapon(param1)
		{
			this.idleFrames = new Array();
			this.runningFrames = new Array();
			this.ninja.weapon = param1;
			this.setWeaponGraphics();
			return;
		}// end function
		
		public function setWeaponGraphics()
		{
			this.weapon = this.ninja.weapon;
			this.weaponSprites = this.dojo.getWeaponSprite(this.weapon);
			this.createFrames();
			return;
		}// end function
		
		public function resetGraphics()
		{
			this.idleFrames = new Array();
			this.runningFrames = new Array();
			this.setWeaponGraphics();
			return;
		}// end function
		
		//Security.allowDomain("*");
	}
}
