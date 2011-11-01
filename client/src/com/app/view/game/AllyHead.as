package com.app.view.game
{
	import com.app.controller.FramebarController;
	import com.framework.utils.CommonUtils;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	
	import res.game.allyBlue;
	import res.game.mcAllyHeader;
	public class AllyHead extends mcAllyHeader 
	{
	
		private var avatar:Bitmap;
		public var data:Object;
		private var pulseUp:Boolean = true;
		private var pulse:int = 2;
		private var main:*;
		public function AllyHead()
		{
			main=FramebarController.instance.framebarview;
			
			//this.removeEventListener(MouseEvent.ROLL_OVER, this.setOptions);
		}// end function
		
		public function setData(param1:Object):void
		{
			this.buttonMode=true;
			this.addEventListener(MouseEvent.ROLL_OVER,setOptions);
			this.data = param1;
			this.removeEventListener(Event.ENTER_FRAME, this.pulsate);
			holder.filters = new Array();
			
			while(holder.numChildren)
				holder.removeChildAt(0);
			if (this.data.cid == 0)
			{
				
				
				this.avatar=new Bitmap(new allyBlue());
				holder.addChild(avatar);
				this.avatar.visible=true;
				this.avatar.y = -9;
				levelStar.visible = false;
				allyName.text = "Add Ally";
				holder.removeEventListener(MouseEvent.CLICK, this.gotoInvite);
				hitZone.addEventListener(MouseEvent.CLICK, this.gotoInvite);
				levelStar.star.gotoAndStop(1);
			}
			else
			{
				if(avatar!=null&&avatar.visible==true)
					this.avatar.visible=false;
				levelStar.visible = true;
				CommonUtils.getImageByUrl(data.avatar,function(mc:Sprite,url:String):void{holder.addChild(mc)});
				allyName.text = param1.name;
				levelStar.levelText.text = param1.level;
				if (param1.level < 15)
				{
					levelStar.star.gotoAndStop(1);
				}
				else if (param1.level < 25)
				{
					levelStar.star.gotoAndStop(2);
				}
				else if (param1.level < 35)
				{
					levelStar.star.gotoAndStop(3);
				}
				else
				{
					levelStar.star.gotoAndStop(4);
				}
				if (parseInt(param1.needs_assistance) > 0)
				{
					this.addEventListener(Event.ENTER_FRAME, this.pulsate);
				}
			}
			return;
		}// end function
		
		private function pulsate(e:Event):void
		{
			if (this.pulseUp)
			{
				this.pulse = this.pulse + 3;
				if (this.pulse > 15)
				{
					this.pulseUp = false;
				}
			}
			else
			{
				this.pulse = this.pulse - 3;
				if (this.pulse < 5)
				{
					this.pulseUp = true;
				}
			}
			holder.filters = new Array(new GlowFilter(16711680, 1, this.pulse, this.pulse));
			return;
		}// end function
		public function disable():void
		{
			trace("disable");
			this.removeEventListener(Event.ENTER_FRAME, this.pulsate);
			holder.filters = new Array();
			hitZone.buttonMode = false;
			hitZone.visible=false;
			this.removeEventListener(MouseEvent.ROLL_OVER, this.setOptions);
			holder.removeEventListener(MouseEvent.CLICK, this.gotoInvite);
			
		}
		public function enable():void{
			/*hitZone.buttonMode = true;
			holder.addEventListener(MouseEvent.CLICK, this.gotoInvite);
			this.addEventListener(MouseEvent.ROLL_OVER,setOptions);
			this.removeEventListener(Event.ENTER_FRAME, this.pulsate);*/
			this.buttonMode=true;
			this.addEventListener(MouseEvent.ROLL_OVER,setOptions);
			
		}/**/
		
		private function gotoInvite(e:MouseEvent):void
		{
//			this.parent.gotoInvite();
			return;
		}//
		private function setOptions(e:MouseEvent)
		{
			main.showOptionhandler(e);
			//this.allyWindow.setClan(this.clan);
			//this.allyWindow.setOptions(this);
			return;
		}
		
		//Security.allowDomain("*");
	}
}
