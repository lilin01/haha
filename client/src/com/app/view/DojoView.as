package com.app.view
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.framework.view.ViewComponent;
	
	import com.app.controller.DojoController;
	
	import com.app.view.dojo.DojoMain;
	
	public class DojoView extends ViewComponent
	{
		
		public var dojomain:DojoMain;
		
		public function DojoView()
		{
			super();
		}
		
		public function init():void{
			this.dojomain = new DojoMain();
			this.addChild(this.dojomain);
			this.initEvent();
		}//init
		
		public function initEvent():void{
			
		//	this._dojomain.btnBack.buttonMode = true;
		//	this._dojomain.btnBack.addEventListener(MouseEvent.CLICK,btnBack_onclick);
		}
		
		public function btnBack_onclick(event:MouseEvent):void{
			DojoController.instance.renderHome();
		}
		
		
		
	}
}