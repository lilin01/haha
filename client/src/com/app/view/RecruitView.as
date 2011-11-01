package com.app.view
{
	import com.framework.view.ViewComponent;
	
	import flash.events.MouseEvent;
	

	import com.app.view.recruit.RecruitMain;
	import com.app.controller.RecruitController;
	
	
	public class RecruitView extends ViewComponent
	{
		private var _recruitmain:RecruitMain;
		
		public function RecruitView()
		{
			super();
		}
		
		
		public function init():void{
			
			this._recruitmain = new RecruitMain();
			this._recruitmain.mapButton.buttonMode = true;
			_recruitmain.y=60;
			this.addChild(this._recruitmain);
			
			//this.initEvent();
		}//init
		
		public function initEvent():void{
			this._recruitmain.mapButton.addEventListener(MouseEvent.CLICK,btnBack_onclick);
		}
		
		public function btnBack_onclick(event:MouseEvent):void{
			RecruitController.instance.renderHome();
		}
		
		
	}
}