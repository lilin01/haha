package com.app.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.framework.view.ViewComponent;
	import com.app.controller.StagingController;
	import com.app.view.staging.StagingMain;
	import com.app.controller.FramebarController;
	public class StagingView extends ViewComponent
	{
		
		public var stagingmain:StagingMain;
		
		public function StagingView()
		{
			super();
		}
		
		public function init():void{
			FramebarController.instance.framebarview.hideAllies();
			this.stagingmain = new StagingMain();
			this.addChild(this.stagingmain);
			this.initEvent();
		}//init
		
		public function initEvent():void{
			
			//	this._dojomain.btnBack.buttonMode = true;
			//	this._dojomain.btnBack.addEventListener(MouseEvent.CLICK,btnBack_onclick);
		}
		
		public function btnBack_onclick(event:MouseEvent):void{
			StagingController.instance.renderHome();
		}
		
		
		
	}
}