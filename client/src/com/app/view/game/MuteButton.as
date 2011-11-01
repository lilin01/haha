package com.app.view.game {
	import flash.events.*;
	import fl.motion.*;
	import flash.geom.*;
	import flash.display.*;
	import res.game.*;
	public class MuteButton extends Sprite {
		
		private var main;
		private var menu;
		private var menuNum;
		private var icon;
		private var eFunction:Function = null;
		private var toggle:int = 0;
		private var audioString:String = "";
		private var sheet:AudioSheet;
		
		public function MuteButton(_arg1, _arg2:String="", _arg3:int=0, _arg4:int=0, _arg5:Function=null, _arg6:int=0){
			this.sheet = new AudioSheet(1, 1);
			super();
			this.main = _arg1;
			this.audioString = _arg2;
			this.toggle = (1 - this.main.settings.data.music);
			this.icon = new Bitmap(new BitmapData(16, 16));
			this.icon.bitmapData.copyPixels(this.sheet, new Rectangle((this.toggle * 16), 0, 16, 16), new Point(0, 0));
			this.addChild(this.icon);
			this.eFunction = _arg5;
			x = _arg3;
			y = _arg4;
			buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, this.mouseUsed);
		}
		public function mouseUsed(... _args){
			if (this.toggle){
				this.toggle = 0;
			} else {
				this.toggle = 1;
			};
			this.setGraphic();
			this.eFunction();
		}
		public function setGraphic(){
			this.icon.bitmapData.dispose();
			this.icon.bitmapData = new BitmapData(16, 16);
			this.icon.bitmapData.copyPixels(this.sheet, new Rectangle((this.toggle * 16), 0, 16, 16), new Point(0, 0));
		}
		public function fadeTab(){
			var _local1:Color = new Color();
			_local1.setTint(0xFFFFFF, 0);
			transform.colorTransform = _local1;
		}
		public function destroy(){
			parent.removeChild(this);
		}
		
	}
}//package 